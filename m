Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbZFOIwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbZFOIwf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757926AbZFOIwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:52:10 -0400
Received: from cantor.suse.de ([195.135.220.2]:55150 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757604AbZFOIwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:52:08 -0400
Date: Mon, 15 Jun 2009 10:52:09 +0200
From: Nick Piggin <npiggin@suse.de>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615085209.GB30964@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <20090615082636.GA30964@wotan.suse.de> <1245054779.23207.6.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245054779.23207.6.camel@penberg-laptop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Mon, Jun 15, 2009 at 11:32:59AM +0300, Pekka Enberg wrote:
> Hi Nick,
> 
> On Mon, 2009-06-15 at 10:26 +0200, Nick Piggin wrote:
> > > 
> > > Might be that I missed something. Maybe some special flag?
> > 
> > No, just a bug in the conversion.
> > 
> > If you predicate the schedule_work call on slab_state == SYSFS, then
> > it should work (when sysfs comes up later in init, previously added
> > slabs will be registered with sysfs).
> > 
> > Oh, and you'd need to also not pass __SYSFS_ADD_DEFERRED into
> > kmem_cache_create in that case too.
> 
> I am not sure I follow you here. We are setting up slab so early that we
> absolutely _must_ defer sysfs setup. But we're also setting up slab much
> earlier than workqueues, so we shouldn't really do schedule_work() at
> that point.

There's 2 types of deferring going on here. In early boot we
obviously don't touch sysfs at all. All other times, we still
need to defer because we don't know the context it is being
called from.


> Furthermore, early boot cache sysfs setup is explicitly
> handled in slab_sysfs_init() so I think we need something like the patch
> below?

I don't think so because keventd probably comes up before sysfs
still is ready (in this respect the existing pre-early-slab code
is probably still broken but just never done such early DMA
allocations). So it just makes sense to do it all via the slab_state
flag.

Also, if you keep the deferred flag on there for early created
slabs, then the next sysfs_add_work will try to add it again
(after slab_sysfs_init already added it).

Here

---
 mm/slub.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c
+++ linux-2.6/mm/slub.c
@@ -2596,6 +2596,7 @@ static noinline struct kmem_cache *dma_k
 	struct kmem_cache *s;
 	char *text;
 	size_t realsize;
+	unsigned long slabflags;
 
 	s = kmalloc_caches_dma[index];
 	if (s)
@@ -2617,9 +2618,18 @@ static noinline struct kmem_cache *dma_k
 			 (unsigned int)realsize);
 	s = kmalloc(kmem_size, flags & ~SLUB_DMA);
 
+	/*
+	 * Must defer sysfs creation to a workqueue because we don't know
+	 * what context we are called from. Before sysfs comes up, we don't
+	 * need to do anything because slab_sysfs_init will start by
+	 * adding all existing slabs to sysfs.
+	 */
+	slabflags = SLAB_CACHE_DMA;
+	if (slab_state >= SYSFS)
+		slabflags |= __SYSFS_ADD_DEFERRED;
+
 	if (!s || !text || !kmem_cache_open(s, flags, text,
-			realsize, ARCH_KMALLOC_MINALIGN,
-			SLAB_CACHE_DMA|__SYSFS_ADD_DEFERRED, NULL)) {
+			realsize, ARCH_KMALLOC_MINALIGN, slabflags, NULL)) {
 		kfree(s);
 		kfree(text);
 		goto unlock_out;
@@ -2628,7 +2638,8 @@ static noinline struct kmem_cache *dma_k
 	list_add(&s->list, &slab_caches);
 	kmalloc_caches_dma[index] = s;
 
-	schedule_work(&sysfs_add_work);
+	if (slab_state >= SYSFS)
+		schedule_work(&sysfs_add_work);
 
 unlock_out:
 	up_write(&slub_lock);
