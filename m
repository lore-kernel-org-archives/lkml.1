Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbYJ3Ola@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbYJ3Ola (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 10:41:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbYJ3OlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 10:41:21 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:31264 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725AbYJ3OlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 10:41:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Mxfq9WzSy1j8eQze9ERf6fOAFd92/MBLtwqN05vkdLzWc3C0/55IH8tWBd0DBr/Z3k
         eLY6sEAxPkyQ/5HrDdCVYHLrNe5tBSZBlswUbdGZvgplMaSp+hRxnkSJK1cc40rBPird
         4Wv0L5oCHZw+fW/C7KOXseCwKRqziqDJVPfm0=
Message-ID: <7a6abd110810300741wf73f838laa3754e23c22baf3@mail.gmail.com>
Date: Thu, 30 Oct 2008 15:41:17 +0100
From: "Jonas Bonn" <jonas.bonn@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [RFC] API for system clocks (oscillators)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'd be happy to get some feedback on this, whether or not it is a good
idea or even the right way to approach this problem.  This is part of
the puzzle for solving the problem of frequency scaling on (primarily)
embedded systems where there are many clocks, (changeable)
relationships between clocks, device dependencies on clock
availability, and device constraints on frequency that appear and
disappear as devices are enabled and disabled.

This is a first draft (almost thinking-out-loud version), so please
read it as such... there is much room for improvement and all
suggestions are welcome.  Release early, release often, right?  Well,
this is an "early" specification...

Regards,
Jonas

Introduction and Motivation
===========================

A system may be comprised of multiple clocks comprising CPU clock, bus
clocks, and external device clocks.  The relationships amongst these
may be complex; this is particularly true for SOC's.  There is
currently no abstraction layer in place that allows for a reasonably
system-agnostic management of this clock hierarchy and usage of this
clock information.

Today we have cpuidle, cpufreq, and struct clk which are all trying to
manage system clocks and their frequencies.  Unfortunately, it seems
that there is a lot of overlap between these three areas.  Cpuidle is
optimal on a system with explicit idle states; however, on other
systems, it may be best just to drop the operating frequency as low as
possible while idling.  Cpufreq can dynamically change the operating
frequency, but collides with cpuidle when there are no explicit idle
states; furthermore, it needs to keep the configuration of the
hierarchy of struct clk objects sane.  The struct clk objects provide
frequency information to drivers that depend on a given clock;
however, there is no notification system in place so that drivers know
(and can react appropriately) to clock frequency changes.

I suggest a new API that manages the system clock hierarchy, allows
frequency operating constraints to be set and respected, and allows
frequency changes to be appropriately notified across the system.
This API could be used by cpuidle when driving the system to a low
frequency state while idling; it could be used by cpufreq to select
appropriate operating frequencies and to set a new frequency in a
device-friendly manner; and it could be used by device drivers to
specify operating constraints for the clock that it uses while
minimizing the knowledge required about the rest of the clock
hierarchy.

The inspiration for this model comes largely from the clock hierarchy
of the Samsung S3C2410 processor; there is surely room for
improvement, especially in areas concerning specific requirements of
other systems.  Feedback is welcome; function names are rather long
and suggestions for good, shortened names would be particularly
appreciated.

Clocks
======

The relationships between system clocks and the devices that rely on
them may be complex.

i)    Clocks may be standalone or may depend on another clock (its parent)
ii)   A clock may relate to another by way of a multiplier or divider
iii)  The multiplier/divider may change
iv)   A clock's parent may change
v)    While clock frequencies (or the relationship between clocks) are
being adjusted, one or more clocks may become unstable/invalid and
should not be used
vi)   Power usage is related to clock frequency
vii)  A clock may be turned off completely if it is no device is using it
viii) A clock may be constrained by device requirements to work within
a given frequency range, or with a set of discrete frequencies
ix)   A clock is constrained by the constraints of its child-clocks
x)    A clock may switch between using discrete frequencies and using
a continuous range of frequencies as device constraints are updated.
xi)   Device constraints may change dynamically; e.g. a device may
disengage the clock when it is not doing work or a device may change
its working frequency range based on some power saving considerations

These requirements give need for an API that allows for a clock's
capabilities to be defined and for the changing state of a clock
signal to be reflected across the system.

------ API Suggestions ------

Since clock, clk, and ck are already used in the kernel, we need a new
name that identifies this clock abstraction.  I'm calling it 'klocka'
(Swedish word for clock) for lack of something better at the moment.

The clock has its own physical limitations when unconstrained by the
limits of any other device.  We need to be able to specify these.

Set operating frequency range for unconstrained clock
klocka_set_freq_range(klocka, min, max)

Set operating frequency table for unconstrained clock
klocka_set_freq_table(klocka, table)

Register clocks:
klocka_register(klocka_info)
klocka_unregister(klocka)

System Functions
================

These functions act on 'klocka' objects, querying capabilities and
making operating frequency selections, as necesasry.

klocka_get_by_name(const char* name)

Make a clock available to clients
klocka_enable(klocka)

Turn off clock (at least, virtually); should make devices the rely on
clock quiesce.
klocka_disable(klocka)

Query the clock.  It must be possible to:
- Get lowest possible operating frequency: returns the lowest
frequency that can be used given all device constraints, including
constraints of child clocks
- Get highest possible operating frequency: return the highest
frequency that can be used given all device constraints, including
constraints of child clocks
- Get closest frequency: return a valid operating frequency closest to
the requested frequency given all constraints.

Returns true if a clock can work with a set of discrete frequencies
only; false if the frequency range is continuous
klocka_has_discrete_frequencies(klocka)

Query available frequencies.  For discrete clocks:
klocka_next_higher_frequency(klocka, freq);
klocka_next_lower_frequency(klocka, freq);
klocka_closest_frequency(klocka, freq);

For discrete and continuous clocks:
klocka_min_frequency()
klocka_max_frequency()

Selecting a new frequency:
klocka_set_frequency(klocka, freq)
--> This fails if freq is invalid within current constraints

Query current frequency:
klocka_get_frequency()

Drivers
=======

Drivers may have clock rate requirements; the driver may:
i)   work only within a given frequency range,
ii)  work only with certain discrete frequencies.

Furthermore, these driver requirements may be variable depending on
operating conditions:
i)   frequency required only when device in operation
ii)  device frequency requirements may change with operating conditions

The 'klocka' API should provide an interface for drivers to specify
their frequency requirements.

------ API Suggestions ------

Add a device that depends on clock:
klocka_device_add(klocka, device)
--> This function might just be implicit in some of the other below

Some drivers require the clock provide a signal within a certain
frequency range in order to function.  Allow driver to tell the clock
that.

klocka_device_set_freq_range(klocka, device, min, max)

Some drivers can work only frequencies from a discrete set.  Allow
this set to be provided to the 'klocka' as a table.

klocka_device_set_freq_table(klocka, device, frequencies):

When device is not busy, the clock frequency may be unimportant; in
this case, the driver can "disengage" the clock, allowing the clock
frequency to drift outside the values acceptable to the device for
normal operation or allowing the clock to be turned off altogether in
order to save power:

klocka_device_disengage(klocka, device)

When the device needs the clock to be turned on or to respect the
device frequency requirements, it can "engage" the clock.  This
function should return a value telling the driver whether the clock is
already ready within the device's operating constraints so that it can
resume right away, or whether the clock needs to be adjusted so that
the device should wait for the appropriate frequency change
notification before resuming.

klocka_device_engage(klocka, device)
	
When the clock frequency changes, the driver may need notification in
order to change the device parameters; allow the driver to register
notifiers for frequency changes:

klocka_device_register_notifiers(klocka, device, notifiers)

The frequency change notifiers are optional and depend on the device
requirements.  Some devices can adjust automatically, some need to
inhibit device operation during the change, some just need to update
some regisiters and can do so on the fly.

Notifiers
---------

pre_change: the frequency is about to change; quiesce the device if
necessary.  This notifier is called while the clock is still running
at the old frequency.

change: update the device to work with the new frequency.  This
notifier is called during the change; some clocks may need to be
stopped while changing frequency, in which case the clock might not be
running at all here.

post_change: the frequency has now changed; continue operation at new
frequency.  This notifier is called when the clock is running at the
new frequency.

clock_invalidated: the clock is about to become unstable/be turned
off; quiesce if necessary

clock_validated: the clock has become stable/turned on again

Examples
========

Clock side
----------

(This is based loosely on S3C2410 processor, but is intended to be abstract)

Clock hierarchy:

MPLL
 |--> fclk
       |--> [Divider=2] --> hclk (hclk = fclk/2)
                             |--> [Divider=2] --> pclk (pclk = hclk/2)

fclk frequency may change which results in hclk and pclk changing as
well.  Users of all three clocks need to be notified.

---------------

MPLL
 |--> fclk
       |--> [Divider=1] --> hclk (hclk = fclk)
          		     |--> [Divider=2] --> pclk (pclk = hclk/2)

Here the divider for hclk has changed, resulting in a change to both
hclk and pclk frequencies.  Users of these two clocks need to be
notified.

---------------

MPLL
 |--> fclk
       |--> [Divider=2] --> hclk (hclk = fclk/2)
       |--> [Divider=2] --> pclk (pclk = fclk/2)

Here pclk has been reparented.  Users of pclk need to be notified of
frequency change.

---------------

Driver side
-----------

The driver gets the clock it is using:

	clk = klocka_get_by_name("hclk")

Now the driver can add device constraints to the clock:

	klocka_device_set_freq_range(clk, dev, 100, 200)

...and the driver can register frequency-change notifiers:

	klocka_device_register_notifiers(clk, dev, notifiers)

When frequency changes, we can be certain that it is within the
constraints given earlier (i.e. 100 < freq < 200).  Notifiers will be
called before, during, and after frequency change as this driver
requires this; for other driver, notification might not be necessary
at all or only the change notification might be necessary.

pre_change notification:
	driver disables device during frequency change
change notification:
	driver updates device registers for new frequency
post_change notification:
	driver resumes operation

We never have to worry about what is happening in the underlying clock
hierarchy because we are only dependent on the clock "hclk".

cpufreq notifiers (for some drivers) go away because we do not really
care about the "global frequency" scaling; we only care specifically
about the "real" frequency of the clock we are using; the cpufreq
infrastructure can adjust this clock as necessary and be sure that all
the users of the clock are correctly notified.

-----------------

Early Draft Definitions
=======================

struct klocka_device {
	struct device* dev;
	int engaged;
	long min_freq;
	long max_freq;
	struct list_head discrete_frequencies;

	void (*freq_prechange)(struct klocka *klk, struct device *dev);
	void (*freq_change)(struct klocka *klk, struct device *dev, newfreq, oldfreq);
	void (*freq_postchange)(struct klocka *klk, struct device *dev);
	void (*klocka_invalidated)(struct klocka *klk, struct device *dev);
	void (*klocka_validated)(struct klocka *klk, struct device *dev);
};

struct klocka {
	const char*      name;

	/* These should not be manipulated directly */
	struct klocka*   parent;
	struct list_head children;
	struct list_head siblings;
	struct list_head engaged_devices;
	struct list_head disengaged_devices;
	
	/* */
	void* data;

	/* Architecture/platform specific functions */

	long (*get_freq)(struct klocka *klocka, int flags);
	int (*set_freq)(struct klocka *klocka, int flags);
	...

};
