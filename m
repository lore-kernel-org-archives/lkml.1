Return-Path: <linux-kernel-owner+w=401wt.eu-S1755338AbZEUNhs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbZEUNhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:37:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZEUNhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:37:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:19556 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbZEUNhh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:37:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,227,1241420400"; 
   d="scan'208";a="414540194"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Eric W. Biederman'" <ebiederm@xmission.com>
CC: "'Ingo Molnar'" <mingo@elte.hu>, "'Yinghai Lu'" <yinghai@kernel.org>,
       "'Joerg Roedel'" <joerg.roedel@amd.com>,
       "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>
Date: Thu, 21 May 2009 21:37:33 +0800
Subject: RE: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
Thread-Topic: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
Thread-Index: AcnZ+4rMUQ7yVMUaSJ2VbO2SxyObUAAGl5qw
Message-ID: <715D42877B251141A38726ABF5CABF2C0545690269@pdsmsx503.ccr.corp.intel.com>
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
	<1242757912-6041-3-git-send-email-weidong.han@intel.com>
	<20090519115055.GB14305@elte.hu> <m1k54cj3iz.fsf@fess.ebiederm.org>
	<20090520082114.GC6736@elte.hu>
	<715D42877B251141A38726ABF5CABF2C0545690223@pdsmsx503.ccr.corp.intel.com>
 <m1octmvkkk.fsf@fess.ebiederm.org>
In-Reply-To: <m1octmvkkk.fsf@fess.ebiederm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> "Han, Weidong" <weidong.han@intel.com> writes:
> 
>> Ingo Molnar wrote:
>>> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>>> 
>>>> Not finding an upstream pcie_bridge and then concluding we are a
>>>> pcie device seems bogus. 
>>>> 
>> 
>> If device is pcie, pci_find_upstream_pcie_bridge() will return
>> NULL. For root complex integrated device, it won't find upstream
>> bridge, and also return NULL. What's more, pcie device and root
>> complex integrated device will be handled as the same way to set
>> sid, so I mix them here. But it also returns NULL for busted
>> hardware. I think no parent bus can be considered Root Complex
>> integrated device, right? If so, I think can handle it as follows:
> 
> I have problems with pci_find_upstream_pcie_bridge.  The
> name is actively misleading about what that function does.
> Returning a pci_to_pci bridge is strongly counter intuitive
> give that name.
> 
> Can we change it to pci_find_upstream_pcie_to_pci_bridge.
> Returning NULL in all cases when there is not an upstream
> pcie_to_pci bridge.

pci_find_upstream_pcie_bridge returns upstream pcie-to-pci/pcix bridge or legacy pci bridge for a pci device. pci_find_upstream_bridge may be more suitable.

> 
> For the set_sid case that is ideal.  For the other cases in
> intel-iommu.c it may be a problem.  Is it even possible to have a
> genuine pci device not behind a pcie to pci bridge on an intel
> chipset with this iommu?
> 

I think it's little possible. But coincide to VT-d spec, we need to handle differently for devices behind pcie-to-pci/pcix bridge and behind legacy pci bridge.

> 
>> 	...
>> 	if (dev->is_pcie || !dev->bus->parent) {
>> 		set_irte_sid(...);
>> 		return 0;
>> 	}
>> 
>> 	bridge = pci_find_upstream_pcie_bridge(dev);
>> 	if (bridge) {
>> 		if (bridge->is_pcie) /* PCIE-to-PCI/PCIx bridge */
>> 		set_irte_sid(...); else /* legacy PCI bridge */
>> 			set_irte_sid(..);
>> 	}
>> 
>> 	return 0;
>> 
>>>> Why if we do have an upstream pcie bridge do we only want to do a
>>>> bus range verification instead of checking just for the bus
>>>>> devfn?
>>>> 
>>>> The legacy PCI case seems even stranger.
>> 
>> Why? If a PCI device isn't connected to a PCIe bridge, it should be
>> a legacy bridge. 
> 
> I am not deep in the IOV specification at the moment.  I am mostly
> wondering why we pick the parts we pick to verify.  I recall
> bus and devfn being on the pcie packets so that makes sense.
> 
> Why would we ever want to do something different?  Does a pcie to pci
> bridge do something different in it's translation?

source-id is different between devices pcie-to-pci/pcix bridge and behind legacy pci bridge. Thus VT-d needs to handle it differently.

The pcie-to-pci/pcix bridges may generate a different requester-id and tag combination in some instances for transactions forwarded to the bridge's PCI Express interface. The action of replacing the original transaction's requester-id with one assigned by the bridge is generally referred to as taking 'ownership' of the transaction. If the bridge generates a new requester-id for a transaction forwarded from the secondary interface to the primary interface, the bridge assigns the PCI Express requester-id using the secondary interface's bus number, and sets both the device number and function number fields to zero. Refer to the PCI Express-to-PCI/PCI-X bridge specifications for more details.

For devices behind conventional PCI bridges, the source-id in the DMA requests is the requester-id of the bridge device.

Regards,
Weidong


