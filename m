Return-Path: <linux-kernel-owner+w=401wt.eu-S1755585AbXKAWoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbXKAWoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 18:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755901AbXKAWn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 18:43:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50810 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755227AbXKAWn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 18:43:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 3/3] PM: Suspend/hibernation debug documentation update
Date: Fri, 2 Nov 2007 00:00:25 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Pavel Machek <pavel@ucw.cz>
References: <200711012357.27797.rjw@sisk.pl>
In-Reply-To: <200711012357.27797.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711020000.25630.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Update the suspend/hibernation debugging and testing documentation to describe
the newly introduced testing facilities.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 Documentation/power/basic-pm-debugging.txt |  188 ++++++++++++++++++++---------
 Documentation/power/drivers-testing.txt    |   28 ++--
 2 files changed, 149 insertions(+), 67 deletions(-)

Index: linux-2.6/Documentation/power/drivers-testing.txt
===================================================================
--- linux-2.6.orig/Documentation/power/drivers-testing.txt
+++ linux-2.6/Documentation/power/drivers-testing.txt
@@ -6,9 +6,9 @@ Testing suspend and resume support in de
 Unfortunately, to effectively test the support for the system-wide suspend and
 resume transitions in a driver, it is necessary to suspend and resume a fully
 functional system with this driver loaded.  Moreover, that should be done
-several times, preferably several times in a row, and separately for the suspend
-to disk (STD) and the suspend to RAM (STR) transitions, because each of these
-cases involves different ordering of operations and different interactions with
+several times, preferably several times in a row, and separately for hibernation
+(aka suspend to disk or STD) and suspend to RAM (STR), because each of these
+cases involves slightly different operations and different interactions with
 the machine's BIOS.
 
 Of course, for this purpose the test system has to be known to suspend and
@@ -22,20 +22,24 @@ for more information about the debugging
 Once you have resolved the suspend/resume-related problems with your test system
 without the new driver, you are ready to test it:
 
-a) Build the driver as a module, load it and try the STD in the test mode (see:
-Documents/power/basic-pm-debugging.txt, 1a)).
+a) Build the driver as a module, load it and try the test modes of hibernation
+(see: Documents/power/basic-pm-debugging.txt, 1)).
 
-b) Load the driver and attempt to suspend to disk in the "reboot", "shutdown"
-and "platform" modes (see: Documents/power/basic-pm-debugging.txt, 1).
+b) Load the driver and attempt to hibernate in the "reboot", "shutdown" and
+"platform" modes (see: Documents/power/basic-pm-debugging.txt, 1).
 
-c) Compile the driver directly into the kernel and try the STD in the test mode.
+c) Compile the driver directly into the kernel and try the test modes of
+hibernation.
 
-d) Attempt to suspend to disk with the driver compiled directly into the kernel
+d) Attempt to hibernate with the driver compiled directly into the kernel
 in the "reboot", "shutdown" and "platform" modes.
 
-e) Attempt to suspend to RAM using the s2ram tool with the driver loaded (see:
-Documents/power/basic-pm-debugging.txt, 2).  As far as the STR tests are
-concerned, it should not matter whether or not the driver is built as a module.
+e) Try the test modes of suspend (see: Documents/power/basic-pm-debugging.txt,
+2)).  [As far as the STR tests are concerned, it should not matter whether or
+not the driver is built as a module.]
+
+f) Attempt to suspend to RAM using the s2ram tool with the driver loaded
+(see: Documents/power/basic-pm-debugging.txt, 2).
 
 Each of the above tests should be repeated several times and the STD tests
 should be mixed with the STR tests.  If any of them fails, the driver cannot be
Index: linux-2.6/Documentation/power/basic-pm-debugging.txt
===================================================================
--- linux-2.6.orig/Documentation/power/basic-pm-debugging.txt
+++ linux-2.6/Documentation/power/basic-pm-debugging.txt
@@ -1,45 +1,96 @@
 Debugging suspend and resume
 	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
 
-1. Testing suspend to disk (STD)
+1. Testing hibernation (aka suspend to disk or STD)
 
-To verify that the STD works, you can try to suspend in the "reboot" mode:
+To check if hibernation works, you can try to hibernate in the "reboot" mode:
 
 # echo reboot > /sys/power/disk
 # echo disk > /sys/power/state
 
-and the system should suspend, reboot, resume and get back to the command prompt
-where you have started the transition.  If that happens, the STD is most likely
-to work correctly, but you need to repeat the test at least a couple of times in
-a row for confidence.  This is necessary, because some problems only show up on
-a second attempt at suspending and resuming the system.  You should also test
-the "platform" and "shutdown" modes of suspend:
+and the system should create a hibernation image, reboot, resume and get back to
+the command prompt where you have started the transition.  If that happens,
+hibernation is most likely to work correctly.  Still, you need to repeat the
+test at least a couple of times in a row for confidence.  This is necessary,
+because some problems only show up on a second attempt at suspending and
+resuming the system.  Moreover, hibernating in the "reboot" and "shutdown" modes
+causes the PM core to skip some platform-related callbacks which on ACPI systems
+might be necessary to make hibernation work.  Thus, if you machine fails to
+hibernate or resume in the "reboot" mode, you should try the "platform" mode:
 
 # echo platform > /sys/power/disk
 # echo disk > /sys/power/state
 
-or
+which is the default and recommended mode of hibernation.
+
+Unfortunately, the "platform" mode of hibernation does not work on some systems
+with broken BIOSes.  In such cases the "shutdown" mode of hibernation might
+work:
 
 # echo shutdown > /sys/power/disk
 # echo disk > /sys/power/state
 
-in which cases you will have to press the power button to make the system
-resume.  If that does not work, you will need to identify what goes wrong.
+(it is similar to the "reboot" mode, but it requires you to press the power
+button to make the system resume).
+
+If neither "platform" nor "shutdown" hibernation mode works, you will need to
+identify what goes wrong.
 
-a) Test mode of STD
+a) Test modes of hibernation
 
-To verify if there are any drivers that cause problems you can run the STD
-in the test mode:
+To find out why hibernation fails on your system, you can use a special testing
+facility available if the kernel is compiled with CONFIG_PM_DEBUG set.  Then,
+there is the file /sys/power/pm_test_level that can be used to make the
+hibernation core run in a test mode.  There are 5 test modes available:
+
+5 - test the freezing of processes
+4 - test the freezing of processes and suspending of devices
+3 - test the freezing of processes, suspending of devices and ACPI global
+    control methods(*)
+2 - test the freezing of processes, suspending of devices, ACPI global control
+    methods(*) and the disabling of nonboot CPUs
+1 - test the freezing of processes, suspending of devices, ACPI global control
+    methods(*), the disabling of nonboot CPUs and suspending of platform/system
+    devices
+
+(*) - the ACPI global control methods are only tested on ACPI systems, if the
+      hibernation mode is set to "platform"
+
+To use test mode N it is necessary to write N to /sys/power/pm_test_level
+and issue the standard hibernation commands.  For example, to use test mode 4
+along with the "platform" mode of hibernation, you should do the following:
 
-# echo test > /sys/power/disk
+# echo 4 > /sys/power/pm_test_level
+# echo platform > /sys/power/disk
 # echo disk > /sys/power/state
 
-in which case the system should freeze tasks, suspend devices, disable nonboot
-CPUs (if any), wait for 5 seconds, enable nonboot CPUs, resume devices, thaw
-tasks and return to your command prompt.  If that fails, most likely there is
-a driver that fails to either suspend or resume (in the latter case the system
-may hang or be unstable after the test, so please take that into consideration).
-To find this driver, you can carry out a binary search according to the rules:
+Then, the kernel will try to freeze processes, suspend devices, wait 5 seconds,
+resume devices and thaw processes.  At level 3, after suspending devices the
+kernel will additionally invoke the global ACPI control methods used to prepare
+the platform firmware for hibernation.  Then, it will wait 5 seconds and invoke
+the ACPI global methods used to cancel hibernation etc.
+
+Writing 0 to /sys/power/pm_test_level causes the kernel to switch to the normal
+hibernation/suspend operations.
+
+Generally, as you can see, each test level is more "invasive" than the previous
+one and level 1 tests the hardware and drivers as deeply as possible without
+creating a hibernation image.  Obviously, if level N test fails, level N-1 test
+will also fail etc., so as a rule of thumb you should try the test modes
+starting from 5 and after sucessfully running level N test you should progress
+to level N-1 (repeat the test on each level a couple of times to make sure that
+any random factors are avoided).
+
+If level 5 test fails, there is a task that cannot be frozen (in that case it
+usually is possible to identify the offending task by analysing the output of
+dmesg obtained after the failing test).  Failure at this level usually means
+that there is a problem with the tasks freezer subsystem that should be
+reported.
+
+If level 4 test fails, most likely there is a driver that cannot suspend or
+resume its device (in the latter case the system may hang or become unstable
+after the test, so please take that into consideration).  To find this driver,
+you can carry out a binary search according to the rules:
 - if the test fails, unload a half of the drivers currently loaded and repeat
 (that would probably involve rebooting the system, so always note what drivers
 have been loaded before the test),
@@ -47,23 +98,42 @@ have been loaded before the test),
 recently and repeat.
 
 Once you have found the failing driver (there can be more than just one of
-them), you have to unload it every time before the STD transition.  In that case
-please make sure to report the problem with the driver.
+them), you have to unload it every time before hibernation.  In that case please
+make sure to report the problem with the driver.
 
-It is also possible that a cycle can still fail after you have unloaded
-all modules. In that case, you would want to look in your kernel configuration
-for the drivers that can be compiled as modules (testing again with them as
-modules), and possibly also try boot time options such as "noapic" or "noacpi".
+It is also possible that level 4 test will still fail after you have unloaded
+all modules. In that case, you may want to look in your kernel configuration
+for the drivers that can be compiled as modules (and test again with these
+drivers compiled as modules).  You may also try to use some special kernel
+command line options such as "noapic", "noacpi" or even "acpi=off".
+
+If level 3 test fails, there is a problem with the handling of ACPI firmware on
+your system.  In that case the "platform" mode of hibernation is not likely to
+work.  You can try the "shutdown" mode, but that is rather a poor man's
+workaround.
+
+If level 2 test fails, the disabling/enabling of nonboot CPUs does not work
+(of course, this only may be an issue on SMP systems) and the problem should be
+reported.
+
+Also, if level 1 test fails, which means that suspending of the system/platform
+devices has failed (these devices are suspended on one CPU with interrupts off),
+the problem should be reported.
+
+A failure of any of the level 3-1 tests may caues your system to hang or become
+unstable, so please beware.  Such a failure usually indicates a serious problem
+that very well may be related to the hardware, but please report it anyway.
 
 b) Testing minimal configuration
 
-If the test mode of STD works, you can boot the system with "init=/bin/bash"
-and attempt to suspend in the "reboot", "shutdown" and "platform" modes.  If
-that does not work, there probably is a problem with a driver statically
-compiled into the kernel and you can try to compile more drivers as modules,
-so that they can be tested individually.  Otherwise, there is a problem with a
-modular driver and you can find it by loading a half of the modules you normally
-use and binary searching in accordance with the algorithm:
+If all of the hibernation test modes work, you can boot the system with the
+"init=/bin/bash" command line parameter and attempt to hibernate in the
+"reboot", "shutdown" and "platform" modes.  If that does not work, there
+probably is a problem with a driver statically compiled into the kernel and you
+can try to compile more drivers as modules, so that they can be tested
+individually.  Otherwise, there is a problem with a modular driver and you can
+find it by loading a half of the modules you normally use and binary searching
+in accordance with the algorithm:
 - if there are n modules loaded and the attempt to suspend and resume fails,
 unload n/2 of the modules and try again (that would probably involve rebooting
 the system),
@@ -71,18 +141,18 @@ the system),
 load n/2 modules more and try again.
 
 Again, if you find the offending module(s), it(they) must be unloaded every time
-before the STD transition, and please report the problem with it(them).
+before hibernation, and please report the problem with it(them).
 
 c) Advanced debugging
 
-In case the STD does not work on your system even in the minimal configuration
-and compiling more drivers as modules is not practical or some modules cannot
-be unloaded, you can use one of the more advanced debugging techniques to find
-the problem.  First, if there is a serial port in your box, you can boot the
-kernel with the 'no_console_suspend' parameter and try to log kernel
-messages using the serial console.  This may provide you with some information
-about the reasons of the suspend (resume) failure.  Alternatively, it may be
-possible to use a FireWire port for debugging with firescope
+In case that hibernation does not work on your system even in the minimal
+configuration and compiling more drivers as modules is not practical or some
+modules cannot be unloaded, you can use one of the more advanced debugging
+techniques to find the problem.  First, if there is a serial port in your box,
+you can boot the kernel with the 'no_console_suspend' parameter and try to log
+kernel messages using the serial console.  This may provide you with some
+information about the reasons of the suspend (resume) failure.  Alternatively,
+it may be possible to use a FireWire port for debugging with firescope
 (ftp://ftp.firstfloor.org/pub/ak/firescope/).  On i386 it is also possible to
 use the PM_TRACE mechanism documented in Documentation/s2ram.txt .
 
@@ -91,16 +161,24 @@ use the PM_TRACE mechanism documented in
 To verify that the STR works, it is generally more convenient to use the s2ram
 tool available from http://suspend.sf.net and documented at
 http://en.opensuse.org/s2ram .  However, before doing that it is recommended to
-carry out the procedure described in section 1.
+carry out STR testing using the facility described in section 1.
 
-Assume you have resolved the problems with the STD and you have found some
-failing drivers.  These drivers are also likely to fail during the STR or
-during the resume, so it is better to unload them every time before the STR
-transition.  Now, you can follow the instructions at
-http://en.opensuse.org/s2ram to test the system, but if it does not work
-"out of the box", you may need to boot it with "init=/bin/bash" and test
-s2ram in the minimal configuration.  In that case, you may be able to search
-for failing drivers by following the procedure analogous to the one described in
-1b).  If you find some failing drivers, you will have to unload them every time
-before the STR transition (ie. before you run s2ram), and please report the
-problems with them.
+Namely, after writing a number (1-5) into /sys/power/pm_test_level (available
+if the kernel is compiled with CONFIG_PM_DEBUG set) the suspend code will work
+in the test mode corresponding to this number.  The STR test modes are defined
+in the same way as for hibernation, so please refer to section 1 for more
+information about them.  In particular, level 1 test allows you to test
+everything except for the actual invocation of the platform firmware in order to
+put the system into the sleep state.
+
+Among other things, the testing with the help of /sys/power/pm_test_level may
+allow you to identify drivers that fail to suspend or resume their devices.
+These should be unloaded every time before an STR transition.
+
+Next, you can follow the instructions at http://en.opensuse.org/s2ram to test
+the system, but if it does not work "out of the box", you may need to boot it
+with "init=/bin/bash" and test s2ram in the minimal configuration.  In that
+case, you may be able to search for failing drivers by following the procedure
+analogous to the one described in section 1.  If you find some failing drivers,
+you will have to unload them every time before an STR transition (ie. before
+you run s2ram), and please report the problems with them.
