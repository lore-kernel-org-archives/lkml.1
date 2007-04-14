Return-Path: <linux-kernel-owner+w=401wt.eu-S1750925AbXDNUUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbXDNUUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 16:20:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750911AbXDNUUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 16:20:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51748 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925AbXDNUUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 16:20:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Diedrich <ranma@tdiedrich.de>
Subject: Re: Linux 2.6.21-rc6
Date: Sat, 14 Apr 2007 22:23:31 +0200
User-Agent: KMail/1.9.5
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <200704142028.04694.rjw@sisk.pl> <20070414195611.GC806@yamamaya.is-a-geek.org>
In-Reply-To: <20070414195611.GC806@yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704142223.32410.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 14 April 2007 21:56, Tobias Diedrich wrote:
> Rafael J. Wysocki wrote:
> > On Saturday, 14 April 2007 15:00, Adrian Bunk wrote:
> > > On Sat, Apr 14, 2007 at 02:31:54PM +0200, Tobias Diedrich wrote:
> > > > Tobias Diedrich wrote:
> > > > > > ed746e3b18f4df18afa3763155972c5835f284c5 is first bad commit
> > > > > > commit ed746e3b18f4df18afa3763155972c5835f284c5
> > > > > > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > > Date:   Sat Feb 10 01:43:32 2007 -0800
> > > > > > 
> > > > > >     [PATCH] swsusp: Change code ordering in disk.c
> > > > > >     
> > > > > >     Change the ordering of code in kernel/power/disk.c so that device_suspend() is
> > > > > >     called before disable_nonboot_cpus() and platform_finish() is called after
> > > > > >     enable_nonboot_cpus() and before device_resume(), as indicated by the recent
> > > > > >     discussion on Linux-PM (cf.
> > > > > >     http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).
> > > > > >     
> > > > > >     The changes here only affect the built-in swsusp.
> > > > > >     
> > > > > >     [alexey.y.starikovskiy@linux.intel.com: fix LED blinking during image load]
> > > > > >     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > >     Acked-by: Pavel Machek <pavel@ucw.cz>
> > > > > >     Cc: Greg KH <greg@kroah.com>
> > > > > >     Cc: Nigel Cunningham <nigel@suspend2.net>
> > > > > >     Cc: Patrick Mochel <mochel@digitalimplant.org>
> > > > > >     Cc: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
> > > > > >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > > >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > > 
> > > > > > :040000 040000 7eca5b3a8f9606bc4f2ff41192ec8c9d4ca90d18 8313b674e1d1bdf6849350af06d28a89b3bb3054 M      kernel
> > > > > > 
> > > > > > 
> > > > > > Now, the remaining test is to try reverting this commit from -rc6. :)
> > > > > 
> > > > > Doesn't apply cleanly against -rc6, but fixes the problem when
> > > > > reverted from -rc1.
> > > > 
> > > > Now, this was already reported in
> > > > http://lkml.org/lkml/2007/3/16/126
> > > > and I even flagged that message in my local folder, but apparently forgot
> > > > to follow up on it... *sigh*
> > > 
> > > Unless I misunderstood something, all of the problems Maxim described in 
> > > this email are fixed for him in -rc6.
> > > 
> > > But it's quite possible that you are running into a different issue 
> > > exposed by this commit.
> > 
> > Yes, it's likely.
> > 
> > Tobias, I'm unable to reproduce the problem with your .config, but my hardware
> > is certainly different.  Which suspend mode do you use?  If that's "platform",
> > can you try to use "shutdown" or "reboot" and see if that helps?
> 
> Sure.
> shutdown/reboot works fine, only platform is broken.

Thanks.

Now, I suspect the problem is somehow related to the hardware, so it would help
a lot if we could identify the piece of hardware (or driver) involved.

AFAICT, your system is a non-SMP one, so we can rule out
disable/enable_nonboot_cpus().  To confirm that the problem is related to
platform_finish(), can you please apply the appended debug patch and
see if the suspend in the 'platform' mode works with it?

Also, would that be feasible for you to use 'shutdown' as a workaround in case
the source of the problem is difficult to find and/or fix?

Rafael

---
 kernel/power/disk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.21-rc6/kernel/power/disk.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/disk.c
+++ linux-2.6.21-rc6/kernel/power/disk.c
@@ -170,8 +170,8 @@ int pm_suspend_disk(void)
 
 	if (in_suspend) {
 		enable_nonboot_cpus();
-		platform_finish();
 		device_resume();
+		platform_finish();
 		resume_console();
 		pr_debug("PM: writing image.\n");
 		error = swsusp_write();
@@ -189,8 +189,8 @@ int pm_suspend_disk(void)
  Enable_cpus:
 	enable_nonboot_cpus();
  Resume_devices:
-	platform_finish();
 	device_resume();
+	platform_finish();
 	resume_console();
  Thaw:
 	unprepare_processes();


