Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYHHPVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYHHPVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 11:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752601AbYHHPVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 11:21:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120AbYHHPVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 11:21:46 -0400
Message-ID: <489C63D1.1000407@redhat.com>
Date: Fri, 08 Aug 2008 11:18:41 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joro@8bytes.org,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       jakub@redhat.com
Subject: Re: [PATCH]: PCI: GART iommu alignment fixes [v2]
References: <200807281523.35469.jbarnes@virtuousgeek.org> <20080806223550K.tomof@acm.org> <4899B611.4070408@redhat.com> <200808071003.47326.jbarnes@virtuousgeek.org> <489B33D4.1080107@redhat.com> <20080808071244.GB6931@il.ibm.com>
In-Reply-To: <20080808071244.GB6931@il.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Muli Ben-Yehuda wrote:
> On Thu, Aug 07, 2008 at 01:41:40PM -0400, Prarit Bhargava wrote:
>
>   
>> As for Calgary, I'm looking into it ATM.  I think I can get my hands
>> on one.
>>     
>
> Feel free to ping me if Calgary testing is needed.
>   

Muli -- I just ran tests on an IBM system with a Calgary iommu that Ed 
Pollard pointed me at.

dma_ops_alloc_addresses() does not have the option to return 
size-aligned values.  This means that 
pci_alloc_consistent()/dma_alloc_coherent() will return unaligned values 
to callers when the lower 4G of memory not available.

Additionally, a quick test shows that in dma_ops_alloc_addresses()

        boundary_size = ALIGN(dma_get_seg_boundary(dev) + 1,
                        PAGE_SIZE) >> PAGE_SHIFT;

may return 0 in the same manner I've been pointing out -- if 
dma_get_seg_boundary(dev) returns 0xffffffff and 1 is added to that 
result, boundary_size = 0.  Then you BUG() in the iommu-helper code.

Jesse pointed out to me that my fix on that line is incorrect.  _If_ 
this is not a compiler issue (I've emailed jakub privately and cc'd him 
on this email) then a better fix would be to do (sorry for the 
cut-and-paste):

--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -78,7 +78,7 @@ static inline unsigned int dma_set_max_seg_size(struct 
device
 static inline unsigned long dma_get_seg_boundary(struct device *dev)
 {
        return dev->dma_parms ?
-               dev->dma_parms->segment_boundary_mask : 0xffffffff;
+               dev->dma_parms->segment_boundary_mask : 0xffffffffUL;
 }
 
However, I'm still waiting for clarification from jakub before 
submitting again with that chunk.

P.


> Cheers,
> Muli
>   
