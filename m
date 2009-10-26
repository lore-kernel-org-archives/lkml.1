Return-Path: <linux-kernel-owner+w=401wt.eu-S1754332AbZJZSwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332AbZJZSwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 14:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754067AbZJZSwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 14:52:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:41336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbZJZSwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 14:52:35 -0400
Message-ID: <4AE5EFDB.2060908@kernel.org>
Date: Mon, 26 Oct 2009 11:52:11 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Alex Chiang <achiang@hp.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [PATCH] pci: pciehp update the slot bridge res to get big range
 for pcie devices
References: <4ADEB601.8020200@kernel.org> <4AE52B68.3070501@jp.fujitsu.com> <4AE53883.3070709@kernel.org> <4AE5545E.1020900@jp.fujitsu.com> <4AE55D12.30403@kernel.org> <4AE57976.4060107@jp.fujitsu.com> <4AE5E37F.8070707@kernel.org>
In-Reply-To: <4AE5E37F.8070707@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> Kenji Kaneshige wrote:
>> I understand you need to touch I/O base/limit and Mem base/limit. But
>> I don't understand why you also need to update bridge's BARs. Could
>> you please explain a little more about it?
>>
>> Just in case, my terminology "bridge's BARs" is Base Address Register
>> 0 (offset 0x10) and Base Address Register 1 (offset 0x14) in the
>> (type 1) configuration space header of the bridge.
> 
> i mean 0x1c, 0x20, 0x28
> 
> did not notice that bridge device's 0x10, 0x14 are used...
> if port service need to use 0x10, 0x14, and the device is enabled, we should touch 0x10, and 0x14.

after check the code, if 

pci_bridge_assign_resources ==> pdev_assign_resources_sorted ==>  pdev_sort_resources

will not touch 0x10 and 0x14, if those resource is claimed by port service.

/* Sort resources by alignment */
void pdev_sort_resources(struct pci_dev *dev, struct resource_list *head)
{       
        int i;
                
        for (i = 0; i < PCI_NUM_RESOURCES; i++) {
                struct resource *r;
                struct resource_list *list, *tmp;
                resource_size_t r_align;
                
                r = &dev->resource[i];
                        
                if (r->flags & IORESOURCE_PCI_FIXED)
                        continue;
        
                if (!(r->flags) || r->parent)
                        continue;
                

r->parent != NULL, will make it skip those two.

So -v3 should be safe.

Thanks

Yinghai Lu


