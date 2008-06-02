Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYFBVKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYFBVKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 17:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751593AbYFBVJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 17:09:50 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56486 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751467AbYFBVJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 17:09:48 -0400
Date: Mon, 2 Jun 2008 17:09:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
cc: netdev@vger.kernel.org, <linux-kernel@vger.kernel.org>,
       Ayaz Abdulla <aabdulla@nvidia.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       David Brownell <david-b@pacbell.net>, <linux-acpi@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/4] Fix forcedeth hibernate/wake-on-lan
 problems
In-Reply-To: <20080601074935.GA2529@yamamaya.is-a-geek.org>
Message-ID: <Pine.LNX.4.44L0.0806021706130.17236-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jun 2008, Tobias Diedrich wrote:

> > > (BTW I first thought the 'immediate reboot because of usb wake' effect is
> > > caused by the optical mouse generating a wake event, but it rather
> > > seems to be a problem with a flaky secondary usb host controller,
> > > which sees a connected device where nothing is attached)
> > 
> > Can you provide debugging information (i.e., CONFIG_USB_DEBUG) with the 
> > details on this bogus wakeup?
> 
> Sure.
> Here is the complete log of one boot and two s2disk_platform cycles
> captured using the serial console (in the first s2disk I forgot to
> remove the 'turn off /sys/bus/usb/device/usb?/power/wakeup' part).
> 
> Interestingly even with power/wakeup disabled for usb1 and usb2,
> which I assume to be the usb root ports, I could wake up the system
> by pressing a key on my keyboard (which didn't work before turning
> on CONFIG_USB_SUSPEND).
> 
> On the second suspend the system rebooted immediately as expected
> (I power/wakeup for usb1 and usb2 back on and disabled the part in
> the script).
> 
> I think this might be some general usb hw flakiness, since it seems
> to detect (and has so for a long time) a non-existing device:
> 
> lsusb output:
> Bus 002 Device 003: ID 045e:00db Microsoft Corp. Natural Ergonomic Keyboard 4000 V1.0
> Bus 002 Device 002: ID 045e:0040 Microsoft Corp. Wheel Mouse Optical
> Bus 002 Device 001: ID 1d6b:0001  
> Bus 001 Device 001: ID 1d6b:0002  
> 
> bogus device?:
> [14316046.469949] usb 2-4: new full speed USB device using ohci_hcd and address 12
> [14316046.679951] usb 2-4: device descriptor read/64, error -62
> [14316046.986619] usb 2-4: device descriptor read/64, error -62
> [14316047.263284] usb 2-4: new full speed USB device using ohci_hcd and address 13
> [14316047.476614] usb 2-4: device descriptor read/64, error -62
> [14316047.786618] usb 2-4: device descriptor read/64, error -62
> [14316048.063282] usb 2-4: new full speed USB device using ohci_hcd and address 14
> [14316048.499945] usb 2-4: device not accepting address 14, error -62
> [14316048.669950] usb 2-4: new full speed USB device using ohci_hcd and address 15
> [14316049.106612] usb 2-4: device not accepting address 15, error -62
> [14316049.112960] hub 2-0:1.0: unable to enumerate USB device on port 4

It's possible.  Maybe there's a builtin broken USB device, or maybe the 
D+ pin on port 4 is wired to a positive voltage source.

The log didn't reveal anything.  Perhaps you can learn more by looking 
at the "registers" file for that OHCI controller in debugfs.

Also, you should run "lspci -vv" as root to see what wakeup signals the 
USB controllers are issuing.

Alan Stern

