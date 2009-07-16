Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbZGPGqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbZGPGqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:46:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbZGPGqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:46:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:45991 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbZGPGqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:46:12 -0400
Message-ID: <4A5ECC62.7050607@kernel.org>
Date: Thu, 16 Jul 2009 15:44:50 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, Boaz Harrosh <bharrosh@panasas.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jeff Garzik <jeff@garzik.org>
Subject: [PATCH #tj-block-for-linus] block: fix failfast merge testing in
 elv_rq_merge_ok()
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 16 Jul 2009 06:45:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ab0fd1debe730ec9998678a0c53caefbd121ed10 tries to prevent merge
of requests with different failfast settings.  In elv_rq_merge_ok(),
it compares new bio's failfast flags against the merge target
request's.  However, the flag testing accessors for bio and blk don't
return boolean but the tested bit value directly and FAILFAST on bio
and blk don't match, so directly comparing them with == results in
false negative unnecessary preventing merge of readahead requests.

This patch convert the results to boolean by negating them before
comparison.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>
---
Eh... talk about being obscure. :-( I've put this onto the following
temp block tree I'm running and will push toward Linus in a few days.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git tj-block-for-linus

Thanks.

 block/elevator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 6f23753..977aa7c 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -103,9 +103,9 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 	/*
 	 * Don't merge if failfast settings don't match
 	 */
-	if (bio_failfast_dev(bio)	!= blk_failfast_dev(rq)		||
-	    bio_failfast_transport(bio)	!= blk_failfast_transport(rq)	||
-	    bio_failfast_driver(bio)	!= blk_failfast_driver(rq))
+	if (!bio_failfast_dev(bio)	 != !blk_failfast_dev(rq)	||
+	    !bio_failfast_transport(bio) != !blk_failfast_transport(rq)	||
+	    !bio_failfast_driver(bio)	 != !blk_failfast_driver(rq))
 		return 0;

 	if (!elv_iosched_allow_merge(rq, bio))
-- 
1.6.0.2

