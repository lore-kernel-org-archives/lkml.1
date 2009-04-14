Return-Path: <linux-kernel-owner+w=401wt.eu-S1752260AbZDNGWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260AbZDNGWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 02:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZDNGV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 02:21:56 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43296 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263AbZDNGVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 02:21:55 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH v3 5/6] don't use bio-map in read() path
Cc: kosaki.motohiro@jp.fujitsu.com, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrea Arcangeli <aarcange@redhat.com>, Jeff Moyer <jmoyer@redhat.com>,
       linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <20090414151204.C647.A69D9226@jp.fujitsu.com>
References: <20090414151204.C647.A69D9226@jp.fujitsu.com>
Message-Id: <20090414152020.C656.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Tue, 14 Apr 2009 15:21:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Who know proper fixing way?

=================
Subject: [Untested][RFC][PATCH] don't use bio-map in read() path

__bio_map_user_iov() has wrong usage of get_user_pages_fast().
it doesn't have prevent fork mechanism.

then, it sould be used read-side (memory to device transfer) gup only.

This patch is obviously temporally fix. we can implement fork safe bio_map_user()
the future...


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 block/blk-map.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/block/blk-map.c
===================================================================
--- a/block/blk-map.c	2009-02-21 16:53:21.000000000 +0900
+++ b/block/blk-map.c	2009-04-12 23:36:32.000000000 +0900
@@ -55,7 +55,7 @@ static int __blk_rq_map_user(struct requ
 	 * direct dma. else, set up kernel bounce buffers
 	 */
 	uaddr = (unsigned long) ubuf;
-	if (blk_rq_aligned(q, ubuf, len) && !map_data)
+	if (blk_rq_aligned(q, ubuf, len) && !map_data && !reading)
 		bio = bio_map_user(q, NULL, uaddr, len, reading, gfp_mask);
 	else
 		bio = bio_copy_user(q, map_data, uaddr, len, reading, gfp_mask);
@@ -208,7 +208,7 @@ int blk_rq_map_user_iov(struct request_q
 		}
 	}
 
-	if (unaligned || (q->dma_pad_mask & len) || map_data)
+	if (unaligned || (q->dma_pad_mask & len) || map_data || read)
 		bio = bio_copy_user_iov(q, map_data, iov, iov_count, read,
 					gfp_mask);
 	else


