Return-Path: <linux-kernel-owner+w=401wt.eu-S1752548AbZFLPF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbZFLPF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZFLPFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:05:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:46587 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZFLPFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:05:14 -0400
Date: Fri, 12 Jun 2009 17:05:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090612150504.GA15084@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <20090610194852.GA28787@n2100.arm.linux.org.uk> <a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com> <20090610213710.GA8472@elf.ucw.cz> <a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com> <20090611082532.GE8592@elf.ucw.cz> <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 01:48:57, Brian Swetland wrote:
> On Thu, Jun 11, 2009 at 1:25 AM, Pavel Machek<pavel@ucw.cz> wrote:
> > On Wed 2009-06-10 14:55:52, Brian Swetland wrote:
> >> I'm not sure the smd (shared memory driver / virtual serial channels)
> >> that everything else depends on makes sense outside of mach-msm, given
> >> it's all very specific to the baseband and firmware that runs on it.
> >
> > Well, it is still a driver for your baseband chip, right?
> 
> Yes -- what I meant is more "does it belong under arch/arm/mach-msm/"
> (given that it's very specific to that architecture and unlikely to
> ever be useful elsewhere) or "does it belong somewhere else" (because
> it's a pretty big pile of code compared to other stuff like
> gpio/interrupt/etc stuff that tends to live under arch/arm/mach-*/).

If it is driver for baseband, then it could live outside mach-msm,
right?

> > ...drivers/staging is _not_ final place for your code. When the code
> > is good enough, it should move. But it is place where stuff like TI
> > wifi driver would be acceptable.
> 
> Interesting -- reading up more on staging now.  I know that Greg KH
> has been pulling some of the "generic" android drivers into staging
> (Thanks, Greg!), but hadn't really looked at the rationale behind
> staging in general.

staging is for GPLed code that needs to be cleaned up, first. Horrible
stuff like drivers for windows in windows coding style go there.

> Sounds like packing up the serial, sdio, nand, framebuffer, etc
> drivers for submission into staging might make sense.  We can do the
> obvious stuff like make sure they're checkpatch clean and reasonably
> tidy first.

Actually, I believe it would be better to submit them first and
checkpatch later. I quickly went through the patches (122KLoC)... and
most are pretty much okay, but some have issues bigger than coding
style (like wrong userland interfaces).

> In order to actually have the peripherals work, though, we'd need to
> add to board-*.c, devices.c, etc so that the platform devices are
> defined so the platform drivers (which almost all of these are) are
> actually probed.

Well, applying smaller patch is better than applying big patch...

> >> Basically there's a stack:
> >>
> >> smsm  -- "shared memory state machine" (used for power collapse coordination)
> >> smd -- "shared memory driver" (virtual serial channels, 8k bidirectional fifos)
> >> rpcrouter/oncrpc -- rpc transport layer used for audio, audio
> >>routing, etc

What is htc_pwrsink infrastructure? Some kind of power accounting
infrastructure for better battery estimates?

> >> These are linux implementations of protocols the baseband speaks.
> >>
> >> Other stuff then stacks on smd (rmnet -- virtual ethernet, at control
> >> channels, etc) and oncrpc (dsp control, rtc, gps, some media control).

I see stuff like jpeg and mp3 coprocessors. That's oncrpc?

> > Is it all neccessary for boot? Getting it booting with display should
> > be the first goal... GPS/RTC/... can come later.
> 
> The lowest layer IPC (proc_comm) is used for clock/power control and
> is already in mainline, and that gets the clk_* framework functional
> and allows most of the peripheral drivers to work, thankfully.  Things
> like the serial driver, framebuffer, sdio, nand controller, etc all
> should be happy without additional core architecture support.

Good, with framebuffer+nand we have "usable" machine, right?

Can someone apply this?

---

Improve documentation, add machine description to Kconfig, remove
misleading comment.

Signed-off-by: Pavel Machek <pavel@ucw.cz>  

diff --git a/Documentation/android.txt b/Documentation/android.txt
index 72a62af..15922d6 100644
--- a/Documentation/android.txt
+++ b/Documentation/android.txt
@@ -14,6 +14,12 @@ CONTENTS:
   1.3 Recommended enabled config options
 2. Contact
 
+0. Getting sources:
+-----------------
+
+git clone  --reference /path/to/linux-git/for/speedup/ git://android.git.kernel.org/kernel/msm.git
+git checkout -b android-msm-2.6.29 origin/android-msm-2.6.29
+
 
 1. Android
 ==========
@@ -26,6 +32,7 @@ To see a working defconfig look at msm_defconfig or goldfish_defconfig
 which can be found at http://android.git.kernel.org in kernel/common.git
 and kernel/msm.git
 
+msm_defconfig should work on qualcomm reference design, HTC Magic and G1/ADP1.
 
 1.1 Required enabled config options
 -----------------------------------
@@ -114,6 +121,22 @@ SERIAL_CORE
 SERIAL_CORE_CONSOLE
 
 
+Board code names
+----------------
+
+board-halibut is a qualcomm reference design.  board-sapphire is HTC
+Magic.  board-trout is HTC Dream/G1/ADP1.
+
+Booting your kernel
+-------------------
+
+hold down camera and red button to boot into rainbow screen. Then
+
+./fastboot boot linux-msm/arch/arm/boot/zImage ramdisk.img
+
+Machine will freeze at rainbow screen for a while, be
+patient. ramdisk.img is required.
+
 2. Contact
 ==========
 website: http://android.git.kernel.org
diff --git a/arch/arm/mach-msm/Kconfig b/arch/arm/mach-msm/Kconfig
index 310caeb..478d20a 100644
--- a/arch/arm/mach-msm/Kconfig
+++ b/arch/arm/mach-msm/Kconfig
@@ -62,7 +62,9 @@ config MACH_HALIBUT
 config MACH_TROUT
 	depends on ARCH_MSM
 	default y
-	bool "Trout"
+	bool "Trout (HTC Dream, T-Mobile G1, Google ADP1)"
+	help
+	 Select this to support HTC Dream, T-Mobile G1, Google ADP1.
 
 config MACH_SAPPHIRE
 	depends on ARCH_MSM
diff --git a/include/linux/usb/mass_storage_function.h b/include/linux/usb/mass_storage_function.h
index 75ebce0..73cf1d4 100644
--- a/include/linux/usb/mass_storage_function.h
+++ b/include/linux/usb/mass_storage_function.h
@@ -1,5 +1,4 @@
 /*
- *  Switch class driver
  *
  * Copyright (C) 2008 Google, Inc.
  * Author: Mike Lockwood <lockwood@android.com>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
