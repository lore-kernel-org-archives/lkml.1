Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZFHSMG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZFHSMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 14:12:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbZFHSL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 14:11:56 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:53468 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZFHSL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 14:11:56 -0400
Date: Mon, 8 Jun 2009 21:11:57 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, acme@redhat.com
Subject: [PATCH 1/2] perf_counter: Add mmap event hooks to mprotect()
Message-ID: <Pine.LNX.4.64.0906082111030.12407@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Some JIT compilers allocate memory for generated code with
posix_memalign() + mprotect() so we need to hook into mprotect() to make
sure 'perf' is aware that we're executing code in anonymous memory.

[ penberg@cs.helsinki.fi: move the hook to sys_mprotect() ]
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
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
-- 
1.5.6.3

