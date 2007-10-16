Return-Path: <linux-kernel-owner+w=401wt.eu-S934323AbXJPO4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934323AbXJPO4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 10:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934285AbXJPOz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 10:55:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46744 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934042AbXJPOz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 10:55:56 -0400
Date: Tue, 16 Oct 2007 10:55:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>
cc: bbpetkov@yahoo.de, Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename 'bInterfaceNumber'
In-Reply-To: <a8e1da0710152222t44de6c8at75d3dd874faf58be@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0710161046330.4418-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Dave Young wrote:

> > I finally duplicated this on one of my machines here at boot time, with
> > USB built into the kernel.  I'll work tomorrow on tracking this down
> > further...
> Hi,
> I add some printk messages, dump_stack and some others, here is the
> dmesg dump with debug info(lines begin with "hidave"):

Okay, good, the extra printk messages show exactly where the problem 
lies.

In usb_set_configuration(), each new interfaces is registered and then
usb_create_sysfs_intf_files() gets called for that interface.  This
makes sense, because obviously we can't create sysfs files for an
interface before it is registered.

The problem is that during registration drivers get probed, and drivers 
sometimes call usb_set_interface() from their probe method.  This 
routine also calls usb_create_sysfs_intf_files(), and the result is 
that the sysfs files get created twice:

	First by usb_set_interface, from the driver probe;

	Then by usb_set_configuration, when registration is
	finished.

I can think of two possible ways around the problem.  One is to add a 
bit to the usb_interface structure, recording whether the sysfs files 
have been created.  The other is always to remove the files just before 
trying to create them.

The first seems more workable, although it is slightly awkward.  Greg, 
what do you think?

Alan Stern

