Return-Path: <linux-kernel-owner+w=401wt.eu-S1755640AbZBINkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640AbZBINkq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbZBINkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:40:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:37785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964AbZBINkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:40:37 -0500
From: Tejun Heo <tj@kernel.org>
To: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/11] elf: add ELF_CORE_COPY_KERNEL_REGS()
Date: Mon,  9 Feb 2009 22:39:51 +0900
Message-Id: <1234186798-16820-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1234186798-16820-1-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 09 Feb 2009 13:40:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ELF core dump is used for both user land core dump and kernel crash
dump.  Depending on architecture, register might need to be accessed
differently for userland and kernel.  Allow architectures to define
ELF_CORE_COPY_KERNEL_REGS() and use different operation for kernel
register dump.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/elfcore.h |    9 +++++++++
 kernel/kexec.c          |    2 +-
 2 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 5ca54d7..7605c5e 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -111,6 +111,15 @@ static inline void elf_core_copy_regs(elf_gregset_t *elfregs, struct pt_regs *re
 #endif
 }
 
+static inline void elf_core_copy_kernel_regs(elf_gregset_t *elfregs, struct pt_regs *regs)
+{
+#ifdef ELF_CORE_COPY_KERNEL_REGS
+	ELF_CORE_COPY_KERNEL_REGS((*elfregs), regs);
+#else
+	elf_core_copy_regs(elfregs, regs);
+#endif
+}
+
 static inline int elf_core_copy_task_regs(struct task_struct *t, elf_gregset_t* elfregs)
 {
 #ifdef ELF_CORE_COPY_TASK_REGS
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 8a6d7b0..795e7b6 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1130,7 +1130,7 @@ void crash_save_cpu(struct pt_regs *regs, int cpu)
 		return;
 	memset(&prstatus, 0, sizeof(prstatus));
 	prstatus.pr_pid = current->pid;
-	elf_core_copy_regs(&prstatus.pr_reg, regs);
+	elf_core_copy_kernel_regs(&prstatus.pr_reg, regs);
 	buf = append_elf_note(buf, KEXEC_CORE_NOTE_NAME, NT_PRSTATUS,
 		      	      &prstatus, sizeof(prstatus));
 	final_note(buf);
-- 
1.6.0.2

