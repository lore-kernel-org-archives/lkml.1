Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZDKTim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZDKTim (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZDKTid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:38:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:54729 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbZDKTic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:38:32 -0400
From: "Rafael J. Wysocki" <rjw@suse.com>
Organization: SUSE
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and (minor but annoying) audio problem
Date: Sat, 11 Apr 2009 21:38:25 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Takashi Iwai <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904101817100.4583@localhost.localdomain> <49DFFC05.7070509@linux.intel.com>
In-Reply-To: <49DFFC05.7070509@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904112138.26518.rjw@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 April 2009, Arjan van de Ven wrote:
> Linus Torvalds wrote:
> > 
> > On Sat, 11 Apr 2009, Rafael J. Wysocki wrote:
> >> On Friday 10 April 2009, Linus Torvalds wrote:
> >>> On Fri, 10 Apr 2009, Rafael J. Wysocki wrote:
> >>>> I've just verified that the resume-after-hibernation issue goes away after
> >>>> reverting commit 9710794383ee5008d67f1a6613a4717bf6de47bc
> >>>> (async: remove the temporary (2.6.29) "async is off by default" code) , so it
> >>>> is async-related.
> >>> Arjan? Clearly all the necessary fixes weren't found..
> >>>
> >>> There _is_ a module loading problem wrt initmem - I think you found that 
> >>> and we added a hack for it for the ACPI battery driver. I wonder if we're 
> >>> hitting a similar issue now with module discovery: modules that use 
> >>> "async_schedule()" to do their discovery asynchronously are now not 
> >>> necessarily fully "done" when the module is loaded. 
> >>>
> >>> And so, anything that expected the devices to be available after module 
> >>> load (like they used to) would be screwed.
> >>>
> >>> IOW, maybe something like the totally untested patch appended here (that 
> >>> should also allow us to make the ACPI battery code to go back to using 
> >>> __init).
> >> I tested it and it worked.
> > 
> > Hmm.
> > 
> > I'm not 100% sure that patch is good.
> > 
> > The reason? I think it's going to deadlock if an async caller ends up 
> > wanting to load a module, because then the nested 
> > "async_synchronize_full()" will basically want to wait for itself.
> > 
> > So it's a good test-patch, and maybe no async caller ever loads a module, 
> > but it makes me a bit nervous.
> 
> It would make a rule that async context can only use request_module_nowait().
> Not too nice, I think we can do better.
> 
> > But the fact that it fixes things for you at least means that the _reason_ 
> > for the problem is know, and maybe there are alternative solutions. Arjan?
> 
> We have async domains; for the acpi type of case we could make a "__init" domain
> that we wait on selectively... but I'm not too fond of this since it'll be fragile over time.
> 
> I suppose this got exposed now that we (just) removed the stop_machine stuff from the module loader...
> (which is a generally good improvement, don't get me wrong).
> 
> For the __init freeing case there is a even more interesting option:
> We can schedule an async task that will free the init mem of the module, and have that
> async task just wait for all its predecessors to complete before doing the actual work.
> That way the module is available and ready to its caller, while the freeing of the init mem
> will be done at a safe time.
> 
> Like this (not yet tested):
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 1196f5d..4ec90e8 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2312,6 +2312,22 @@ static noinline struct module *load_module(void __user *umod,
>   	goto free_hdr;
>   }
> 
> +static void async_module_free_initmem(void *data, async_cookie_t cookie)
> +{
> +	struct module *mod = data;
> +	async_synchronize_cookie(cookie);
> +
> +	mutex_lock(&module_mutex);
> +	/* Drop initial reference. */
> +	module_put(mod);
> +	module_free(mod, mod->module_init);
> +	mod->module_init = NULL;
> +	mod->init_size = 0;
> +	mod->init_text_size = 0;
> +	mutex_unlock(&module_mutex);
> +
> +}
> +
>   /* This is where the real work happens */
>   SYSCALL_DEFINE3(init_module, void __user *, umod,
>   		unsigned long, len, const char __user *, uargs)
> @@ -2372,15 +2388,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
>   	blocking_notifier_call_chain(&module_notify_list,
>   				     MODULE_STATE_LIVE, mod);
> 
> -	mutex_lock(&module_mutex);
> -	/* Drop initial reference. */
> -	module_put(mod);
> -	module_free(mod, mod->module_init);
> -	mod->module_init = NULL;
> -	mod->init_size = 0;
> -	mod->init_text_size = 0;
> -	mutex_unlock(&module_mutex);
> -
> +	async_schedule(async_module_free_initmem, mod);
>   	return 0;
>   }
> 
> 
> 
> Now the second case of "the devices are available when the module load is done".
> 
> The hard case here is that we're talking about a storage device. In 2.6.28 and before (eg well before
> any async stuff landed), SCSI probing already was done asynchronously. Same for USB. Libata I think is the same,
> by virtue of using scsi as infrastructure.
> 
> Realistically, unless you call scsi_complete_async_scans(), you could not depend on scsi devices being available
> after loading one of their modules. (from userland you could do this via the scsi_wait_scan module)
> 
> (speculation: on ATA likely the scan was done relatively quickly ... and with async it's just done with different timing. So it
> was kind of luck before)
> 
> Rafael: would it be reasonable to call "scsi_compete_async_scans()" from the resume-from-disk code ?

FWIW, I applied the appended patch and it fixed the problem for me.

Thanks,
Rafael

---
 drivers/scsi/scsi_priv.h      |    3 ---
 drivers/scsi/scsi_wait_scan.c |    2 +-
 include/scsi/scsi_scan.h      |   11 +++++++++++
 kernel/power/disk.c           |    8 ++++++++
 4 files changed, 20 insertions(+), 4 deletions(-)

Index: linux-2.6/include/scsi/scsi_scan.h
===================================================================
--- /dev/null
+++ linux-2.6/include/scsi/scsi_scan.h
@@ -0,0 +1,11 @@
+#ifndef _SCSI_SCSI_SCAN_H
+#define _SCSI_SCSI_SCAN_H
+
+#ifdef CONFIG_SCSI
+/* drivers/scsi/scsi_scan.c */
+extern int scsi_complete_async_scans(void);
+#else
+static inline int scsi_complete_async_scans(void) { return 0; }
+#endif
+
+#endif /* _SCSI_SCSI_SCAN_H */
Index: linux-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_priv.h
+++ linux-2.6/drivers/scsi/scsi_priv.h
@@ -38,9 +38,6 @@ static inline void scsi_log_completion(s
 	{ };
 #endif
 
-/* scsi_scan.c */
-int scsi_complete_async_scans(void);
-
 /* scsi_devinfo.c */
 extern int scsi_get_device_flags(struct scsi_device *sdev,
 				 const unsigned char *vendor,
Index: linux-2.6/drivers/scsi/scsi_wait_scan.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_wait_scan.c
+++ linux-2.6/drivers/scsi/scsi_wait_scan.c
@@ -11,7 +11,7 @@
  */
 
 #include <linux/module.h>
-#include "scsi_priv.h"
+#include <scsi/scsi_scan.h>
 
 static int __init wait_scan_init(void)
 {
Index: linux-2.6/kernel/power/disk.c
===================================================================
--- linux-2.6.orig/kernel/power/disk.c
+++ linux-2.6/kernel/power/disk.c
@@ -22,6 +22,7 @@
 #include <linux/console.h>
 #include <linux/cpu.h>
 #include <linux/freezer.h>
+#include <scsi/scsi_scan.h>
 #include <asm/suspend.h>
 
 #include "power.h"
@@ -645,6 +646,13 @@ static int software_resume(void)
 		return 0;
 
 	/*
+	 * We can't depend on SCSI devices being available after loading one of
+	 * their modules if scsi_complete_async_scans() is not called and the
+	 * resume device usually is a SCSI one.
+	 */
+	scsi_complete_async_scans();
+
+	/*
 	 * name_to_dev_t() below takes a sysfs buffer mutex when sysfs
 	 * is configured into the kernel. Since the regular hibernate
 	 * trigger path is via sysfs which takes a buffer mutex before

