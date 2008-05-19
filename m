Return-Path: <linux-kernel-owner+w=401wt.eu-S1763069AbYESRwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763069AbYESRwp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 13:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760144AbYESRwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 13:52:36 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:20036 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758498AbYESRwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 13:52:35 -0400
Date: Mon, 19 May 2008 10:51:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
       Thomas Renninger <trenn@suse.de>, Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [PATCH 15/15] rfkill: document rw rfkill switches and clarify
 input subsystem interactions
Message-Id: <20080519105108.8f843c47.randy.dunlap@oracle.com>
In-Reply-To: <1211136485-19878-16-git-send-email-hmh@hmh.eng.br>
References: <1211136485-19878-1-git-send-email-hmh@hmh.eng.br>
	<1211136485-19878-16-git-send-email-hmh@hmh.eng.br>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008 15:48:05 -0300 Henrique de Moraes Holschuh wrote:

> Rework the documentation so as to make sure driver writers understand
> exactly where the boundaries are for input drivers related to rfkill
> switches, buttons and keys, and rfkill class drivers.
> 
> Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Dmitry Torokhov <dtor@mail.ru>
> ---
>  Documentation/rfkill.txt |  329 ++++++++++++++++++++++++++++++++++++++-------
>  1 files changed, 277 insertions(+), 52 deletions(-)
> 
> diff --git a/Documentation/rfkill.txt b/Documentation/rfkill.txt
> index ec75d6d..bf8709c 100644
> --- a/Documentation/rfkill.txt
> +++ b/Documentation/rfkill.txt
> @@ -2,82 +2,299 @@ rfkill - RF switch subsystem support
>  ====================================
>  

Add INTRODUCTION item here?

>  1 Implementation details
> -2 Driver support
> -3 Userspace support
> +2 Kernel driver guidelines
> +3 Kernel API
> +4 Userspace support
>  
> -===============================================================================
> -1: Implementation details
> +
> +INTRODUCTION:
>  

[snip]

> +===============================================================================
> +1: Implementation details
> +
> +The rfkill class provides kernel drivers with an interface that allows them to
> +know when they should enable or disable a wireless network device transmitter.
> +
> +The rfkill-input module provides the kernel with the hability to implement

s/hability/ability/

> +a basic response to when the user presses a key or button (or toggles a switch)

s/to when/when/

> +related to rfkill functionality.  This is optional, and can also be done in
> +userspace.
> +
> +All state changes on rfkill devices is propagated by the rfkill class to a

s/is/are/

> +notification chain and also to userspace through uevents.
>  
>  The system inside the kernel has been split into 2 separate sections:
>  	1 - RFKILL
>  	2 - RFKILL_INPUT
>  
> -The first option enables rfkill support and will make sure userspace will
> -be notified of any events through the input device. It also creates several
> -sysfs entries which can be used by userspace. See section "Userspace support".
> +The first option enables rfkill support and will make sure userspace will be
> +notified of any events through uevents.  It provides a notification chain for
> +interested parties in the kernel to also get notified of rfkill state changes
> +in other drivers.  It creates several sysfs entries which can be used by
> +userspace.  See section "Userspace support".
> +
> +The second option provides an rfkill input handler. This handler will listen to
> +all rfkill key events and will toggle the radio accordingly.  With this option
> +enabled userspace could either do nothing or simply perform monitoring tasks.
> +
> +When a rfkill switch is in the RFKILL_STATE_ON, the wireless transmitter (radio
> +TX circuit for example) is *enabled*.  When the rfkill switch is in the
> +RFKILL_STATE_OFF, the wireless transmitter is to be *blocked* from operating.
> +
> +Full rfkill functionality requires two different subsystems to cooperate: the
> +input layer, and the rfkill class.  The input layer issues *commands* to the

no comma.

> +entire system requesting that devices registered to the rfkill class change
> +state.  The way this interation happens is not complex, but it is not

                        interaction

 obvious
> +either:
> +
> +Kernel Input layer:
> +	* Generates KEY_WWAN, KEY_WLAN, KEY_BLUETOOTH, SW_RFKILL_ALL, and
> +	  other such events when the user presses certain keys, buttons, or
> +	  toggles certain physical switches.

[snip]

> +===============================================================================
> +2: Kernel driver guidelines
> +
> +The first thing one needs to know is whether his driver should be talking to
> +the rfkill class, or to the input layer.

no comma.

> +
> +Do not mistake input devices for rfkill devices.  The only type of "rfkill
> +switch" device that is to be registered with the rfkill class are those
> +directly controlling the circuits that cause a wireless transmitter to stop
> +working (or the software equivalent of them).  Every other kind of "rfkill
> +switch" is just an input device and MUST NOT be registered with the rfkill
> +class.

[snip]

> +   Typically, the ACPI "radio kill" switch of a laptop is the master input
> +   device to issue rfkill events, and, e.g., the WLAN card is just a slave
> +   device that gets disabled by its hardware radio-kill input pin.
>  
> -The second option provides an rfkill input handler. This handler will
> -listen to all rfkill key events and will toggle the radio accordingly.
> -With this option enabled userspace could either do nothing or simply
> -perform monitoring tasks.
> +When in doubt, do not issue input events.  For drivers that should generate
> +input events in some platforms, but not in others (e.g. b43), the best solution
> +is to NEVER generate input events in the first place.  That work should be
> +deferred to a platform-specific kernel module (which will known when to

s/known/know/

> +generate events through the rfkill notifier chain), or to userspace.  This

no comma.

> +avoids the usual maintenance problems with DMI whitelisting.
>  
> +
> +Corner cases and examples:
>  ====================================
> -2: Driver support
>  
> -To build a driver with rfkill subsystem support, the driver should
> -depend on the Kconfig symbol RFKILL; it should _not_ depend on
> -RKFILL_INPUT.
> +1. If the device is an input device that, because of hardware or firmware,
> +causes wireless transmitters to be blocked regardless of the kernel's will, it
> +is still just an input device, and NOT to be registered with the rfkill class.
>  
> -Unless key events trigger an interrupt to which the driver listens, polling
> -will be required to determine the key state changes. For this the input
> -layer providers the input-polldev handler.
> +2. If the wireless transmitter switch control is read-only, it is an input
> +device and not to be registered with the rfkill class (and maybe not to be made
> +an input layer event source either, see below).
>  
> -A driver should implement a few steps to correctly make use of the
> -rfkill subsystem. First for non-polling drivers:
> +3. If there is some other device driver *closer* to the actuall hardware the

s/actuall/actual/

> +user interacted with (the button/switch/key) to issue an input event, THAT is

[snip]

> +the device driver that should be issuing input events.
> +COMMON MISTAKES in kernel drivers, related to rfkill:
> +====================================
> +
> +1. NEVER confuse input device keys and buttons with input device switches.
> +
> +  1a. Switches are always set or reset.  They report the current state
> +      (on position or off position).
> +
> +  1b. Keys and buttons are either in the pressed or not-pressed state, and
> +      that's it.  A "button" that latches down when you press it, and
> +      unlatches when you press it again is in fact a switch as far as input
> +      devices go.
> +
> +Add the SW_* events you need them for switches, do NOT try to emulate a button

Delete "them"?  A little misworded/confusing.

> +using KEY_* events just because there is no such SW_* event yet.  Do NOT try to
> +use, for example, KEY_BLUETOOTH when you should be using SW_BLUETOOTH instead.
> +
> +2. Input device switches (sources of EV_SW events) DO store their current
> +state, and that state CAN be queried from userspace through IOCTLs.  There is
> +no sysfs interface for this, but that doesn't mean you should break things
> +trying to hook it to the rfkill class to get a sysfs interface :-)
> +
> +
> +===============================================================================
> +3: Kernel API
> +
> +To build a driver with rfkill subsystem support, the driver should depend on
> +the Kconfig symbol RFKILL; it should _not_ depend on RKFILL_INPUT.
> +
> +The hardware the driver talks to may be write-only (where the current state
> +of the hardware is unknown), or read-write (where the hardware can be queried
> +about its current state).
> +
> +The rfkill class will call the get_state hook of a device every time it needs
> +to know the *real* current state of the hardware.  This can happen often.
> +
> +Some hardware provide events when its status change.  In these cases, it is

                 provides

> +best for the driver to not provide a get_state hook, and instead register the
> +rfkill class *already* with the correct status, and keep it updated using
> +rfkill_force_state() when it gets an event from the hardware.

[snip]

+===============================================================================
> +4: Userspace support
> +
> +rfkill devices issue uevents (with an action of "change"), with the following
> +environment variables set:
> +
> +RFKILL_NAME
> +RFKILL_STATE
> +RFKILL_TYPE
>  
> -For each key an input device will be created which will send out the correct
> -key event when the rfkill key has been pressed.
> +The ABI for these variables is defined by the sysfs attributes.  It is best
> +to take a quick look at the source to make sure of the possible values.
> +
> +It is expected that HAL will trap those, and bridge them to DBUS, etc.  These
> +events CAN and SHOULD be used to give feedback to the user about the rfkill
> +status of the system.
> +
> +Input devices may issue events that are related to rfkill.  These are the
> +various KEY_* events and SW_* events supported by rfkill-input.c.
> +
> +******IMPORTANT******
> +When rfkill-input is ACTIVE, userspace is NOT TO CHANGE THE STATE OF A RFKILL

OF AN RKFILL ?
i.e., does one say "R F KILL" or does one say "rifkill" or "rufkill" or
something else?

> +SWITCH IN RESPONSE TO AN INPUT EVENT also handled by rfkill-input, unless it
> +has set to true the user_claim attribute for that particular switch.  This rule
> +is *absolute*, do NOT violate it.

s/,/;/

> +******IMPORTANT******
> +
> +When rfkill-input is not active, userspace must initiate an rfkill status
> +change by writing to the "state" attribute in order for anything to happen.
> +
> +Take particular care to implement EV_SW SW_RFKILL_ALL properly.  When that
> +switch is set to OFF, *every* rfkill device *MUST* be immediately put into the
> +OFF state, no questions asked.
>  
>  The following sysfs entries will be created:

[snip]

---
~Randy
