Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYDDL1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYDDL1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 07:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbYDDL1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 07:27:46 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:37723 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbYDDL1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 07:27:45 -0400
Message-ID: <47F610AD.8070202@tiscali.nl>
Date: Fri, 04 Apr 2008 13:27:41 +0200
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: nickpiggin@yahoo.com.au, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] likely_prof: update to test_and_set_bit_lock / clear_bit_unlock
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the _lock routines are faster and provide a better example to follow.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
As suggested by Nick Piggin. To be applied after Daniels likeliness patches
and my previous likeliness-accounting-change-and-cleanup.patch, 
The patch was checkpatch.pl, compile, sparse and run tested (uml).

diff --git a/lib/likely_prof.c b/lib/likely_prof.c
index c9a8d1d..0da3181 100644
--- a/lib/likely_prof.c
+++ b/lib/likely_prof.c
@@ -36,7 +36,7 @@ int do_check_likely(struct likeliness *likeliness, unsigned int ret)
 		 * disable and it was a bit cleaner then using internal __raw
 		 * spinlock calls.
 		 */
-		if (!test_and_set_bit(0, &likely_lock)) {
+		if (!test_and_set_bit_lock(0, &likely_lock)) {
 			if (likeliness->label & LP_UNSEEN) {
 				likeliness->label &= (~LP_UNSEEN);
 				likeliness->next = likeliness_head;
@@ -44,8 +44,7 @@ int do_check_likely(struct likeliness *likeliness, unsigned int ret)
 				likeliness->caller = (unsigned long)
 						__builtin_return_address(0);
 			}
-			smp_mb__before_clear_bit();
-			clear_bit(0, &likely_lock);
+			clear_bit_unlock(0, &likely_lock);
 		}
 	}
 
