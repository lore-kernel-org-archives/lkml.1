Return-Path: <linux-kernel-owner+w=401wt.eu-S1765732AbYBBAar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765732AbYBBAar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 19:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762912AbYBBAZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 19:25:06 -0500
Received: from cantor.suse.de ([195.135.220.2]:54663 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762889AbYBBAZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 19:25:03 -0500
Date: Fri, 1 Feb 2008 16:20:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>, Nick Piggin <npiggin@suse.de>
Subject: [patch 18/27] CASSINI: Revert dont touch page_count.
Message-ID: <20080202002051.GS8368@suse.de>
References: <20080202001232.472591439@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cassini_2.patch"
In-Reply-To: <20080202001927.GA8368@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: David Miller <davem@davemloft.net>

[ Upstream commit: 9de4dfb4c7176e5bb232a21cdd8df78da2b15cac ]

This reverts changeset fa4f0774d7c6cccb4d1fda76b91dd8eddcb2dd6a
([CASSINI]: dont touch page_count) because it breaks the driver.

The local page counting added by this changeset did not account
for the asynchronous page count changes done by kfree_skb()
and friends.

The change adds extra atomics and on top of it all appears to be
totally unnecessary as well.

Signed-off-by: David S. Miller <davem@davemloft.net>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/cassini.c |   36 ++++--------------------------------
 1 file changed, 4 insertions(+), 32 deletions(-)

--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -336,30 +336,6 @@ static inline void cas_mask_intr(struct 
 		cas_disable_irq(cp, i);
 }
 
-static inline void cas_buffer_init(cas_page_t *cp)
-{
-	struct page *page = cp->buffer;
-	atomic_set((atomic_t *)&page->lru.next, 1);
-}
-
-static inline int cas_buffer_count(cas_page_t *cp)
-{
-	struct page *page = cp->buffer;
-	return atomic_read((atomic_t *)&page->lru.next);
-}
-
-static inline void cas_buffer_inc(cas_page_t *cp)
-{
-	struct page *page = cp->buffer;
-	atomic_inc((atomic_t *)&page->lru.next);
-}
-
-static inline void cas_buffer_dec(cas_page_t *cp)
-{
-	struct page *page = cp->buffer;
-	atomic_dec((atomic_t *)&page->lru.next);
-}
-
 static void cas_enable_irq(struct cas *cp, const int ring)
 {
 	if (ring == 0) { /* all but TX_DONE */
@@ -497,7 +473,6 @@ static int cas_page_free(struct cas *cp,
 {
 	pci_unmap_page(cp->pdev, page->dma_addr, cp->page_size,
 		       PCI_DMA_FROMDEVICE);
-	cas_buffer_dec(page);
 	__free_pages(page->buffer, cp->page_order);
 	kfree(page);
 	return 0;
@@ -527,7 +502,6 @@ static cas_page_t *cas_page_alloc(struct
 	page->buffer = alloc_pages(flags, cp->page_order);
 	if (!page->buffer)
 		goto page_err;
-	cas_buffer_init(page);
 	page->dma_addr = pci_map_page(cp->pdev, page->buffer, 0,
 				      cp->page_size, PCI_DMA_FROMDEVICE);
 	return page;
@@ -606,7 +580,7 @@ static void cas_spare_recover(struct cas
 	list_for_each_safe(elem, tmp, &list) {
 		cas_page_t *page = list_entry(elem, cas_page_t, list);
 
-		if (cas_buffer_count(page) > 1)
+		if (page_count(page->buffer) > 1)
 			continue;
 
 		list_del(elem);
@@ -1374,7 +1348,7 @@ static inline cas_page_t *cas_page_spare
 	cas_page_t *page = cp->rx_pages[1][index];
 	cas_page_t *new;
 
-	if (cas_buffer_count(page) == 1)
+	if (page_count(page->buffer) == 1)
 		return page;
 
 	new = cas_page_dequeue(cp);
@@ -1394,7 +1368,7 @@ static cas_page_t *cas_page_swap(struct 
 	cas_page_t **page1 = cp->rx_pages[1];
 
 	/* swap if buffer is in use */
-	if (cas_buffer_count(page0[index]) > 1) {
+	if (page_count(page0[index]->buffer) > 1) {
 		cas_page_t *new = cas_page_spare(cp, index);
 		if (new) {
 			page1[index] = page0[index];
@@ -2066,7 +2040,6 @@ static int cas_rx_process_pkt(struct cas
 		skb->len      += hlen - swivel;
 
 		get_page(page->buffer);
-		cas_buffer_inc(page);
 		frag->page = page->buffer;
 		frag->page_offset = off;
 		frag->size = hlen - swivel;
@@ -2091,7 +2064,6 @@ static int cas_rx_process_pkt(struct cas
 			frag++;
 
 			get_page(page->buffer);
-			cas_buffer_inc(page);
 			frag->page = page->buffer;
 			frag->page_offset = 0;
 			frag->size = hlen;
@@ -2255,7 +2227,7 @@ static int cas_post_rxds_ringN(struct ca
 	released = 0;
 	while (entry != last) {
 		/* make a new buffer if it's still in use */
-		if (cas_buffer_count(page[entry]) > 1) {
+		if (page_count(page[entry]->buffer) > 1) {
 			cas_page_t *new = cas_page_dequeue(cp);
 			if (!new) {
 				/* let the timer know that we need to

-- 
