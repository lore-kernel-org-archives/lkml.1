Return-Path: <linux-kernel-owner+w=401wt.eu-S1753342AbYIYHgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbYIYHgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYIYHgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:36:35 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:44041 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbYIYHge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:36:34 -0400
Date: Thu, 25 Sep 2008 16:35:31 +0900
To: knikanth@suse.de
Cc: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Subject: Re: [PATCH] BUG: ll_merge_requests_fn() updates
 req->nr_phys_segments wrongly
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200809232358.02810.knikanth@suse.de>
References: <200809232358.02810.knikanth@suse.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080925163351G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2008 23:58:02 +0530
Nikanth Karthikesan <knikanth@suse.de> wrote:

> 
> From: Nikanth Karthikesan <knikanth@suse.de>
> 
> ll_merge_requests_fn() decreases the req->nr_phys_segments if 
> blk_phys_contig_segment() returns true, but it is perfectly possible that 
> blk_hw_contig_segment() is false.

Yeah, in fact, blk_hw_contig_segment() is always false on the majority
of architectures (on only PARISC and Alpha, it could be true).

Your patch doesn't look correct. Virtually, the patch always disables
physical merging.


> A new hw_segment implies a new phys_segment. 
> So decrementing nr_phys_segments wrongly here triggers the BUG_ON() in 
> scsi_init_sgtable(), as blk_rq_map_sg() would map 1 phys_segment more than  
> req->nr_phys_segment. This is easily reproducible. Other callers of 
> blk_rq_map_sg() should also be affected by this bug.

I have no idea how BUG_ON() in scsi_init_sgtable() is triggered.

Can you give more information, HBA, IOMMU (if you use), and the values
of req->nr_phys_segment, req->nr_hw_segment, count, etc in in
scsi_init_sgtable() when you hit the bug?


BTW, blk_hw_contig_segment() will be removed for 2.6.28 (virtual
merging account in the block layer will be removed).
