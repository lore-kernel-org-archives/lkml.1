Return-Path: <linux-kernel-owner+w=401wt.eu-S933138AbXBRJ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138AbXBRJ1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 04:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933149AbXBRJ1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 04:27:37 -0500
Received: from mail.gmx.net ([213.165.64.20]:50724 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933138AbXBRJ1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 04:27:36 -0500
X-Provags-ID: V01U2FsdGVkX19SnBgDHWBSbBKdTzUAsikCP8X/VM6/SMEYZrw0du
	bxxQ==
Subject: Re: 2.6.20.git regression: 'PCI: add the sysfs driver name to all
	modules' causes hard hang on boot
From: Mike Galbraith <efault@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1171785752.6787.17.camel@Homer.simpson.net>
References: <1171619710.6828.24.camel@Homer.simpson.net>
	 <20070216223609.GA6165@kroah.com>
	 <1171676288.6448.9.camel@Homer.simpson.net>
	 <20070217015048.GB18591@kroah.com>
	 <1171700401.6443.16.camel@Homer.simpson.net>
	 <1171785752.6787.17.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sun, 18 Feb 2007 10:27:27 +0100
Message-Id: <1171790847.6844.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-18 at 09:02 +0100, Mike Galbraith wrote:

> The reason it's hanging is that nobody releases the driver, so we wait
> forever in driver_unregister().  With the below, box boots fine...
> 
> --- drivers/base/bus.c.org	2007-02-18 08:38:57.000000000 +0100
> +++ drivers/base/bus.c	2007-02-18 08:39:09.000000000 +0100
> @@ -593,6 +593,7 @@ void bus_remove_driver(struct device_dri
>  	driver_detach(drv);
>  	module_remove_driver(drv);
>  	kobject_unregister(&drv->kobj);
> +	driver_release(&drv->kobj);
>  	put_bus(drv->bus);
>  }
>  
> 
> ...but that can't be right given that the darn thing booted just fine
> prior to the naming patch with an equally unhappy init_ipmi_si().  Hmm.

Ok.  The path it's supposed to take to driver_release() goes like so....

[   17.495312] bus platform: add driver ipmi
[   17.506560] ipmi message handler version 39.1
[   17.518099] ipmi device interface
[   17.528491] device class 'ipmi': registering
[   17.539854] bus platform: add driver ipmi_si
[   17.551210] IPMI System Interface driver.
[   17.562242] bus pci: add driver ipmi_si
[   17.583686] bus pci: remove driver ipmi_si
[   17.594721] BUG: at drivers/base/bus.c:65 driver_release()
[   17.607224]  [<c0105136>] show_trace_log_lvl+0x1a/0x30
[   17.619434]  [<c0105862>] show_trace+0x12/0x14
[   17.630822]  [<c0105906>] dump_stack+0x16/0x18
[   17.642098]  [<c034b632>] driver_release+0x37/0x39
[   17.653703]  [<c02c73b9>] kobject_cleanup+0x43/0x64
[   17.665359]  [<c02c73e5>] kobject_release+0xb/0xd
[   17.676748]  [<c02c8017>] kref_put+0x28/0x8c
[   17.687626]  [<c02c7374>] kobject_put+0x14/0x16
[   17.698712]  [<c02c74c4>] kobject_unregister+0x22/0x25
[   17.710359]  [<c034b7e0>] bus_remove_driver+0x95/0xa5
[   17.721911]  [<c034c87b>] driver_unregister+0xe/0x47
[   17.733317]  [<c02d59ac>] pci_unregister_driver+0x13/0x73
[   17.745149]  [<c033e141>] init_ipmi_si+0x798/0x7ba
[   17.756339]  [<c065b58c>] init+0x114/0x23c
[   17.766748]  [<c0104dab>] kernel_thread_helper+0x7/0x1c

...so I guess it's a ref counting problem somewhere.

	-Mike

