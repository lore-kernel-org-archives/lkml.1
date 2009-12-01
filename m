Return-Path: <linux-kernel-owner+w=401wt.eu-S1753728AbZLAS32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728AbZLAS32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 13:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZLAS31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 13:29:27 -0500
Received: from hera.kernel.org ([140.211.167.34]:39813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbZLAS31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 13:29:27 -0500
Message-ID: <4B15604D.2090202@kernel.org>
Date: Tue, 01 Dec 2009 10:28:29 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Williamson <alex.williamson@hp.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Grant Grundler <grundler@parisc-linux.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Alex Chiang <achiang@hp.com>
Subject: Re: [PATCH] pci: fix bridge 64bit flag setting
References: <20091130212228.7555.43533.stgit@debian.lart> <4B14B928.2000108@kernel.org> <4B14BFDD.3020802@kernel.org> <200912010838.56945.bjorn.helgaas@hp.com>
In-Reply-To: <200912010838.56945.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Tuesday 01 December 2009 12:03:57 am Yinghai Lu wrote:
>> Alex found one system that one pci bridge pref mmio 64 is not set correctly.
>> aka, the upper32 base/limit is not cleaned.
>> he found that bridge is supporting 64 bit pref mmio, but device under that
>> does not support that. so that IORESOURCE_MEM_64 get cleared in pbus_size_mem()
> 
> I think it's wrong that pbus_size_mem() fiddles with IORESOURCE_MEM_64
> in bus resources based on where BARs of devices on that bus live.  That
> feels fragile.

yes. need more clean up.

> 
> The question of whether the bridge supports 64-bit apertures is
> strictly a hardware property of the bridge.  It has nothing to do
> with where we place downstream devices.
> 
> Is there really a problem with writing to PCI_PREF_BASE_UPPER32
> unconditionally?  As Alex pointed out, per 3.2.5.10 of the bridge
> spec, the UPPER32 registers are read-only if only 32-bit apertures
> are supported.  If you mentioned a problem with doing this
> unconditionally, I missed it.

remember that some x2apic registers say they are reserved, and read them could cause GP error.

and for pci devices, if it is read-only, for good design, then write it should be ok.
but if there is some design problem in devices, and they could say those are read-only.
why kernel write value to it?

> 
> The only place we test IORESOURCE_MEM_64 for a bus resource is when
> we're programming PCI_PREF_BASE_UPPER32.  If we think it's important
> to program it conditionally, why don't we skip IORESOURCE_MEM_64

IORESOURCE_MEM_64 is used to control if we can use MMIO > 4g.

> altogether, and just look at the bits in PCI_PREF_MEMORY_BASE directly?
> E.g., something like this:
> 
> 	pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &l);
> 	if ((l & PCI_PREF_RANGE_TYPE_MASK) == PCI_PREF_RANGE_TYPE_64) {
> 		pci_write_config_dword(bridge, PCI_PREF_BASE_UPPER32, bu);
> 		pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, lu);
> 	}
> 
> Then we don't have to maintain flags at all, and it's easy to verify
> that the code corresponds to the spec.

that will have several extra read, and also we already store that bit in pci_read_bridge_bases()

but forget to set that in pci_check_bus_range()

YH

YH

