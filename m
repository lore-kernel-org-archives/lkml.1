Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab0BDR1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:27:16 -0500
Received: from kroah.org ([198.145.64.141]:34904 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933345Ab0BDRWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:21 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:22 2010
Message-Id: <20100204171521.468899693@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [59/74] block: fix bugs in bio-integrity mempool usage
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chuck Ebbert <cebbert@redhat.com>

commit 9e9432c267e4047db98b9d4fba95099c6effcef9 upstream.

Fix two bugs in the bio integrity code:

 use_bip_pool() always returns 0 because it checks against the wrong limit,
 causing the mempool to be used only when regular allocation fails.

 When the mempool is used as a fallback we don't free the data properly.

Signed-Off-By: Chuck Ebbert <cebbert@redhat.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/bio-integrity.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -61,7 +61,7 @@ static inline unsigned int vecs_to_idx(u
 
 static inline int use_bip_pool(unsigned int idx)
 {
-	if (idx == BIOVEC_NR_POOLS)
+	if (idx == BIOVEC_MAX_IDX)
 		return 1;
 
 	return 0;
@@ -95,6 +95,7 @@ struct bio_integrity_payload *bio_integr
 
 	/* Use mempool if lower order alloc failed or max vecs were requested */
 	if (bip == NULL) {
+		idx = BIOVEC_MAX_IDX;  /* so we free the payload properly later */
 		bip = mempool_alloc(bs->bio_integrity_pool, gfp_mask);
 
 		if (unlikely(bip == NULL)) {


