Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbXHHOBq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbXHHOBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:01:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbXHHOBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:01:38 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:29007 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbXHHOBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:01:37 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] ehca: map 4k firmware context of cq, qp to user space
Date: Wed, 8 Aug 2007 16:13:39 +0200
User-Agent: KMail/1.8.2
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, stefan.roscher@de.ibm.com,
       paulus@samba.org, general@lists.openfabrics.org
References: <200708021139.31695.hnguyen@linux.vnet.ibm.com> <adawswd3ayo.fsf@cisco.com> <200708031036.20859.hnguyen@linux.vnet.ibm.com>
In-Reply-To: <200708031036.20859.hnguyen@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708081613.39837.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Roland!
Haven't got any ack for this updated patch yet. Anyway, since it contains
another bug as shown below, please ignore this patch. We'll send a patch 
set that includes the proper version of this patch later.

> @@ -109,7 +109,7 @@ static int ehca_mmap_fw(struct vm_area_struct *vma, struct h_galpas *galpas,
>  	u64 vsize, physical;
>  
>  	vsize = vma->vm_end - vma->vm_start;
> -	if (vsize != EHCA_PAGESIZE) {
> +	if (vsize >= EHCA_PAGESIZE) {
should be
> +	if (vsize < EHCA_PAGESIZE) {
which is sort of invalid arg.

Thanks
Nam



On Friday 03 August 2007 10:36, Hoang-Nam Nguyen wrote:
> From: Hoang-Nam Nguyen <hnguyen at de.ibm.com>
> Date: Fri, 3 Aug 2007 09:44:56 +0200
> Subject: [PATCH] ehca: map 4k firmware context of cq, qp to user space
> This patch utilizes remap_4k_pfn() as introduced by Paul M.,
> for details see http://patchwork.ozlabs.org/linuxppc/patch?id=10281,
> to map ehca cq, qp firmware context (4k) to user space if kernel page
> size is 64k. For reason, why this is required, see also Paul's patch.
> In addition to that the kernel page offset of firmware context needs
> to be set in cq and qp response block so that user space can assemble
> the proper virtual address to use.
> An appropriate patch for libehca will follow for ofed-1.3.
> 
> Signed-off-by: Hoang-Nam Nguyen <hnguyen@de.ibm.com>
> ---
>  drivers/infiniband/hw/ehca/ehca_classes.h |    4 +++-
>  drivers/infiniband/hw/ehca/ehca_cq.c      |    2 ++
>  drivers/infiniband/hw/ehca/ehca_qp.c      |    2 ++
>  drivers/infiniband/hw/ehca/ehca_uverbs.c  |    6 +++---
>  4 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/ehca/ehca_classes.h b/drivers/infiniband/hw/ehca/ehca_classes.h
> index b5e9603..206d4eb 100644
> --- a/drivers/infiniband/hw/ehca/ehca_classes.h
> +++ b/drivers/infiniband/hw/ehca/ehca_classes.h
> @@ -337,6 +337,8 @@ struct ehca_create_cq_resp {
>  	u32 cq_number;
>  	u32 token;
>  	struct ipzu_queue_resp ipz_queue;
> +	u32 fw_handle_ofs;
> +	u32 dummy;
>  };
>  
>  struct ehca_create_qp_resp {
> @@ -347,7 +349,7 @@ struct ehca_create_qp_resp {
>  	u32 qkey;
>  	/* qp_num assigned by ehca: sqp0/1 may have got different numbers */
>  	u32 real_qp_num;
> -	u32 dummy; /* padding for 8 byte alignment */
> +	u32 fw_handle_ofs;
>  	struct ipzu_queue_resp ipz_squeue;
>  	struct ipzu_queue_resp ipz_rqueue;
>  };
> diff --git a/drivers/infiniband/hw/ehca/ehca_cq.c b/drivers/infiniband/hw/ehca/ehca_cq.c
> index 81aff36..ed5d67f 100644
> --- a/drivers/infiniband/hw/ehca/ehca_cq.c
> +++ b/drivers/infiniband/hw/ehca/ehca_cq.c
> @@ -276,6 +276,8 @@ struct ib_cq *ehca_create_cq(struct ib_device *device, int cqe, int comp_vector,
>  		resp.ipz_queue.queue_length = ipz_queue->queue_length;
>  		resp.ipz_queue.pagesize = ipz_queue->pagesize;
>  		resp.ipz_queue.toggle_state = ipz_queue->toggle_state;
> +		resp.fw_handle_ofs = (u32)
> +			(my_cq->galpas.user.fw_handle & (PAGE_SIZE - 1));
>  		if (ib_copy_to_udata(udata, &resp, sizeof(resp))) {
>  			ehca_err(device, "Copy to udata failed.");
>  			goto create_cq_exit4;
> diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
> index b178cba..66f632c 100644
> --- a/drivers/infiniband/hw/ehca/ehca_qp.c
> +++ b/drivers/infiniband/hw/ehca/ehca_qp.c
> @@ -745,6 +745,8 @@ static struct ehca_qp *internal_create_qp(
>  			queue2resp(&resp.ipz_squeue, &my_qp->ipz_squeue);
>  		if (HAS_RQ(my_qp))
>  			queue2resp(&resp.ipz_rqueue, &my_qp->ipz_rqueue);
> +		resp.fw_handle_ofs = (u32)
> +			(my_qp->galpas.user.fw_handle & (PAGE_SIZE - 1));
>  
>  		if (ib_copy_to_udata(udata, &resp, sizeof resp)) {
>  			ehca_err(pd->device, "Copy to udata failed");
> diff --git a/drivers/infiniband/hw/ehca/ehca_uverbs.c b/drivers/infiniband/hw/ehca/ehca_uverbs.c
> index 4bc687f..be062f1 100644
> --- a/drivers/infiniband/hw/ehca/ehca_uverbs.c
> +++ b/drivers/infiniband/hw/ehca/ehca_uverbs.c
> @@ -109,7 +109,7 @@ static int ehca_mmap_fw(struct vm_area_struct *vma, struct h_galpas *galpas,
>  	u64 vsize, physical;
>  
>  	vsize = vma->vm_end - vma->vm_start;
> -	if (vsize != EHCA_PAGESIZE) {
> +	if (vsize >= EHCA_PAGESIZE) {
>  		ehca_gen_err("invalid vsize=%lx", vma->vm_end - vma->vm_start);
>  		return -EINVAL;
>  	}
> @@ -118,8 +118,8 @@ static int ehca_mmap_fw(struct vm_area_struct *vma, struct h_galpas *galpas,
>  	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>  	ehca_gen_dbg("vsize=%lx physical=%lx", vsize, physical);
>  	/* VM_IO | VM_RESERVED are set by remap_pfn_range() */
> -	ret = remap_pfn_range(vma, vma->vm_start, physical >> PAGE_SHIFT,
> -			      vsize, vma->vm_page_prot);
> +	ret = remap_4k_pfn(vma, vma->vm_start, physical >> EHCA_PAGESHIFT,
> +			   vma->vm_page_prot);
>  	if (unlikely(ret)) {
>  		ehca_gen_err("remap_pfn_range() failed ret=%x", ret);
>  		return -ENOMEM;

