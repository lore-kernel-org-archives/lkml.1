Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbXHQFGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbXHQFGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 01:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754931AbXHQFG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 01:06:26 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:16326 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbXHQFGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 01:06:24 -0400
X-IronPort-AV: i="4.19,273,1183359600"; 
   d="scan'208"; a="171378201:sNHT46585278"
To: akepner@sgi.com
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, jes@sgi.com
Subject: Re: [PATCH] sn-ia64: allow drivers to flush in-flight DMA
X-Message-Flag: Warning: May contain useful information
References: <20070816225603.GJ1813@sgi.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Thu, 16 Aug 2007 22:06:22 -0700
In-Reply-To: <20070816225603.GJ1813@sgi.com> (akepner@sgi.com's message of "Thu, 16 Aug 2007 15:56:03 -0700")
Message-ID: <adawsvuyckx.fsf@cisco.com>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Aug 2007 05:06:22.0850 (UTC) FILETIME=[5AE74E20:01C7E08C]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The overall approach looks fine to me, although I'm not the arbiter of
taste for the DMA API.

However, I think this wants to be split into at least three parts for
merging: adding the dmaflush flags stuff into the DMA API; adding the
dmaflush parameter to the ib_umem_get() API (and fixing every caller);
and using that API to fix mthca on SGI boxes.  (And also there should
probably be a 4th patch to fix the same issue with mlx4 at least, and
possibly further patches for other drivers such as the cxgb3 RDMA
driver, etc)

Also further comments below:

 >  struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 > -			    size_t size, int access)
 > +			    size_t size, int access, int dmaflush)

This change means every caller of ib_umem_get needs to be fixed up as
part of the patch.

 > @@ -1027,7 +1029,14 @@ static struct ib_mr *mthca_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 >  	if (!mr)
 >  		return ERR_PTR(-ENOMEM);
 >  
 > -	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc);
 > +	if (ib_copy_from_udata(&ucmd, udata, sizeof ucmd)) {
 > +		err = -EFAULT;
 > +		goto err;
 > +	}

trivial, but you might as well do the copy_from_udata before
allocating mr, so that you can just return ERR_PTR(-EFAULT) without
having to free mr on the error path.

 > +	dmaflush = (int) ucmd.mr_attrs & MTHCA_MR_DMAFLUSH;
 > +
 > +	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 
 > +			       dmaflush);

I think the dmaflush temporary variable isn't adding anything, and
certainly the cast to int is unnecessary.  Anyway, it looks better to
me to write this simply as

	mr->umem = ib_umem_get(pd->uobject->context, start, length, acc, 
			       ucmd.mr_attrs & MTHCA_MR_DMAFLUSH);

 > +#define MTHCA_MR_DMAFLUSH 0x1	/* flush in-flight DMA on a write to 
 > +				 * memory region (IA64_SGI_SN2 only) */

I would leave out the commentary about this being SN2-only -- the
whole point is to use a generic API to hide this detail.

 - R.
