Return-Path: <linux-kernel-owner+w=401wt.eu-S1753525AbZFMEvK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525AbZFMEvK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 00:51:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZFMEu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 00:50:57 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:61937 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750742AbZFMEu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 00:50:56 -0400
X-IronPort-AV: E=Sophos;i="4.42,213,1243814400"; 
   d="scan'208";a="322874109"
From: Roland Dreier <rdreier@cisco.com>
To: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Cc: ossrosch@linux.vnet.ibm.com, alexs@linux.vnet.ibm.com,
       ewg@lists.openfabrics.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, raisch@de.ibm.com
Subject: Re: [PATCH 2.6.31] ehca: Tolerate dynamic memory operations and huge pages
References: <200906091559.24661.hannes.hering@linux.vnet.ibm.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 12 Jun 2009 21:50:58 -0700
In-Reply-To: <200906091559.24661.hannes.hering@linux.vnet.ibm.com> (Hannes
	Hering's message of "Tue, 9 Jun 2009 15:59:24 +0200")
Message-ID: <adar5xoybwt.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 13 Jun 2009 04:50:58.0552 (UTC) FILETIME=[8B181F80:01C9EBE2]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, one major issue with this patch and a few minor nits.

First, the major issue is that I don't see anything in the patch that
changes the code in ehca_mem_notifier() in ehca_main.c:

	case MEM_GOING_ONLINE:
	case MEM_GOING_OFFLINE:
		/* only ok if no hca is attached to the lpar */
		spin_lock_irqsave(&shca_list_lock, flags);
		if (list_empty(&shca_list)) {
			spin_unlock_irqrestore(&shca_list_lock, flags);
			return NOTIFY_OK;
		} else {
			spin_unlock_irqrestore(&shca_list_lock, flags);
			if (printk_timed_ratelimit(&ehca_dmem_warn_time,
						   30 * 1000))
				ehca_gen_err("DMEM operations are not allowed"
					     "in conjunction with eHCA");
			return NOTIFY_BAD;
		}

But your patch description says:

 > This patch implements toleration of dynamic memory operations....

But it seems you're still going to hit the same NOTIFY_BAD case above
after your patch.  So something doesn't compute for me.  Could you
explain more?

Second, a nit:

 > +#define EHCA_REG_MR 0
 > +#define EHCA_REG_BUSMAP_MR (~0)

and you pass these as the reg_busmap parm in:

 >  int ehca_reg_mr(struct ehca_shca *shca,
 >  		struct ehca_mr *e_mr,
 >  		u64 *iova_start,
 > @@ -991,7 +1031,8 @@
 >  		struct ehca_pd *e_pd,
 >  		struct ehca_mr_pginfo *pginfo,
 >  		u32 *lkey, /*OUT*/
 > -		u32 *rkey) /*OUT*/
 > +		u32 *rkey, /*OUT*/
 > +		int reg_busmap)

and test it as:

 > +	if (reg_busmap)
 > +		ret = ehca_reg_bmap_mr_rpages(shca, e_mr, pginfo);
 > +	else
 > +		ret = ehca_reg_mr_rpages(shca, e_mr, pginfo);

So the ~0 for true looks a bit odd.  One option would be to make
reg_busmap a bool, since that's how you're using it, but then you lose
the nice self-documenting macro where you call things.

So I think it would be cleaner to do something like

enum ehca_reg_type {
	EHCA_REG_MR,
	EHCA_REG_BUSMAP_MR
};

and make the "int reg_busmap" parameter into "enum ehca_reg_type reg_type"
and have the code become

+	if (reg_type == EHCA_REG_BUSMAP_MR)
+		ret = ehca_reg_bmap_mr_rpages(shca, e_mr, pginfo);
+	else if (reg_type == EHCA_REG_MR)
+		ret = ehca_reg_mr_rpages(shca, e_mr, pginfo);
+	else
+		ret = -EINVAL

or something like that.

 > +struct ib_dma_mapping_ops ehca_dma_mapping_ops = {
 > +	.mapping_error = ehca_dma_mapping_error,
 > +	.map_single = ehca_dma_map_single,
 > +	.unmap_single = ehca_dma_unmap_single,
 > +	.map_page = ehca_dma_map_page,
 > +	.unmap_page = ehca_dma_unmap_page,
 > +	.map_sg = ehca_dma_map_sg,
 > +	.unmap_sg = ehca_dma_unmap_sg,
 > +	.dma_address = ehca_dma_address,
 > +	.dma_len = ehca_dma_len,
 > +	.sync_single_for_cpu = ehca_dma_sync_single_for_cpu,
 > +	.sync_single_for_device = ehca_dma_sync_single_for_device,
 > +	.alloc_coherent = ehca_dma_alloc_coherent,
 > +	.free_coherent = ehca_dma_free_coherent,
 > +};

I always think structures like this are easier to read if you align the
'=' signs.  But no big deal.

 > +	ret = ehca_create_busmap();
 > +	if (ret) {
 > +		ehca_gen_err("Cannot create busmap.");
 > +		goto module_init2;
 > +	}
 > +
 >  	ret = ibmebus_register_driver(&ehca_driver);
 >  	if (ret) {
 >  		ehca_gen_err("Cannot register eHCA device driver");
 >  		ret = -EINVAL;
 > -		goto module_init2;
 > +		goto module_init3;
 >  	}
 >  
 >  	ret = register_memory_notifier(&ehca_mem_nb);
 >  	if (ret) {
 >  		ehca_gen_err("Failed registering memory add/remove notifier");
 > -		goto module_init3;
 > +		goto module_init4;

Having to renumber unrelated things is when something changes is why I
don't like this style of error path labels.  But I think it's well and
truly too late to fix that in ehca.

 - R.
