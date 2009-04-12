Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbZDLSHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbZDLSHV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752062AbZDLSHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:07:05 -0400
Received: from cantor.suse.de ([195.135.220.2]:45928 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbZDLSHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:07:03 -0400
From: "Rafael J. Wysocki" <rjw@suse.com>
Organization: SUSE
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and (minor but annoying) audio problem
Date: Sun, 12 Apr 2009 20:06:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc1-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Takashi Iwai <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904111253520.4583@localhost.localdomain> <49E0F805.2090502@linux.intel.com>
In-Reply-To: <49E0F805.2090502@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904122006.57425.rjw@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 April 2009, Arjan van de Ven wrote:
> Linus Torvalds wrote:
> > 
> > On Sat, 11 Apr 2009, Rafael J. Wysocki wrote:
> >> FWIW, I applied the appended patch and it fixed the problem for me.
> > 
> > I think that patch is probably the right thing to do regardless, but I 
> > also think it doesn't obviate the need for also doing so at module loading 
> > time. 
> > 
> > I'm pretty sure that calling scsi_complete_async_scans() won't protect 
> > against an async USB bus scan, for example.
> 
> but neither does anything else we have in the kernel right now.......
> (specifically, USB does not use the async infrastructure)
> 
> > But I do think your patch is probably worth doing anyway.
> 
> Absolutely; I wonder if we should make a more generic "wait for async storage scans"
> function, that just calls this one, but allows other systems to also be in there.
> (although.. right now I'd not know which ones it would be).

OK, updated patch follows, with a changelog.

I've added this check to user.c too, because that code can be called
independently of the one in disk.c .  Also, if resume is user space-driven,
it's a good idea to wait for all of the device probes to complete before
continuing.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM/Hibernate: Wait for SCSI devices scan to complete during resume

There is a race between resume from hibernation and the asynchronous
scanning of SCSI devices and to prevent it from happening we need to
call scsi_complete_async_scans() during resume from hibernation.

In addition, if the resume from hibernation is userland-driven, it's
better to wait for all device probes in the kernel to complete before
attempting to open the resume device.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/scsi/scsi_priv.h      |    3 ---
 drivers/scsi/scsi_wait_scan.c |    2 +-
 include/scsi/scsi_scan.h      |   11 +++++++++++
 kernel/power/disk.c           |    8 ++++++++
 kernel/power/user.c           |    9 +++++++++
 5 files changed, 29 insertions(+), 4 deletions(-)

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
Index: linux-2.6/kernel/power/user.c
===================================================================
--- linux-2.6.orig/kernel/power/user.c
+++ linux-2.6/kernel/power/user.c
@@ -24,6 +24,7 @@
 #include <linux/cpu.h>
 #include <linux/freezer.h>
 #include <linux/smp_lock.h>
+#include <scsi/scsi_scan.h>
 
 #include <asm/uaccess.h>
 
@@ -92,6 +93,7 @@ static int snapshot_open(struct inode *i
 	filp->private_data = data;
 	memset(&data->handle, 0, sizeof(struct snapshot_handle));
 	if ((filp->f_flags & O_ACCMODE) == O_RDONLY) {
+		/* Hibernating.  The image device should be accessible. */
 		data->swap = swsusp_resume_device ?
 			swap_type_of(swsusp_resume_device, 0, NULL) : -1;
 		data->mode = O_RDONLY;
@@ -99,6 +101,13 @@ static int snapshot_open(struct inode *i
 		if (error)
 			pm_notifier_call_chain(PM_POST_HIBERNATION);
 	} else {
+		/*
+		 * Resuming.  We may need to wait for the image device to
+		 * appear.
+		 */
+		wait_for_device_probe();
+		scsi_complete_async_scans();
+
 		data->swap = -1;
 		data->mode = O_WRONLY;
 		error = pm_notifier_call_chain(PM_RESTORE_PREPARE);
