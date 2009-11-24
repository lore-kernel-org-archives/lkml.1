Return-Path: <linux-kernel-owner+w=401wt.eu-S933593AbZKXQ55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbZKXQ55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 11:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933566AbZKXQ54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 11:57:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:60347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933652AbZKXQ5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 11:57:51 -0500
Date: Tue, 24 Nov 2009 16:57:05 GMT
From: tip-bot for Tim Blechmann <tim@klingt.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, tim@klingt.org, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       tim@klingt.org, mingo@elte.hu
In-Reply-To: <4B0BBB93.3080307@klingt.org>
References: <4B0BBB93.3080307@klingt.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, x86: Optimize branch hint in __switch_to()
Message-ID: <tip-a3a1de0c34de6f5f8332cd6151c46af7813c0fcb@git.kernel.org>
Git-Commit-ID: a3a1de0c34de6f5f8332cd6151c46af7813c0fcb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a3a1de0c34de6f5f8332cd6151c46af7813c0fcb
Gitweb:     http://git.kernel.org/tip/a3a1de0c34de6f5f8332cd6151c46af7813c0fcb
Author:     Tim Blechmann <tim@klingt.org>
AuthorDate: Tue, 24 Nov 2009 11:55:15 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 24 Nov 2009 12:20:04 +0100

sched, x86: Optimize branch hint in __switch_to()

Branch hint profiling on my nehalem machine showed 96%
incorrect branch hints:

  6548732 174664120  96 __switch_to                    process_64.c
    406
  6548745 174565593  96 __switch_to                    process_64.c
    410

Signed-off-by: Tim Blechmann <tim@klingt.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <4B0BBB93.3080307@klingt.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/process_64.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ad535b6..d9db104 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -406,11 +406,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	 * This won't pick up thread selector changes, but I guess that is ok.
 	 */
 	savesegment(es, prev->es);
-	if (unlikely(next->es | prev->es))
+	if (next->es | prev->es)
 		loadsegment(es, next->es);
-
 	savesegment(ds, prev->ds);
-	if (unlikely(next->ds | prev->ds))
+	if (next->ds | prev->ds)
 		loadsegment(ds, next->ds);
 
 
