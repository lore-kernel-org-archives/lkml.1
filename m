Return-Path: <linux-kernel-owner+w=401wt.eu-S1762782AbYERS6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762782AbYERS6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 14:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760596AbYERSs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 14:48:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:54086 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760576AbYERSsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 14:48:16 -0400
X-Sasl-enc: 4i0diKSkORMcoUOi9mY8tc0XgN85ow1gskU+vi26huap 1211136495
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: linux-kernel@vger.kernel.org
Cc: Ivo van Doorn <IvDoorn@gmail.com>, Thomas Renninger <trenn@suse.de>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Dmitry Torokhov <dtor@mail.ru>
Subject: [PATCH 15/15] rfkill: document rw rfkill switches and clarify input subsystem interactions
Date: Sun, 18 May 2008 15:48:05 -0300
Message-Id: <1211136485-19878-16-git-send-email-hmh@hmh.eng.br>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework the documentation so as to make sure driver writers understand
exactly where the boundaries are for input drivers related to rfkill
switches, buttons and keys, and rfkill class drivers.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 Documentation/rfkill.txt |  329 ++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 277 insertions(+), 52 deletions(-)

diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
index ec75d6d..bf8709c 100644
--- a/Documentation/rfkill.txt
+++ b/Documentation/rfkill.txt
@@ -2,82 +2,299 @@ rfkill - RF switch subsystem support
 ====================================
 
 1 Implementation details
-2 Driver support
-3 Userspace support
+2 Kernel driver guidelines
+3 Kernel API
+4 Userspace support
 
-===============================================================================
-1: Implementation details
+
+INTRODUCTION:
 
 The rfkill switch subsystem exists to add a generic interface to circuitry that
-can enable or disable the RF output of a radio *transmitter* of any type.
+can enable or disable the signal output of a wireless *transmitter* of any
+type.  By far, the most common use is to disable radio-frequency transmitters.
 
-When a rfkill switch is in the RFKILL_STATE_ON, the radio transmitter is
-*enabled*.  When the rfkill switch is in the RFKILL_STATE_OFF, the radio
-transmitter is *disabled*.
+The rfkill switch subsystem offers support for keys and switches often found on
+laptops to enable wireless devices like WiFi and Bluetooth to actually perform
+an action.
 
-The rfkill switch subsystem offers support for keys often found on laptops
-to enable wireless devices like WiFi and Bluetooth.
+The buttons to enable and disable the wireless transmitters are important in
+situations where the user is for example using his laptop on a location where
+radio-frequency transmitters _must_ be disabled (e.g. airplanes).
 
-This is done by providing the user 3 possibilities:
- 1 - The rfkill system handles all events; userspace is not aware of events.
- 2 - The rfkill system handles all events; userspace is informed about the events.
- 3 - The rfkill system does not handle events; userspace handles all events.
+Because of this requirement, userspace support for the keys should not be made
+mandatory.  Because userspace might want to perform some additional smarter
+tasks when the key is pressed, rfkill provides userspace the possibility to
+take over the task to handle the key events.
 
-The buttons to enable and disable the wireless radios are important in
-situations where the user is for example using his laptop on a location where
-wireless radios _must_ be disabled (e.g. airplanes).
-Because of this requirement, userspace support for the keys should not be
-made mandatory. Because userspace might want to perform some additional smarter
-tasks when the key is pressed, rfkill still provides userspace the possibility
-to take over the task to handle the key events.
+===============================================================================
+1: Implementation details
+
+The rfkill class provides kernel drivers with an interface that allows them to
+know when they should enable or disable a wireless network device transmitter.
+
+The rfkill-input module provides the kernel with the hability to implement
+a basic response to when the user presses a key or button (or toggles a switch)
+related to rfkill functionality.  This is optional, and can also be done in
+userspace.
+
+All state changes on rfkill devices is propagated by the rfkill class to a
+notification chain and also to userspace through uevents.
 
 The system inside the kernel has been split into 2 separate sections:
 	1 - RFKILL
 	2 - RFKILL_INPUT
 
-The first option enables rfkill support and will make sure userspace will
-be notified of any events through the input device. It also creates several
-sysfs entries which can be used by userspace. See section "Userspace support".
+The first option enables rfkill support and will make sure userspace will be
+notified of any events through uevents.  It provides a notification chain for
+interested parties in the kernel to also get notified of rfkill state changes
+in other drivers.  It creates several sysfs entries which can be used by
+userspace.  See section "Userspace support".
+
+The second option provides an rfkill input handler. This handler will listen to
+all rfkill key events and will toggle the radio accordingly.  With this option
+enabled userspace could either do nothing or simply perform monitoring tasks.
+
+When a rfkill switch is in the RFKILL_STATE_ON, the wireless transmitter (radio
+TX circuit for example) is *enabled*.  When the rfkill switch is in the
+RFKILL_STATE_OFF, the wireless transmitter is to be *blocked* from operating.
+
+Full rfkill functionality requires two different subsystems to cooperate: the
+input layer, and the rfkill class.  The input layer issues *commands* to the
+entire system requesting that devices registered to the rfkill class change
+state.  The way this interation happens is not complex, but it is not obvious
+either:
+
+Kernel Input layer:
+	* Generates KEY_WWAN, KEY_WLAN, KEY_BLUETOOTH, SW_RFKILL_ALL, and
+	  other such events when the user presses certain keys, buttons, or
+	  toggles certain physical switches.
+
+	THE INPUT LAYER IS NEVER USED TO PROPAGATE STATUS, NOTIFICATIONS OR THE
+	KIND OF STUFF AN ON-SCREEN-DISPLAY APPLICATION WOULD REPORT.  It is
+	used to issue *commands* for the system to change behaviour, and these
+	commands may or may not be carried out by some kernel driver or
+	userspace application.  It follows that doing user feedback based only
+	on input events is broken, there is no guarantee that an input event
+	will be acted upon.
+
+	Most wireless communication device drivers implementing rfkill
+	functionality MUST NOT generate these events, and have no reason to
+	register themselves with the input layer.  This is a common
+	misconception.  There is an API to propagate rfkill status change
+	information, and it is NOT the input layer.
+
+rfkill class:
+	* Calls a hook in a driver to effectively change the wireless
+	  transmitter state;
+	* Keeps track of the wireless transmitter state (with help from
+	  the driver);
+	* Generates userspace notifications (uevents) and a call to a
+	  notification chain (kernel) when there is a wireless transmitter
+	  state change;
+	* Connects a wireless communications driver with the common rfkill
+	  control system, which, for example, allows actions such as
+	  "switch all bluetooth devices offline" to be carried out by
+	  userspace or by rfkill-input.
+
+	THE RFKILL CLASS NEVER ISSUES INPUT EVENTS.  THE RFKILL CLASS DOES
+	NOT LISTEN TO INPUT EVENTS.  NO DRIVER USING THE RFKILL CLASS SHALL
+	EVER LISTEN TO, OR ACT ON RFKILL INPUT EVENTS.
+
+	Most wireless data communication drivers in the kernel have just to
+	implement the rfkill class API to work properly.  Interfacing to the
+	input layer is not often required (and is very often a *bug*).
+
+Userspace input handlers (uevents) or kernel input handlers (rfkill-input):
+	* Implements the policy of what should happen when one of the input
+	  layer events related to rfkill operation is received.
+	* Uses the sysfs interface (userspace) or private rfkill API calls
+	  to tell the devices registered with the rfkill class to change
+	  their state (i.e. translates the input layer event into real
+	  action).
+
+Userspace uevent handler or kernel platform-specific drivers hooked to the
+rfkill notifier chain:
+
+	* Taps into the rfkill notifier chain or to KOBJ_CHANGE uevents,
+	  in order to know when a device that is registered with the rfkill
+	  class changes state;
+	* Issues feedback notifications to the user;
+	* In the rare platforms where this is required, synthesizes an input
+	  event to command all *OTHER* rfkill devices to also change their
+	  statues when a specific rfkill device changes state.
+
+
+===============================================================================
+2: Kernel driver guidelines
+
+The first thing one needs to know is whether his driver should be talking to
+the rfkill class, or to the input layer.
+
+Do not mistake input devices for rfkill devices.  The only type of "rfkill
+switch" device that is to be registered with the rfkill class are those
+directly controlling the circuits that cause a wireless transmitter to stop
+working (or the software equivalent of them).  Every other kind of "rfkill
+switch" is just an input device and MUST NOT be registered with the rfkill
+class.
+
+A driver should register a device with the rfkill class when ALL of the
+following conditions are met:
+
+1. The device is/controls a data communications wireless transmitter;
+
+2. The kernel can interact with the hardware/firmware to CHANGE the wireless
+   transmitter state (block/unblock TX operation);
+
+A driver should register a device with the input subsystem to issue
+rfkill-related events (KEY_WLAN, KEY_BLUETOOTH, KEY_WWAN, KEY_WIMAX,
+SW_RFKILL_ALL, etc) when ALL of the folowing conditions are met:
+
+1. It is directly related to some physical device the user interacts with, to
+   command the O.S./firmware/hardware to enable/disable a data communications
+   wireless transmitter.
+
+   Examples of the physical device are: buttons, keys and switches the user
+   will press/touch/slide/switch to enable or disable the wireless
+   communication device.
+
+2. It is NOT slaved to another device, i.e. there is no other device that
+   issues rfkill-related input events in preference to this one.
+
+   Typically, the ACPI "radio kill" switch of a laptop is the master input
+   device to issue rfkill events, and, e.g., the WLAN card is just a slave
+   device that gets disabled by its hardware radio-kill input pin.
 
-The second option provides an rfkill input handler. This handler will
-listen to all rfkill key events and will toggle the radio accordingly.
-With this option enabled userspace could either do nothing or simply
-perform monitoring tasks.
+When in doubt, do not issue input events.  For drivers that should generate
+input events in some platforms, but not in others (e.g. b43), the best solution
+is to NEVER generate input events in the first place.  That work should be
+deferred to a platform-specific kernel module (which will known when to
+generate events through the rfkill notifier chain), or to userspace.  This
+avoids the usual maintenance problems with DMI whitelisting.
 
+
+Corner cases and examples:
 ====================================
-2: Driver support
 
-To build a driver with rfkill subsystem support, the driver should
-depend on the Kconfig symbol RFKILL; it should _not_ depend on
-RKFILL_INPUT.
+1. If the device is an input device that, because of hardware or firmware,
+causes wireless transmitters to be blocked regardless of the kernel's will, it
+is still just an input device, and NOT to be registered with the rfkill class.
 
-Unless key events trigger an interrupt to which the driver listens, polling
-will be required to determine the key state changes. For this the input
-layer providers the input-polldev handler.
+2. If the wireless transmitter switch control is read-only, it is an input
+device and not to be registered with the rfkill class (and maybe not to be made
+an input layer event source either, see below).
 
-A driver should implement a few steps to correctly make use of the
-rfkill subsystem. First for non-polling drivers:
+3. If there is some other device driver *closer* to the actuall hardware the
+user interacted with (the button/switch/key) to issue an input event, THAT is
+the device driver that should be issuing input events.
 
-	- rfkill_allocate()
-	- input_allocate_device()
-	- rfkill_register()
-	- input_register_device()
+E.g:
+  [RFKILL slider switch] -- [GPIO hardware] -- [WLAN card rf-kill input]
+                           (platform driver)    (wireless card driver)
+
+The user is closer to the RFKILL slide switch plaform driver, so the driver
+which must issue input events is the platform driver looking at the GPIO
+hardware, and NEVER the wireless card driver (which is just a slave).  It is
+very likely that there are other leaves than just the WLAN card rf-kill input
+(e.g. a bluetooth card, etc)...
+
+On the other hand, some embedded devices do this:
+
+  [RFKILL slider switch] -- [WLAN card rf-kill input]
+                             (wireless card driver)
+
+In this situation, the wireless card driver *could* register itself as an input
+device and issue rf-kill related input events... but in order to AVOID the need
+for DMI whitelisting, the wireless card driver does NOT do it.  Userspace (HAL)
+or a platform driver (that exists only on these embedded devices) will do the
+dirty job of issuing the input events.
+
+
+COMMON MISTAKES in kernel drivers, related to rfkill:
+====================================
+
+1. NEVER confuse input device keys and buttons with input device switches.
+
+  1a. Switches are always set or reset.  They report the current state
+      (on position or off position).
+
+  1b. Keys and buttons are either in the pressed or not-pressed state, and
+      that's it.  A "button" that latches down when you press it, and
+      unlatches when you press it again is in fact a switch as far as input
+      devices go.
+
+Add the SW_* events you need them for switches, do NOT try to emulate a button
+using KEY_* events just because there is no such SW_* event yet.  Do NOT try to
+use, for example, KEY_BLUETOOTH when you should be using SW_BLUETOOTH instead.
+
+2. Input device switches (sources of EV_SW events) DO store their current
+state, and that state CAN be queried from userspace through IOCTLs.  There is
+no sysfs interface for this, but that doesn't mean you should break things
+trying to hook it to the rfkill class to get a sysfs interface :-)
+
+
+===============================================================================
+3: Kernel API
+
+To build a driver with rfkill subsystem support, the driver should depend on
+the Kconfig symbol RFKILL; it should _not_ depend on RKFILL_INPUT.
+
+The hardware the driver talks to may be write-only (where the current state
+of the hardware is unknown), or read-write (where the hardware can be queried
+about its current state).
+
+The rfkill class will call the get_state hook of a device every time it needs
+to know the *real* current state of the hardware.  This can happen often.
+
+Some hardware provide events when its status change.  In these cases, it is
+best for the driver to not provide a get_state hook, and instead register the
+rfkill class *already* with the correct status, and keep it updated using
+rfkill_force_state() when it gets an event from the hardware.
 
-For polling drivers:
+There is no provision for a statically-allocated rfkill struct.  You must
+use rfkill_allocate() to allocate one.
 
+You should:
 	- rfkill_allocate()
-	- input_allocate_polled_device()
+	- modify rfkill fields (flags, name)
+	- modify state to the current hardware state (THIS IS THE ONLY TIME
+	  YOU CAN ACCESS state DIRECTLY)
 	- rfkill_register()
-	- input_register_polled_device()
 
-When a key event has been detected, the correct event should be
-sent over the input device which has been registered by the driver.
+Please refer to the source for more documentation.
 
-====================================
-3: Userspace support
+===============================================================================
+4: Userspace support
+
+rfkill devices issue uevents (with an action of "change"), with the following
+environment variables set:
+
+RFKILL_NAME
+RFKILL_STATE
+RFKILL_TYPE
 
-For each key an input device will be created which will send out the correct
-key event when the rfkill key has been pressed.
+The ABI for these variables is defined by the sysfs attributes.  It is best
+to take a quick look at the source to make sure of the possible values.
+
+It is expected that HAL will trap those, and bridge them to DBUS, etc.  These
+events CAN and SHOULD be used to give feedback to the user about the rfkill
+status of the system.
+
+Input devices may issue events that are related to rfkill.  These are the
+various KEY_* events and SW_* events supported by rfkill-input.c.
+
+******IMPORTANT******
+When rfkill-input is ACTIVE, userspace is NOT TO CHANGE THE STATE OF A RFKILL
+SWITCH IN RESPONSE TO AN INPUT EVENT also handled by rfkill-input, unless it
+has set to true the user_claim attribute for that particular switch.  This rule
+is *absolute*, do NOT violate it.
+******IMPORTANT******
+
+When rfkill-input is not active, userspace must initiate an rfkill status
+change by writing to the "state" attribute in order for anything to happen.
+
+Take particular care to implement EV_SW SW_RFKILL_ALL properly.  When that
+switch is set to OFF, *every* rfkill device *MUST* be immediately put into the
+OFF state, no questions asked.
 
 The following sysfs entries will be created:
 
@@ -89,8 +306,16 @@ The following sysfs entries will be created:
 Both the "state" and "claim" entries are also writable. For the "state" entry
 this means that when 1 or 0 is written all radios, not yet in the requested
 state, will be will be toggled accordingly.
+
 For the "claim" entry writing 1 to it means that the kernel no longer handles
 key events even though RFKILL_INPUT input was enabled. When "claim" has been
 set to 0, userspace should make sure that it listens for the input events or
-check the sysfs "state" entry regularly to correctly perform the required
-tasks when the rkfill key is pressed.
+check the sysfs "state" entry regularly to correctly perform the required tasks
+when the rkfill key is pressed.
+
+A note about input devices and EV_SW events:
+
+In order to know the current state of an input device switch (like
+SW_RFKILL_ALL), you will need to use an IOCTL.  That information is not
+available through sysfs in a generic way at this time, and it is not available
+through the rfkill class AT ALL.
-- 
1.5.5.1

