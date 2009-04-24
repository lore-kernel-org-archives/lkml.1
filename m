Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbZDXAgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbZDXAgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 20:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbZDXAgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 20:36:12 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:15796 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbZDXAgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 20:36:10 -0400
X-IronPort-AV: E=Sophos;i="4.40,238,1238976000"; 
   d="scan'208";a="176142454"
Date: Thu, 23 Apr 2009 17:35:55 -0700
From: David VomLehn <dvomlehn@cisco.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jamie Lokier <jamie@shareable.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090424003555.GA31173@cuplxvomd02.corp.sa.net>
References: <20090422220853.0af12ece@lxorguk.ukuu.org.uk> <Pine.LNX.4.44L0.0904221723010.23158-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904221723010.23158-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Authentication-Results: sj-dkim-1; header.From=dvomlehn@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 05:24:18PM -0400, Alan Stern wrote:
> On Wed, 22 Apr 2009, Alan Cox wrote:
> 
> > > 2.	All devices have been probed
> > > If we exit for reason 2, it means that no such device is present,
> > > and we go on to the do the appropriate thing for that device class.
> > 
> > USB has no notion of #2 really
> 
> That's true, it doesn't.  But it _does_ rather have a notion of "all 
> devices that were present at boot time have been probed".  That should 
> be good enough.
> 
> Alan Stern

Okay, I've been slugging away at this and have a proposed interface. The
interface is at the level of devices of particular types because that would
maximize the opportunities for concurrency, but I don't know if interesting
buses actually provide that level of detail early enough for this to be
useful. If not, the fallback is just to do things on a bus granularity.

If bus granularity is the best that can be done, it is still interesting
to distingish between boot device types. If a boot device type is not 
upported by a particular bus, we don't have to wait for probing to complete
on that bus.

I'm still scratching my head, trying to figure out where I can tap into the
'USB notion of "all devices that were present at boot time have been probed"'
that Alan mentions above, so I don't have a specific implementation yet. I'm
open to any tips in this area.

Below is a write-up of the interface that looks like it should be added to
Documentation/driver-model/bus.txt. Comments are much appreciated.

----------------------------- CUT HERE -------------------------------------
Synchronization with hot pluggable boot devices
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Earlier versions of the Linux kernel used a single-threaded approach to
boot initialization. This took a number of seconds, which mean that
hotpluggable devices used or configured during boot were generally available
before they were used. Modern kernels use a multithreaded approach, which
requires synchronization between code that wants to act upon boot devices
and the probing and initialization of those devices. Support of fine-grained
boot concurrency requires distinguishing between types of boot devices, so
that devices can be used as soon as they are initialized.

There currently two types supported:
-	consoles
-	network devices

There is a distinction between the hardware type and the boot device type.
>From the hardware view, most any serial device can be used as a console,
but console support is generally be configured separately. For example,
consider USB serial devices. These should be considered a console only if
the software is configured to support this usage, which is done by enabling
the CONFIG_USB_SERIAL_CONSOLE option. If this option is disabled, the USB bus
driver should not report that it has found any console devices.

Two functions are available for use by the per-bus support code:

bus_bootdev_found(int bootdev_mask)
	This function must be called each time a boot device device is found.
	It is passed a bit mask created by ORing any of the following flags
	that apply to the device found:
		BOOTDEV_CONSOLE_MASK
		BOOTDEV_NETDEV_MASK
	There is no need to call this function for a given device if it is
	known that it cannot be used as a boot device. If it is not
	possible to determine whether a device is usable as a boot device,
	or what the specific type of boot device it may be, the argument
	BOOTDEV_ANY_MASK can be passed.  This should be used only when
	necessary as it reduces the level of concurrency that can be
	achieved from boot time initialization.

bus_bootdev_initialized(int bootdev_mask)
	This function must be called by the bus support code after it calls the
	initialiation function for a boot device. Every call to
	bus_bootdev_found must be matched by a call to
	bus_bootdev_initialized with the same bootdev_mask.

	Device initialization functions must have called the appropriate
	registration function for that device before bus_bootdev_initialized
	is called. So, for console devices, register_console must be called
	before bus_bootdev_initialized, and for network devices,
	register_netdevice must be called first.

It is possible for bus code to avoid the need to call bus_bootdev_found
for each device if it calls it once at the beginning of device discovery and
once at the end with a mask for all of the possible types of boot devices
that could be on that bus. This approach should be avoid if at all possible
because it reduces the available boot-time concurency, which can lead
to increased boot times.

When it is time to use a given boot device type, the following function
should be used:

bus_wait_for_bootdev(enum bootdev_type type, bool (*done)(void))
	The type is one of:
		BOOTDEV_CONSOLE
		BOOTDEV_NETDEV
	The done function checks to see whether all of the boot devices
	required have been registered. If it determines that this is the
	case, it can return true. This will cause the wait to be terminated
	even though some boot devices of the given type have not yet been
	initialized, which can decrease the time to boot. If this is not
	possible, it can return false. In that case, bus_wait_for_bootdev
	won't return until all devices of the given type on all buses have
	been initialized. Not surprisingly, this limit the opportunities to
	reduce boot time.
