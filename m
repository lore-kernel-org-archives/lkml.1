Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbZECCOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbZECCOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 22:14:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbZECCO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 22:14:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:43240 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZECCO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 22:14:29 -0400
Date: Sat, 2 May 2009 22:08:41 -0400
From: Rik van Riel <riel@surriel.com>
To: Izik Eidus <ieidus@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, chrisw@redhat.com, alan@lxorguk.ukuu.org.uk,
       device@lanana.org, linux-mm@kvack.org, hugh@veritas.com,
       nickpiggin@yahoo.com.au, Izik Eidus <ieidus@redhat.com>
Subject: Re: [PATCH 1/6] ksm: limiting the num of mem regions user can
 register per fd.
Message-ID: <20090502220841.376eb730@riellaptop.surriel.com>
In-Reply-To: <1241302572-4366-2-git-send-email-ieidus@redhat.com>
References: <1241302572-4366-1-git-send-email-ieidus@redhat.com>
	<1241302572-4366-2-git-send-email-ieidus@redhat.com>
Organization: surriel
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  3 May 2009 01:16:07 +0300
Izik Eidus <ieidus@redhat.com> wrote:

> Right now user can open /dev/ksm fd and register unlimited number of
> regions, such behavior may allocate unlimited amount of kernel memory
> and get the whole host into out of memory situation.
> 
> Signed-off-by: Izik Eidus <ieidus@redhat.com>
> ---
>  mm/ksm.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 6165276..d58db6b 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -48,6 +48,9 @@ static int rmap_hash_size;
>  module_param(rmap_hash_size, int, 0);
>  MODULE_PARM_DESC(rmap_hash_size, "Hash table size for the reverse
> mapping"); 
> +static int regions_per_fd;
> +module_param(regions_per_fd, int, 0);
> +
>  /*
>   * ksm_mem_slot - hold information for an userspace scanning range
>   * (the scanning for this region will be from addr untill addr +
> @@ -67,6 +70,7 @@ struct ksm_mem_slot {
>   */
>  struct ksm_sma {
>  	struct list_head sma_slots;
> +	int nregions;
>  };
>  
>  /**
> @@ -453,6 +457,11 @@ static int
> ksm_sma_ioctl_register_memory_region(struct ksm_sma *ksm_sma, struct
> ksm_mem_slot *slot; int ret = -EPERM;
>  
> +	if ((ksm_sma->nregions + 1) > regions_per_fd) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
>  	slot = kzalloc(sizeof(struct ksm_mem_slot), GFP_KERNEL);
>  	if (!slot) {
>  		ret = -ENOMEM;
> @@ -473,6 +482,7 @@ static int
> ksm_sma_ioctl_register_memory_region(struct ksm_sma *ksm_sma, 
>  	list_add_tail(&slot->link, &slots);
>  	list_add_tail(&slot->sma_link, &ksm_sma->sma_slots);
> +	ksm_sma->nregions++;
>  
>  	up_write(&slots_lock);
>  	return 0;
> @@ -511,6 +521,7 @@ static int
> ksm_sma_ioctl_remove_memory_region(struct ksm_sma *ksm_sma)
> mmput(slot->mm); list_del(&slot->sma_link);
>  		kfree(slot);
> +		ksm_sma->nregions--;
>  	}
>  	up_write(&slots_lock);
>  	return 0;
> @@ -1389,6 +1400,7 @@ static int
> ksm_dev_ioctl_create_shared_memory_area(void) }
>  
>  	INIT_LIST_HEAD(&ksm_sma->sma_slots);
> +	ksm_sma->nregions = 0;
>  
>  	fd = anon_inode_getfd("ksm-sma", &ksm_sma_fops, ksm_sma, 0);
>  	if (fd < 0)
> @@ -1631,6 +1643,9 @@ static int __init ksm_init(void)
>  	if (r)
>  		goto out_free1;
>  
> +	if (!regions_per_fd)
> +		regions_per_fd = 1024;
> +
>  	ksm_thread = kthread_run(ksm_scan_thread, NULL, "kksmd");
>  	if (IS_ERR(ksm_thread)) {
>  		printk(KERN_ERR "ksm: creating kthread failed\n");


-- 
All rights reversed.
