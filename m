Return-Path: <linux-kernel-owner+w=401wt.eu-S1756374AbZFPHI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374AbZFPHI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZFPHIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:08:18 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:60020 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZFPHIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:08:18 -0400
Date: Tue, 16 Jun 2009 09:08:09 +0200
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Hannes Hering <hannes.hering@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, ewg@lists.openfabrics.org,
       linuxppc-dev@ozlabs.org, raisch@de.ibm.com, ossrosch@linux.vnet.ibm.com,
       Hoang-Nam Nguyen <HNGUYEN@linux.vnet.ibm.com>
Subject: Re: [PATCH 2.6.31] ehca: Tolerate dynamic memory operations and
 huge pages
Message-ID: <20090616090809.34d162fc@BL3D1974.boeblingen.de.ibm.com>
In-Reply-To: <adar5xoybwt.fsf@cisco.com>
References: <200906091559.24661.hannes.hering@linux.vnet.ibm.com>
 <adar5xoybwt.fsf@cisco.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,

thank you for taking a look at the code!

On Fri, 12 Jun 2009 21:50:58 -0700
Roland Dreier <rdreier@cisco.com> wrote:

> OK, one major issue with this patch and a few minor nits.
> 
> First, the major issue is that I don't see anything in the patch that
> changes the code in ehca_mem_notifier() in ehca_main.c:
> 
> 	case MEM_GOING_ONLINE:
> 	case MEM_GOING_OFFLINE:
> 		/* only ok if no hca is attached to the lpar */
> 		spin_lock_irqsave(&shca_list_lock, flags);
> 		if (list_empty(&shca_list)) {
> 			spin_unlock_irqrestore(&shca_list_lock, flags);
> 			return NOTIFY_OK;
> 		} else {
> 			spin_unlock_irqrestore(&shca_list_lock, flags);
> 			if (printk_timed_ratelimit(&ehca_dmem_warn_time,
> 						   30 * 1000))
> 				ehca_gen_err("DMEM operations are not allowed"
> 					     "in conjunction with eHCA");
> 			return NOTIFY_BAD;
> 		}
> 
> But your patch description says:
> 
>  > This patch implements toleration of dynamic memory operations....
> 
> But it seems you're still going to hit the same NOTIFY_BAD case above
> after your patch.  So something doesn't compute for me.  Could you
> explain more?

Yeah, the notifier code remains untouched as we still do not allow dynamic
memory operations _while_ our module is loaded. The patch allows the driver to
cope with DMEM operations that happened before the module was loaded, which
might result in a non-contiguous memory layout. When the driver registers
its global memory region in the system, the memory layout must be considered.

We chose the term "toleration" instead of "support" to illustrate this.

I'll put some more details into the changelog, incorporate the other comments
and send out a second version of the patch.

Thanks,
Alex

> 
> Second, a nit:
> 
>  > +#define EHCA_REG_MR 0
>  > +#define EHCA_REG_BUSMAP_MR (~0)
> 
> and you pass these as the reg_busmap parm in:
> 
>  >  int ehca_reg_mr(struct ehca_shca *shca,
>  >  		struct ehca_mr *e_mr,
>  >  		u64 *iova_start,
>  > @@ -991,7 +1031,8 @@
>  >  		struct ehca_pd *e_pd,
>  >  		struct ehca_mr_pginfo *pginfo,
>  >  		u32 *lkey, /*OUT*/
>  > -		u32 *rkey) /*OUT*/
>  > +		u32 *rkey, /*OUT*/
>  > +		int reg_busmap)
> 
> and test it as:
> 
>  > +	if (reg_busmap)
>  > +		ret = ehca_reg_bmap_mr_rpages(shca, e_mr, pginfo);
>  > +	else
>  > +		ret = ehca_reg_mr_rpages(shca, e_mr, pginfo);
> 
> So the ~0 for true looks a bit odd.  One option would be to make
> reg_busmap a bool, since that's how you're using it, but then you lose
> the nice self-documenting macro where you call things.
> 
> So I think it would be cleaner to do something like
> 
> enum ehca_reg_type {
> 	EHCA_REG_MR,
> 	EHCA_REG_BUSMAP_MR
> };
> 
> and make the "int reg_busmap" parameter into "enum ehca_reg_type reg_type"
> and have the code become
> 
> +	if (reg_type == EHCA_REG_BUSMAP_MR)
> +		ret = ehca_reg_bmap_mr_rpages(shca, e_mr, pginfo);
> +	else if (reg_type == EHCA_REG_MR)
> +		ret = ehca_reg_mr_rpages(shca, e_mr, pginfo);
> +	else
> +		ret = -EINVAL
> 
> or something like that.
> 
>  > +struct ib_dma_mapping_ops ehca_dma_mapping_ops = {
>  > +	.mapping_error = ehca_dma_mapping_error,
>  > +	.map_single = ehca_dma_map_single,
>  > +	.unmap_single = ehca_dma_unmap_single,
>  > +	.map_page = ehca_dma_map_page,
>  > +	.unmap_page = ehca_dma_unmap_page,
>  > +	.map_sg = ehca_dma_map_sg,
>  > +	.unmap_sg = ehca_dma_unmap_sg,
>  > +	.dma_address = ehca_dma_address,
>  > +	.dma_len = ehca_dma_len,
>  > +	.sync_single_for_cpu = ehca_dma_sync_single_for_cpu,
>  > +	.sync_single_for_device = ehca_dma_sync_single_for_device,
>  > +	.alloc_coherent = ehca_dma_alloc_coherent,
>  > +	.free_coherent = ehca_dma_free_coherent,
>  > +};
> 
> I always think structures like this are easier to read if you align the
> '=' signs.  But no big deal.
> 
>  > +	ret = ehca_create_busmap();
>  > +	if (ret) {
>  > +		ehca_gen_err("Cannot create busmap.");
>  > +		goto module_init2;
>  > +	}
>  > +
>  >  	ret = ibmebus_register_driver(&ehca_driver);
>  >  	if (ret) {
>  >  		ehca_gen_err("Cannot register eHCA device driver");
>  >  		ret = -EINVAL;
>  > -		goto module_init2;
>  > +		goto module_init3;
>  >  	}
>  >  
>  >  	ret = register_memory_notifier(&ehca_mem_nb);
>  >  	if (ret) {
>  >  		ehca_gen_err("Failed registering memory add/remove notifier");
>  > -		goto module_init3;
>  > +		goto module_init4;
> 
> Having to renumber unrelated things is when something changes is why I
> don't like this style of error path labels.  But I think it's well and
> truly too late to fix that in ehca.

