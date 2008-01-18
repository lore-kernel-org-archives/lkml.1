Return-Path: <linux-kernel-owner+w=401wt.eu-S1758566AbYARJSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758566AbYARJSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 04:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774AbYARJS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 04:18:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:35268 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102AbYARJS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 04:18:28 -0500
Date: Fri, 18 Jan 2008 10:18:10 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Zan Lynx <zlynx@acm.org>
Subject: Re: [2.6.24-rc8-mm1] Locking API boot-time self-tests hangs.
Message-ID: <20080118091810.GG24337@elte.hu>
References: <200801180120.m0I1KBuC065806@www262.sakura.ne.jp> <20080117181935.02294863.akpm@linux-foundation.org> <200801180319.m0I3Ju9N089501@www262.sakura.ne.jp> <20080117204247.5318e500.akpm@linux-foundation.org> <200801180640.m0I6enPI029212@www262.sakura.ne.jp> <a8e1da0801172259s3377895dwb0b2ca1dd781d11b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801172259s3377895dwb0b2ca1dd781d11b@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Young <hidave.darkstar@gmail.com> wrote:

> On Jan 18, 2008 2:40 PM, Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
> > Hello.
> >
> > Andrew Morton wrote:
> > > It could be compiler version dependent.  I used gcc-4.1.0.  Which version
> > > were you and Zan using please?
> 
> I have the same problem, gcc 3.4.6

is the patch below already in -rc8-mm1? hmm ... it appears it's not. 
Could you give it a try?

	Ingo

------------->
commit 5a26db5bd25cf4bf32ae9fa9f6136b6b6d5b45c5
Author: Nick Piggin <npiggin@suse.de>
Date:   Wed Jan 16 09:51:58 2008 +0100

    lockdep: fix internal double unlock during self-test
    Lockdep, during self-test (when it was simulating double unlocks) was
    sometimes unconditionally unlocking a spinlock when it had not been
    locked. This won't work for ticket locks.
    
    Signed-off-by: Nick Piggin <npiggin@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 723bd9f..4335f12 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2943,9 +2943,10 @@ void lockdep_free_key_range(void *start, unsigned long size)
 	struct list_head *head;
 	unsigned long flags;
 	int i;
+	int locked;
 
 	raw_local_irq_save(flags);
-	graph_lock();
+	locked = graph_lock();
 
 	/*
 	 * Unhash all classes that were created by this module:
@@ -2959,7 +2960,8 @@ void lockdep_free_key_range(void *start, unsigned long size)
 				zap_class(class);
 	}
 
-	graph_unlock();
+	if (locked)
+		graph_unlock();
 	raw_local_irq_restore(flags);
 }
 
@@ -2969,6 +2971,7 @@ void lockdep_reset_lock(struct lockdep_map *lock)
 	struct list_head *head;
 	unsigned long flags;
 	int i, j;
+	int locked;
 
 	raw_local_irq_save(flags);
 
@@ -2987,7 +2990,7 @@ void lockdep_reset_lock(struct lockdep_map *lock)
 	 * Debug check: in the end all mapped classes should
 	 * be gone.
 	 */
-	graph_lock();
+	locked = graph_lock();
 	for (i = 0; i < CLASSHASH_SIZE; i++) {
 		head = classhash_table + i;
 		if (list_empty(head))
@@ -3000,7 +3003,8 @@ void lockdep_reset_lock(struct lockdep_map *lock)
 			}
 		}
 	}
-	graph_unlock();
+	if (locked)
+		graph_unlock();
 
 out_restore:
 	raw_local_irq_restore(flags);

