Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab0BJSd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 13:33:27 -0500
Received: from exprod6og101.obsmtp.com ([64.18.1.181]:55111 "HELO
	exprod6og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753069Ab0BJSdZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 13:33:25 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [PWM PATCH 1/7] API to consolidate PWM devices behind a common user and kernel interface
Date: Wed, 10 Feb 2010 13:33:23 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190902153321@mi8nycmail19.Mi8.com>
In-Reply-To: <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PWM PATCH 1/7] API to consolidate PWM devices behind a common user and kernel interface
Thread-Index: AcqpyXXfdax78YKCSHSk8n3rMNTneAAskNuw
References: <cover.1265748263.git.bgat@billgatliff.com> <b7afd475c3fce08f459bceff7814de57ffce7bd0.1265748264.git.bgat@billgatliff.com>
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "Bill Gatliff" <bgat@billgatliff.com>, <linux-embedded@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 10 Feb 2010 18:33:23.0466 (UTC) FILETIME=[86EBF6A0:01CAAA7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 09, 2010 1:46 PM, Bill Gatliff wrote:
> diff --git a/Documentation/pwm.txt b/Documentation/pwm.txt
> new file mode 100644
> index 0000000..2c41ca5
> --- /dev/null
> +++ b/Documentation/pwm.txt

A couple minor comments below.

> @@ -0,0 +1,260 @@
> +                       Generic PWM Device API
> +
> +                          February 1, 2010
> +                            Bill Gatliff
> +                        <bgat@billgatliff.com>
> +
> +
> +
> +The code in drivers/pwm and include/linux/pwm/ implements an API for
> +applications involving pulse-width-modulation signals.  This document
> +describes how the API implementation facilitates both PWM-generating
> +devices, and users of those devices.
> +
> +
> +
> +Motivation
> +
> +The primary goals for implementing the "generic PWM API" are to
> +consolidate the various PWM implementations within a consistent and
> +redundancy-reducing framework, and to facilitate the use of
> +hotpluggable PWM devices.
> +
> +Previous PWM-related implementations within the Linux kernel achieved
> +their consistency via cut-and-paste, but did not need to (and didn't)
> +facilitate more than one PWM-generating device within the system---
> +hotplug or otherwise.  The Generic PWM Device API might be most
> +appropriately viewed as an update to those implementations, rather
> +than a complete rewrite.
> +
> +
> +
> +Challenges
> +
> +One of the difficulties in implementing a generic PWM framework is the
> +fact that pulse-width-modulation applications involve real-world
> +signals, which often must be carefully managed to prevent destruction
> +of hardware that is linked to those signals.  A DC motor that
> +experiences a brief interruption in the PWM signal controlling it
> +might destructively overheat; it could suddenly change speed, losing
> +synchronization with a sensor; it could even suddenly change direction
> +or torque, breaking the mechanical device connected to it.
> +
> +(A generic PWM device framework is not directly responsible for
> +preventing the above scenarios: that responsibility lies with the
> +hardware designer, and the application and driver authors.  But it
> +must to the greatest extent possible make it easy to avoid such
> +problems).
> +
> +A generic PWM device framework must accommodate the substantial
> +differences between available PWM-generating hardware devices, without
> +becoming sub-optimal for any of them.
> +
> +Finally, a generic PWM device framework must be relatively
> +lightweight, computationally speaking.  Some PWM users demand
> +high-speed outputs, plus the ability to regulate those outputs
> +quickly.  A device framework must be able to "keep up" with such
> +hardware, while still leaving time to do real work.
> +
> +The Generic PWM Device API is an attempt to meet all of the above
> +requirements.  At its initial publication, the API was already in use
> +managing small DC motors, sensors and solenoids through a
> +custom-designed, optically-isolated H-bridge driver.
> +
> +
> +
> +Functional Overview
> +
> +The Generic PWM Device API framework is implemented in
> +include/linux/pwm/pwm.h and drivers/pwm/pwm.c.  The functions therein
> +use information from pwm_device, pwm_channel and pwm_channel_config
> +structures to invoke services in PWM peripheral device drivers.
> +Consult drivers/pwm/atmel-pwm.c for an example driver.
> +
> +There are two classes of adopters of the PWM framework:
> +
> +  "Users" -- those wishing to employ the API merely to produce PWM
> +  signals; once they have identified the appropriate physical output
> +  on the platform in question, they don't care about the details of
> +  the underlying hardware
> +
> +  "Driver authors" -- those wishing to bind devices that can generate
> +  PWM signals to the Generic PWM Device API, so that the services of
> +  those devices become available to users. Assuming the hardware can
> +  support the needs of a user, driver authors don't care about the
> +  details of the user's application
> +
> +Generally speaking, users will first invoke pwm_request() to obtain a
> +handle to a PWM device.  They will then pass that handle to functions
> +like pwm_duty_ns() and pwm_period_ns() to set the duty cycle and
> +period of the PWM signal, respectively.  They will also invoke
> +pwm_start() and pwm_stop() to turn the signal on and off.
> +
> +The Generic PWM API framework also provides a sysfs interface to PWM
> +devices, which is adequate for basic application needs and testing.
> +
> +Driver authors fill out a pwm_device structure, which describes the
> +capabilities of the PWM hardware being constructed--- including the
> +number of distinct output "channels" the peripheral offers.  They then
> +invoke pwm_register() (usually from within their device's probe()
> +handler) to make the PWM API aware of their device.  The framework
> +will call back to the methods described in the pwm_device structure as
> +users begin to configure and utilize the hardware.
> +
> +Note that PWM signals can be produced by a variety of peripherals,
> +beyond the true "PWM hardware" offered by many system-on-chip devices.
> +Other possibilities include timer/counters with compare-match
> +capabilities, carefully-programmed synchronous serial ports
> +(e.g. SPI), and GPIO pins driven by kernel interval timers.  With a
> +proper pwm_device structure, these devices and pseudo-devices can all
> +be accommodated by the Generic PWM Device API framework.
> +
> +
> +
> +Using the API to Generate PWM Signals -- Basic Functions for Users
> +
> +
> +pwm_request() -- Returns a pwm_channel pointer, which is subsequently
> +passed to the other user-related PWM functions.  Once requested, a PWM
> +channel is marked as in-use and subsequent requests prior to
> +pwm_free() will fail.
> +
> +The names used to refer to PWM devices are defined by driver authors.
> +Typically they are platform device bus identifiers, and this
> +convention is encouraged for consistency.
> +
> +
> +pwm_free() -- Marks a PWM channel as no longer in use.  The PWM device
> +is stopped before it is released by the API.
> +
> +
> +pwm_period_ns() -- Specifies the PWM signal's period, in nanoseconds.
> +
> +
> +pwm_duty_ns() -- Specifies the PWM signal's active duration, in nanoseconds.
> +
> +
> +pwm_duty_percent() -- Specifies the PWM signal's active duration, as a
> +percentage of the current period of the signal.  NOTE: this value is
> +not recalculated if the period of the signal is subsequently changed.
> +
> +
> +pwm_start(), pwm_stop() -- Turns the PWM signal on and off.  Except
> +where stated otherwise by a driver author, signals are stopped at the
> +end of the current period, at which time the output is set to its
> +inactive state.
> +
> +
> +pwm_polarity() -- Defines whether the PWM signal output's active
> +region is "1" or "0".  A 10% duty-cycle, polarity=1 signal will
> +conventionally be at 5V (or 3.3V, or 1000V, or whatever the platform
> +hardware does) for 10% of the period.  The same configuration of a
> +polarity=0 signal will be at 5V (or 3.3V, or ...) for 90% of the
> +period.
> +
> +
> +
> +Using the API to Generate PWM Signals -- Advanced Functions
> +
> +
> +pwm_config() -- Passes a pwm_channel_config structure to the
> +associated device driver.  This function is invoked by pwm_start(),
> +pwm_duty_ns(), etc. and is one of two main entry points to the PWM
> +driver for the hardware being used.  The configuration change is
> +guaranteed atomic if multiple configuration changes are specified.
> +This function might sleep, depending on what the device driver has to
> +do to satisfy the request.  All PWM device drivers must support this
> +entry point.
> +
> +
> +pwm_config_nosleep() -- Passes a pwm_channel_config structure to the
> +associated device driver.  If the driver must sleep in order to
> +implement the requested configuration change, -EWOULDBLOCK is
> +returned.  Users may call this function from interrupt handlers, for
> +example.  This is the other main entry point into the PWM hardware
> +driver, but not all device drivers support this entry point.
> +
> +
> +pwm_synchronize(), pwm_unsynchronize() -- "Synchronizes" two or more
> +PWM channels, if the underlying hardware permits.  (If it doesn't, the
> +framework facilitates emulating this capability but it is not yet
> +implemented).  Synchronized channels will start and stop
> +simultaneously when any single channel in the group is started or
> +stopped.  Use pwm_unsynchronize(..., NULL) to completely detach a
> +channel from any other synchronized channels.  By default, all PWM
> +channels are unsynchronized.
> +
> +
> +pwm_set_handler() -- Defines an end-of-period callback.  The indicated
> +function will be invoked in a worker thread at the end of each PWM
> +period, and can subsequently invoke pwm_config(), etc.  Must be used
> +with extreme care for high-speed PWM outputs.  Set the handler
> +function to NULL to un-set the handler.

This requires that the pwm producer can generate an interrupt signaling
the end-of-period.  If so you might want to mention this so that driver
writers don't spin their wheels trying to get the callback to work.  It's
mentioned below but you might want to bring it up here.

> +
> +
> +
> +Implementing a PWM Device API Driver -- Functions for Driver Authors
> +
> +
> +Fill out the appropriate fields in a pwm_device structure, and submit
> +to pwm_register():
> +

What about dev?  If it's missing you will get the oops.

> +
> +bus_id -- the plain-text name of the device.  Users will bind to a
> +channel on the device using this name plus the channel number.  For
> +example, the Atmel PWMC's bus_id is "atmel_pwmc", the same as used by
> +the platform device driver (recommended).  The first device registered
> +thereby receives bus_id "atmel_pwmc.0", which is what you put in
> +pwm_device.bus_id.  Channels are then named "atmel_pwmc.0:[0-3]".
> +(Hint: just use pdev->dev.bus_id in your probe() method).

The hint doesn't work.  The bus_id needs to be a string, use dev_name
or something along that line.

> +
> +
> +nchan -- the number of distinct output channels provided by the device.
> +
> +
> +request -- (optional) Invoked each time a user requests a channel.
> +Use to turn on clocks, clean up register states, etc.  The framework
> +takes care of device locking/unlocking; you will see only successful
> +requests.
> +
> +
> +free -- (optional) Callback for each time a user relinquishes a
> +channel.  The framework will have already stopped, unsynchronized and
> +un-handled the channel.  Use to turn off clocks, etc. as necessary.
> +
> +
> +synchronize, unsynchronize -- (optional) Callbacks to
> +synchronize/unsynchronize channels.  Some devices provide this
> +capability in hardware; for others, it can be emulated (see
> +atmel_pwmc.c's sync_mask for an example).
> +
> +
> +set_callback -- (optional) Invoked when a user requests a handler.  If
> +the hardware supports an end-of-period interrupt, invoke the function
> +indicated during your interrupt handler.  The callback function itself
> +is always internal to the API, and does not map directly to the user's
> +callback function.

See above.

> +
> +
> +config -- Invoked to change the device configuration, always from a
> +sleep-capable context.  All the changes indicated must be performed
> +atomically, ideally synchronized to an end-of-period event (so that
> +you avoid short or long output pulses).  You may sleep, etc. as
> +necessary within this function.
> +
> +
> +config_nosleep -- (optional) Invoked to change device configuration
> +from within a context that is not allowed to sleep.  If you cannot
> +perform the requested configuration changes without sleeping, return
> +-EWOULDBLOCK.

If the pwm hardware does not implement this callback the API will
return -EINVAL.  Does this need to be mentioned?

Also, it appears all your drivers first try to implement the pwm_config
using the config_nosleep then fall back to the config inplementation.
is this the desired standard?

> +
> +
> +
> +Acknowledgements
> +
> +
> +The author expresses his gratitude to the countless developers who
> +have reviewed and submitted feedback on the various versions of the
> +Generic PWM Device API code, and those who have submitted drivers and
> +applications that use the framework.  You know who you are.  ;)
> +

Regards,
Hartley

 
