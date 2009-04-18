Return-Path: <linux-kernel-owner+w=401wt.eu-S1759186AbZDRTWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759186AbZDRTWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 15:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753892AbZDRTVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 15:21:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:58155 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbZDRTVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 15:21:54 -0400
Message-ID: <49EA27B9.3030004@kernel.org>
Date: Sat, 18 Apr 2009 12:19:21 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] pci: keep pci device resource name pointer right.
References: <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org> <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com> <49E96731.1000501@kernel.org> <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 17 Apr 2009, Yinghai Lu wrote:
>> it turns that we need to reget res->name because dev->dev.kobj name is changed
>> after device_add.
> 
> Can we not make the rule be that the name should just be set before?
> 
> IOW, there is something else broken, I think. Rather than put this ugly 
> band-aid, why now make sure that whoever had that broken name fixes it?
> 

driver core guys are enforcing to use dev_name(device) instead of referring it.

for pci code:

via acpi_pci_root_driver.ops.add (aka acpi_pci_root_add) ==> pci_acpi_scan_root is used to scan pci bus/device, and at the same we read the resource for pci_dev  at this point still need to use bus->devices to go over all pci_devices if needed.
in the pci_read_bases, we have res->name = pci_name(pci_dev); pci_name is calling dev_name.

later via acpi_pci_root_driver.ops.start (aka acpi_pci_root_start) ==> pci_bus_add_device to add all pci_dev in kobj tree.

pci_bus_add_device will call device_add. 

actually in device_add

        /* first, register with generic layer. */
        error = kobject_add(&dev->kobj, dev->kobj.parent, "%s", dev_name(dev));
        if (error)
                goto Error;

will get one new name for that kobj, old name is freed.

Will try to make kobject_add more smart to reuse the old one.

YH
