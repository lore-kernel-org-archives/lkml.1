Return-Path: <linux-kernel-owner+w=401wt.eu-S934372AbXGWXN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934372AbXGWXN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 19:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbXGWXN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 19:13:27 -0400
Received: from mx1.suse.de ([195.135.220.2]:40391 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432AbXGWXNY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 19:13:24 -0400
Date: Mon, 23 Jul 2007 15:57:25 -0700
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oneukum@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Kevin Lloyd <linux@sierrawireless.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.22+: BUG: sleeping function called from
	invalid context at
	/home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/urb.c:524,
	in_atomic():1, irqs_disabled():0
Message-ID: <20070723225725.GA25741@suse.de>
References: <46A50CB5.5020006@goop.org> <Pine.LNX.4.44L0.0707231649200.2702-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0707231649200.2702-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 23, 2007 at 04:50:50PM -0400, Alan Stern wrote:
> On Mon, 23 Jul 2007, Jeremy Fitzhardinge wrote:
> 
> > I get this when suspending.  The kernel is 2.6.22+recent git (just before -rc1).
> > 
> > usb 2-1: USB disconnect, address 3
> > BUG: sleeping function called from invalid context at /home/jeremy/hg/xen/paravirt/linux/drivers/usb/core/urb.c:524
> > in_atomic():1, irqs_disabled():0
> > 1 lock held by khubd/207:
> >  #0:  (&table_lock){--..}, at: [<f89fba38>] usb_serial_put+0x13/0x2c [usbserial]
> >  [<c0109162>] show_trace_log_lvl+0x1a/0x2f
> >  [<c0109bf8>] show_trace+0x12/0x14
> >  [<c0109c10>] dump_stack+0x16/0x18
> >  [<c01247b7>] __might_sleep+0xea/0xf1
> >  [<c02cd7a2>] usb_kill_urb+0x1a/0xc7
> >  [<f89e7203>] sierra_shutdown+0x5d/0x9c [sierra]
> >  [<f89fbb5a>] destroy_serial+0x45/0x10a [usbserial]
> >  [<c0219a2f>] kref_put+0x63/0x71
> >  [<f89fba44>] usb_serial_put+0x1f/0x2c [usbserial]
> >  [<f89fbf00>] usb_serial_disconnect+0x79/0xa6 [usbserial]
> >  [<c02d06df>] usb_unbind_interface+0x47/0x98
> >  [<c02925f2>] __device_release_driver+0x74/0x90
> >  [<c02929e0>] device_release_driver+0x30/0x47
> >  [<c0291f81>] bus_remove_device+0x73/0x82
> >  [<c0290650>] device_del+0x208/0x27e
> >  [<c02cdf2a>] usb_disable_device+0x5f/0xbc
> >  [<c02ca497>] usb_disconnect+0x95/0x12f
> >  [<c02caba8>] hub_thread+0x377/0xa57
> >  [<c013cb7f>] kthread+0x3b/0x64
> >  [<c0108d27>] kernel_thread_helper+0x7/0x10
> >  =======================
> > sierra3 ttyUSB0: Sierra USB modem (3 port) converter now disconnected from ttyUSB0
> > sierra3 ttyUSB1: Sierra USB modem (3 port) converter now disconnected from ttyUSB1
> > sierra3 ttyUSB2: Sierra USB modem (3 port) converter now disconnected from ttyUSB2
> > sierra 2-1:1.0: device disconnected
> 
> Clearly there's a bug in 
> drivers/usb/serial/usb-serial.c:usb_serial_put().  It shouldn't call 
> kref_put() while holding a spinlock.

Oliver, didn't you make this change to the usb_serial_put() function?

Do we need to audit the shutdown() callbacks in the serial drivers so
that they can not sleep?  Or just change the spinlock to a mutex?

thanks,

greg k-h
