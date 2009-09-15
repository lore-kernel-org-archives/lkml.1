Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZIOJfu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZIOJfu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:35:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZIOJfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:35:48 -0400
Received: from hera.kernel.org ([140.211.167.34]:57385 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbZIOJfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:35:46 -0400
Date: Tue, 15 Sep 2009 09:35:13 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/core] perf_counter: Allow mmap if paranoid checks are turned off
Message-ID: <tip-459ec28ab404d7afcd512ce9b855959ad301605a@git.kernel.org>
Git-Commit-ID: 459ec28ab404d7afcd512ce9b855959ad301605a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 15 Sep 2009 09:35:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  459ec28ab404d7afcd512ce9b855959ad301605a
Gitweb:     http://git.kernel.org/tip/459ec28ab404d7afcd512ce9b855959ad301605a
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Sun, 13 Sep 2009 17:33:44 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 13 Sep 2009 17:33:44 +0200

perf_counter: Allow mmap if paranoid checks are turned off

Before:

  $ perf sched record -f sleep 1
  Error: failed to mmap with 1 (Operation not permitted)

After:

  $ perf sched record -f sleep 1
  [ perf record: Captured and wrote 0.095 MB perf.data (~4161 samples) ]

Note, this is only allowed if perfcounter_paranoid is set to
the most permissive (non-default) value of -1.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index e0d91fd..667ab25 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2315,7 +2315,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	lock_limit >>= PAGE_SHIFT;
 	locked = vma->vm_mm->locked_vm + extra;
 
-	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+	if ((locked > lock_limit) && perf_paranoid_tracepoint_raw() &&
+		!capable(CAP_IPC_LOCK)) {
 		ret = -EPERM;
 		goto unlock;
 	}
