Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZD3Xgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZD3Xgl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 19:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751443AbZD3Xgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 19:36:32 -0400
Received: from xenotime.net ([72.52.64.118]:56278 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751061AbZD3Xgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 19:36:32 -0400
Message-ID: <49FA3650.8030307@xenotime.net>
Date: Thu, 30 Apr 2009 16:37:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Fenghua Yu <fenghua.yu@intel.com>, dwmw2@infradead.org, mingo@elte.hu,
       torvalds@linux-foundation.org, weidong.han@intel.com,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] Intel IOMMU Pass Through Support
References: <20090327212241.234500000@intel.com>	<20090327212321.070229000@intel.com>	<20090416001957.GA1527@linux-os.sc.intel.com> <20090430162905.d232be29.akpm@linux-foundation.org>
In-Reply-To: <20090430162905.d232be29.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 15 Apr 2009 17:19:57 -0700
> Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
>> The patch adds kernel parameter intel_iommu=pt to set up pass through mode in
>> context mapping entry. This disables DMAR in linux kernel; but KVM still runs on
>> VT-d and interrupt remapping still works.
>>
>> In this mode, kernel uses swiotlb for DMA API functions but other VT-d
>> functionalities are enabled for KVM. KVM always uses multi level translation
>> page table in VT-d. By default, pass though mode is disabled in kernel.
>>
>> This is useful when people don't want to enable VT-d DMAR in kernel but still
>> want to use KVM and interrupt remapping for reasons like DMAR performance
>> concern or debug purpose.
>>
> 
> The patch is now in linux-next and broke my build.
> 
> arch/x86/built-in.o: In function `iommu_setup':
> arch/x86/kernel/pci-dma.c:215: undefined reference to `iommu_pass_through'
> arch/x86/built-in.o: In function `pci_swiotlb_init':
> arch/x86/kernel/pci-swiotlb.c:74: undefined reference to `iommu_pass_through'
> 
> Because iommu_pass_through is defined in drivers/pci/intel-iommu.c and
> 
> # CONFIG_DMAR is not set
> 
> I'll need to cook up some local hack to work around that.
> 

Patch just went to linux-next mailing list (but should have also
gone to lkml):

http://marc.info/?l=linux-next&m=124113213400748&w=2


> 
> Also, the patch in linux-next (but not the one which I'm replying to
> here does:
> 
> : --- a/arch/x86/kernel/pci-dma.c
> : +++ b/arch/x86/kernel/pci-dma.c
> : @@ -160,6 +160,8 @@ again:
> :         return page_address(page);
> :  }
> :  
> : +extern int iommu_pass_through;
> : +
> 
> Which is wrong and unnecessary - the variable was already declared in a
> header file.
> 
> scripts/checkpatch.pl would have warned you about this error, but
> apparently neither you nor the people who reviewed or merged the patch
> bother to use it.

