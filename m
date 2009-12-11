Return-Path: <linux-kernel-owner+w=401wt.eu-S1762112AbZLKAqP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762112AbZLKAqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:46:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762103AbZLKAqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:46:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:44584 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762045AbZLKAqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:46:07 -0500
Date: Fri, 11 Dec 2009 00:45:50 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       brgerst@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       brgerst@gmail.com, tglx@linutronix.de
In-Reply-To: <1260380084-3707-3-git-send-email-brgerst@gmail.com>
References: <1260380084-3707-3-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, 64-bit: Use user_mode() to determine new stack pointer in copy_thread()
Message-ID: <tip-fa4b8f84383ae197e643a46c36bf58ab8dffc95c@git.kernel.org>
Git-Commit-ID: fa4b8f84383ae197e643a46c36bf58ab8dffc95c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fa4b8f84383ae197e643a46c36bf58ab8dffc95c
Gitweb:     http://git.kernel.org/tip/fa4b8f84383ae197e643a46c36bf58ab8dffc95c
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Wed, 9 Dec 2009 12:34:41 -0500
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Thu, 10 Dec 2009 15:55:30 -0800

x86, 64-bit: Use user_mode() to determine new stack pointer in copy_thread()

Use user_mode() instead of a magic value for sp to determine when returning
to kernel mode.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
LKML-Reference: <1260380084-3707-3-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/process_64.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 92484c2..00ac66f 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -254,7 +254,7 @@ int kernel_thread(int (*fn)(void *), void *arg, unsigned long flags)
 	regs.flags = X86_EFLAGS_IF;
 
 	/* Ok, create the new process.. */
-	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, ~0UL, &regs, 0, NULL, NULL);
+	return do_fork(flags | CLONE_VM | CLONE_UNTRACED, 0, &regs, 0, NULL, NULL);
 }
 EXPORT_SYMBOL(kernel_thread);
 
@@ -312,8 +312,9 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 	*childregs = *regs;
 
 	childregs->ax = 0;
-	childregs->sp = sp;
-	if (sp == ~0UL)
+	if (user_mode(regs))
+		childregs->sp = sp;
+	else
 		childregs->sp = (unsigned long)childregs;
 
 	p->thread.sp = (unsigned long) childregs;
