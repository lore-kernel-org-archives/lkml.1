Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbXITVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbXITVJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbXITVJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 17:09:01 -0400
Received: from www.osadl.org ([213.239.205.134]:54988 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750772AbXITVJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 17:09:00 -0400
Subject: Re: 2.6.23-rc6-mm1: failure to boot on HP nx6325, no sound when
	booted, USB-related WARNING
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jaroslav Kysela <perex@suse.cz>, Takashi Iwai <tiwai@suse.de>,
       linux-usb-devel@lists.sourceforge.net,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Linus Torvalds <torvalds@osdl.org>,
       miklos@szeredi.hu
In-Reply-To: <200709202239.11070.rjw@sisk.pl>
References: <20070918011841.2381bd93.akpm@linux-foundation.org>
	 <1190299841.3481.37.camel@chaos> <1190303393.3639.0.camel@chaos>
	 <200709202239.11070.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 23:08:52 +0200
Message-Id: <1190322532.3085.42.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

On Thu, 2007-09-20 at 22:39 +0200, Rafael J. Wysocki wrote:
> > Works as well. What's the difference between this and the real thing ?
> 
> The real thing also calls device_power_down(PMSG_FREEZE), which is a
> counterpart of sysdev_shutdown(), more or less, and I think that's what goes
> belly up.
> 
> You can use the patch below (on top of -rc6-mm1), which just disables the image
> creation (that should be irrelevant anyway) and see what happens.

In meantime I figured out what's happening. The ordering in
hibernate_snapshot() is wrong. It does:

	swsusp_shrink_memory();
        suspend_console();
        device_suspend(PMSG_FREEZE);
        platform_prepare(platform_mode);

	disable_nonboot_cpus();

        swsusp_suspend();

	enable_nonboot_cpus();

	platform_finish(platform_mode);
        device_resume();
        resume_console();

We disable everything in device_suspend() including timekeeping, so any
code which is depending on working timekeeping and timer functionality
(which is suspended in timekeeping_suspend() as well) is busted.

enable_nonboot_cpus() definitely relies on working timekeeping and
timers depending on the codepath. It's just a surprise that this did not
blow up earlier (also before clock events).

I changed the ordering of the above to:

	disable_nonboot_cpus();

	swsusp_shrink_memory();
        suspend_console();
        device_suspend(PMSG_FREEZE);
        platform_prepare(platform_mode);
        swsusp_suspend();
	platform_finish(platform_mode);
        device_resume();
        resume_console();

	enable_nonboot_cpus();

and non-surprisingly the "my VAIO needs help from keyboard" problem went
away immediately. See patch below. (on top of rc7-hrt1, -mm1 does not
work at all on my VAIO due to some yet not identified wreckage)

I did not yet look into the suspend to ram code, but I guess that there
is an equivalent problem.

But I have no idea why this affects Andrews jinxed VAIO (UP machine),
though I suspect that we have more timekeeping/timer depending code
somewhere waiting to bite us.

Also I still need to debug why the HIBERNATION_TEST code path (which has
a msleep(5000) in it) does not fail, but I postpone this until tomorrow
morning. I'm dead tired after hunting this Heisenbug which changes with
every other printk added to the code. I'm going to add some really noisy
messages for everything which accesses timekeeping / timers _after_
those systems have been shut down.

We really need to fix this once and forever _before_ 2.6.23 final, even
if it requires a -rc8.

Thanks,

	tglx

--- a/kernel/power/disk.c	2007-09-11 09:25:24.000000000 +0200
+++ b/kernel/power/disk.c	2007-09-20 22:47:30.000000000 +0200
@@ -130,10 +130,14 @@ int hibernation_snapshot(int platform_mo
 {
 	int error;
 
+	error = disable_nonboot_cpus();
+	if (error)
+		goto resume_cpus;
+
 	/* Free memory before shutting down devices. */
 	error = swsusp_shrink_memory();
 	if (error)
-		return error;
+		goto resume_cpus;
 
 	suspend_console();
 	error = device_suspend(PMSG_FREEZE);
@@ -144,23 +148,22 @@ int hibernation_snapshot(int platform_mo
 	if (error)
 		goto Resume_devices;
 
-	error = disable_nonboot_cpus();
-	if (!error) {
-		if (hibernation_mode != HIBERNATION_TEST) {
-			in_suspend = 1;
-			error = swsusp_suspend();
-			/* Control returns here after successful restore */
-		} else {
-			printk("swsusp debug: Waiting for 5 seconds.\n");
-			mdelay(5000);
-		}
+	if (hibernation_mode != HIBERNATION_TEST) {
+		in_suspend = 1;
+		error = swsusp_suspend();
+		/* Control returns here after successful restore */
+	} else {
+		printk("swsusp debug: Waiting for 5 seconds.\n");
+		mdelay(5000);
 	}
-	enable_nonboot_cpus();
+
  Resume_devices:
 	platform_finish(platform_mode);
 	device_resume();
  Resume_console:
 	resume_console();
+resume_cpus:
+	enable_nonboot_cpus();
 	return error;
 }
 



