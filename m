Return-Path: <linux-kernel-owner+w=401wt.eu-S969166AbXGaEiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969166AbXGaEiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968297AbXGaEcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:32:21 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34625 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968282AbXGaEcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:32:19 -0400
Date: Mon, 30 Jul 2007 21:33:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, npiggin@suse.de, petr@vmware.com,
       andrea@suse.de, hugh@veritas.com, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 19/26] mm: kill validate_anon_vma to avoid mapcount BUG
Message-ID: <20070731043324.GT3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-kill-validate_anon_vma-to-avoid-mapcount-bug.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Hugh Dickins <hugh@veritas.com>

validate_anon_vma gave a useful check on the integrity of the anon_vma list
when Andrea was developing obj rmap; but it was not enabled in SLES9
itself, nor in mainline, until Nick changed commented-out RMAP_DEBUG to
configurable CONFIG_DEBUG_VM in 2.6.17.  Now Petr Vandrovec reports that
its BUG_ON(mapcount > 100000) can easily crash a CONFIG_DEBUG_VM=y system.

That limit was just an arbitrary number to protect against an infinite
loop.  We could raise it to something enormous (depending on sizeof struct
vma and size of memory?); but I rather think validate_anon_vma has outlived
its usefulness, and is better just removed - which gives a magnificent
performance boost to anything like Petr's test program ;)

Of course, a very long anon_vma list is bad news for preemption latency,
and I believe there has been one recent report of such: let's not forget
that, but validate_anon_vma only makes it worse not better.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: Petr Vandrovec <petr@vmware.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Cc: Andrea Arcangeli <andrea@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 mm/rmap.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

--- linux-2.6.21.6.orig/mm/rmap.c
+++ linux-2.6.21.6/mm/rmap.c
@@ -53,24 +53,6 @@
 
 struct kmem_cache *anon_vma_cachep;
 
-static inline void validate_anon_vma(struct vm_area_struct *find_vma)
-{
-#ifdef CONFIG_DEBUG_VM
-	struct anon_vma *anon_vma = find_vma->anon_vma;
-	struct vm_area_struct *vma;
-	unsigned int mapcount = 0;
-	int found = 0;
-
-	list_for_each_entry(vma, &anon_vma->head, anon_vma_node) {
-		mapcount++;
-		BUG_ON(mapcount > 100000);
-		if (vma == find_vma)
-			found = 1;
-	}
-	BUG_ON(!found);
-#endif
-}
-
 /* This must be called under the mmap_sem. */
 int anon_vma_prepare(struct vm_area_struct *vma)
 {
@@ -121,10 +103,8 @@ void __anon_vma_link(struct vm_area_stru
 {
 	struct anon_vma *anon_vma = vma->anon_vma;
 
-	if (anon_vma) {
+	if (anon_vma)
 		list_add_tail(&vma->anon_vma_node, &anon_vma->head);
-		validate_anon_vma(vma);
-	}
 }
 
 void anon_vma_link(struct vm_area_struct *vma)
@@ -134,7 +114,6 @@ void anon_vma_link(struct vm_area_struct
 	if (anon_vma) {
 		spin_lock(&anon_vma->lock);
 		list_add_tail(&vma->anon_vma_node, &anon_vma->head);
-		validate_anon_vma(vma);
 		spin_unlock(&anon_vma->lock);
 	}
 }
@@ -148,7 +127,6 @@ void anon_vma_unlink(struct vm_area_stru
 		return;
 
 	spin_lock(&anon_vma->lock);
-	validate_anon_vma(vma);
 	list_del(&vma->anon_vma_node);
 
 	/* We must garbage collect the anon_vma if it's empty */

-- 
