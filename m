Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbXFVS0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbXFVS0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 14:26:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759411AbXFVSZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 14:25:34 -0400
Received: from faui03.informatik.uni-erlangen.de ([131.188.30.103]:61080 "EHLO
	faui03.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759247AbXFVSZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 14:25:31 -0400
From: Alexander Wuerstlein <arw@arw.name>
To: linux-kernel@vger.kernel.org
Cc: Alexander Wuerstlein <arw@arw.name>,
       Johannes Schlumberger <spjsschl@stud.informatik.uni-erlangen.de>
Subject: [PATCH] sns: add syscall to check signed state of a process [4/4]
Date: Fri, 22 Jun 2007 20:25:29 +0200
Message-Id: <11825367293600-git-send-email-arw@arw.name>
X-Mailer: git-send-email 1.5.2.1
In-Reply-To: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
References: <20070621155516.GA6838@faui01.informatik.uni-erlangen.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Makes it possible for a userspace process to ask for the trustworthiness of
another process.

Signed-off-by: Johannes Schlumberger <spjsschl@cip.informatik.uni-erlangen.de>
---
 arch/i386/kernel/syscall_table.S |    1 +
 include/asm-i386/unistd.h        |    3 ++-
 security/sns.c                   |   15 +++++++++++++++
 3 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/syscall_table.S b/arch/i386/kernel/syscall_table.S
index bf6adce..e8ba35a 100644
--- a/arch/i386/kernel/syscall_table.S
+++ b/arch/i386/kernel/syscall_table.S
@@ -323,3 +323,4 @@ ENTRY(sys_call_table)
 	.long sys_signalfd
 	.long sys_timerfd
 	.long sys_eventfd
+	.long sys_sns_is_trusted	/* 320 */
diff --git a/include/asm-i386/unistd.h b/include/asm-i386/unistd.h
index e84ace1..3f8df3e 100644
--- a/include/asm-i386/unistd.h
+++ b/include/asm-i386/unistd.h
@@ -329,10 +329,11 @@
 #define __NR_signalfd		321
 #define __NR_timerfd		322
 #define __NR_eventfd		323
+#define __NR_sns_is_trusted	324
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 324
+#define NR_syscalls 325
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/security/sns.c b/security/sns.c
index 3192a90..1978f7c 100644
--- a/security/sns.c
+++ b/security/sns.c
@@ -112,3 +112,18 @@ int sns_signature_valid(struct file *file)
 	crypto_free_hash(tfm);
 	return ret;
 }
+
+asmlinkage int sys_sns_is_trusted(pid_t p)
+{
+	struct task_struct *t;
+	rcu_read_lock();
+	t = find_task_by_pid(p);
+	if (IS_ERR(t)) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	p = t->sns_valid_sig; /*locking needed*/
+	rcu_read_unlock();
+	return p;
+}
+EXPORT_SYMBOL_GPL(sys_sns_is_trusted);
-- 
1.5.2.1

