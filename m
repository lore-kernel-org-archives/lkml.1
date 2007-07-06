Return-Path: <linux-kernel-owner+w=401wt.eu-S1762393AbXGFAdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762393AbXGFAdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 20:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbXGFAdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 20:33:37 -0400
Received: from ozlabs.org ([203.10.76.45]:46561 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758389AbXGFAdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 20:33:36 -0400
Subject: Re: [PATCH 2/3] Virtio draft IV: the block driver
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: virtualization@lists.linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <200707050932.50110.borntraeger@de.ibm.com>
References: <1183522348.6110.37.camel@localhost.localdomain>
	 <1183522765.6110.40.camel@localhost.localdomain>
	 <200707050932.50110.borntraeger@de.ibm.com>
Content-Type: text/plain
Date: Fri, 06 Jul 2007 10:33:20 +1000
Message-Id: <1183682000.6005.108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 09:32 +0200, Christian Borntraeger wrote:
> Am Mittwoch, 4. Juli 2007 schrieb Rusty Russell:
> > +		vbr = mempool_alloc(vblk->pool, GFP_ATOMIC);
> > +		if (!vbr)
> > +			goto stop;
> [...]
> > +		BUG_ON(req->nr_phys_segments > ARRAY_SIZE(vblk->sg));
> > +		vbr->req = req;
> > +		if (!do_req(q, vblk, vbr))
> > +			goto stop;
> [...]
> > +stop:
> > +	/* Queue full?  Wait. */
> > +	blk_stop_queue(q);
> > +	mempool_free(vbr, vblk->pool);
> 
> 
> Hmm, can mempool_free really handle NULL as its first argument? (first goto). 

Good point.  Any objections to fixing that?

Cheers,
Rusty.
===
Christian Borntraeger points out that mempool_free() doesn't noop when
handed NULL.  This is inconsistent with the other free-like functions
in the kernel.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r a306f0a8de5e mm/mempool.c
--- a/mm/mempool.c	Fri Jul 06 10:28:39 2007 +1000
+++ b/mm/mempool.c	Fri Jul 06 10:29:40 2007 +1000
@@ -263,6 +263,9 @@ void mempool_free(void *element, mempool
 {
 	unsigned long flags;
 
+	if (unlikely(element == NULL))
+		return;
+
 	smp_mb();
 	if (pool->curr_nr < pool->min_nr) {
 		spin_lock_irqsave(&pool->lock, flags);


