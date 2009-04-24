Return-Path: <linux-kernel-owner+w=401wt.eu-S1754025AbZDXTU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025AbZDXTU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753204AbZDXTUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:20:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43512 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751917AbZDXTUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:20:43 -0400
Date: Fri, 24 Apr 2009 15:20:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David VomLehn <dvomlehn@cisco.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jamie Lokier <jamie@shareable.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
In-Reply-To: <20090424003555.GA31173@cuplxvomd02.corp.sa.net>
Message-ID: <Pine.LNX.4.44L0.0904241502440.4531-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, David VomLehn wrote:

> I'm still scratching my head, trying to figure out where I can tap into the
> 'USB notion of "all devices that were present at boot time have been probed"'
> that Alan mentions above, so I don't have a specific implementation yet. I'm
> open to any tips in this area.

This is a general notion; it applies to all subsystems that do
asynchronous device discovery or registration.  The idea is simple
enough: Keep a count of all devices which are known or suspected to be
present, and decrement the count each time one of them is registered or
determined not to exist.  When the count first reaches 0, all devices
that were present (or reachable) at boot time will have been
registered.

Isn't this basically what you had in mind?  If you're concerned about 
the USB implementation, don't be -- I can write it quite easily.

> Below is a write-up of the interface that looks like it should be added to
> Documentation/driver-model/bus.txt. Comments are much appreciated.
> 
> ----------------------------- CUT HERE -------------------------------------
> Synchronization with hot pluggable boot devices

It's not just hot-pluggable devices.  These ideas are appropriate 
whenever detection or registration is asynchronous.

> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> Earlier versions of the Linux kernel used a single-threaded approach to
> boot initialization. This took a number of seconds, which mean that
> hotpluggable devices used or configured during boot were generally available
> before they were used. Modern kernels use a multithreaded approach, which
> requires synchronization between code that wants to act upon boot devices
> and the probing and initialization of those devices. Support of fine-grained
> boot concurrency requires distinguishing between types of boot devices, so
> that devices can be used as soon as they are initialized.
> 
> There currently two types supported:
> -	consoles
> -	network devices

You might as well add block devices too.

> There is a distinction between the hardware type and the boot device type.
> From the hardware view, most any serial device can be used as a console,
> but console support is generally be configured separately. For example,
> consider USB serial devices. These should be considered a console only if
> the software is configured to support this usage, which is done by enabling
> the CONFIG_USB_SERIAL_CONSOLE option. If this option is disabled, the USB bus
> driver should not report that it has found any console devices.
> 
> Two functions are available for use by the per-bus support code:
> 
> bus_bootdev_found(int bootdev_mask)
> 	This function must be called each time a boot device device is found.
> 	It is passed a bit mask created by ORing any of the following flags
> 	that apply to the device found:
> 		BOOTDEV_CONSOLE_MASK
> 		BOOTDEV_NETDEV_MASK
> 	There is no need to call this function for a given device if it is
> 	known that it cannot be used as a boot device. If it is not
> 	possible to determine whether a device is usable as a boot device,
> 	or what the specific type of boot device it may be, the argument
> 	BOOTDEV_ANY_MASK can be passed.  This should be used only when
> 	necessary as it reduces the level of concurrency that can be
> 	achieved from boot time initialization.
> 
> bus_bootdev_initialized(int bootdev_mask)
> 	This function must be called by the bus support code after it calls the
> 	initialiation function for a boot device. Every call to
> 	bus_bootdev_found must be matched by a call to
> 	bus_bootdev_initialized with the same bootdev_mask.

Even if the device can't be initialized for some reason, or if it turns
out not the be the sort of boot device originally thought, this
function still has to be called.  That should be made extremely clear.

> 	Device initialization functions must have called the appropriate
> 	registration function for that device before bus_bootdev_initialized
> 	is called. So, for console devices, register_console must be called
> 	before bus_bootdev_initialized, and for network devices,
> 	register_netdevice must be called first.

It's not clear how either of these two functions is bus-specific.

> It is possible for bus code to avoid the need to call bus_bootdev_found
> for each device if it calls it once at the beginning of device discovery and
> once at the end with a mask for all of the possible types of boot devices
> that could be on that bus. This approach should be avoid if at all possible
> because it reduces the available boot-time concurency, which can lead
> to increased boot times.
> 
> When it is time to use a given boot device type, the following function
> should be used:
> 
> bus_wait_for_bootdev(enum bootdev_type type, bool (*done)(void))
> 	The type is one of:
> 		BOOTDEV_CONSOLE
> 		BOOTDEV_NETDEV
> 	The done function checks to see whether all of the boot devices
> 	required have been registered. If it determines that this is the
> 	case, it can return true. This will cause the wait to be terminated
> 	even though some boot devices of the given type have not yet been
> 	initialized, which can decrease the time to boot. If this is not
> 	possible, it can return false. In that case, bus_wait_for_bootdev
> 	won't return until all devices of the given type on all buses have
> 	been initialized. Not surprisingly, this limit the opportunities to
> 	reduce boot time.

This looks like a good plan and not hard to implement.  It even should 
be possible to fit USB disk drives into the scheme.

Alan Stern

