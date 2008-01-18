Return-Path: <linux-kernel-owner+w=401wt.eu-S1757911AbYARE3G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbYARE3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 23:29:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751514AbYARE24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 23:28:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.184]:18931 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYARE2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 23:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nMKrMBQszq2qpKtgUn3qBFnOgV7sq1+q+zuV72u8ZibdzKSCtAzF+VbaYgBu7Qzy8Obq2yi5bfwm74RXXZP6mfpB7Z4GW9oNq4OQyCdgm0Sq6nd+IUH8lbCsK+6N+W9JSCMZzQwBx5Qz67xLcPUCTS5H7ZcieqSr9iMmlfmNuok=
Subject: [PATCH] x86: Rename stack_pointer to kernel_trap_sp
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <47901E89.4060001@zytor.com>
References: <1200611078.5724.46.camel@brick>	<478FDE76.3070309@zytor.com>
	 <1200612389.5724.63.camel@brick>	<478FF9F3.9030604@zytor.com>
	 <1200618952.5724.85.camel@brick>
	 <20080118013712.4090526FA0B@magilla.localdomain>
	 <479002B6.9030607@zytor.com> <1200622862.5724.106.camel@brick>
	 <47901E89.4060001@zytor.com>
Content-Type: text/plain
Date: Thu, 17 Jan 2008 20:28:49 -0800
Message-Id: <1200630529.5724.116.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Choose a less generic name for such a special case.  Add
a comment explaining the odd use in X86_32.

Change the one user of stack_pointer.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/oprofile/backtrace.c |    2 +-
 include/asm-x86/ptrace.h      |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/oprofile/backtrace.c b/arch/x86/oprofile/backtrace.c
index 0ca4815..e2095cb 100644
--- a/arch/x86/oprofile/backtrace.c
+++ b/arch/x86/oprofile/backtrace.c
@@ -77,7 +77,7 @@ void
 x86_backtrace(struct pt_regs * const regs, unsigned int depth)
 {
 	struct frame_head *head = (struct frame_head *)frame_pointer(regs);
-	unsigned long stack = stack_pointer(regs);
+	unsigned long stack = kernel_trap_sp(regs);
 
 	if (!user_mode_vm(regs)) {
 		if (depth)
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 79d5b8f..d9e04b4 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -182,7 +182,13 @@ static inline int v8086_mode(struct pt_regs *regs)
 #endif
 }
 
-static inline unsigned long stack_pointer(struct pt_regs *regs)
+/*
+ * X86_32 CPUs don't save ss and esp if the CPU is already in kernel mode
+ * when it traps.  So regs will be the current sp.
+ *
+ * This is valid only for kernel mode traps.
+ */
+static inline unsigned long kernel_trap_sp(struct pt_regs *regs)
 {
 #ifdef CONFIG_X86_32
 	return (unsigned long)regs;
-- 
1.5.4.rc2.1164.g6451



