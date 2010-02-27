Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030288Ab0B0RfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 12:35:23 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:65224 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030250Ab0B0RfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 12:35:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=xv13ZdyPpFcBleGxl9yQMWXPelqfHnHRafq19b9fasTbME5qB12+NE/2GwB0/X9OGb
         wjYFUF9nIscdw5mL2q3ZqTv2JgjAiYuR/TJSgcIFT+/nq3txKgWjZrG3SJ6WtXG0QWhS
         P3RCY7KcusHwzpu+e3dGgTW0wrPp6vH+qdh2Y=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
Date: Sat, 27 Feb 2010 20:35:12 +0300
Message-Id: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merge_bvec_fn() returns bvec->bv_len on success. So we have to check
against this value. But in case of fs_optimization merge we compare
with wrong value. This patch must be included in
 b428cd6da7e6559aca69aa2e3a526037d3f20403
But accidentally i've forgot to add this in the initial patch.
To make things straight let's replace all such checks.
In fact this makes code easy to understand.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/bio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 88094af..c28e5fb 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -557,7 +557,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 					.bi_rw = bio->bi_rw,
 				};
 
-				if (q->merge_bvec_fn(q, &bvm, prev) < len) {
+				if (q->merge_bvec_fn(q, &bvm, prev) != prev->bv_len) {
 					prev->bv_len -= len;
 					return 0;
 				}
@@ -611,7 +611,7 @@ static int __bio_add_page(struct request_queue *q, struct bio *bio, struct page
 		 * merge_bvec_fn() returns number of bytes it can accept
 		 * at this offset
 		 */
-		if (q->merge_bvec_fn(q, &bvm, bvec) < len) {
+		if (q->merge_bvec_fn(q, &bvm, bvec) != bvec->bv_len) {
 			bvec->bv_page = NULL;
 			bvec->bv_len = 0;
 			bvec->bv_offset = 0;
-- 
1.6.6

