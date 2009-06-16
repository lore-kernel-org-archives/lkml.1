Return-Path: <linux-kernel-owner+w=401wt.eu-S1755489AbZFPIwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489AbZFPIwn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:52:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752384AbZFPIwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:52:24 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:44367
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751444AbZFPIwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:52:24 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KLBPZ3-02-3FS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 1/2] dma-debug: check for sg_call_ents in best-fit algorithm too
Date: Tue, 16 Jun 2009 10:52:09 +0200
Message-ID: <1245142330-7067-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245142330-7067-1-git-send-email-joerg.roedel@amd.com>
References: <1245142330-7067-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 16 Jun 2009 08:52:14.0998 (UTC) FILETIME=[BEF7BB60:01C9EE5F]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't check for sg_call_ents the hash_bucket_find function might
still return the wrong dma_debug_entry for sg mappings.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 lib/dma-debug.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ad65fc0..c71e2dd 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -262,11 +262,12 @@ static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
 		 */
 		matches += 1;
 		match_lvl = 0;
-		entry->size      == ref->size      ? ++match_lvl : match_lvl;
-		entry->type      == ref->type      ? ++match_lvl : match_lvl;
-		entry->direction == ref->direction ? ++match_lvl : match_lvl;
+		entry->size         == ref->size         ? ++match_lvl : 0;
+		entry->type         == ref->type         ? ++match_lvl : 0;
+		entry->direction    == ref->direction    ? ++match_lvl : 0;
+		entry->sg_call_ents == ref->sg_call_ents ? ++match_lvl : 0;
 
-		if (match_lvl == 3) {
+		if (match_lvl == 4) {
 			/* perfect-fit - return the result */
 			return entry;
 		} else if (match_lvl > last_lvl) {
@@ -1076,16 +1077,14 @@ void debug_dma_unmap_sg(struct device *dev, struct scatterlist *sglist,
 			.dev_addr       = sg_dma_address(s),
 			.size           = sg_dma_len(s),
 			.direction      = dir,
-			.sg_call_ents   = 0,
+			.sg_call_ents   = nelems,
 		};
 
 		if (mapped_ents && i >= mapped_ents)
 			break;
 
-		if (!i) {
-			ref.sg_call_ents = nelems;
+		if (!i)
 			mapped_ents = get_nr_mapped_entries(dev, s);
-		}
 
 		check_unmap(&ref);
 	}
-- 
1.6.3.1


