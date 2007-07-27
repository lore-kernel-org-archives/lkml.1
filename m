Return-Path: <linux-kernel-owner+w=401wt.eu-S934248AbXG0Ist@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934248AbXG0Ist (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 04:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbXG0Isl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 04:48:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40269 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759142AbXG0Ish (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 04:48:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Suspend and hibernation status report
Date: Fri, 27 Jul 2007 10:57:04 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, pm list <linux-pm@lists.linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271057.05438.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Below is a document describing the current state of development of the suspend
and hibernation infrastructure: how it works, what known problems there are in
it and what the future development plans are (at least as far as I am
concerned).

[It's almost exactly one yaer after I released the previous swsusp status
report and that's mostly because in the Summer I have more time to write such
things.  Thus, probably, the next report will be released next Summer, but
since the present one is quite long, the next one is going to be incremental.
;-)]

As usual, comments, suggestions, opinions etc are welcome.

Greetings,
Rafael


---
Hibernation and Suspend Status Report

I. Introduction

One year ago I wrote a report documenting the status of development of swsusp
(ie. software suspend, or hibernation, subsystem) that can be found at
http://lkml.org/lkml/2006/7/25/105 .  Although I thought I would be able to
release an updated version of the report within 3-4 months, this turned out to
be very difficult due to several substantial changes made to swsusp since then,
causing it to be a moving target from the documentation-writing perspective.
Moreover, in the meantime I started to work on the core suspend code used,
among other things, for transitioning the system into the ACPI S3 sleep state,
known as the suspend to RAM, which currently has some things in common with
swsusp.  For this reason, I thought it would be a good idea to document these
two subsystems together, but that increased the number of things to cover and
added to the delay.  Finally, however, I have had some time to complete the
present document.

In analogy with the previous report, this document is intended as an
introductory presentation of the current (ie. as in the 2.6.23-rc1 kernel)
design of the suspend (ie. suspend-to-RAM and standby) and hibernation code,
the status of it, known problems with it and the future development plans.
Thus, I will first explain how this code works and identify all of the distinct
parts of it.  Next, I will describe each of these parts in more detail and
discuss the known problems related to them.  Finally, I will outline the
possible directions of future development related to suspend and hibernation.

II. Terminology

Before I start to talk about technical details, some terms that will be used
throughout of the rest of this document need to be defined.  They are the
following:
* system working state - any state, in which the system's processors can carry
  out useful computations
* system sleep state - state, in which no useful work can be done by the
  system's processors, but its main memory is powered and, consequently, the
  contents of memory are preserved, so that the computations carried out when
  the system was last in a working state can be continued after transitioning
  the system back to the working state
* system hibernation state - state, in which the system's processors are off and
  its main memory is not powered, but the information necessary for continuing
  the computations carried out when the system was last in a working state is
  preserved in a storage space, such as a disk
* ACPI S4 state - system hibernation state, in which some information is
  preserved by the ACPI platform, in accordance with the ACPI specification
* system suspend - operation, in which the system leaves a working state and
  enters a sleep state
* system resume - operation, in which the system leaves a sleep state and enters
  a working state
* system hibernation - operation, in which the system leaves a working state and
  enters a hibernation state
* system restore - operation, in which the system leaves a hibernation state and
  enters a working state
* device full power state - state of a device, in which it is fully operational
  and draws maximum power
* device low power state - state of a device, in which it draws less power than
  in the full power state and may not be fully operational
* device quiescent state - state of a device, in which it does not generate
  interrupts and/or it will not take part in any DMA transfers
* device off state - state of a device, in which it draws minimal power and is
  not regarded as operational
* device suspend - operation, in which the device is put into a low power state
  compatible with the system sleep state that is going to be entered
* device wake up - operation, in which the device is put into the full power
  state or to a low power state compatible with the system working state that is
  going to be entered

III. System suspend outline

System suspend support is included in the kernel if CONFIG_PM is set in the
.config .  Then, there is the file /sys/power/state, by reading which one can
check what suspend states are available on given system.

At present, two different suspend states can generally be supported, "standby"
and "mem", but some platforms support only one of them and many platforms do not
support any sleep states at all.  If both are supported, "standby" is the state
in which the system draws more power, but can be switched to a working state
faster than from the "mem" sleep state.

A transition to a system sleep state can be started by writing the name of a
system sleep state supported by the platform ("mem" or "standby") to
/sys/power/state (there is another method to do that, with the help of the
hibernation userland interface, but it should only be used as a part of the
suspend-to-both functionality described later).  If that happens, the kernel
performs the following actions:

(1) power management notifiers are executed with PM_SUSPEND_PREPARE
(2) tasks are frozen
(3) target system sleep state is announced to the platform-handling code
(4) devices are suspended
(5) platform-specific global suspend preparation methods are executed
(6) non-boot CPUs are taken off-line
(7) interrupts are disabled on the remaining (main) CPU
(8) late suspend of devices is carried out
(9) platform-specific global methods are invoked to put the system to sleep

Of course all of this happens if there are no errors in the way.  However, for
example, if one of the devices refuses to suspend, we need to wake up all of the
devices that have already been suspended, inform the platform that the
transition to the low power state will not occur, enable the non-boot CPUs and
thaw tasks.  Finally, we have to execute the power management notifiers to
inform their owners that the transition has been canceled.

A resume starts when the platform notices a wake-up event, such as the opening
of a laptop's lid or pressing the power button.  Then, the platform prepares
itself and the main processor for entering a system working state and returns
the control to the kernel.  Next, the following actions are performed:

(10) the main CPU is switched to the appropriate mode, if necessary
(11) early resume of devices is carried out
(12) interrupts are enabled on the main CPU
(13) non-boot CPUs are enabled
(14) platform-specific global resume preparation methods are invoked
(15) devices are woken up
(16) tasks are thawed
(17) power management notifiers are executed with PM_POST_SUSPEND

For each of steps (1)-(17) above there is a separate part of the suspend code
responsible for its completion.

IV. System hibernation outline

System hibernation support is included in the kernel if CONFIG_SOFTWARE_SUSPEND
is set in the .config .  Then, the hibernation state called "disk" is listed
in the /sys/power/state file.

Currently there are two possible ways of carrying out a system hibernation.  The
first of them is entirely kernel-driven and the second one requires a userland
task that will drive the hibernation procedure calling the kernel to perform
specific, more or less atomic, actions.  Only the first method is covered in
this part of the report, because it is generally simpler and the actions of the
kernel are pretty much the same in both cases.  The other method will be
described later.

The kernel-driven hibernation procedure is started by writing "disk" to
/sys/power/state.  Then, the kernel performs the following actions:

(1) power management notifiers are executed with PM_HIBERNATION_PREPARE
(2) tasks are frozen
(3) some memory is released, if necessary
(4) (optional, on ACPI systems) target system sleep state (S4) is announced to
    the platform-handling code
(5) devices are suspended for hibernation
(6) (optional) platform-specific global hibernation preparation methods are
    invoked
(7) non-boot CPUs are taken off-line
(8) interrupts are disabled on the main CPU
(9) late suspend of devices for hibernation is carried out
(10) atomic copy of the system memory (aka hibernation image) is created
(11) early resume of devices is carried out
(12) interrupts are enabled on the main CPU
(13) non-boot CPUs are enabled
(14) (optional, but necessary if (6) is performed) platform-specific global
    hibernation-related methods are invoked
(15) devices are woken up
(16) hibernation image is saved in a storage space
(17) devices are put into the off state
(18) the system is powered off _or_ (optionally, on ACPI systems)
    platform-specific global methods are invoked to put the system into the S4
    sleep state

In analogy with the system suspend described in Section III, if any of the
operations listed above fails, the operations that have already been performed
need to be reverted, so that the system can flawlessly continue operating in the
working state.  In particular, the power management notifiers need to be called
to inform their owners that the system state transition has been canceled.

System restore is started by booting the kernel with the "resume=<partition>"
command line parameter, where <partition> is the one the hibernation image has
been written to in step (16).  This partition may be a swap partition or a
partition containing the swap file with the hibernation image, in which case the
additional kernel command line parameter "resume_offset=<offset>" is needed,
where <offset> points to the location of the swap file's header (see
Documentation/power/swsusp-and-swap-files.txt in the kernel tree for details).

The kernel booted with the "resume=<partition>" and (optionally)
"resume_offset=<offset>" command line parameters, often referred to as the boot
kernel, is responsible for loading the hibernation image into memory and passing
control to the kernel contained in the hibernation image, that from now on will
be referred to as the target kernel.  The following operations are performed by
it:

(19) hibernation image is loaded into RAM
(20) tasks are frozen
(21) devices are suspended for jumping to the target kernel
(22) (optional, but necessary if (6) was done during the hibernation)
    platform-specific global restore preparation functions are executed
(23) non-boot CPUs are taken off-line
(24) interrupts are disabled on the remaining CPU
(25) late suspend of devices (for jumping to the target kernel) is carried out
(26) control is passed to the target kernel

If any of steps (19)-(23) fails, the boot kernel continues running as in the
case of a normal non-restore boot.  Otherwise, the target kernel gets the
control and the following operations are performed by it:

(27) early resume of devices is carried out
(28) interrupts are enabled on the main CPU
(29) non-boot CPUs are enabled
(30) (optional, but necessary if (6) is performed) finish of the system state
    transition is announced to the platform
(31) devices are woken up
(32) tasks are thawed
(33) power management notifiers are executed with PM_POST_HIBERNATION

Again, for each of steps (1)-(33) there is a part of the hibernation code
responsible for completing it and some of these parts are shared with the
suspend code outlined in Section III.

V. Power management notifiers

This is a new feature, introduced very recently in order to allow subsystems
that need to know if a system state transition is going to happen to register
notifiers called right before and right after any such transition.  The
parameter passed to the notifiers determines if the transition in question is a
suspend or a hibernation.

This mechanism is described in detail in Documentation/power/notifiers.txt .
At present, it is only used to disable user mode helpers before the freezing of
tasks.

VI. Freezing and thawing tasks

Steps (2) and (16) of the suspend-resume cycle described in Section III as well
as steps (2) and (32) of the hibernation-restore cycle outlined in Section IV
are done by a special code called the freezer.  Generally speaking, it requests
tasks to "park" themselves in a safe place, called "the refrigerator", in which
they do not hold any locks, to not start any new I/O operations, do not allocate
memory and do not do anything else that might destructively interfere with the
suspend or hibernation procedure.  Userland processes are made enter the
refrigerator by the kernel's signal-handling code, but kernel threads should
enter the refrigerator voluntarily, by calling the function try_to_freeze(),
where it is appropriate from their point of view.  Moreover, kernel threads that
want to receive freeze requests from the freezer have to explicitly mark
themselves as freezable and they are responsible for entering the refrigerator
relatively quickly after receiving a freeze request.  The freezable kernel
threads are only asked to enter the refrigerator after userland processes have
been frozen and sys_sync() is called before sending any freeze requests to
kernel threads.  A frozen task is only allowed to exit the refrigerator at the
freezer's request.  Detailed description of this mechanism is available in
Documentation/power/freezing-of-tasks.txt .

The freezing of tasks generally works, although there are some known problems
with it.  First of all, uninterruptible tasks cannot be frozen, so if there are
any such tasks in the system, except for the tasks waiting for vfork()
completions handled in a special way, it is impossible to suspend or hibernate
it.  This is a strong limitation stemming from the fact that uninterruptible
tasks can hold locks that might be necessary for suspending devices later during
the suspend or hibernation procedure.  Unfortunately, it also leads to problems
in the situations, in which one userland task may wait in the
TASK_UNINTERRUPTIBLE state for another userland task.  Namely, in such cases the
task that is being waited for may be frozen before the task that waits for it
and the freezing of tasks will fail as a result.

Another known issue related to the freezer is that some system calls, such as
sys_poll(), may be interrupted by fake signals sent by it to userland tasks.

VII. Freeing memory

Step (3) of the hibernation procedure outlined in Section IV is completed by
calling the same functions that are normally used by kswapd, but in a slightly
different way.  The part of code responsible for that is referred to as the
memory shrinker (it may sometimes be called by the suspend code as well, so it
can be treated as a shared piece of code).  It generally works well, but it
seems to be inefficient if there are lots of slab objects to free.

VIII. Platform support

On ACPI systems there are parts of the platform that should only be accessed
by the kernel through the execution of so-called ACPI control methods encoded
in the AML language.  These control methods are executed with the help of the
AML interpreter included in the kernel's ACPI subsystem.

Since the platform is responsible for registering and acting upon events
supposed to wake up the system being in a sleep state, as well as for passing
control back to the kernel after such an event, it requires special handling
during every suspend.  Also, during a resume the platform has to be put into a
state that is compatible with the system working state being entered.

The handling of an ACPI platform related to suspend and resume is done on two
levels.  First, some global ACPI control methods need to be executed, which is
done in steps (5), (9) and (14) of the procedure outlined in Section III, with
the help of the information passed to the platform-handling code in step (3).
Second, some device-specific ACPI control methods are executed while devices are
being suspended.  The ordering of execution of different ACPI control methods
involved in suspend and resume operations is strictly defined by the ACPI
specification and it currently is reflected by the ordering of the kernel's
suspend and resume code.

As far as system hibernation is concerned, in principle the platform support
is optional.  However, some ACPI platforms do not work correctly after a restore
if the appropriate ACPI control methods are not executed during transitions to
and from the hibernation state.  For this reason, the platform support in the
hibernation code is enabled by default, but the users can request that it be
disabled by writing "shutdown" to the /sys/power/disk control file before
the hibernation.  By reading this file one can see if the platform support will
be used during subsequent hibernations (the active setting is shown inside the
square braces and "[platform]" means that the platform hibernation support is
enabled).

During a hibernation-restore cycle global ACPI control methods are executed in
steps (6), (14), (18) and (30) listed in Section IV.  Additionally, the
platform-handling code is informed of the target system sleep state (ACPI S4) in
step (4) and the ACPI general purpose events (GPEs) are disabled in step (22)
(if the restore fails, they are enabled during the subsequent clean-up
procedure).  The restore code in the boot kernel uses the platform support
routines if special flag in the image header is set by the hibernation code.
Still, the current hibernation and restore code does not exactly follow the ACPI
specification.  Namely, the specification requires that the ACPI subsystem be
not enabled during a restore until the image is loaded into memory and the
control is passed to the target kernel, but in our current implementation the
ACPI subsystem is already enabled in the boot kernel before loading the image.

Apart from this, in step (14) of the hibernation procedure we inform the
platform that the system will not enter the sleep state, which is not what is
going to happen.  We do that in order to be able to resume devices needed for
saving the image and in step (18) the platform is prepared for entering the S4
sleep state from the start.

IX. Handling of devices

Steps (4), (8), (11), and (15) of the suspend-resume cycle outlined in Section
III, as well as steps (5), (9), (11), (15), (21), (25), (27), and (31) of the
hibernation-restore cycle described in Section IV are completed in a large part
by device drivers.  Namely, each device driver supporting the suspend and/or
resume of devices handled by it is required to define the .suspend() and
.resume() callbacks and register them with the driver model, as described in
Documentation/power/devices.txt .  These callbacks are used by the power
management core to suspend the driver's devices in step (4) of the
suspend-resume cycle and in steps (5) and (21) of the hibernation-restore cycle.

At present, the same callbacks are used for both suspend and hibernation.  In
the case of a suspend they are called with the second parameter equal to
PMSG_SUSPEND, whereas for a hibernation the second parameter passed to each of
them is equal to PMSG_FREEZE.  Moreover, the drivers' .suspend() callbacks are
also executed in step (21) of the hibernation-restore cycle, in order to prepare
devices for passing control to the target kernel, in which case the second
parameter passed to them is equal to PMSG_PRETHAW.  Thus, theoretically, the
drivers can use the second parameter of their .suspend() callbacks to
distinguish between suspend, hibernation and restore operations, although only a
few drivers actually do that.

Similarly, the same .resume() callbacks are used for waking up devices in step
(11) of the suspend-resume cycle, as well as in steps (15) and (31) of the
hibernation-restore cycle.  Since these callbacks take only one parameter,
being a pointer to the device object associated with given device, the drivers
have no means to distinguish between different reasons for which the devices may
be woken up and they need to perform basically the same actions in each of these
cases.

In order to suspend devices the power management core walks the dpm_active list
in the reverse order.  This list is set up during the kernel initialization and
devices are put on it in the order in which they are registered with the driver
model.  Thus, the devices that have been registered last, are suspended first
and so on, which guarantees that basic dependencies between devices will not be
violated (ie. parent devices are always suspended after the devices that depend
on them).  For each device the core checks if:
* the device's class has defined a .suspend() callback, in which case this
  callback is executed,
* the device's type has defined a .suspend() callback, in which case this
  callback is executed,
* the device's bus type has defined a .suspend() callback, in which case this
  callback is executed.
All of the .suspend() callbacks defined by device classes, types and bus types
are always executed as long as none of them returns an error.  This means that,
for example, if a device class has defined the .suspend() callback and a bus
type has done that too, then both of these callbacks will be executed for each
device belonging to this class and associated with this bus type and it is up to
the class, bus type and driver code to cope with that correctly.  If any of the
.suspend() callbacks listed above returns an error, the suspending of devices is
immediately terminated and the devices that have already been suspended are
woken up.  The .suspend() callbacks defined by device drivers are executed by
the device class, device type and bus type .suspend() callbacks.

The suspended devices are moved from the dpm_active list to the dpm_off list in
the order in which they have been suspended (note that a device may be regarded
as suspended even if no .suspend() callbacks have been executed for it, for
instance, when there are no such callbacks defined for it).  This list is used
by the power management core for waking up devices.  Namely, for each device on
it the power management core checks if:
* the device's bus type has defined a .resume() callback, in which case this
  callback is executed,
* the device's type has defined a .resume() callback, in which case this
  callback is executed,
* the device's class has defined a .resume() callback, in which case this
  callback is executed.
Again, all bus type, device type and device class .resume() callbacks that have
been defined are always executed for each device that they fit to.  Moreover,
any errors returned by them are discarded.  All devices for which they have been
executed are unconditionally moved from the dpm_off to the dpm_active list, in
such a way that the original ordering of the dpm_active list is eventually
restored.

Apart from "ordinary" devices, the suspending and resuming of which is described
above, there are special devices that need some handling in steps (8) and (11)
of the suspend-resume cycle and in steps (9), (11), (25), and (27) of the
hibernation-restore cycle.  There are two kinds of such devices:
* devices the bus types and drivers of which define .suspend_late() and/or
  .resume_early() callbacks,
* system devices (aka sysdevs)

The devices handled with the help of .suspend_late() callbacks are moved from
the dpm_off list to the dpm_off_irq list, which is used later to check if the
.resume_early() callbacks have been defined for them and to execute these
callbacks if that is the case.  All devices on the dpm_off_irq list are moved
from there back to the dpm_off list before the "ordinary" waking up of devices
described above.  It should be noted that the right ordering of devices is
always preserved by all of these operations.  Moreover, the .suspend() and
.resume() callbacks may be defined for a device for which .suspend_late() and
.resume_early() are also defined and all of these callbacks will always be
executed in the right order.

System devices are handled in a special way, independent of the above general
framework.  Specifically, system device classes and drivers can define
.suspend() and .resume() callbacks that are used to handle their devices.
However, these callbacks are only executed when one CPU is on-line and with
interrupts disabled by it.  Thus, if any of such devices needs to be handled
with interrupts enabled too, it is necessary to create a separate device object
for it that will be treated in the ordinary way.  For this reason, from the
power management point of view, system devices are rather inflexible and the use
of them is no longer recommended.  The existing ones are expected to be
gradually phased out or replaced with device objects corresponding to the
"platform" bus type.

The main problem with the current approach to the handling of devices is that
the same callbacks are used for both suspend and hibernation, which leads to
confusion and introduces unnecessary limitations.  For example, it generally is
not necessary, and may even be harmful, to put devices into low power states
before step (10) of the hibernation procedure.  In fact, it should be sufficient
to put devices into quiescent states in step (5) of it and to put them back into
the full power state (or into the low power states in which they were before the
hibernation procedure has been started) in step (15).  Then, the execution of
platform-specific functions in steps (6) and (14) should not be necessary and
the entire hibernation procedure might be simplified.  It also is generally
unnecessary to put devices into low power states in step (21), during a restore.
Moreover, the boot kernel need not handle the same set of devices as the target
kernel, which means that the callbacks used by the target kernel to "wake up"
devices must be prepared to deal with the situation in which their devices have
not been initialized or, worse yet, have been initialized by the platform
firmware in an inappropriate way.  Generally, they need not be in the same
states in which they were left in step (5).  Yet, this obviously is not the case
during a resume, since the states of devices generally need not change between
steps (4) and (15) of the suspend-resume cycle.  Thus, by requesting that all of
the .resume() callbacks need to be able to deal with uninitialized devices, we
impose an unnecessary limitation on the suspend code, which should be avoided.

The next major limitation is related to the handling of removable storage
devices.  Namely, if some filesystems are mounted out of removable devices, such
as USB storage devices or memory cards, before a suspend or hibernation, they
will not be accessible after the corresponding resume or restore and the users
may lose data as a result of this.  The problem is that for removable, or rather
"hotpluggable", devices the suspend operation usually causes the device to
disconnect, as though it were physically disconnected from the system.  There is
the kernel configuration parameter CONFIG_USB_PERSIST which allows one to work
around this behavior, but it generally is dangerous and the use of it is not
recommended, unless the user knows exactly what she is doing.

The third major problem with the handling of devices is related to graphics
adapters that often are not touched by the platform after it has registered a
wake-up event and before it passes control back to the kernel during a resume.
Usually, the kernel also does not know how to bring the graphics adapter back to
the pre-suspend state and that may lead to various undesirable effects, from the
image corruption up to and including a crash of the resuming system, depending
on the type of the graphics card, platform firmware and its version and other
similar factors.  A workaround of this that seems to work in the majority of
cases is to use a userland tool able to put the graphics adapter into the right
state after a resume, given some simple instructions how to do it, such as s2ram
(http://en.opensuse.org/s2ram).

At present, the majority of reported and tracked bugs related to suspend and
hibernation are associated with the platform support, described in Section VIII,
and with the handling of devices.  Unfortunately, these bugs are usually
reproducible only on a limited number of machines and hard to debug.

X. Handling of non-boot CPUs

Steps (6) and (13) of the suspend-resume cycle, as well as steps (7), (13),
(23), and (29) of the hibernation-restore cycle are completed with the help of
the CPU hotplug infrastructure, which basically is external with respect to the
suspend and hibernation code.  There were some problems with this mechanism in
the past, but currently it is generally reported to work, even on 4-way
machines.

XI. Snapshotting memory and restoring its state

The snapshotting of memory, step (10) of the hibernation procedure, is completed
by making a copy of each memory page that needs to be saved.  For this reason,
the hibernation code needs as much as 50% of free RAM to create the image.  This
is a serious limitation, as it generally affects the system responsiveness after
a restore and sometimes requires quite a lot of memory to be freed in step (3).
Still, usually there are many saveable pages in the system that will not be
accessed when userland processes are frozen, and in principle these pages could
be included in the hibernation image without copying.  Unfortunately, however,
no efficient method of identifying them pages has been proposed yet.  If you
have any ideas and/or hints, please help.

The code that restores the memory state from the hibernation image in steps (19)
and (26) of the hibernation-restore cycle is able to handle images much greater
than 50% of RAM.  It practically is only limited by the amount of memory
occupied by the boot kernel and its data structures.  Thus, it would be possible
to use hibernation images as big as 80% or even 90% of RAM if the "snapshotting"
code could create them.

Apart from the above limitation, there are no any known problems with this part
of the hibernation code.  Also, it uses data structures that are completely
independent of the rest of the kernel's memory management subsystem and are
allocated on demand, during the hibernation and restore.

XII. Saving and loading the hibernation image

The hibernation image is saved in a swap partition or in a swap file in step
(16) and loaded from it in step (19) of the hibernation-restore cycle, with the
help of standard block I/O callbacks and/or functions designed for accessing
swap devices and/or swap files.  This code has not been changed for a long time.

There are almost no problems with this part of the hibernation code.
Practically, there have not been any bugs found in it for the last year.  Yet,
it is quite limited, since it does not support image compression that may
substantially increase the speed of saving and loading the image.  It also is
only capable of using swap space (ie. swap partitions or swap files) for saving
hibernation images and only one swap partition or swap file can be used at a
time.

XIII. Userland hibernation interface

Some users of the hibernation subsystem want it to be able to perform certain
transformations of the hibernation image, such as encryption and/or compression,
before saving it.  Moreover, some of them would like the hibernation and restore
code to use splash screens and display graphical progress meters.  Still, the
idea of implementing all these things in the kernel space is questionable, so it
has been made possible to export the hibernation image out of the kernel, in
order for some userland tools to be able to carry out the desired operations and
save the image afterwards.  This is the basic role of the userland hibernation
interface, which also allows userland processes to drive the entire hibernation
and restore procedure.

The userland hibernation interface has been implemented as a special software
character device with appropriate file operations and some special ioctls.  It
is described quite thoroughly in Documentation/power/userland-swsusp.txt, so
please refer to this document for details.  A reference implementation of the
userland tools that use this interface is available at http://suspend.sf.net .
At present, this method of driving the hibernation and restore procedures is
used by default in OpenSUSE and is optionally available for the users of some
other major distributions.

One of the features provided by the userland hibernation interface is the
possibility to create and save a hibernation image and suspend to RAM right
after that.  Then, the system can be resumed with the help of the platform,
if there is still enough battery power, or the state of it can be restored on
the basis of the hibernation image.  This often is referred to as the
suspend-to-both capability.  To make it possible, the hibernation userland
interface includes a special ioctl allowing one to make the system enter the
"mem" sleep state if some additional conditions are met.  However, it is
strongly recommended to use this ioctl only as a part of the suspend-to-both
functionality.

XIV. Debugging

Problems related to suspend and hibernation are usually difficult to debug,
since most often they are only reproducible on a limited number of systems and
it generally is difficult to obtain any diagnostic information from a system
after or during a failing resume or restore.  Nevertheless, there are some
facilities that can be used to debug suspend and hibernation issues.

First, some standard debugging techniques that can be used in such cases are
described in Documentation/power/basic-pm-debugging.txt and
Documentation/power/drivers-testing.txt .  There also is the suspend-resume
events tracing functionality, available when CONFIG_PM_TRACE is set in .config
(in addition to CONFIG_PM being set), described in
Documentation/power/s2ram.txt .

Recently, we have added a feature allowing the user to make the kernel beep
in the early phase of resume, right after it has received control from the
platform, which may help confirm that the control is really passed from the
platform to the kernel.  This feature can by activated by executing the
following command:

# r=`cat /proc/sys/kernel/acpi_video_flags` && r=`expr $r + 4` && \
> echo $r > /proc/sys/kernel/acpi_video_flags

XV. Reporting bugs and problems

If you find a bug in the suspend/hibernation code or have a problem related to
it, please report it, preferably to linux-pm@lists.linux-foundation.org .  You
can also use the kernel bugzilla (http://bugzilla.kernel.org/) for this purpose,
in which case please file the report with the "Hibernation/Suspend" component
of "Power Management" and add the e-mail address rjwysocki@sisk.pl to its Cc
list.

The list of bugs related to suspend and hibernation being tracked at the moment
can be found at http://bugzilla.kernel.org/show_bug.cgi?id=7216 .

XVI. Future development plans

As you have certainly realized, there are some known problems and limitations
related to the suspend and hibernation code, so I do not consider these
subsystems as finished work.  Therefore I intend to work on improving them or
even redesigning them to a reasonable extent, if that is desirable.  However,
in my opinion that should be done in an organized way, so that we do not
introduce regressions and do not end up with a solution worse than the current
one.

In my opinion, the part of the suspend and hibernation code that should be
taken care of first is the handling of devices.  Namely, I think that we should
first separate the hibernation-related handling of devices from the
suspend-related handling of them in order to overcome limitations mentioned in
Section IX.  This also will be necessary if we want to try some new approaches
to hibernation, such as the kexec-based one recently discussed on the LKML.
For this reason, I think that it will be necessary to introduce some
hibernation-related callbacks to be used in steps (5), (9), (11), (15), (21),
(25), (27), and (31) of the hibernation-restore cycle instead of the existing
.suspend(), .resume(), .suspend_late() and .resume_early() callbacks which
should only be used during suspend and resume.  We have discussed this issue
for a couple of times on the linux-pm list (linux-pm@lists.linux-foundation.org)
and it generally seems to be known how the hibernation-specific callbacks should
work.

The next thing that seems reasonable to do is to eliminate the freezing of
tasks, described in Section VI, from the suspend and resume code, since the
limitations related to it are regarded by many people as too restrictive.
Still, for this purpose we will need to make device drivers be able to block
userland tasks on I/O after their .suspend() callbacks have been executed.
Currently, there are only a few drivers which can do that and there are drivers
which openly assume the userland tasks to be frozen in the initial phase of
suspend.  Thus, quite a lot of work needs to be done on the drivers before we
can drop the freezing of tasks from the suspend code path.

When drivers are able to block userland tasks on I/O after executing their
.suspend() callbacks, or analogous hibernation-specific callbacks (to be
introduced), we may also be able to eliminate the freezing of tasks from the
hibernation code path or leave only a much simplified and less intrusive form
of it.  In theory, that can be achieved by using a kexec-based hibernation
framework, but I think that there also are other possibilities worthy of
considering.  Apart from this, I think that we have not yet explored all
possibilities to improve the current framework, including the freezing of tasks,
so as long as the freezer is in use, I am going to improve it and fix reported
problems related to it.

There also is the alternative hibernation framework TuxOnIce maintained by Nigel
Cunningham, which is more feature-rich than the current in-kernel hibernation
code.  It therefore seems reasonable to incorporate at least some of the more
advanced TuxOnIce features into the in-kernel code.  I believe that by combining
TuxOnIce with the current in-kernel hibernation implementation we can obtain a
relatively simple, but powerful and solid hibernation framework, so I am going
to work in this direction, after the separation of the suspend-specific and
hibernation-specific device handling is done at the core and device class/device
type/bus type level.
