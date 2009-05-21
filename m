Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZEUJBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZEUJBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbZEUJBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:01:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:7821 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750794AbZEUJBJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:01:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,226,1241420400"; 
   d="scan'208";a="414479308"
From: "Han, Weidong" <weidong.han@intel.com>
To: "'Ingo Molnar'" <mingo@elte.hu>,
       "'Eric W. Biederman'" <ebiederm@xmission.com>,
       "'Yinghai Lu'" <yinghai@kernel.org>,
       "'Joerg Roedel'" <joerg.roedel@amd.com>
CC: "'dwmw2@infradead.org'" <dwmw2@infradead.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'kvm@vger.kernel.org'" <kvm@vger.kernel.org>
Date: Thu, 21 May 2009 17:00:34 +0800
Subject: RE: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
Thread-Topic: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
Thread-Index: AcnZI/9uDaeSaPbVSNe7EYityV5klwAyKv1w
Message-ID: <715D42877B251141A38726ABF5CABF2C0545690223@pdsmsx503.ccr.corp.intel.com>
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
 <1242757912-6041-3-git-send-email-weidong.han@intel.com>
 <20090519115055.GB14305@elte.hu> <m1k54cj3iz.fsf@fess.ebiederm.org>
 <20090520082114.GC6736@elte.hu>
In-Reply-To: <20090520082114.GC6736@elte.hu>
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

Ingo Molnar wrote:
> * Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
>> Not finding an upstream pcie_bridge and then concluding we are a
>> pcie device seems bogus. 
>> 

If device is pcie, pci_find_upstream_pcie_bridge() will return NULL. For root complex integrated device, it won't find upstream bridge, and also return NULL. What's more, pcie device and root complex integrated device will be handled as the same way to set sid, so I mix them here. But it also returns NULL for busted hardware. I think no parent bus can be considered Root Complex integrated device, right? If so, I think can handle it as follows:

	...
	if (dev->is_pcie || !dev->bus->parent) {
		set_irte_sid(...);
		return 0;
	}

	bridge = pci_find_upstream_pcie_bridge(dev);
	if (bridge) {
		if (bridge->is_pcie) /* PCIE-to-PCI/PCIx bridge */
			set_irte_sid(...);
		else /* legacy PCI bridge */
			set_irte_sid(..);
	}

	return 0;

>> Why if we do have an upstream pcie bridge do we only want to do a
>> bus range verification instead of checking just for the bus
>>> devfn?
>> 
>> The legacy PCI case seems even stranger.

Why? If a PCI device isn't connected to a PCIe bridge, it should be a legacy bridge.

Regards,
Weidong

> 
> Good points. Would be nice to get an ack from the PCI folks to make
> sure these bits are sane.
> 

