Return-Path: <linux-kernel-owner+w=401wt.eu-S1756054AbXITKdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbXITKdW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 06:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbXITKdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 06:33:14 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:31110 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbXITKdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 06:33:13 -0400
Date: Thu, 20 Sep 2007 14:32:29 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc6-mm1: BUG kmalloc-16: Object padding overwritten (sysfs?)
Message-ID: <20070920103229.GB6781@localhost.sw.ru>
References: <20070919123907.GA15591@localhost.sw.ru> <20070919125918.GA6760@localhost.sw.ru> <20070919123954.fb552e80.akpm@linux-foundation.org> <Pine.LNX.4.64.0709191355340.3136@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0709191432200.3111@schroedinger.engr.sgi.com> <20070920075353.GA6781@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920075353.GA6781@localhost.sw.ru>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 11:53:53AM +0400, Alexey Dobriyan wrote:
> On Wed, Sep 19, 2007 at 02:36:04PM -0700, Christoph Lameter wrote:
> > So I would think that this is an actual memory corruption issue on your 
> > system and the /sys/slab stuff works fine. slabinfo -v will perform a more 
> > details scan to help you located the problem.
> 
> OK, I do clean boot, ssh to box, then sudo slabinfo -v.
> 
> 
> =============================================================================
> BUG kmalloc-16: Object padding overwritten
> -----------------------------------------------------------------------------

The winner is slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab.patch
Blind bisecting pointed to it and reverting the patch from full -mm makes
the problem go away

From: Christoph Lameter <clameter@sgi.com>

Set c->node to -1 if we allocate from a debug slab instead for SlabDebug
which requires access the page struct cacheline.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/slub.c~slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab mm/slub.c
--- a/mm/slub.c~slub-avoid-touching-page-struct-when-freeing-to-per-cpu-slab
+++ a/mm/slub.c
@@ -1537,6 +1537,7 @@ debug:
 
 	c->page->inuse++;
 	c->page->freelist = object[c->offset];
+	c->node = -1;
 	slab_unlock(c->page);
 	return object;
 }
@@ -1560,8 +1561,7 @@ static void __always_inline *slab_alloc(
 
 	local_irq_save(flags);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (unlikely(!c->page || !c->freelist ||
-					!node_match(c, node)))
+	if (unlikely(!c->freelist || !node_match(c, node)))
 
 		object = __slab_alloc(s, gfpflags, node, addr, c);
 
@@ -1670,7 +1670,7 @@ static void __always_inline slab_free(st
 	local_irq_save(flags);
 	debug_check_no_locks_freed(object, s->objsize);
 	c = get_cpu_slab(s, smp_processor_id());
-	if (likely(page == c->page && !SlabDebug(page))) {
+	if (likely(page == c->page && c->node >= 0)) {
 		object[c->offset] = c->freelist;
 		c->freelist = object;
 	} else
_

