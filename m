Return-Path: <linux-kernel-owner+w=401wt.eu-S1757364AbZKROwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbZKROwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757570AbZKROwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:52:01 -0500
Received: from server1.wserver.cz ([82.113.45.157]:51193 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757546AbZKROv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:51:58 -0500
From: Jiri Slaby <jslaby@novell.com>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org,
       Jiri Slaby <jslaby@novell.com>, James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-ia64@vger.kernel.org
Subject: [PATCH 03/16] IA64: use ACCESS_ONCE for rlimits
Date: Wed, 18 Nov 2009 15:51:49 +0100
Message-Id: <1258555922-2064-3-git-send-email-jslaby@novell.com>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <4B040A03.2020508@gmail.com>
References: <4B040A03.2020508@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure compiler won't do weird things with limits. E.g. fetching
them twice may return 2 different values after writable limits are
implemented.

Signed-off-by: Jiri Slaby <jslaby@novell.com>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/kernel/perfmon.c  |    2 +-
 arch/ia64/kernel/sys_ia64.c |    2 +-
 arch/ia64/mm/init.c         |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/ia64/kernel/perfmon.c b/arch/ia64/kernel/perfmon.c
index f178270..91b8607 100644
--- a/arch/ia64/kernel/perfmon.c
+++ b/arch/ia64/kernel/perfmon.c
@@ -2298,7 +2298,7 @@ pfm_smpl_buffer_alloc(struct task_struct *task, struct file *filp, pfm_context_t
 	 * if ((mm->total_vm << PAGE_SHIFT) + len> task->rlim[RLIMIT_AS].rlim_cur)
 	 * 	return -ENOMEM;
 	 */
-	if (size > task->signal->rlim[RLIMIT_MEMLOCK].rlim_cur)
+	if (size > ACCESS_ONCE(task->signal->rlim[RLIMIT_MEMLOCK].rlim_cur))
 		return -ENOMEM;
 
 	/*
diff --git a/arch/ia64/kernel/sys_ia64.c b/arch/ia64/kernel/sys_ia64.c
index 92ed83f..6a2b5d9 100644
--- a/arch/ia64/kernel/sys_ia64.c
+++ b/arch/ia64/kernel/sys_ia64.c
@@ -129,7 +129,7 @@ ia64_brk (unsigned long brk)
 		goto out;
 
 	/* Check against rlimit.. */
-	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
+	rlim = ACCESS_ONCE(current->signal->rlim[RLIMIT_DATA].rlim_cur);
 	if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
 		goto out;
 
diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 1857766..fe6d63f 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -91,7 +91,8 @@ dma_mark_clean(void *addr, size_t size)
 inline void
 ia64_set_rbs_bot (void)
 {
-	unsigned long stack_size = current->signal->rlim[RLIMIT_STACK].rlim_max & -16;
+	unsigned long stack_size = ACCESS_ONCE(current->signal->
+			rlim[RLIMIT_STACK].rlim_max) & -16;
 
 	if (stack_size > MAX_USER_STACK_SIZE)
 		stack_size = MAX_USER_STACK_SIZE;
-- 
1.6.4.2

