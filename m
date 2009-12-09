Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZLIReW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZLIReW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZLIReU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:34:20 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52269 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754242AbZLIReR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HH8QU6nDJYpnYw/9AenOHCq1YmejkEgZyBVQQU4oJC8VJK3JVNlXO5eL4rd4XGg5Gp
         On8Cg1cMebchzMf1mdnOzFn3uaDB6St5Pou6e+OAy+9I4lmFB6PAhDl7Af29x1SFZZuE
         12ASIpy/84uSoHfR2Yfk00Zx0/T1imMNrS9j4=
From: Brian Gerst <brgerst@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86, 64-bit: Use user_mode() to determine new stack pointer in copy_thread()
Date: Wed,  9 Dec 2009 12:34:41 -0500
Message-Id: <1260380084-3707-3-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
References: <1260380084-3707-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use user_mode() instead of a magic value for sp to determine when returning
to kernel mode.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/kernel/process_64.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 866b4b4..1d8b03d 100644
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
-- 
1.6.5.2

