Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZLIRea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZLIRea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbZLIRe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:34:27 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52269 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbZLIReX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:34:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=l4AHZIKZPdsWrx9bIzqab8nBZ4Yrt7Gk/zQHuW54K2a5NPZyLZkKqezEO2vqJUfLI/
         /6r3CFr2RdQqQcDP46SrJaXTZ0T5bO6kY9s9tLU8tAaysvyN9bfjDLnl0ENPo3e04RO1
         NqSnrNzdXBm7ZZiwpFvivgogMJsaLXY1ja9IY=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] x86: Sync 32/64-bit kernel_thread
Date: Wed,  9 Dec 2009 12:34:43 -0500
Message-Id: <1260380084-3707-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
References: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/process_32.c |    5 ++++-
 arch/x86/kernel/process_64.c |   11 +++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index ee0d4bc..e45aa22 100644
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
index 1d8b03d..54c9939 100644
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
-- 
1.6.5.2

