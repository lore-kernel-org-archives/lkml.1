Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbYGJV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbYGJV5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753384AbYGJV5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 17:57:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYGJV5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 17:57:09 -0400
Date: Thu, 10 Jul 2008 17:56:08 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [SUGGESTION]: drop virtual merge accounting in I/O requests
Message-ID: <Pine.LNX.4.64.0807101702090.19775@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm getting crashes with InitIO A100u2w controller on Sparc64 (I had to 
fix the endianity issues in the driver, but that's unrelated).

When I examined the crashes, it turned out that SCSI layer passed requests 
with too many segments. The controller has at most 32 SG entries per 
request. It sets shost->sg_tablesize to 32, but despite this, larger 
requests were submitted to it --- this resulted in overwriting random 
memory and crashes.

A typical scenario, in the beginning of inia100_queue, looked like this:
A number of segments returned by scsi_sg_count(cmd) == 33
cmd->request->nr_hw_segments == 32
cmd->request->nr_phys_segments == 37
cmd->sdb.table.nents == 33
cmd->sdb.table.orig_nents == 37

The SCSI layer submitted a request with 33 scatter-gather segments.

When I was searching for a reson for this, I found that virtual merging 
thing. The idea behind virtual merging is this: on architectures with 
IOMMU, the kernel can program IOMMU in such a way that several 
discontinuous pages in memory appear as continuous space for the PCI 
device. Thus, entries in device's SG table are saved. The virtual merging 
alone is good and harmless idea --- it just improves performance a bit by 
reducing the number of regions visible to the device.

But now, look at the block layer:

The block layer, when merging requests, must make sure that it won't 
overflow the device's SG table. So it accounts the number of physical 
segments and it tries to account the number of segments after virtual 
merging by the IOMMU is performed (see function blk_recalc_rq_segments and 
similar). The block layer calls BIOVEC_VIRT_MERGEABLE and 
BIOVEC_VIRT_OVERSIZE (these macros use architecture-specific constants 
BIO_VMERGE_BOUNDARY and BIO_VMERGE_MAX_SIZE) to check if two segments can 
be merged by the IOMMU and sets rq->nr_hw_segments appropriatelly.

What was causing the bug in my case - IO layer expected that two segments 
could be virtually merged and so merged the I/O requests. However, the 
IOMMU function dma_4u_map_sg didn't merge these segments (the specific 
check that was failing was "outs->dma_length + s->length > max_seg_size" 
--- but any of the three checks in that function could trigger that bug). 
So it produced one more SG entry than the IO layer accounted and crashed 
the SCSI host driver.

--

When I thought about it more, I realized that this accounting of virtual 
segments in I/O layer can't work correctly at all. If an architecture 
defines symbols BIOVEC_VIRT_MERGEABLE and BIOVEC_VIRT_OVERSIZE, it 
declares that it's IOMMU must merge any two regions satisfying these 
conditions. But in an IOMMU, it is impossible to guarantee, because:

* the bus address is allocated basiclly randomly, so we can hit 
dev->dma_parms->segment_boundary_mask any time. This will prevent virtual 
merging from happenning. I/O layer doesn't know the bus address at the 
time it merges requests, so it can't predict when this happens.

* the IOMMU isn't guaranteed to find a continuous space in it's bus 
address space. If it skips over already mapped regions, it can't perform 
virtual merging.

* when creating the mapping, we can hit per-device limit 
"dev->dma_parms->max_segment_size" --- but the I/O layer checks only 
against global limit BIOVEC_VIRT_OVERSIZE. (this last issue is fixable, 
the previous two are not).

Basically, the IOMMU treats virtual merging as an option that it can do to 
increase performance, but doesn't have to do it in some boundary 
conditions. And the I/O layer treats virtual merging as a mandatory 
feature and expects that any two regions satisfying the alignment and size 
can be virtually merged.


I would suggest to drop the virtual segment accounting from the I/O layer 
at all. (I am not suggesting to drop the virtual merging itself). For SCSI 
drivers with large SGLIST, dropping the virtual segment accounting will 
make no difference (the merge will happen anyway, just the I/O layer won't 
know about it in advance). For SCSI drivers with small SGLIST, like 
A100u2w, dropping virtual merge accounting may slightly decrease 
performance (the I/O layer won't use maximum request size considering 
virtual merging) --- but it will make these drivers work. They don't work 
now, because these off-by-one overshoots in number of segments are 
inevitable.

Mikulas
