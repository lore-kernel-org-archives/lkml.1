Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZKRKlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZKRKlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 05:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbZKRKlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 05:41:21 -0500
Received: from cantor.suse.de ([195.135.220.2]:51052 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159AbZKRKlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 05:41:20 -0500
Date: Wed, 18 Nov 2009 11:41:25 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Russ Dill <russ.dill@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Use of usb_find_interface in open is racy
In-Reply-To: <f9d2a5e10911171306r416eaf2k45c3256370e82eda@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.0911181141030.31913@twin.jikos.cz>
References: <f9d2a5e10911171306r416eaf2k45c3256370e82eda@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ linux-usb should be CCed here at least ]

On Tue, 17 Nov 2009, Russ Dill wrote:

> Many usb drivers that create character devices use "struct
> usb_class_driver", a set of fops, and a usb_find_interface in their
> open call. A prime example is drivers/usb/usb-skeleton.c. A race
> occurs when userspace receives a hotplug event for the addition for
> the interface and then opens the associated device file before the
> device is added to the driver's klist_devices.
> 
> The usb core senses a new usb device (usb_new_device) and calls
> device_add. This eventually gets down to really_probe and the
> usb-skeleton probe function, skel_probe. skel_probe calls
> usb_register_dev() which registers the associated character device for
> skel_class. The hotplug events for the class device get emitted.
> 
> User space receives the hotplug event for the class device, makes the
> device node and notifies another program that opens the device node.
> The program opens the device node which calls into usb_open and then
> skel_open. skel_open calls usb_find_interface. usb_find_interfaces
> searches the klist_devices of skel_driver, finds no device associated
> with the minor number and returns NULL. skel_open returns -ENODEV.
> 
> Control returns to really_probe and really_probe calls driver_bound
> which adds the device to the list of devices associated with
> skel_driver (klist_devices).
> 
> I'm not sure what the right way to solve this is. A call to
> wait_for_device_probe() in the skel_open call before calling
> usb_find_interface fixes the problem, but it is a rather large hammer.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

