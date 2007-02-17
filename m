Return-Path: <linux-kernel-owner+w=401wt.eu-S933016AbXBQVqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbXBQVqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933029AbXBQVqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:46:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46711 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933016AbXBQVqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:46:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH] Documentation: Ask driver writers to provide suspend/resume support
Date: Sat, 17 Feb 2007 22:40:37 +0100
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Alan <alan@lxorguk.ukuu.org.uk>,
       Nigel Cunningham <ncunningham@linuxmail.org>
References: <200702171128.54492.rjw@sisk.pl> <20070217114009.GE9120@elf.ucw.cz> <200702172157.58902.rjw@sisk.pl>
In-Reply-To: <200702172157.58902.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702172240.38394.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 17 February 2007 21:57, Rafael J. Wysocki wrote:
> On Saturday, 17 February 2007 12:40, Pavel Machek wrote:
> > > > > +PM support:	Since Linux is used on many portable and desktop systems, your
> > > > > +		driver is likely to be used on such a system and therefore it
> > > > > +		should support basic power management by implementing, if
> > > > > +		necessary, the .suspend and .resume methods used during the
> > > > > +		system-wide suspend and resume transitions.  You should verify
> > > > > +		that your driver correctly handles the suspend and resume, but
> > > > > +		if you are unable to ensure that, please at least define the
> > > > > +		.suspend method returning the -ENOSYS ("Function not
> > > > > +		implemented") error.
> > > > 
> > > > Perhaps pointer to Documentation/power/drivers-testing.txt would be
> > > > useful here?
> > > 
> > > Okay, maybe something like this:
> > > 
> > > "Please see Documentation/power/drivers-testing.txt for the driver testing
> > > instructions."
> > > 
> > > as the last sentence?
> > 
> > Looks ok. (BTW you have my ACK).
> 
> Thanks.

Anyway, please have a look at the appended revised version.  I have separated
the driver testing and debugging documents and changed the paragraph in
SubmittingDrivers a bit.

Greetings,
Rafael


---
 Documentation/SubmittingDrivers            |   11 +++
 Documentation/power/basic-pm-debugging.txt |  106 +++++++++++++++++++++++++++++
 Documentation/power/drivers-testing.txt    |   42 +++++++++++
 3 files changed, 159 insertions(+)

Index: linux-2.6.20-git13/Documentation/SubmittingDrivers
===================================================================
--- linux-2.6.20-git13.orig/Documentation/SubmittingDrivers
+++ linux-2.6.20-git13/Documentation/SubmittingDrivers
@@ -87,6 +87,17 @@ Clarity:	It helps if anyone can see how 
 		driver that intentionally obfuscates how the hardware works
 		it will go in the bitbucket.
 
+PM support:	Since Linux is used on many portable and desktop systems, your
+		driver is likely to be used on such a system and therefore it
+		should support basic power management by implementing, if
+		necessary, the .suspend and .resume methods used during the
+		system-wide suspend and resume transitions.  You should verify
+		that your driver correctly handles the suspend and resume, but
+		if you are unable to ensure that, please at least define the
+		.suspend method returning the -ENOSYS ("Function not
+		implemented") error.  For the driver testing instructions see
+		Documentation/power/drivers-testing.txt .
+
 Control:	In general if there is active maintainance of a driver by
 		the author then patches will be redirected to them unless
 		they are totally obvious and without need of checking.
Index: linux-2.6.20-git13/Documentation/power/drivers-testing.txt
===================================================================
--- /dev/null
+++ linux-2.6.20-git13/Documentation/power/drivers-testing.txt
@@ -0,0 +1,42 @@
+Testing suspend and resume support in device drivers
+	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
+
+1. Preparing the test system
+
+Unfortunately, to effectively test the support for the system-wide suspend and
+resume transitions in a driver, it is necessary to suspend and resume a fully
+functional system with this driver loaded.  Moreover, that should be done
+several times, preferably several times in a row, and separately for the suspend
+to disk (STD) and the suspend to RAM (STR) transitions, because each of these
+cases involves different ordering of operations and different interactions with
+the machine's BIOS.
+
+Of course, for this purpose the test system has to be known to suspend and
+resume without the driver being tested.  Thus, if possible, you should first
+resolve all suspend/resume-related problems in the test system before you start
+testing the new driver.  Please see Documents/power/basic-pm-debugging.txt for
+more information about the debugging of suspend/resume functionality.
+
+2. Testing the driver
+
+Once you have resolved the suspend/resume-related problems with your test system
+without the new driver, you are ready to test it:
+
+a) Build the driver as a module, load it and try the STD in the test mode (see:
+Documents/power/basic-pm-debugging.txt, 1a)).
+
+b) Load the driver and attempt to suspend to disk in the "reboot", "shutdown"
+and "platform" modes (see: Documents/power/basic-pm-debugging.txt, 1).
+
+c) Compile the driver directly into the kernel and try the STD in the test mode.
+
+d) Attempt to suspend to disk with the driver compiled directly into the kernel
+in the "reboot", "shutdown" and "platform" modes.
+
+e) Attempt to suspend to RAM using the s2ram tool with the driver loaded (see:
+Documents/power/basic-pm-debugging.txt, 2).  As far as the STR tests are
+concerned, it should not matter whether or not the driver is built as a module.
+
+Each of the above tests should be repeated several times and the STD tests
+should be mixed with the STR tests.  If any of them fails, the driver cannot be
+regarded as suspend/resume-safe.
Index: linux-2.6.20-git13/Documentation/power/basic-pm-debugging.txt
===================================================================
--- /dev/null
+++ linux-2.6.20-git13/Documentation/power/basic-pm-debugging.txt
@@ -0,0 +1,106 @@
+Debugging suspend and resume
+	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>, GPL
+
+1. Testing suspend to disk (STD)
+
+To verify that the STD works, you can try to suspend in the "reboot" mode:
+
+# echo reboot > /sys/power/disk
+# echo disk > /sys/power/state
+
+and the system should suspend, reboot, resume and get back to the command prompt
+where you have started the transition.  If that happens, the STD is most likely
+to work correctly, but you need to repeat the test at least a couple of times in
+a row for confidence.  This is necessary, because some problems only show up on
+a second attempt at suspending and resuming the system.  You should also test
+the "platform" and "shutdown" modes of suspend:
+
+# echo platform > /sys/power/disk
+# echo disk > /sys/power/state
+
+or
+
+# echo shutdown > /sys/power/disk
+# echo disk > /sys/power/state
+
+in which cases you will have to press the power button to make the system
+resume.  If that does not work, you will need to identify what goes wrong.
+
+a) Test mode of STD
+
+To verify if there are any drivers that cause problems you can run the STD
+in the test mode:
+
+# echo test > /sys/power/disk
+# echo disk > /sys/power/state
+
+in which case the system should freeze tasks, suspend devices, disable nonboot
+CPUs (if any), wait for 5 seconds, enable nonboot CPUs, resume devices, thaw
+tasks and return to your command prompt.  If that fails, most likely there is
+a driver that fails to either suspend or resume (in the latter case the system
+may hang or be unstable after the test, so please take that into consideration).
+To find this driver, you can carry out a binary search according to the rules:
+- if the test fails, unload a half of the drivers currently loaded and repeat
+(that would probably involve rebooting the system, so always note what drivers
+have been loaded before the test),
+- if the test succeeds, load a half of the drivers you have unloaded most
+recently and repeat.
+
+Once you have found the failing driver (there can be more than just one of
+them), you have to unload it every time before the STD transition.  In that case
+please make sure to report the problem with the driver.
+
+It is also possible that a cycle can still fail after you have unloaded
+all modules. In that case, you would want to look in your kernel configuration
+for the drivers that can be compiled as modules (testing again with them as
+modules), and possibly also try boot time options such as "noapic" or "noacpi".
+
+b) Testing minimal configuration
+
+If the test mode of STD works, you can boot the system with "init=/bin/bash"
+and attempt to suspend in the "reboot", "shutdown" and "platform" modes.  If
+that does not work, there probably is a problem with a driver statically
+compiled into the kernel and you can try to compile more drivers as modules,
+so that they can be tested individually.  Otherwise, there is a problem with a
+modular driver and you can find it by loading a half of the modules you normally
+use and binary searching in accordance with the algorithm:
+- if there are n modules loaded and the attempt to suspend and resume fails,
+unload n/2 of the modules and try again (that would probably involve rebooting
+the system),
+- if there are n modules loaded and the attempt to suspend and resume succeeds,
+load n/2 modules more and try again.
+
+Again, if you find the offending module(s), it(they) must be unloaded every time
+before the STD transition, and please report the problem with it(them).
+
+c) Advanced debugging
+
+In case the STD does not work on your system even in the minimal configuration
+and compiling more drivers as modules is not practical or some modules cannot
+be unloaded, you can use one of the more advanced debugging techniques to find
+the problem.  First, if there is a serial port in your box, you can set the
+CONFIG_DISABLE_CONSOLE_SUSPEND kernel configuration option and try to log kernel
+messages using the serial console.  This may provide you with some information
+about the reasons of the suspend (resume) failure.  Alternatively, it may be
+possible to use a FireWire port for debugging with firescope
+(ftp://ftp.firstfloor.org/pub/ak/firescope/).  On i386 it is also possible to
+use the PM_TRACE mechanism documented in Documentation/s2ram.txt .
+
+2. Testing suspend to RAM (STR)
+
+To verify that the STR works, it is generally more convenient to use the s2ram
+tool available from http://suspend.sf.net and documented at
+http://en.opensuse.org/s2ram .  However, before doing that it is recommended to
+carry out the procedure described in section 1.
+
+Assume you have resolved the problems with the STD and you have found some
+failing drivers.  These drivers are also likely to fail during the STR or
+during the resume, so it is better to unload them every time before the STR
+transition.  Now, you can follow the instructions at
+http://en.opensuse.org/s2ram to test the system, but if it does not work
+"out of the box", you may need to boot it with "init=/bin/bash" and test
+s2ram in the minimal configuration.  In that case, you may be able to search
+for failing drivers by following the procedure analogous to the one described in
+1b).  If you find some failing drivers, you will have to unload them every time
+before the STR transition (ie. before you run s2ram), and please report the
+problems with them.
