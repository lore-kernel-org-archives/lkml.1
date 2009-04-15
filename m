Return-Path: <linux-kernel-owner+w=401wt.eu-S1759828AbZDONKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759828AbZDONKw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 09:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZDONKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 09:10:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:34989 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751919AbZDONKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 09:10:41 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, bharrosh@panasas.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] scatterlist: make sure sg_miter_next() doesn't return 0 sized mappings
Date: Wed, 15 Apr 2009 22:10:23 +0900
Message-Id: <1239801027-9201-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1239801027-9201-1-git-send-email-tj@kernel.org>
References: <1239801027-9201-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 15 Apr 2009 13:10:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix not-so-critical but annoying bug

sg_miter_next() returns 0 sized mapping if there is an zero sized sg
entry in the list or at the end of each iteration.  As the users
always check the ->length field, this bug shouldn't be critical other
than causing unnecessary iteration.

Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 lib/scatterlist.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index b7b449d..a295e40 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -347,9 +347,12 @@ bool sg_miter_next(struct sg_mapping_iter *miter)
 	sg_miter_stop(miter);
 
 	/* get to the next sg if necessary.  __offset is adjusted by stop */
-	if (miter->__offset == miter->__sg->length && --miter->__nents) {
-		miter->__sg = sg_next(miter->__sg);
-		miter->__offset = 0;
+	while (miter->__offset == miter->__sg->length) {
+		if (--miter->__nents) {
+			miter->__sg = sg_next(miter->__sg);
+			miter->__offset = 0;
+		} else
+			return false;
 	}
 
 	/* map the next page */
-- 
1.6.0.2

