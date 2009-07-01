Return-Path: <linux-kernel-owner+w=401wt.eu-S1761935AbZGAAxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761935AbZGAAxn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:53:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761417AbZGAAed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:33 -0400
Received: from kroah.org ([198.145.64.141]:60196 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761356AbZGAAe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:20 2009
Message-Id: <20090701002420.141480274@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:14 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Joerg Roedel <joerg.roedel@amd.com>, lethal@linux-sh.org,
       just.for.lkml@googlemail.com, hancockrwd@gmail.com,
       jens.axboe@oracle.com, bharrosh@panasas.com,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 025/108] dma-debug: change hash_bucket_find from first-fit to best-fit
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=dma-debug-change-hash_bucket_find-from-first-fit-to-best-fit.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Roedel <joerg.roedel@amd.com>

commit 7caf6a49bb17d0377210693af5737563b31aa5ee upstream.

Some device drivers map the same physical address multiple times to a
dma address. Without an IOMMU this results in the same dma address being
put into the dma-debug hash multiple times. With a first-fit match in
hash_bucket_find() this function may return the wrong dma_debug_entry.

This can result in false positive warnings. This patch fixes it by
changing the first-fit behavior of hash_bucket_find() into a best-fit
algorithm.

Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
Reported-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: lethal@linux-sh.org
Cc: just.for.lkml@googlemail.com
Cc: hancockrwd@gmail.com
Cc: jens.axboe@oracle.com
Cc: bharrosh@panasas.com
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <20090605104132.GE24836@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 lib/dma-debug.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -185,15 +185,50 @@ static void put_hash_bucket(struct hash_
 static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
 						struct dma_debug_entry *ref)
 {
-	struct dma_debug_entry *entry;
+	struct dma_debug_entry *entry, *ret = NULL;
+	int matches = 0, match_lvl, last_lvl = 0;
 
 	list_for_each_entry(entry, &bucket->list, list) {
-		if ((entry->dev_addr == ref->dev_addr) &&
-		    (entry->dev == ref->dev))
+		if ((entry->dev_addr != ref->dev_addr) ||
+		    (entry->dev != ref->dev))
+			continue;
+
+		/*
+		 * Some drivers map the same physical address multiple
+		 * times. Without a hardware IOMMU this results in the
+		 * same device addresses being put into the dma-debug
+		 * hash multiple times too. This can result in false
+		 * positives being reported. Therfore we implement a
+		 * best-fit algorithm here which returns the entry from
+		 * the hash which fits best to the reference value
+		 * instead of the first-fit.
+		 */
+		matches += 1;
+		match_lvl = 0;
+		entry->size      == ref->size      ? ++match_lvl : match_lvl;
+		entry->type      == ref->type      ? ++match_lvl : match_lvl;
+		entry->direction == ref->direction ? ++match_lvl : match_lvl;
+
+		if (match_lvl == 3) {
+			/* perfect-fit - return the result */
 			return entry;
+		} else if (match_lvl > last_lvl) {
+			/*
+			 * We found an entry that fits better then the
+			 * previous one
+			 */
+			last_lvl = match_lvl;
+			ret      = entry;
+		}
 	}
 
-	return NULL;
+	/*
+	 * If we have multiple matches but no perfect-fit, just return
+	 * NULL.
+	 */
+	ret = (matches == 1) ? ret : NULL;
+
+	return ret;
 }
 
 /*


