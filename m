Return-Path: <linux-kernel-owner+w=401wt.eu-S1758294AbZF1PHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294AbZF1PHy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 11:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757850AbZF1PGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 11:06:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:55103 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbZF1PGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 11:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=LQecrLUgm1QOz6RTzZ8gQ42v+SoGv5Po3UhfZRgyFzmr+uE9zwheuhebB7ZxBurT3N
         td+1v5PmvZJrWNbJNJWgywQISY7rvKScgpQbYWMX1dmHpDpeABe9h/7b48IIL2c7ajCC
         Oqtg/DTAePSbglbLXocCbtz61Xy6toFZ6t7VM=
From: tom.leiming@gmail.com
To: a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       Ming Lei <tom.leiming@gmail.com>
Subject: [RESEND PATCH 11/11] kernel:lockdep:fix return value of check_usage*()
Date: Sun, 28 Jun 2009 23:04:46 +0800
Message-Id: <1246201486-7308-12-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.6.0.GIT
In-Reply-To: <1246201486-7308-11-git-send-email-tom.leiming@gmail.com>
References: <1246201486-7308-1-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-2-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-3-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-4-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-5-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-6-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-7-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-8-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-9-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-10-git-send-email-tom.leiming@gmail.com>
 <1246201486-7308-11-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

Return zero if BFS find the target, so fix return value of callers
of BFS.

The patch fixes the boot failure introduced by the patch:
	lockdep: clean up after BFS patches
.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 09a141f..48c3364 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1250,8 +1250,6 @@ find_usage_forwards(struct lock_list *root, enum lock_usage_bit bit,
 	debug_atomic_inc(&nr_find_usage_forwards_checks);
 
 	result = __bfs_forwards(root, (void *)bit, usage_match, target_entry);
-	if (result < 0)
-		return print_bfs_bug(result);
 
 	return result;
 }
@@ -1275,8 +1273,6 @@ find_usage_backwards(struct lock_list *root, enum lock_usage_bit bit,
 	debug_atomic_inc(&nr_find_usage_backwards_checks);
 
 	result = __bfs_backwards(root, (void *)bit, usage_match, target_entry);
-	if (result < 0)
-		return print_bfs_bug(result);
 
 	return result;
 }
@@ -1397,13 +1393,17 @@ check_usage(struct task_struct *curr, struct held_lock *prev,
 
 	this.class = hlock_class(prev);
 	ret = find_usage_backwards(&this, bit_backwards, &target_entry);
-	if (!ret || ret == 1)
+	if (ret < 0)
+		return print_bfs_bug(ret);
+	if (ret == 1)
 		return ret;
 
 	that.parent = NULL;
 	that.class = hlock_class(next);
 	ret = find_usage_forwards(&that, bit_forwards, &target_entry1);
-	if (!ret || ret == 1)
+	if (ret < 0)
+		return print_bfs_bug(ret);
+	if (ret == 1)
 		return ret;
 
 	return print_bad_irq_dependency(curr, &this, &that,
@@ -2088,7 +2088,9 @@ check_usage_forwards(struct task_struct *curr, struct held_lock *this,
 	root.parent = NULL;
 	root.class = hlock_class(this);
 	ret = find_usage_forwards(&root, bit, &target_entry);
-	if (!ret || ret == 1)
+	if (ret < 0)
+		return print_bfs_bug(ret);
+	if (ret == 1)
 		return ret;
 
 	return print_irq_inversion_bug(curr, &root, target_entry,
@@ -2110,7 +2112,9 @@ check_usage_backwards(struct task_struct *curr, struct held_lock *this,
 	root.parent = NULL;
 	root.class = hlock_class(this);
 	ret = find_usage_backwards(&root, bit, &target_entry);
-	if (!ret || ret == 1)
+	if (ret < 0)
+		return print_bfs_bug(ret);
+	if (ret == 1)
 		return ret;
 
 	return print_irq_inversion_bug(curr, &root, target_entry,
-- 
1.6.0.GIT

