Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbZKMTzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbZKMTzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 14:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757403AbZKMTzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 14:55:05 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50975 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756929AbZKMTyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 14:54:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=xtiEewMNJXtIvs61sjrlfJz98tHywZj418syvxBbsg2aGM9b5qQ0E/yvrjL48nBXBt
         fjFxUetVkANu5PaIHS2NOqqCBJkFL6kH381MSBr/VzvLwBbd3Ls0v3KohLKiHSYLTUTG
         HUo0aHmXxLbTMCaFvyeLqANqZ+mfYhuxhz+ao=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86, 64-bit: Use user_mode() to determine new stack pointer in copy_thread()
Date: Fri, 13 Nov 2009 14:54:58 -0500
Message-Id: <1258142098-3832-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258142098-3832-1-git-send-email-brgerst@gmail.com>
References: <1258142098-3832-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use user_mode() instead of a magic value for sp to determine when returning
to kernel mode.  This simplifies kernel_thread().

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/process.c    |    6 +-----
 arch/x86/kernel/process_64.c |    5 +++--
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 71a22c9..4ebe3e4 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -255,7 +255,6 @@ extern void kernel_thread_helper(void);
 int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 {
 	struct pt_regs regs;
-	unsigned long newsp;
 
 	memset(&regs, 0, sizeof(regs));
 
@@ -267,9 +266,6 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.es = __USER_DS;
 	regs.fs = __KERNEL_PERCPU;
 	regs.gs = __KERNEL_STACK_CANARY;
-	newsp = 0;
-#else
-	newsp = ~0UL;
 #endif
 
 	regs.orig_ax = -1;
@@ -278,7 +274,7 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.flags = X86_EFLAGS_IF | 2;
 
 	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, newsp, &regs, 0, NULL, NULL);
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
 }
 EXPORT_SYMBOL(kernel_thread);
 
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 8151a82..a9be0d5 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -283,8 +283,9 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	*childregs = *regs;
 
 	childregs->ax = 0;
-	childregs->sp = sp;
-	if (sp == ~0UL)
+	if (user_mode(regs))
+		childregs->sp = sp;
+	else
 		childregs->sp = (unsigned long)childregs;
 
 	p->thread.sp = (unsigned long) childregs;
-- 
1.6.2.5

