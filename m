Return-Path: <linux-kernel-owner+w=401wt.eu-S1754692AbZG2P1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692AbZG2P1F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752628AbZG2P1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:27:04 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:59181 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516AbZG2P1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:27:03 -0400
Subject: [PATCH] kmemleak: Protect the seq start/next/stop sequence by
	rcu_read_lock()
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Wed, 29 Jul 2009 16:26:57 +0100
Message-ID: <20090729152101.1878.71159.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-9-gd8846
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jul 2009 15:26:57.0604 (UTC) FILETIME=[02A9E040:01CA1061]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Objects passed to kmemleak_seq_next() have an incremented reference
count (hence not freed) but they may point via object_list.next to
other freed objects. To avoid this, the whole start/next/stop sequence
must be protected by rcu_read_lock().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

This is a fix for bug #13761 in buzilla.kernel.org. If there are no
objections, please apply it before 2.6.31. Thanks.

 mm/kmemleak.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 5aabd41..4872673 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1217,7 +1217,6 @@ static void *kmemleak_seq_start(struct seq_file *seq, loff_t *pos)
 	}
 	object = NULL;
 out:
-	rcu_read_unlock();
 	return object;
 }
 
@@ -1233,13 +1232,11 @@ static void *kmemleak_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 
 	++(*pos);
 
-	rcu_read_lock();
 	list_for_each_continue_rcu(n, &object_list) {
 		next_obj = list_entry(n, struct kmemleak_object, object_list);
 		if (get_object(next_obj))
 			break;
 	}
-	rcu_read_unlock();
 
 	put_object(prev_obj);
 	return next_obj;
@@ -1255,6 +1252,7 @@ static void kmemleak_seq_stop(struct seq_file *seq, void *v)
 		 * kmemleak_seq_start may return ERR_PTR if the scan_mutex
 		 * waiting was interrupted, so only release it if !IS_ERR.
 		 */
+		rcu_read_unlock();
 		mutex_unlock(&scan_mutex);
 		if (v)
 			put_object(v);

