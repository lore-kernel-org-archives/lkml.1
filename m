Return-Path: <linux-kernel-owner+w=401wt.eu-S934535AbZARQpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934535AbZARQpg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 11:45:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933801AbZARQjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 11:39:51 -0500
Received: from hera.kernel.org ([140.211.167.34]:37553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932988AbZARQjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 11:39:48 -0500
From: Tejun Heo <tj@kernel.org>
To: mingo@elte.hu, linux-kernel@vger.kernel.org, brgerst@gmail.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/12] x86-64: Move isidle from PDA to per-cpu.
Date: Mon, 19 Jan 2009 01:39:18 +0900
Message-Id: <1232296759-2253-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1232296759-2253-1-git-send-email-tj@kernel.org>
References: <1232296759-2253-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 16:39:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Brian Gerst <brgerst@gmail.com>

tj: s/isidle/is_idle/

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/include/asm/pda.h   |    1 -
 arch/x86/kernel/process_64.c |    5 +++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pda.h b/arch/x86/include/asm/pda.h
index b30ef6b..c31ca04 100644
--- a/arch/x86/include/asm/pda.h
+++ b/arch/x86/include/asm/pda.h
@@ -23,7 +23,6 @@ struct x8664_pda {
 					   offset 40!!! */
 #endif
 	short in_bootmem;		/* pda lives in bootmem */
-	short isidle;
 } ____cacheline_aligned_in_smp;
 
 DECLARE_PER_CPU(struct x8664_pda, __pda);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 4801289..4523ff8 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -61,6 +61,7 @@ DEFINE_PER_CPU(struct task_struct *, current_task) = &init_task;
 EXPORT_PER_CPU_SYMBOL(current_task);
 
 DEFINE_PER_CPU(unsigned long, old_rsp);
+static DEFINE_PER_CPU(unsigned char, is_idle);
 
 unsigned long kernel_thread_flags = CLONE_VM | CLONE_UNTRACED;
 
@@ -80,13 +81,13 @@ EXPORT_SYMBOL_GPL(idle_notifier_unregister);
 
 void enter_idle(void)
 {
-	write_pda(isidle, 1);
+	percpu_write(is_idle, 1);
 	atomic_notifier_call_chain(&idle_notifier, IDLE_START, NULL);
 }
 
 static void __exit_idle(void)
 {
-	if (test_and_clear_bit_pda(0, isidle) == 0)
+	if (x86_test_and_clear_bit_percpu(0, is_idle) == 0)
 		return;
 	atomic_notifier_call_chain(&idle_notifier, IDLE_END, NULL);
 }
-- 
1.6.0.2

