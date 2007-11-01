Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbXKAUJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbXKAUJB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 16:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXKAUIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 16:08:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50949 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753418AbXKAUIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 16:08:53 -0400
Date: Thu, 1 Nov 2007 16:08:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Steven King <sfking@fdwdc.com>
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
       <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] ti_usb_3410_5052 breakage in 2.6.24-rc1
In-Reply-To: <200711011031.04620.sfking@fdwdc.com>
Message-ID: <Pine.LNX.4.44L0.0711011547080.6180-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2007, Steven King wrote:

> > The real question is why 2.6.24-rc1 doesn't like the second
> > configuration descriptor.  To answer it, you should see what shows up
> > in the dmesg log when you first plug in the device on a kernel with
> > CONFIG_USB_DEBUG enabled.
> 
> ?!? As I wrote at the top of the message you quoted, I rebuilt with 
> CONFIG_USB_DEBUG enabled and loaded the modules with debug=1, thats how I was 
> able to see the 'wrong number of endpoints' message.

But you didn't post the log messages, so I haven't seen them.  
In addition, that "wrong number of endpoints" message occurs long after 
the underlying problem; it's probably not connected.

> Given that the dongle works correctly with a stock 2.6.24-rc1 with commit 
> 063a2da8f01806906f7d7b1a1424b9afddebc443 reversed,

Can you post the /proc/bus/usb/devices entry under that kernel?  Do
both configurations show up?

> I'm reasonably confident 
> that with that commit in place, the usb core is working correctly (or atleast 
> as expected) in initially parsing the device descriptor, then usb-serial 
> attempts to match the interface descriptor on the first configuration, and 
> using the new more strict matching code, fails when the device reports for 
> the only interface on the first configuration it has only a single bulk_out 
> endpoint while the ti_usb_3410_5052 driver is expecting an interrupt_in and a 
> bulk_in.  It never gets to the second configuration descriptor.

Why shouldn't the core ever get to parse the second configuration
descriptor?  Config descriptor parsing happens before driver matching
and binding.  It has to; otherwise the core wouldn't know which 
configuration to install by default.

In the "working" 2.6.23 kernel there were two configurations and Config
#2 was installed.  What happens if you install Config #1 under that
kernel (echo 1 >/sys/bus/usb/devices/.../bConfigurationValue)?

Presumably if Config #2 was present and installed in the "non-working"  
2.6.24-rc1 kernel, the driver would bind correctly.

> for me the only question is whether ti_usb_3410_5052 should 
> have .num_interrupt_in and .num_bulk_in set to NUM_DONT_CARE or set to 0.

Then you're concerned about the wrong question.  It's more important to 
find out why Config #2 disappeared under 2.6.24-rc1.  The commit you 
are focused on would not have caused it.

> Are there versions of the dongle that have different device descriptors?  
> Before I bricked (sticked?) my TI eZ430-rf2500 dongle, it reported a 
> different idProduct even though as far as I can tell they are almost the 
> exact same hardware, so that shouldnt be a problem...

I have no idea what versions of your dongle are available.  In fact, I 
never heard of it before reading your email messages.  However if you 
have had two different dongles that report different idProduct values, 
it's a safe bet that _something_ has changed between them.  The 
firmware, if nothing else.

Alan Stern

