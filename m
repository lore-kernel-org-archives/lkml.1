Return-Path: <linux-kernel-owner+w=401wt.eu-S933664AbZKXQ5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933664AbZKXQ5z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933645AbZKXQ5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:57:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:60342 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933643AbZKXQ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:57:48 -0500
Date: Tue, 24 Nov 2009 16:56:51 GMT
From: tip-bot for Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       tim@klingt.org, mingo@elte.hu
In-Reply-To: <4B0BBB9F.6080304@klingt.org>
References: <4B0BBB9F.6080304@klingt.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Optimize branch hint in context_switch()
Message-ID: <tip-710390d90f143a9ebb87a475215140f426792efd@git.kernel.org>
Git-Commit-ID: 710390d90f143a9ebb87a475215140f426792efd
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  710390d90f143a9ebb87a475215140f426792efd
Gitweb:     http://git.kernel.org/tip/710390d90f143a9ebb87a475215140f426792efd
Author:     Tim Blechmann <tim@klingt.org>
AuthorDate: Tue, 24 Nov 2009 11:55:27 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 12:18:42 +0100

sched: Optimize branch hint in context_switch()

Branch hint profiling on my nehalem machine showed over 90%
incorrect branch hints:

  10420275 170645395  94 context_switch                 sched.c
   3043
  10408421 171098521  94 context_switch                 sched.c
   3050

Signed-off-by: Tim Blechmann <tim@klingt.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0BBB9F.6080304@klingt.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 93474a7..010d5e1 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2829,14 +2829,14 @@ context_switch(struct rq *rq, struct task_struct *prev,
 	 */
 	arch_start_context_switch(prev);
 
-	if (unlikely(!mm)) {
+	if (likely(!mm)) {
 		next->active_mm = oldmm;
 		atomic_inc(&oldmm->mm_count);
 		enter_lazy_tlb(oldmm, next);
 	} else
 		switch_mm(oldmm, mm, next);
 
-	if (unlikely(!prev->mm)) {
+	if (likely(!prev->mm)) {
 		prev->active_mm = NULL;
 		rq->prev_mm = oldmm;
 	}
