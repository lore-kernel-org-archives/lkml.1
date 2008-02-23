Return-Path: <linux-kernel-owner+w=401wt.eu-S935521AbYBWIch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935521AbYBWIch (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936905AbYBWIUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:20:33 -0500
Received: from qb-out-0506.google.com ([72.14.204.229]:41798 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936200AbYBWIU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:20:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y7vh+Hq2HIK3Ox5C4TQEoOl/ffLU9jt/cWR0P1P6L40NqBISqXGjtBiv/O/WkFPqYNDlT3Rs/l2zq/bKMTxIUrB9b4o3bdKZbbgCD0sjXXU/CcJGhtr3k3dAuehDxrDbFLXUGvVBPbAbIk0v37Vpf4iGBizYLRWG5WtiGe6lBkE=
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 07/16] arm: use get_personality()
Date: Sat, 23 Feb 2008 16:14:10 +0800
Message-Id: <12037545311452-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: <1203754519825-git-send-email-xiyou.wangcong@gmail.com>
References: <12037544592096-git-send-email-xiyou.wangcong@gmail.com>
 <12037544671847-git-send-email-xiyou.wangcong@gmail.com>
 <1203754478165-git-send-email-xiyou.wangcong@gmail.com>
 <1203754488669-git-send-email-xiyou.wangcong@gmail.com>
 <12037544991876-git-send-email-xiyou.wangcong@gmail.com>
 <1203754509934-git-send-email-xiyou.wangcong@gmail.com>
 <1203754519825-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use get_personality() macro instead of explicit reference
for arm code.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Russell King <rmk@arm.linux.org.uk>

---
 arch/arm/kernel/traps.c     |    4 ++--
 include/asm-arm/namei.h     |    2 +-
 include/asm-arm/processor.h |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/traps.c b/arch/arm/kernel/traps.c
index 5595fdd..975faaf 100644
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -381,8 +381,8 @@ static int bad_syscall(int n, struct pt_regs *regs)
 	struct thread_info *thread = current_thread_info();
 	siginfo_t info;
 
-	if (current->personality != PER_LINUX &&
-	    current->personality != PER_LINUX_32BIT &&
+	if (get_personality() != PER_LINUX &&
+	    get_personality() != PER_LINUX_32BIT &&
 	    thread->exec_domain->handler) {
 		thread->exec_domain->handler(n, regs);
 		return regs->ARM_r0;
diff --git a/include/asm-arm/namei.h b/include/asm-arm/namei.h
index a402d3b..c55dc87 100644
--- a/include/asm-arm/namei.h
+++ b/include/asm-arm/namei.h
@@ -14,7 +14,7 @@
 
 static inline char *__emul_prefix(void)
 {
-	switch (current->personality) {
+	switch (get_personality()) {
 	case PER_BSD:
 		return ARM_BSD_EMUL;
 	default:
diff --git a/include/asm-arm/processor.h b/include/asm-arm/processor.h
index bd8029e..7f040b4 100644
--- a/include/asm-arm/processor.h
+++ b/include/asm-arm/processor.h
@@ -23,7 +23,7 @@
 #include <asm/types.h>
 
 #ifdef __KERNEL__
-#define STACK_TOP	((current->personality == PER_LINUX_32BIT) ? \
+#define STACK_TOP	((get_personality() == PER_LINUX_32BIT) ? \
 			 TASK_SIZE : TASK_SIZE_26)
 #define STACK_TOP_MAX	TASK_SIZE
 #endif
@@ -65,7 +65,7 @@ struct thread_struct {
 	unsigned long *stack = (unsigned long *)sp;			\
 	set_fs(USER_DS);						\
 	memzero(regs->uregs, sizeof(regs->uregs));			\
-	if (current->personality & ADDR_LIMIT_32BIT)			\
+	if (get_personality() & ADDR_LIMIT_32BIT)			\
 		regs->ARM_cpsr = USR_MODE;				\
 	else								\
 		regs->ARM_cpsr = USR26_MODE;				\
-- 
1.5.3.8

