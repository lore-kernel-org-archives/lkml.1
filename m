Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZLATQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZLATQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 14:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZLATQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 14:16:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:47249 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZLATQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 14:16:25 -0500
Message-ID: <4B156B54.9080603@kernel.org>
Date: Tue, 01 Dec 2009 11:15:32 -0800
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
References: <20091130212228.7555.43533.stgit@debian.lart> <4B14B928.2000108@kernel.org> <4B14BFDD.3020802@kernel.org> <200912010838.56945.bjorn.helgaas@hp.com> <4B15604D.2090202@kernel.org>
In-Reply-To: <4B15604D.2090202@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Bjorn Helgaas wrote:
>> On Tuesday 01 December 2009 12:03:57 am Yinghai Lu wrote:
>>> Alex found one system that one pci bridge pref mmio 64 is not set correctly.
>>> aka, the upper32 base/limit is not cleaned.
>>> he found that bridge is supporting 64 bit pref mmio, but device under that
>>> does not support that. so that IORESOURCE_MEM_64 get cleared in pbus_size_mem()
>> I think it's wrong that pbus_size_mem() fiddles with IORESOURCE_MEM_64
>> in bus resources based on where BARs of devices on that bus live.  That
>> feels fragile.
> 
> yes. need more clean up.

other than we should store PCI_PREF_RANGE_TYPE_64, and use it in pci_setup_bridge

others should be ok.


for pcie hot plug, the bridge IORESOURCE_MEM_64 could be set, and MMIO > 4g, and later when plug one device doesn't
support 64bit mmio pref, and 

pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
                resource_size_t size, resource_size_t align,
                resource_size_t min, unsigned int type_mask,
                void (*alignf)(void *, struct resource *, resource_size_t,
                                resource_size_t),
                void *alignf_data)
{       
        int i, ret = -ENOMEM;        
        resource_size_t max = -1;    

        type_mask |= IORESOURCE_IO | IORESOURCE_MEM;
                
        /* don't allocate too high if the pref mem doesn't support 64bit*/
        if (!(res->flags & IORESOURCE_MEM_64))
                max = PCIBIOS_MAX_MEM_32;

will make sure that allocation will fail.

so it will get range freom mmio non pref range. or fail there again.

then we will release the bridge pref mmio...

YH
