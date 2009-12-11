Return-Path: <linux-kernel-owner+w=401wt.eu-S1759040AbZLKPhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040AbZLKPhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbZLKPg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:36:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:57507 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758875AbZLKPg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:36:57 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 7/9] kgdb,x86: do not set kgdb_single_step on x86
Date: Fri, 11 Dec 2009 09:36:15 -0600
Message-Id: <1260545777-8089-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1260545777-8089-7-git-send-email-jason.wessel@windriver.com>
References: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-2-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-3-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-4-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-5-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-6-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-7-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 Dec 2009 15:36:34.0816 (UTC) FILETIME=[B879B000:01CA7A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an SMP system the kgdb_single_step flag has the possibility to
indefinitely hang the system in the case.  Consider the case where,
CPU 1 has the schedule lock and CPU 0 is set to single step, there is
no way for CPU 0 to run another task.

The easy way to observe the problem is to make 2 cpus busy, and run
the kgdb test suite.  You will see that it hangs the system very
quickly.

while [ 1 ] ; do find /proc > /dev/null 2>&1 ; done &
while [ 1 ] ; do find /proc > /dev/null 2>&1 ; done &
echo V1 > /sys/module/kgdbts/parameters/kgdbts

The side effect of this patch is that there is the possibility
to miss a breakpoint in the case that a single step operation
was executed to step over a breakpoint in common code.

The trade off of the missed breakpoint is preferred to
hanging the kernel.  This can be fixed in the future by
using kprobes or another strategy to step over planted
breakpoints with out of line execution.

CC: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index aefae46..dd74fe7 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -400,7 +400,6 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 		/* set the trace bit if we're stepping */
 		if (remcomInBuffer[0] == 's') {
 			linux_regs->flags |= X86_EFLAGS_TF;
-			kgdb_single_step = 1;
 			atomic_set(&kgdb_cpu_doing_single_step,
 				   raw_smp_processor_id());
 		}
-- 
1.6.4.rc1

