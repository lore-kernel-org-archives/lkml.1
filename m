Return-Path: <linux-kernel-owner+w=401wt.eu-S940282AbXHIPIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940282AbXHIPIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 11:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935348AbXHIPII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 11:08:08 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57960 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S936647AbXHIPIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 11:08:06 -0400
Date: Thu, 9 Aug 2007 11:08:03 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jonathan Corbet <corbet@lwn.net>, <Ingo@sc8-sf-spam2-b.sourceforge.net>,
       <linux-usb-devel@lists.sourceforge.net>,
       Roman Zippel <zippel@linux-m68k.org>, <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Molnar <mingo@elte.hu>
Subject: Re: [linux-usb-devel] [PATCH] msleep() with hrtimers
In-Reply-To: <20070809001640.ec2f3bfb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0708091105150.3559-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Andrew Morton wrote:

> This failed the Vaio test.  I guess it triggered a USB bug.
> 
> With this patch applied, when I hotplug my wireless mouse, the little LED
> on the mouse comes on for a second or so then goes out and no pointy clicky
> for me.
> 
> It says:
> 
> [  152.481522] usb 1-1: new low speed USB device using uhci_hcd and address 2
> 
> 
> Without this patch applied, I get
> 
> [  195.935445] usb 2-1: new low speed USB device using uhci_hcd and address 2
> [  196.116183] usb 2-1: configuration #1 chosen from 1 choice
> [  196.198362] input: Microsoft Microsoft Wireless Optical Mouse 1.00 as /class/input/input7
> [  196.223724] input: USB HID v1.11 Mouse [Microsoft Microsoft Wireless Optical Mouse 1.00] on usb-0000:00:1d.1-1
> [  196.224570] usb 2-1: new device found, idVendor=045e, idProduct=00e1
> [  196.224579] usb 2-1: new device strings: Mfr=1, Product=2, SerialNumber=0
> [  196.224585] usb 2-1: Product: Microsoft Wireless Optical Mouse 1.00
> [  196.224590] usb 2-1: Manufacturer: Microsoft
> 
> and lots of pointy clickiness.
> 
> I would assume that there is some msleep() in USB which is too short, and
> the present wild rounding-up which msleep() does covered up the
> incorrectly-chosen sleep duration.
> 
> I'm using HZ=250 (http://userweb.kernel.org/~akpm/config-sony.txt) and it
> could well be that the mouse would fail just by going to HZ=1000, but I
> didn't bother testing that.
> 
> Could one of the USB developers please suggest which msleep()(s) I should
> start looking at?

It could be one of the calls in drivers/usb/core/hub.c, however almost 
all of them are at least 10 ms already.  There's a 0-ms msleep near the 
start of hub_port_wait_reset() which might cause problems.

It will be easier to pin down the culprit if you turn on 
CONFIG_USB_DEBUG.

Alan Stern

