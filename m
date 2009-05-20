Return-Path: <linux-kernel-owner+w=401wt.eu-S1756523AbZETIjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbZETIjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 04:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754615AbZETIjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 04:39:37 -0400
Received: from mga01.intel.com ([192.55.52.88]:12260 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbZETIjg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 04:39:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,220,1241420400"; 
   d="scan'208";a="692011468"
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
Date: Wed, 20 May 2009 16:38:53 +0800
Subject: RE: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
Thread-Topic: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
Thread-Index: AcnZI/9uDaeSaPbVSNe7EYityV5klwAAU3Vw
Message-ID: <715D42877B251141A38726ABF5CABF2C054568FF38@pdsmsx503.ccr.corp.intel.com>
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
>> Ingo Molnar <mingo@elte.hu> writes:
>> 
>>> * Weidong Han <weidong.han@intel.com> wrote:
>>> 
>>>> To support domain-isolation usages, the platform hardware must be
>>>> capable of uniquely identifying the requestor (source-id) for each
>>>> interrupt message. Without source-id checking for interrupt
>>>> remapping , a rouge guest/VM with assigned devices can launch
>>>> interrupt attacks to bring down anothe guest/VM or the VMM itself.
>>>> 
>>>> This patch adds source-id checking for interrupt remapping, and
>>>> then really isolates interrupts for guests/VMs with assigned
>>>> devices.
>>>> 
>>>> Because PCI subsystem is not initialized yet when set up IOAPIC
>>>> entries, use read_pci_config_byte to access PCI config space
>>>> directly.
>>>> 
>>>> Signed-off-by: Weidong Han <weidong.han@intel.com>
>>>> ---
>>>>  arch/x86/kernel/apic/io_apic.c |    6 +++
>>>>  drivers/pci/intr_remapping.c   |   90
>>>>  ++++++++++++++++++++++++++++++++++++++-
>>>>  drivers/pci/intr_remapping.h   |    2 + include/linux/dmar.h     
>>>>  |   11 +++++ 4 files changed, 106 insertions(+), 3 deletions(-)
>>> 
>>> Code structure looks nice now. (and i susect you have tested this on
>>> real and relevant hardware?) I've Cc:-ed Eric too ... does this
>>> direction look good to you too Eric?
>> 
>> Being a major nitpick, I have to point out that the code is not
>> structured to support other iommus, and I think AMD has one that
>> can do this as well.
> 
> (Joerg Cc:-ed)

The patch just changes code in interrupt remapping of Intel IOMMU. How does AMD IOMMU remap interrupts in ioapic code? I didn't find relative code. If AMD IOMMU already enabled the same code, it can wrap the same code in IOMMU API. 

> 
>> The early pci reading of the bus is just wrong.  What happens if
>> the pci layer decided to renumber things?  It looks like we have a
>> real dependency on pci there and are avoiding sorting it out with
>> this.
> 
> Yes ... but is there much we can do about this bootstrap dependency?
> We want to enable the IO-APIC very early in its final form. There's
> quite a bit of IRQ functionality that doesnt go via the PCI layer,
> and which is being relied on by early bootup. The timer irq must
> work, etc.

Currently VT-d code didn't support pci rebalance. There is much work to do. It needs to track devcie identity changes and resultant imapct to Device Scope under each VT-d engine.

> 
>> Hmm.  But that is what we use in setup_ioapic_sid.... I expect the
>> right solution is to delay enabling ioapic entries until driver
>> enable them.  That could also reduce screaming irqs during bootup
>> in the kdump case.
> 
> Yes, and note that we are moving in that direction in tip:irq/numa
> (Yinghai Cc:-ed) - we are delaying IRQ setup to the very last
> moment. We recently got rid of 32-bit IRQ compression in that branch
> as well and the IRQ vectoring code is now unified between 64-bit and
> 32-bit so it's nify and you might want to check it and look for
> holes ...
> 
> ( The motivation there was different: delay allocation of the
>   irq_desc so that we can make it NUMA-local - but it has the same
>   general effect. )
> 
>> set_msi_sid looks wrong.  The comment are unhelpful. irte->svt
>> should get an enum value or a deine (removing the repeated
>> explanations of the magic value) and then we could have room to
>> explain why we are doing what we are doing.
> 
> (yes, it probably wants a helper method - i pointed these smaller
> details out in my review.)

will update as Ingo suggested.

Regards,
Weidong

> 
>> Not finding an upstream pcie_bridge and then concluding we are a
>> pcie device seems bogus. 
>> 
>> Why if we do have an upstream pcie bridge do we only want to do a
>> bus range verification instead of checking just for the bus
>>> devfn?
>> 
>> The legacy PCI case seems even stranger.
> 
> Good points. Would be nice to get an ack from the PCI folks to make
> sure these bits are sane.
> 
>> ....
>> 
>> The table of apic information by apic_id also seems wrong.  Don't
>> we have chip_data or something that should point it that we can
>> get from the irq?
> 
> ->chip_data is already used for io-apic configuration bits - if it's
> reused then the right way to do it is to extend struct irq_cfg in
> arch/x86/kernel/apic/io_apic.c.
> 
> 	Ingo

