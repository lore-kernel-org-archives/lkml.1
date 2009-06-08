Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbZFHVeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbZFHVeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 17:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755210AbZFHVd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 17:33:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:40229 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754873AbZFHVd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 17:33:57 -0400
Date: Mon, 8 Jun 2009 21:33:28 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, penberg@cs.helsinki.fi, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <Pine.LNX.4.64.0906082111030.12407@melkki.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0906082111030.12407@melkki.cs.Helsinki.FI>
Subject: [tip:perfcounters/core] perf_counter: Add mmap event hooks to mprotect()
Message-ID: <tip-dab5855b12411334355ba21349a06700e4ae7a3b@git.kernel.org>
Git-Commit-ID: dab5855b12411334355ba21349a06700e4ae7a3b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 08 Jun 2009 21:33:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dab5855b12411334355ba21349a06700e4ae7a3b
Gitweb:     http://git.kernel.org/tip/dab5855b12411334355ba21349a06700e4ae7a3b
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 8 Jun 2009 21:11:57 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 8 Jun 2009 23:10:43 +0200

perf_counter: Add mmap event hooks to mprotect()

Some JIT compilers allocate memory for generated code with
posix_memalign() + mprotect() so we need to hook into mprotect()
to make sure 'perf' is aware that we're executing code in
anonymous memory.

[ penberg@cs.helsinki.fi: move the hook to sys_mprotect() ]
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
LKML-Reference: <Pine.LNX.4.64.0906082111030.12407@melkki.cs.Helsinki.FI>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 mm/mprotect.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 258197b..d80311b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -23,6 +23,7 @@
 #include <linux/swapops.h>
 #include <linux/mmu_notifier.h>
 #include <linux/migrate.h>
+#include <linux/perf_counter.h>
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
 #include <asm/cacheflush.h>
@@ -299,6 +300,7 @@ SYSCALL_DEFINE3(mprotect, unsigned long, start, size_t, len,
 		error = mprotect_fixup(vma, &prev, nstart, tmp, newflags);
 		if (error)
 			goto out;
+		perf_counter_mmap(vma);
 		nstart = tmp;
 
 		if (nstart < prev->vm_end)
