Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbZBJOwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbZBJOwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:52:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084AbZBJOvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:51:48 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:22264 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbZBJOvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:51:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=FS/zfUwrKTpKh6htHN0BD/xBeS6Y3+WzLVQP7UQ643C/v7mU98ZigVBWpSle4okBk0
         AVdA1ul7N3JPAPwKTSvCfN+gKBtLzizHyrqt5sCsIRoVw5GGieH80lq7LC56ut2HZnAr
         mIVuULBdx+gy6DqUa3e/DouCpOfylAkX1E6bk=
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: Use pt_regs pointer in do_device_not_available()
Date: Tue, 10 Feb 2009 09:51:45 -0500
Message-Id: <1234277507-4987-2-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
References: <1234277507-4987-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generic exception handler (error_code) passes in the pt_regs
pointer and the error code (unused in this case).  The commit
"x86: fix math_emu register frame access" changed this to pass by
value, which doesn't work correctly with stack protector enabled.
Change it back to use the pt_regs pointer.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/traps.h |    2 +-
 arch/x86/kernel/traps.c      |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index cf3bb05..0d53425 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -41,7 +41,7 @@ dotraplinkage void do_int3(struct pt_regs *, long);
 dotraplinkage void do_overflow(struct pt_regs *, long);
 dotraplinkage void do_bounds(struct pt_regs *, long);
 dotraplinkage void do_invalid_op(struct pt_regs *, long);
-dotraplinkage void do_device_not_available(struct pt_regs);
+dotraplinkage void do_device_not_available(struct pt_regs *, long);
 dotraplinkage void do_coprocessor_segment_overrun(struct pt_regs *, long);
 dotraplinkage void do_invalid_TSS(struct pt_regs *, long);
 dotraplinkage void do_segment_not_present(struct pt_regs *, long);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 3b7b2e1..71a8f87 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -905,19 +905,20 @@ void math_emulate(struct math_emu_info *info)
 }
 #endif /* CONFIG_MATH_EMULATION */
 
-dotraplinkage void __kprobes do_device_not_available(struct pt_regs regs)
+dotraplinkage void __kprobes
+do_device_not_available(struct pt_regs *regs, long error_code)
 {
 #ifdef CONFIG_X86_32
 	if (read_cr0() & X86_CR0_EM) {
 		struct math_emu_info info = { };
 
-		conditional_sti(&regs);
+		conditional_sti(regs);
 
-		info.regs = &regs;
+		info.regs = regs;
 		math_emulate(&info);
 	} else {
 		math_state_restore(); /* interrupts still off */
-		conditional_sti(&regs);
+		conditional_sti(regs);
 	}
 #else
 	math_state_restore();
-- 
1.6.1

