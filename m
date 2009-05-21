Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbZEUKEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbZEUKEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 06:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbZEUKEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 06:04:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54915 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277AbZEUKET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 06:04:19 -0400
To: "Han\, Weidong" <weidong.han@intel.com>
Cc: "'Ingo Molnar'" <mingo@elte.hu>, "'Yinghai Lu'" <yinghai@kernel.org>,
       "'Joerg Roedel'" <joerg.roedel@amd.com>,
       "'dwmw2\@infradead.org'" <dwmw2@infradead.org>,
       "Siddha\, Suresh B" <suresh.b.siddha@intel.com>,
       "'linux-kernel\@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "'iommu\@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'kvm\@vger.kernel.org'" <kvm@vger.kernel.org>
References: <1242757912-6041-1-git-send-email-weidong.han@intel.com>
	<1242757912-6041-3-git-send-email-weidong.han@intel.com>
	<20090519115055.GB14305@elte.hu> <m1k54cj3iz.fsf@fess.ebiederm.org>
	<20090520082114.GC6736@elte.hu>
	<715D42877B251141A38726ABF5CABF2C0545690223@pdsmsx503.ccr.corp.intel.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 21 May 2009 03:04:11 -0700
In-Reply-To: <715D42877B251141A38726ABF5CABF2C0545690223@pdsmsx503.ccr.corp.intel.com> (Weidong Han's message of "Thu\, 21 May 2009 17\:00\:34 +0800")
Message-ID: <m1octmvkkk.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: weidong.han@intel.com, kvm@vger.kernel.org, iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, dwmw2@infradead.org, joerg.roedel@amd.com, yinghai@kernel.org, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Han\, Weidong" <weidong.han@intel.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4997]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH v2 2/2] Intel-IOMMU, intr-remap: source-id checking
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Han, Weidong" <weidong.han@intel.com> writes:

> Ingo Molnar wrote:
>> * Eric W. Biederman <ebiederm@xmission.com> wrote:
>> 
>>> Not finding an upstream pcie_bridge and then concluding we are a
>>> pcie device seems bogus. 
>>> 
>
> If device is pcie, pci_find_upstream_pcie_bridge() will return
> NULL. For root complex integrated device, it won't find upstream
> bridge, and also return NULL. What's more, pcie device and root
> complex integrated device will be handled as the same way to set
> sid, so I mix them here. But it also returns NULL for busted
> hardware. I think no parent bus can be considered Root Complex
> integrated device, right? If so, I think can handle it as follows:

I have problems with pci_find_upstream_pcie_bridge.  The
name is actively misleading about what that function does.
Returning a pci_to_pci bridge is strongly counter intuitive
give that name.

Can we change it to pci_find_upstream_pcie_to_pci_bridge.
Returning NULL in all cases when there is not an upstream
pcie_to_pci bridge.

For the set_sid case that is ideal.  For the other cases in
intel-iommu.c it may be a problem.  Is it even possible to have a
genuine pci device not behind a pcie to pci bridge on an intel
chipset with this iommu?


> 	...
> 	if (dev->is_pcie || !dev->bus->parent) {
> 		set_irte_sid(...);
> 		return 0;
> 	}
>
> 	bridge = pci_find_upstream_pcie_bridge(dev);
> 	if (bridge) {
> 		if (bridge->is_pcie) /* PCIE-to-PCI/PCIx bridge */
> 			set_irte_sid(...);
> 		else /* legacy PCI bridge */
> 			set_irte_sid(..);
> 	}
>
> 	return 0;
>
>>> Why if we do have an upstream pcie bridge do we only want to do a
>>> bus range verification instead of checking just for the bus
>>>> devfn?
>>> 
>>> The legacy PCI case seems even stranger.
>
> Why? If a PCI device isn't connected to a PCIe bridge, it should be a legacy bridge.

I am not deep in the IOV specification at the moment.  I am mostly
wondering why we pick the parts we pick to verify.  I recall
bus and devfn being on the pcie packets so that makes sense.

Why would we ever want to do something different?  Does a pcie to pci
bridge do something different in it's translation?

Eric
