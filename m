Return-Path: <linux-kernel-owner+w=401wt.eu-S1755696AbZDKCK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755696AbZDKCK3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 22:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbZDKCKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 22:10:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:22755 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbZDKCKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 22:10:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,171,1239001200"; 
   d="scan'208";a="402213063"
Message-ID: <49DFFC05.7070509@linux.intel.com>
Date: Fri, 10 Apr 2009 19:10:13 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "Rafael J. Wysocki" <rjw@suse.com>, linux-pm@lists.linux-foundation.org,
       Takashi Iwai <tiwai@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
References: <200904100057.43827.rjw@sisk.pl> <200904102058.36018.rjw@sisk.pl> <alpine.LFD.2.00.0904101204350.4583@localhost.localdomain> <200904110206.33525.rjw@suse.com> <alpine.LFD.2.00.0904101817100.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904101817100.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Sat, 11 Apr 2009, Rafael J. Wysocki wrote:
>> On Friday 10 April 2009, Linus Torvalds wrote:
>>> On Fri, 10 Apr 2009, Rafael J. Wysocki wrote:
>>>> I've just verified that the resume-after-hibernation issue goes away after
>>>> reverting commit 9710794383ee5008d67f1a6613a4717bf6de47bc
>>>> (async: remove the temporary (2.6.29) "async is off by default" code) , so it
>>>> is async-related.
>>> Arjan? Clearly all the necessary fixes weren't found..
>>>
>>> There _is_ a module loading problem wrt initmem - I think you found that 
>>> and we added a hack for it for the ACPI battery driver. I wonder if we're 
>>> hitting a similar issue now with module discovery: modules that use 
>>> "async_schedule()" to do their discovery asynchronously are now not 
>>> necessarily fully "done" when the module is loaded. 
>>>
>>> And so, anything that expected the devices to be available after module 
>>> load (like they used to) would be screwed.
>>>
>>> IOW, maybe something like the totally untested patch appended here (that 
>>> should also allow us to make the ACPI battery code to go back to using 
>>> __init).
>> I tested it and it worked.
> 
> Hmm.
> 
> I'm not 100% sure that patch is good.
> 
> The reason? I think it's going to deadlock if an async caller ends up 
> wanting to load a module, because then the nested 
> "async_synchronize_full()" will basically want to wait for itself.
> 
> So it's a good test-patch, and maybe no async caller ever loads a module, 
> but it makes me a bit nervous.

It would make a rule that async context can only use request_module_nowait().
Not too nice, I think we can do better.

> But the fact that it fixes things for you at least means that the _reason_ 
> for the problem is know, and maybe there are alternative solutions. Arjan?

We have async domains; for the acpi type of case we could make a "__init" domain
that we wait on selectively... but I'm not too fond of this since it'll be fragile over time.

I suppose this got exposed now that we (just) removed the stop_machine stuff from the module loader...
(which is a generally good improvement, don't get me wrong).

For the __init freeing case there is a even more interesting option:
We can schedule an async task that will free the init mem of the module, and have that
async task just wait for all its predecessors to complete before doing the actual work.
That way the module is available and ready to its caller, while the freeing of the init mem
will be done at a safe time.

Like this (not yet tested):

diff --git a/kernel/module.c b/kernel/module.c
index 1196f5d..4ec90e8 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2312,6 +2312,22 @@ static noinline struct module *load_module(void __user *umod,
  	goto free_hdr;
  }

+static void async_module_free_initmem(void *data, async_cookie_t cookie)
+{
+	struct module *mod = data;
+	async_synchronize_cookie(cookie);
+
+	mutex_lock(&module_mutex);
+	/* Drop initial reference. */
+	module_put(mod);
+	module_free(mod, mod->module_init);
+	mod->module_init = NULL;
+	mod->init_size = 0;
+	mod->init_text_size = 0;
+	mutex_unlock(&module_mutex);
+
+}
+
  /* This is where the real work happens */
  SYSCALL_DEFINE3(init_module, void __user *, umod,
  		unsigned long, len, const char __user *, uargs)
@@ -2372,15 +2388,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
  	blocking_notifier_call_chain(&module_notify_list,
  				     MODULE_STATE_LIVE, mod);

-	mutex_lock(&module_mutex);
-	/* Drop initial reference. */
-	module_put(mod);
-	module_free(mod, mod->module_init);
-	mod->module_init = NULL;
-	mod->init_size = 0;
-	mod->init_text_size = 0;
-	mutex_unlock(&module_mutex);
-
+	async_schedule(async_module_free_initmem, mod);
  	return 0;
  }



Now the second case of "the devices are available when the module load is done".

The hard case here is that we're talking about a storage device. In 2.6.28 and before (eg well before
any async stuff landed), SCSI probing already was done asynchronously. Same for USB. Libata I think is the same,
by virtue of using scsi as infrastructure.

Realistically, unless you call scsi_complete_async_scans(), you could not depend on scsi devices being available
after loading one of their modules. (from userland you could do this via the scsi_wait_scan module)

(speculation: on ATA likely the scan was done relatively quickly ... and with async it's just done with different timing. So it
was kind of luck before)

Rafael: would it be reasonable to call "scsi_compete_async_scans()" from the resume-from-disk code ?
