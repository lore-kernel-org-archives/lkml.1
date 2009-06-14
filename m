Return-Path: <linux-kernel-owner+w=401wt.eu-S1759220AbZFNUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220AbZFNUl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZFNUlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 16:41:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:50060 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbZFNUlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 16:41:18 -0400
Date: Sun, 14 Jun 2009 20:39:30 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, efault@gmx.de, arjan@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, penberg@cs.helsinki.fi,
       a.p.zijlstra@chello.nl, efault@gmx.de, arjan@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter, x86: Fix call-chain walking
Message-ID: <tip-5a6cec3abbdb74244caab68db100825a8c4ac02d@git.kernel.org>
Git-Commit-ID: 5a6cec3abbdb74244caab68db100825a8c4ac02d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 14 Jun 2009 20:39:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a6cec3abbdb74244caab68db100825a8c4ac02d
Gitweb:     http://git.kernel.org/tip/5a6cec3abbdb74244caab68db100825a8c4ac02d
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 29 May 2009 11:25:09 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 14 Jun 2009 22:37:15 +0200

perf_counter, x86: Fix call-chain walking

Fix the ptregs variant when we hit user-mode tasks.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 77a59a5..09d8cb6 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -1644,7 +1644,9 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 	const void __user *fp;
 	int nr = entry->nr;
 
-	regs = (struct pt_regs *)current->thread.sp0 - 1;
+	if (!user_mode(regs))
+		regs = task_pt_regs(current);
+
 	fp   = (void __user *)regs->bp;
 
 	callchain_store(entry, regs->ip);
@@ -1656,7 +1658,7 @@ perf_callchain_user(struct pt_regs *regs, struct perf_callchain_entry *entry)
 		if (!copy_stack_frame(fp, &frame))
 			break;
 
-		if ((unsigned long)fp < user_stack_pointer(regs))
+		if ((unsigned long)fp < regs->sp)
 			break;
 
 		callchain_store(entry, frame.return_address);
