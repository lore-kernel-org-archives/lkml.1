Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbZFGKXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbZFGKXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 06:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbZFGKXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 06:23:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:56988 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755627AbZFGKXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 06:23:24 -0400
Date: Sun, 7 Jun 2009 10:22:42 GMT
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       just.for.lkml@googlemail.com, torvalds@linux-foundation.org,
       joerg.roedel@amd.com, fujita.tomonori@lab.ntt.co.jp, stable@kernel.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       just.for.lkml@googlemail.com, joerg.roedel@amd.com,
       torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090605104132.GE24836@amd.com>
References: <20090605104132.GE24836@amd.com>
Subject: [tip:core/iommu] dma-debug: change hash_bucket_find from first-fit to best-fit
Message-ID: <tip-7caf6a49bb17d0377210693af5737563b31aa5ee@git.kernel.org>
Git-Commit-ID: 7caf6a49bb17d0377210693af5737563b31aa5ee
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 07 Jun 2009 10:22:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7caf6a49bb17d0377210693af5737563b31aa5ee
Gitweb:     http://git.kernel.org/tip/7caf6a49bb17d0377210693af5737563b31aa5ee
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Fri, 5 Jun 2009 12:01:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 7 Jun 2009 10:04:53 +0200

dma-debug: change hash_bucket_find from first-fit to best-fit

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
Cc: <stable@kernel.org>
LKML-Reference: <20090605104132.GE24836@amd.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 lib/dma-debug.c |   43 +++++++++++++++++++++++++++++++++++++++----
 1 files changed, 39 insertions(+), 4 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index cdd205d..8fcc09c 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -186,15 +186,50 @@ static void put_hash_bucket(struct hash_bucket *bucket,
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
