Return-Path: <linux-kernel-owner+w=401wt.eu-S933283AbZLKAqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933283AbZLKAqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762079AbZLKAqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:46:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:35794 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760532AbZLKAqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:46:38 -0500
Date: Fri, 11 Dec 2009 00:46:20 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260380084-3707-5-git-send-email-brgerst@gmail.com>
References: <1260380084-3707-5-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Sync 32/64-bit kernel_thread
Message-ID: <tip-f443ff4201dd25cd4dec183f9919ecba90c8edc2@git.kernel.org>
Git-Commit-ID: f443ff4201dd25cd4dec183f9919ecba90c8edc2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f443ff4201dd25cd4dec183f9919ecba90c8edc2
Gitweb:     http://git.kernel.org/tip/f443ff4201dd25cd4dec183f9919ecba90c8edc2
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 9 Dec 2009 12:34:43 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Dec 2009 15:55:39 -0800

x86: Sync 32/64-bit kernel_thread

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260380084-3707-5-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/process_32.c |    5 ++++-
 arch/x86/kernel/process_64.c |   11 +++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index bd874d2..f2e8b05 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -211,14 +211,17 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.si = (unsigned long) fn;
 	regs.di = (unsigned long) arg;
 
+#ifdef CONFIG_X86_32
 	regs.ds = __USER_DS;
 	regs.es = __USER_DS;
 	regs.fs = __KERNEL_PERCPU;
 	regs.gs = __KERNEL_STACK_CANARY;
+#endif
+
 	regs.orig_ax = -1;
 	regs.ip = (unsigned long) kernel_thread_helper;
 	regs.cs = __KERNEL_CS | get_kernel_rpl();
-	regs.flags = X86_EFLAGS_IF | X86_EFLAGS_SF | X86_EFLAGS_PF | 0x2;
+	regs.flags = X86_EFLAGS_IF | 0x2;
 
 	/* Ok, create the new process.. */
 	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 00ac66f..d49a909 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -248,10 +248,17 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.si = (unsigned long) fn;
 	regs.di = (unsigned long) arg;
 
+#ifdef CONFIG_X86_32
+	regs.ds = __USER_DS;
+	regs.es = __USER_DS;
+	regs.fs = __KERNEL_PERCPU;
+	regs.gs = __KERNEL_STACK_CANARY;
+#endif
+
 	regs.orig_ax = -1;
 	regs.ip = (unsigned long) kernel_thread_helper;
-	regs.cs = __KERNEL_CS;
-	regs.flags = X86_EFLAGS_IF;
+	regs.cs = __KERNEL_CS | get_kernel_rpl();
+	regs.flags = X86_EFLAGS_IF | 0x2;
 
 	/* Ok, create the new process.. */
 	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
