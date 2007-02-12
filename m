Return-Path: <linux-kernel-owner+w=401wt.eu-S1030519AbXBLXxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030519AbXBLXxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXBLXxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:53:48 -0500
Received: from pop5-1.us4.outblaze.com ([205.158.62.125]:47751 "HELO
	pop5-1.us4.outblaze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030519AbXBLXxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:53:47 -0500
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 18:53:47 EST
Subject: Re: [RFC][PATCH] PM: Document requirements for basic PM support in
	drivers
From: Nigel Cunningham <ncunningham@linuxmail.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Alan <alan@lxorguk.ukuu.org.uk>, pm list <linux-pm@lists.osdl.org>
In-Reply-To: <200702130023.23418.rjw@sisk.pl>
References: <200702130023.23418.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 13 Feb 2007 10:47:00 +1100
Message-Id: <1171324020.4081.94.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Tue, 2007-02-13 at 00:23 +0100, Rafael J. Wysocki wrote:
> Hi,
> 
> Here's my attempt to document the requirements with respect to the basic PM
> support in drivers and the testing of that.  Comments welcome.
> 
> Greetings,
> Rafael
> 
> ---
>  Documentation/SubmittingDrivers         |   10 ++
>  Documentation/power/drivers-testing.txt |  119 ++++++++++++++++++++++++++++++++
>  2 files changed, 129 insertions(+)
> 
> Index: linux-2.6.20-git4/Documentation/SubmittingDrivers
> ===================================================================
> --- linux-2.6.20-git4.orig/Documentation/SubmittingDrivers
> +++ linux-2.6.20-git4/Documentation/SubmittingDrivers
> @@ -87,6 +87,16 @@ Clarity:	It helps if anyone can see how 
>  		driver that intentionally obfuscates how the hardware works
>  		it will go in the bitbucket.
>  
> +PM support:	Since Linux is used on many portable and desktop systems, your
> +		driver is likely to be used on such a system and therefore it
> +		should support basic power management by implementing, if
> +		necessary, the .suspend and .resume methods used during the
> +		system-wide suspend and resume transitions.  You should verify
> +		that your driver correctly handles the suspend and resume, but
> +		if you are unable to ensure that, please at least define the
> +		.suspend method returning the -ENOSYS ("Function not
> +		implemented") error.
> +
>  Control:	In general if there is active maintainance of a driver by
>  		the author then patches will be redirected to them unless
>  		they are totally obvious and without need of checking.
> Index: linux-2.6.20-git4/Documentation/power/drivers-testing.txt
> ===================================================================
> --- /dev/null
> +++ linux-2.6.20-git4/Documentation/power/drivers-testing.txt
> @@ -0,0 +1,119 @@
> +Testing suspend and resume support in drivers
> +	(C) 2007 Rafael J. Wysocki <rjw@sisk.pl>
> +
> +Unfortunately, to effectively test the support for the system-wide suspend and
> +resume transitions in a driver, it is necessary to suspend and resume a fully
> +functional system with this driver loaded.  Moreover, that should be done many
> +times, preferably many times in a row, and separately for the suspend to disk
> +(STD) and the suspend to RAM (STR) transitions, because each of these cases
> +involves different ordering of operations and different interactions with the
> +machine's BIOS.
> +
> +Of course, for this purpose the test system has to be known to suspend and
> +resume without the driver being tested.  Thus, if possible, you should first
> +resolve all suspend/resume-related problems in the test system before you start
> +testing the new driver.
> +
> +I. Preparing the test system
> +
> +1. To verify that the STD works, you can try to suspend in the "reboot" mode:
> +
> +# echo reboot > /sys/power/disk
> +# echo disk > /sys/power/state
> +
> +and the system should suspend, reboot, resume and get back to the command prompt
> +where you have started the transition.  If that happens, the STD is most likely
> +to work correctly, but you can repeat the test a couple of times in a row for
> +confidence.  You should also test the "platform" and "shutdown" modes of

I would say "you need to repeat the test at least a couple of times...",
perhaps adding something along the lines of "This is necessary because
some problems only show up on a second attempt at suspending and
resuming a driver. You can think of it as the driver coming back 'dazed
and confused' after the first cycle, and only being properly killed by
the second attempt."

> +suspend:
> +
> +# echo platform > /sys/power/disk
> +# echo disk > /sys/power/state
> +
> +or
> +
> +# echo shutdown > /sys/power/disk
> +# echo disk > /sys/power/state
> +
> +in which cases you will have to press the power button to make the system
> +resume.  If that works, you are ready to test the STD with the new driver
> +loaded.  Otherwise, you have to identify what is wrong.
> +
> +a) To verify if there are any drivers that cause problems you can run the STD
> +in the test mode:
> +
> +# echo test > /sys/power/disk
> +# echo disk > /sys/power/state
> +
> +in which case the system should freeze tasks, suspend devices, disable nonboot
> +CPUs (if any), wait for 5 seconds, enable nonboot CPUs, resume devices, thaw
> +tasks and return to your command prompt.  If that fails, most likely there is
> +a driver that fails to either suspend or resume (in the latter case the system
> +may hang or be unstable after the test, so please take that into consideration).
> +To find this driver, you can carry out a binary search according to the rules:
> +- if the test fails, unload a half of the drivers currently loaded and repeat
> +(that would probably involve rebooting the system, so always note what drivers
> +have been loaded before the test),
> +- if the test succeeds, load a half of the drivers you have unloaded most
> +recently and repeat.
> +
> +Once you have found the failing driver (there can be more than just one of
> +them), you have to unload it every time before the STD transition.  In that case
> +please make sure to report the problem with the driver.

It is also possible that a cycle can still fail after you have unloaded
all modules. In that case, you would want to look in your kernel
configuration for possibilities that can be modularised (testing again
with them as modules), and possibly also try boot time options such as
noapic or noacpi.

> +
> +b) If the test mode of STD works, you can boot the system with "init=/bin/bash"
> +and attempt to suspend in the "reboot", "shutdown" and "platform" modes.  If
> +that does not work, there probably is a problem with one of the low level
> +drivers and you generally cannot do much about it except for reporting it
> +(fortunately, that does not happen very often these days).  Otherwise, there is

Oh. Perhaps some of the suggestions from above belong here?

> +a problem with a modular driver and you can find it by loading a half of the
> +modules you normally use and binary searching in accordance with the algorithm:
> +- if there are n modules loaded and the attempt to suspend and resume fails,
> +unload n/2 of the modules and try again (that would probably involve rebooting
> +the system),
> +- if there are n modules loaded and the attempt to suspend and resume succeeds,
> +load n/2 modules more and try again.
> +
> +Again, if you find the offending module(s), it(they) must be unloaded every time
> +before the STD transition, and please report the problem with it(them).
> +
> +2. To verify that the STR works, it is generally more convenient to use the
> +s2ram tool available from http://suspend.sf.net and documented at
> +http://en.opensuse.org/s2ram .  However, before doing that it is recommended to
> +carry out the procedure described in section 1.
> +
> +Assume you have resolved the problems with the STD and you have found some
> +failing drivers.  These drivers are also likely to fail during the STR or
> +during the resume, so it is better to unload them every time before the STR
> +transition.  Now, you can follow the instructions at
> +http://en.opensuse.org/s2ram to test the system, but if it does not work
> +"out of the box", you may need to boot it with "init=/bin/bash" and test
> +s2ram in the minimal configuration.  In that case, you may be able to search
> +for failing drivers by following the procedure analogous to the one described in
> +1b).  If you find some failing drivers, you will have to unload them every time
> +before the STR transition (ie. before you run s2ram), and please report the
> +problem with them.
> +
> +II. Testing the driver
> +
> +Once you have resolved the suspend/resume-related problems with your test system
> +without the new driver, you are ready to test it:
> +
> +1. Build the driver as a module, load it and try the STD in the test mode
> +(cf. 1a)).
> +
> +2. Compile the driver directly into the kernel and try the STD in the test mode
> +(cf. 1a)).
> +
> +3. Build the driver as a module, load it and attempt to suspend to disk in the
> +"reboot", "shutdown" and "platform" modes (cf. 1).
> +
> +4. Compile the driver directly into the kernel and attempt to suspend to disk in
> +the "reboot", "shutdown" and "platform" modes (cf. 1).
> +
> +5. Build the driver as a module, load it and attempt to run s2ram (cf. 2).
> +
> +6. Compile the driver directly into the kernel and attempt to run s2ram (cf. 2).
> +
> +Each of the above tests should be repeated several times and if any of them
> +fails, the driver cannot be regarded as suspend/resume-safe.

Apart from the minor comments above, looks good to me.

Regards,

Nigel

