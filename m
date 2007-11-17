Return-Path: <linux-kernel-owner+w=401wt.eu-S1755288AbXKQXBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288AbXKQXBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 18:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbXKQXAz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 18:00:55 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:47376 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752051AbXKQXAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 18:00:54 -0500
Date: Sun, 18 Nov 2007 00:00:49 +0100
To: Ingo Molnar <mingo@elte.hu>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       nfs@lists.sourceforge.net, Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [BUG] 2.6.24-rc2-mm1 - kernel bug on nfs v4
Message-ID: <20071117230049.GA25905@dyad>
References: <473DA608.1020804@linux.vnet.ibm.com> <64bb37e0711170953p67d1be49lf4eaa190d662e2b4@mail.gmail.com> <20071117180946.GA14055@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071117180946.GA14055@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: root@programming.kicks-ass.net (root)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 17, 2007 at 07:09:46PM +0100, Ingo Molnar wrote:
> 
> * Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> 
> > Sadly lockdep does not work for me, as it gets turned off early:
> > [   39.851594] ---------------------------------
> > [   39.855963] inconsistent {softirq-on-W} -> {in-softirq-W} usage.
> > [   39.861981] swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
> > [   39.866963]  (&n->list_lock){-+..}, at: [<ffffffff802935c1>]
> 
> hey, that means it found a bug - which is not sad at all :-)

---
Subject: lockdep: slub: annotate boot time node->list_lock usage

inconsistent {softirq-on-W} -> {in-softirq-W} usage.
swapper/0 [HC0[0]:SC1[1]:HE0:SE0] takes:
 (&n->list_lock){-+..}, at: [<ffffffff802935c1>] add_partial+0x31/0xa0
{softirq-on-W} state was registered at:
  [<ffffffff80259fb8>] __lock_acquire+0x3e8/0x1140
  [<ffffffff80259838>] debug_check_no_locks_freed+0x188/0x1a0
  [<ffffffff8025ad65>] lock_acquire+0x55/0x70
  [<ffffffff802935c1>] add_partial+0x31/0xa0
  [<ffffffff805c76de>] _spin_lock+0x1e/0x30
  [<ffffffff802935c1>] add_partial+0x31/0xa0
  [<ffffffff80296f9c>] kmem_cache_open+0x1cc/0x330
  [<ffffffff805c7984>] _spin_unlock_irq+0x24/0x30
  [<ffffffff802974f4>] create_kmalloc_cache+0x64/0xf0
  [<ffffffff80295640>] init_alloc_cpu_cpu+0x70/0x90
  [<ffffffff8080ada5>] kmem_cache_init+0x65/0x1d0
  [<ffffffff807f1b4e>] start_kernel+0x23e/0x350
  [<ffffffff807f112d>] _sinittext+0x12d/0x140
  [<ffffffffffffffff>] 0xffffffffffffffff

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Christoph Lameter <clameter@sgi.com>
CC: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 mm/slub.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -2155,6 +2155,7 @@ static struct kmem_cache_node *early_kme
 {
 	struct page *page;
 	struct kmem_cache_node *n;
+	unsigned long flags;
 
 	BUG_ON(kmalloc_caches->size < sizeof(struct kmem_cache_node));
 
@@ -2179,7 +2180,14 @@ static struct kmem_cache_node *early_kme
 #endif
 	init_kmem_cache_node(n);
 	atomic_long_inc(&n->nr_slabs);
+	/*
+	 * lockdep requires consistent irq usage for each lock
+	 * so even though there cannot be a race this early in
+	 * the boot sequence, we still disable irqs.
+	 */
+	local_irq_save(flags);
 	add_partial(kmalloc_caches, page, 0);
+	local_irq_restore(flags);
 	return n;
 }
 
