Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbZFEITO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbZFEITO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:19:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZFEIGq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:46 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37479 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698AbZFEIGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:06:04 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 39/62] Blackfin: make sure stack is accessible before dumping it
Date: Fri,  5 Jun 2009 04:04:48 -0400
Message-Id: <1244189111-19639-40-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

When displaying a crash dump, make sure accessing the stack is safe so
we don't crash at the same time.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/traps.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index fb57742..0d04a47 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -196,6 +196,11 @@ done:
 
 asmlinkage void double_fault_c(struct pt_regs *fp)
 {
+#ifdef CONFIG_DEBUG_BFIN_HWTRACE_ON
+	int j;
+	trace_buffer_save(j);
+#endif
+
 	console_verbose();
 	oops_in_progress = 1;
 #ifdef CONFIG_DEBUG_VERBOSE
@@ -220,6 +225,7 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
 		dump_bfin_process(fp);
 		dump_bfin_mem(fp);
 		show_regs(fp);
+		dump_bfin_trace_buffer();
 	}
 #endif
 	panic("Double Fault - unrecoverable event");
@@ -832,6 +838,11 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 	decode_address(buf, (unsigned int)stack);
 	printk(KERN_NOTICE " SP: [0x%p] %s\n", stack, buf);
 
+	if (!access_ok(VERIFY_READ, stack, (unsigned int)endstack - (unsigned int)stack)) {
+		printk(KERN_NOTICE "Invalid stack pointer\n");
+		return;
+	}
+
 	/* First thing is to look for a frame pointer */
 	for (addr = (unsigned int *)((unsigned int)stack & ~0xF); addr < endstack; addr++) {
 		if (*addr & 0x1)
-- 
1.6.3.1

