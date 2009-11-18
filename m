Return-Path: <linux-kernel-owner+w=401wt.eu-S1756796AbZKRBGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796AbZKRBGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 20:06:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756753AbZKRBGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 20:06:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:6829 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbZKRBGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 20:06:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Vo4v66vjXEcu+BWCURGLqHggJleuKTQFxO/9TB1w6s3ewESBerZjOVPsNan+BXxiE7
         oHraAAmeCUXwC/TM39VNCdN1YRC5WXgiVlzndZZ1d/XRJ59cm9OYTUt0JBYgnm7JCX0k
         d+5BwZi8GYdHxEs6dEmj2o+txOiyRqFnyEnGI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/2] lockdep: Don't only check recursive read locks once in a sequence
Date: Wed, 18 Nov 2009 02:06:38 +0100
Message-Id: <1258506398-5151-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1258506398-5151-1-git-send-email-fweisbec@gmail.com>
References: <1258506398-5151-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Say we have the following locks:
A (rwlock, Aw: writelock, Ar: recursive read lock)
B (normal lock)

and the following sequences:
Ar -> B -> Ar
Aw -> B

This won't be detected as a lock inversion because in the sequence
of locks held by the current task, if we have a same class acquired
as read-recursive several times, only the first one will be checked
in the tree (although all of them are checked for deadlocks in the
current held sequence).

Fix it by always adding recursive read locks in the dependency tree.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ming Lei <tom.leiming@gmail.com>
---
 kernel/lockdep.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index a6f7440..13d1d54 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -1949,9 +1949,9 @@ static int validate_chain(struct task_struct *curr, struct lockdep_map *lock,
 			hlock->read = 2;
 		/*
 		 * Add dependency only if this lock is not the head
-		 * of the chain, and if it's not a secondary read-lock:
+		 * of the chain.
 		 */
-		if (!chain_head && ret != 2)
+		if (!chain_head)
 			if (!check_prevs_add(curr, hlock))
 				return 0;
 		graph_unlock();
-- 
1.6.2.3

