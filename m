Return-Path: <linux-kernel-owner+w=401wt.eu-S1760302AbZCNBZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302AbZCNBZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 21:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZCNBT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 21:19:57 -0400
Received: from kroah.org ([198.145.64.141]:34858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752546AbZCNBTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 21:19:55 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 18:10:33 2009
Message-Id: <20090314011033.444403324@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 18:09:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Nick Piggin <npiggin@suse.de>
Subject: [patch 014/114] mm: vmap fix overflow
References: <20090314010937.416083662@mini.kroah.org>
Content-Disposition: inline; filename=mm-vmap-fix-overflow.patch
In-Reply-To: <20090314011649.GA26170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 7766970cc13e9071b356b1f2a48a9eb8675bfcce upstream.

The new vmap allocator can wrap the address and get confused in the case
of large allocations or VMALLOC_END near the end of address space.

Problem reported by Christoph Hellwig on a 32-bit XFS workload.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reported-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmalloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -323,6 +323,7 @@ static struct vmap_area *alloc_vmap_area
 	unsigned long addr;
 	int purged = 0;
 
+	BUG_ON(!size);
 	BUG_ON(size & ~PAGE_MASK);
 
 	va = kmalloc_node(sizeof(struct vmap_area),
@@ -334,6 +335,9 @@ retry:
 	addr = ALIGN(vstart, align);
 
 	spin_lock(&vmap_area_lock);
+	if (addr + size - 1 < addr)
+		goto overflow;
+
 	/* XXX: could have a last_hole cache */
 	n = vmap_area_root.rb_node;
 	if (n) {
@@ -365,6 +369,8 @@ retry:
 
 		while (addr + size > first->va_start && addr + size <= vend) {
 			addr = ALIGN(first->va_end + PAGE_SIZE, align);
+			if (addr + size - 1 < addr)
+				goto overflow;
 
 			n = rb_next(&first->rb_node);
 			if (n)
@@ -375,6 +381,7 @@ retry:
 	}
 found:
 	if (addr + size > vend) {
+overflow:
 		spin_unlock(&vmap_area_lock);
 		if (!purged) {
 			purge_vmap_area_lazy();


