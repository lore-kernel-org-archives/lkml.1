Return-Path: <linux-kernel-owner+w=401wt.eu-S1755615AbZFHPvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbZFHPvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 11:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751257AbZFHPuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 11:50:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:55442 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbZFHPuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 11:50:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=ZBK8XOc/NhPvIpJ5aPOWtVs4r6oL8ijdOhvskQLyAJ3OC41jkWKzmmKNwAsb0ppDTV
         WYkFadpeThHjRJqrYNTmlNobtC4CeGKcpi6mKQsG8eSWIquGEleNXjbOLkgZWne7Mj+M
         t9FgLa7jTWecUvGSqIBDak0az0jBacDdMGE+I=
Date: Mon, 8 Jun 2009 23:50:43 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/8] kernel:lockdep:replace DFS with BFS
Message-ID: <20090608235043.02660ce4@linux-lm>
In-Reply-To: <1244463727.13761.8700.camel@twins>
References: <yes>
	<1243781365-26814-1-git-send-email-tom.leiming@gmail.com>
	<1244463727.13761.8700.camel@twins>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Jun 2009 14:22:07 +0200
Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Sun, 2009-05-31 at 22:49 +0800, tom.leiming@gmail.com wrote:
> > Hi,
> > Currently lockdep uses recursion DFS(depth-first search) algorithm
> > to search target in checking lock
> > circle(check_noncircular()),irq-safe ->
> > irq-unsafe(check_irq_usage()) and irq inversion when adding a new
> > lock dependency. This patches replace the current DFS with BFS,
> > based on the following consideration:
> > 
> >      1,no loss of efficiency, no matter DFS or BFS, the running time
> >      are O(V+E) (V is vertex count, and E is edge count of one
> >      graph);
> > 
> >      2,BFS may be easily implemented by circular queue and consumes
> >      much less kernel stack space than DFS for DFS is implemented by
> >      recursion.
> > 
> >      3, The shortest path can be obtained by BFS if the target is
> >      found, but can't be got by DFS. By the shortest path, we can
> >      shorten the lock dependency chain and help to troubleshoot lock
> >      problem easier than before.
> > 
> 
> OK, so I applied the patches and the cleanup below.
> 
> mostly little style nits and moving the circular queue into lockdep.c
> (nobody else uses it, so why share it?).
> 
> One thing though, macros with return statements?! that's seriously bad
> style, don't do that.
> 
> One thing that worries me a little is that we loose DaveM's
> lockdep_dependency_visit() optimization. My brain seems unwilling to
> co-operate on determining if BFS would make that redundant, so a
> little word on that would be appreciated.
> 
> Then I booted it and all hell broke loose, so either I wrecked
> something or you did :-), would you terribly mind poking at that a
> little?

I have fixed the bug, which is introduced in your patch:
	lockdep: clean up after BFS patches.

Please apply and verify the patch,thanks.

I'll go to bed,:-)

>From e99ce7b2b4985032e9f54b08a7790f3df2783286 Mon Sep 17 00:00:00 2001
From: Ming Lei <tom.leiming@gmail.com>
Date: Mon, 8 Jun 2009 23:38:59 +0800
Subject: [PATCH] kernel:lockdep:fix return value of check_usage*()

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




-- 
Lei Ming
