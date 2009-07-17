Return-Path: <linux-kernel-owner+w=401wt.eu-S934559AbZGQNMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934559AbZGQNMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 09:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934491AbZGQNMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 09:12:00 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41068 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934419AbZGQNL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 09:11:59 -0400
Subject: [PATCH] kmemleak: Protect the seq start/next/stop sequence by
	rcu_read_lock()
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 17 Jul 2009 14:11:57 +0100
Message-ID: <20090717131043.24954.4134.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc1-6-gcef5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2009 13:11:58.0226 (UTC) FILETIME=[2A19DF20:01CA06E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Objects passed to kmemleak_seq_next() have an incremented reference
count (hence not freed) but they may point via object_list.next to
other freed objects. To avoid this, the whole start/next/stop sequence
must be protected by rcu_read_lock().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---

This is a fix for bug #13761 raised on bugzilla.kernel.org.

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

