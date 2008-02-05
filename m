Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbYBES1H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbYBES1H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 13:27:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYBES0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 13:26:55 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47150 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751234AbYBES0y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 13:26:54 -0500
Date: Tue, 5 Feb 2008 19:27:12 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Nigel Cunningham <nigel@nigel.suspend2.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Trivial patch monkey <trivial@kernel.org>
Subject: Re: [linux-pm] Re: Small pm documentation cleanups
Message-ID: <20080205182712.GA9483@elf.ucw.cz>
References: <20080204234700.GA1912@elf.ucw.cz> <200802050224.51039.rjw@sisk.pl> <47A7F581.8060300@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A7F581.8060300@nigel.suspend2.net>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

>> On Tuesday, 5 of February 2008, Pavel Machek wrote:
>>> Small documentation fixes/additions that accumulated in my tree.
>>>
>>> Signed-off-by: Pavel Machek <pavel@suse.cz>
>>
>> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>>
...
>>> 0
>>>   	acpi_sleep=	[HW,ACPI] Sleep options
>>> -			Format: { s3_bios, s3_mode }
>>> -			See Documentation/power/video.txt
>>> +			Format: { s3_bios, s3_mode, s3_beep }
>>> +			See Documentation/power/video.txt for s3_bios and s3_mode.
>>> +			s3_beep is for debugging; it beeps on PC speaker as soon as
>>> +			kernel's real-mode entry point is called.
>
> s/kernel's/the kernel's/

Thanks for comments, I applied them.

Small documentation fixes/additions that accumulated in my tree.

Len, please pick this up, thanks.
									Pavel


Signed-off-by: Pavel Machek <pavel@suse.cz>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index cf38689..e2fb127 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -147,8 +147,10 @@ and is between 256 and 4096 characters. 
 			default: 0
 
 	acpi_sleep=	[HW,ACPI] Sleep options
-			Format: { s3_bios, s3_mode }
-			See Documentation/power/video.txt
+			Format: { s3_bios, s3_mode, s3_beep }
+			See Documentation/power/video.txt for s3_bios and s3_mode.
+			s3_beep is for debugging; it beeps on PC speaker as soon as
+			the kernel's real-mode entry point is called.
 
 	acpi_sci=	[HW,ACPI] ACPI System Control Interrupt trigger mode
 			Format: { level | edge | high | low }
diff --git a/Documentation/power/swsusp.txt b/Documentation/power/swsusp.txt
index aea7e92..9d60ab7 100644
--- a/Documentation/power/swsusp.txt
+++ b/Documentation/power/swsusp.txt
@@ -386,6 +386,11 @@ before suspending; then remount them aft
 There is a work-around for this problem.  For more information, see
 Documentation/usb/persist.txt.
 
+Q: Can I suspend-to-disk using a swap partition under LVM?
+
+A: No. You can suspend successfully, but you'll not be able to
+resume. uswsusp should be able to work with LVM. See suspend.sf.net.
+
 Q: I upgraded the kernel from 2.6.15 to 2.6.16. Both kernels were
 compiled with the similar configuration files. Anyway I found that
 suspend to disk (and resume) is much slower on 2.6.16 compared to
diff --git a/drivers/acpi/hardware/hwsleep.c b/drivers/acpi/hardware/hwsleep.c
index fd1c4ba..058d0be 100644
--- a/drivers/acpi/hardware/hwsleep.c
+++ b/drivers/acpi/hardware/hwsleep.c
@@ -286,13 +286,13 @@ acpi_status asmlinkage acpi_enter_sleep_
 	}
 
 	/*
+	 * 1) Disable/Clear all GPEs
 	 * 2) Enable all wakeup GPEs
 	 */
 	status = acpi_hw_disable_all_gpes();
 	if (ACPI_FAILURE(status)) {
 		return_ACPI_STATUS(status);
 	}
-
 	acpi_gbl_system_awake_and_running = FALSE;
 
 	status = acpi_hw_enable_all_wakeup_gpes();
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 485de13..c9a733f 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -170,7 +170,7 @@ static int acpi_pm_enter(suspend_state_t
 	/* Reprogram control registers and execute _BFS */
 	acpi_leave_sleep_state_prep(acpi_state);
 
-	/* ACPI 3.0 specs (P62) says that it's the responsabilty
+	/* ACPI 3.0 specs (P62) says that it's the responsibility
 	 * of the OSPM to clear the status bit [ implying that the
 	 * POWER_BUTTON event should not reach userspace ]
 	 */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index ef9b802..78bb205 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -74,14 +74,14 @@ config PM_TRACE_RTC
 	RTC across reboots, so that you can debug a machine that just hangs
 	during suspend (or more commonly, during resume).
 
-	To use this debugging feature you should attempt to suspend the machine,
-	then reboot it, then run
+	To use this debugging feature you should attempt to suspend the
+	machine, reboot it and then run
 
 		dmesg -s 1000000 | grep 'hash matches'
 
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
 config PM_SLEEP_SMP
 	bool
 	depends on SMP
@@ -123,7 +129,10 @@ config HIBERNATION
 	  called "hibernation" in user interfaces.  STD checkpoints the
 	  system and powers it off; and restores that checkpoint on reboot.
 
-	  You can suspend your machine with 'echo disk > /sys/power/state'.
+	  You can suspend your machine with 'echo disk > /sys/power/state' 
+	  after placing resume=/dev/swappartition on the kernel command line
+	  in your bootloader's configuration file.
+
 	  Alternatively, you can use the additional userland tools available
 	  from <http://suspend.sf.net>.
 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
