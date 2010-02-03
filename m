Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab0BCUbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 15:31:55 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45985 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932347Ab0BCUbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 15:31:51 -0500
Date: Wed, 3 Feb 2010 15:31:49 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Corey Wright <undefined@pobox.com>
cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: regression in 2.6.27.45 with usb and suspend-to-disk
In-Reply-To: <20100203134755.a56e2314.undefined@pobox.com>
Message-ID: <Pine.LNX.4.44L0.1002031521160.1321-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Feb 2010, Corey Wright wrote:

> the device is a usb SD reader w/ SD card in it.
> 
> # cat /sys/bus/usb/devices/1-8/product
> USB 2.0  SD MMC READER 
> 
> i removed the media reader after the failed suspend (it is only used at
> boot-up to hold the LUKS key material to decrypt the filesystem) but the
> message is the same:
> 
> [ 4002.585329] ehci_hcd 0000:00:10.4: suspend root hub
> [ 4002.585334] ehci_hcd 0000:00:10.4: suspend failed because port 8 is
> resuming
> [ 4002.585338] usb usb1: bus suspend fail, err -16
> 
> and /sys/bus/usb/devices/1-8 no longer exists (little
> alone /sys/bus/usb/devices/1-8/power/wakeup):
> 
> # ls -1 /sys/bus/usb/devices/
> 1-0:1.0
> 1-7
> 1-7:1.0
> 2-0:1.0
> 2-1
> 2-1:1.0
> 3-0:1.0
> 4-0:1.0
> 5-0:1.0
> usb1
> usb2
> usb3
> usb4
> usb5
> 
> > And what happens if you do:
> > 
> > 	echo disabled >/sys/bus/usb/devices/1-8/power/wakeup
> > 
> > before trying to hibernate?
> 
> it's the same immediately after a reboot (and before suspending), a
> successful suspend, or a failed suspend:
> 
> # echo disabled >/sys/bus/usb/devices/1-8/power/wakeup 
> bash: echo: write error: Invalid argument
> 
> and as previously said, that sysfs entry does not exist if the media reader
> is removed, though the error appears to continue to refer to that
> port/device.

Okay, thanks for testing.  That narrows it down, and I believe the 
patch below will fix the bug.  Let me know how it works.

Alan Stern


Index: 2.6.27.45/drivers/usb/host/ehci-hub.c
===================================================================
--- 2.6.27.45.orig/drivers/usb/host/ehci-hub.c
+++ 2.6.27.45/drivers/usb/host/ehci-hub.c
@@ -255,7 +255,6 @@ static int ehci_bus_resume (struct usb_h
 		temp &= ~(PORT_RWC_BITS | PORT_WAKE_BITS);
 		if (test_bit(i, &ehci->bus_suspended) &&
 				(temp & PORT_SUSPEND)) {
-			ehci->reset_done [i] = jiffies + msecs_to_jiffies (20);
 			temp |= PORT_RESUME;
 		}
 		ehci_writel(ehci, temp, &ehci->regs->port_status [i]);

