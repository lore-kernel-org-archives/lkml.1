Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0CODbI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 23:31:08 -0400
Received: from xenotime.net ([72.52.64.118]:36656 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752007Ab0CODbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 23:31:04 -0400
Message-ID: <4B9DA9F4.7040906@xenotime.net>
Date: Sun, 14 Mar 2010 20:31:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Update device power management document
References: <201003142103.19420.rjw@sisk.pl>
In-Reply-To: <201003142103.19420.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/10 13:03, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The device PM document, Documentation/power/devices.txt, is badly
> outdated and requires total rework to fit the current design of the
> PM framework.  Make it more up to date.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
> This has been promised for a long time, but the interface has been changing
> so that it's been a moving target.  Since I hope it'll stabilize now, here it
> goes.
> 
> Please let me know if you find any problems.  I have read it for a few times
> already, so I'm afraid I won't find any even if they are present.
> 
> Enjoy!
> 
> Rafael
> ---
>  Documentation/power/devices.txt |  721 ++++++++++++++++++++++++----------------
>  1 file changed, 442 insertions(+), 279 deletions(-)
> 
> Index: linux-2.6/Documentation/power/devices.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/devices.txt
> +++ linux-2.6/Documentation/power/devices.txt
> @@ -1,3 +1,7 @@
> +Device Power Management
> +
> +(C) 2010 Rafael J. Wysocki <rjw@sisk.pl>, Novell Inc.
> +
>  Most of the code in Linux is device drivers, so most of the Linux power
>  management code is also driver-specific.  Most drivers will do very little;
>  others, especially for platforms with small batteries (like cell phones),
> @@ -25,31 +29,39 @@ states:
>  	them without loss of data.
>  
>  	Some drivers can manage hardware wakeup events, which make the system
> -	leave that low-power state.  This feature may be disabled using the
> -	relevant /sys/devices/.../power/wakeup file; enabling it may cost some
> -	power usage, but let the whole system enter low power states more often.
> +	leave that low-power state.  This feature may be enabled or disabled
> +	using the relevant /sys/devices/.../power/wakeup file (for Ethernet
> +	drivers the ioctl interface used by ethtool may also be used for this
> +	purpose); enabling it may cost some power usage, but let the whole
> +	system enter low power states more often.
>  
>      Runtime Power Management model:
> -	Drivers may also enter low power states while the system is running,
> -	independently of other power management activity.  Upstream drivers
> -	will normally not know (or care) if the device is in some low power
> -	state when issuing requests; the driver will auto-resume anything
> -	that's needed when it gets a request.
> -
> -	This doesn't have, or need much infrastructure; it's just something you
> -	should do when writing your drivers.  For example, clk_disable() unused
> -	clocks as part of minimizing power drain for currently-unused hardware.
> -	Of course, sometimes clusters of drivers will collaborate with each
> -	other, which could involve task-specific power management.
> +	Devices may also be put into low power states while the system is
> +	running, independently of other power management activity in principle.
> +	However, devices are not generally independent of each other (for
> +	example, parent device cannot be suspended unless all of its child
> +	devices have been suspended).  Moreover,  depending on the bus type the
> +	device is on, it may be necessary to carry some bus-specific operations

	                                     carry out (?)

> +	on the device for this purpose.  Also, devices put into low power states
> +	at run time may require special handling during system-wide power
> +	transitions, like suspend to RAM.

> @@ -103,64 +148,44 @@ physically support wakeup events.  When 
>  
...

> +
> +/sys/devices/.../power/control files
> +------------------------------------
> +All devices in the driver model have a flag to control the desired behavior of
> +its driver with respect to runtime power management.  This flag, called
> +runtime_auto, is initialized by the bus type (or generally subsystem) code using
> +pm_runtime_allow() or pm_runtime_forbid(), depending on whether or not the
> +driver is supposed to power manage the device at run time by default,
> +respectively.
> +
> +This setting may be adjusted by the user space by writing either "on" or "auto"

drop "the"                         ^^^

> +to the device's "control" file.  If "auto" is written, the device's runtime_auto
> +flag will be set and the driver will be allowed to power manage the device if
> +capable of doing that.  If "on" is written, the driver is not allowed to power
> +manage the device which in turn is supposed to remain in the full power state at
> +run time.  The user space can check the current value of the runtime_auto flag

              User space can check

> +by reading from the device's "control" file.
> +
> +The device's runtime_auto flag has no effect on the handling of system-wide
> +power transitions by its driver.  In particular, the device can (and in the
> +majority of cases should and will) be put into a low power state during a
> +system-wide transition to a sleep state (like "suspend-to-RAM") even though its
> +runtime_auto flag is unset (in which case its "control" file contains "on").
>  
...

> @@ -207,54 +231,166 @@ system always includes every phase, exec
...

> +Hibernation Phases
> +------------------
> +Hibernating the system is more complicated than putting it into the standby or
> +memory sleep state, because it involves creating a system image and saving it.
> +Therefore there are more phases of hibernation and special device PM methods are
> +used in this case.
> +
> +First, it is necessary to prepare the system for creating a hibernation image.
> +This is similar to putting the system into the standby or memory sleep state,
> +although it generally doesn't require that devices be put into low power states
> +(that even is not desirable at this point).  Driver notifications are then

   (that is even not desirable at this point).
or
   omit "even"

> +issued in the following order:
> +
> +   1	bus->pm.prepare(dev) is called after tasks have been frozen and enough
> +	memory has been freed.
> +


> @@ -284,84 +420,86 @@ ways; the aforementioned LCD might be ac

>  Resuming Devices
>  ----------------
>  Resuming is done in multiple phases, much like suspending, with all
>  devices processing each phase's calls before the next phase begins.
>  
> -The phases are seen by driver notifications issued in this order:
> +Again, however, different callbacks are used depending on whether the system is
> +waking up from the standby or memory sleep state ("suspend-to-RAM") or from
> +hibernation ("suspend-to-disk").
> +
> +If the system is waking up from the standby or memory sleep state, the phases
> +are seen by driver notifications issued in this order:
> +
> +   1	bus->pm.resume_noirq(dev) is called, if implemented.  It may call the
> +	device driver's ->pm.resume_noirq() method, depending on the bus type in
> +	question.
> +
> +	The role of this method is to perform actions that need to be performed
> +	before device drivers' interrupt handlers are allowed to be invoked.  If
> +	given bus type permits devices to share interrupt vectors, like PCI,

	the given (or "a given")

> +	this method should bring the device and its driver into a state in which
> +	the driver can recognize if the device is the source of incoming
> +	interrupts, if any, and handle them correctly.
> +
> +	For example, the PCI bus type's ->pm.resume_noirq() puts the device into
> +	the full power state (D0 in the PCI terminology) and restores the
> +	standard configuration registers of the device.  Then, it calls the
> +	device driver's ->pm.resume_noirq() method to perform device-specific
> +	actions needed at this stage of resume.
> +
...

> @@ -389,10 +592,13 @@ System devices will only be suspended wi
>  all other devices have been suspended.  On resume, they will be resumed
>  before any other devices, and also with interrupts disabled.
>  
> -That is, IRQs are disabled, the suspend_late() phase begins, then the
> -sysdev_driver.suspend() phase, and the system enters a sleep state.  Then
> -the sysdev_driver.resume() phase begins, followed by the resume_early()
> -phase, after which IRQs are enabled.
> +That is, when the nonboot CPUs are all offline and IRQs are disabled on the

                     non-boot

> +remaining online CPU, then the sysdev_driver.suspend() phase is carried out, and
> +the system enters a sleep state (or hibernation image is created).  During
> +resume (or after the image has been created) the sysdev_driver.resume() phase
> +is carried out, IRQs are enabled on the only online CPU, the nonboot CPUs are

                                                                non-boot

> +enabled and that is followed by the "early resume" phase (in which the "noirq"
> +callbacks provided by subsystems and device drivers are invoked).
>  
>  Code to actually enter and exit the system-wide low power state sometimes
>  involves hardware details that are only known to the boot firmware, and
> @@ -400,6 +606,21 @@ may leave a CPU running software (from S
>  the system and manages its wakeup sequence.
>  
>  
> +Power Management Notifiers
> +--------------------------
> +As stated in Documentation/power/notifiers.txt, there are some operations that
> +cannot be carried out by the power management callbacks discussed above, because
> +carrying them out at these points would be too late or too early.  To handle
> +that cases subsystems and device drivers may register power management notifiers

   these cases,

> +called before tasks are frozen and after they have been thawed.

   that are called before ...

> +
> +Generally speaking, the PM notifiers are suitable for performing actions that
> +either require the user space to be available, or at least won't interfere with

drop "the" before "user space" above and below

> +the user space in a wrong way.
> +
> +For details refer to Documentation/power/notifiers.txt.
> +
> +
>  Runtime Power Management
>  ========================
>  Many devices are able to dynamically power down while the system is still



-- 
~Randy
