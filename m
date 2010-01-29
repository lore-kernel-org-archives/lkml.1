Return-Path: <linux-kernel-owner+w=401wt.eu-S1756346Ab0A2BDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab0A2BDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 20:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570Ab0A2BDH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 20:03:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755451Ab0A2BDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 20:03:04 -0500
Message-Id: <201001290102.o0T12nHu022353@int-mx05.intmail.prod.int.phx2.redhat.com>
Date: Thu, 28 Jan 2010 20:02:48 -0500
From: Chuck Ebbert <cebbert@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [patch] block: fix bugs in bio-integrity mempool usage
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

block: fix bugs in bio-integrity mempool usage

Fix two bugs in the bio integrity code:

 use_bip_pool() always returns 0 because it checks against the wrong limit,
 causing the mempool to be used only when regular allocation fails.

 When the mempool is used as a fallback we don't free the data properly.

Signed-Off-By: Chuck Ebbert <cebbert@redhat.com>

--- linux-2.6.32.noarch.orig/fs/bio-integrity.c
+++ linux-2.6.32.noarch/fs/bio-integrity.c
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
