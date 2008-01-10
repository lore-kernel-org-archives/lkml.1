Return-Path: <linux-kernel-owner+w=401wt.eu-S1756873AbYAJUPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873AbYAJUPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 15:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYAJUPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 15:15:45 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:55754 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbYAJUPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 15:15:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=IN0jt2MUjxqmZOt4PJb50gH8HQxALVLlUH04Hlhm6rs7jggCRcIq4kfKJpkJ36WxJFGwXcH6FNw68ontimw8rQ9PdOoSyaAqzkfL16ADvfeNzsjSzAtOfMAdE9vpOJNmYSQQNevmA4Gtm4M/N11kCnYLfIBs5dzJfci5SKrMI1A=
Subject: [PATCHv2] x86: Use wrmsrl in kprobes.c, step.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <478676AE.9000101@zytor.com>
References: <1199949482.19760.9.camel@brick>
	 <20080110124041.GA15156@elte.hu> <1199994043.19760.31.camel@brick>
	 <478676AE.9000101@zytor.com>
Content-Type: text/plain
Date: Thu, 10 Jan 2008 12:15:44 -0800
Message-Id: <1199996144.19760.33.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Where x86_32 passed zero in the high 32 bits, use wrmsrl which
will zero extend for us.  This allows ifdefs for 32/64 bit to
be eliminated.

Eliminate ifdef in step.c.  Similar cleanup was done when unifying
kprobes_32|64.c and wrmsr() was chosen there over wrmsrl().  This
patch changes these to wrmsrl.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Incorporating HPA's comment removing 0L.

 arch/x86/kernel/kprobes.c |    4 ++--
 arch/x86/kernel/step.c    |    4 ----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 53ba6a5..34becd1 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -410,13 +410,13 @@ static void __kprobes set_current_kprobe(struct kprobe *p, struct pt_regs *regs,
 static void __kprobes clear_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
-		wrmsr(MSR_IA32_DEBUGCTLMSR, 0, 0);
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, 0);
 }
 
 static void __kprobes restore_btf(void)
 {
 	if (test_thread_flag(TIF_DEBUGCTLMSR))
-		wrmsr(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr, 0);
+		wrmsrl(MSR_IA32_DEBUGCTLMSR, current->thread.debugctlmsr);
 }
 
 static void __kprobes prepare_singlestep(struct kprobe *p, struct pt_regs *regs)
diff --git a/arch/x86/kernel/step.c b/arch/x86/kernel/step.c
index 21ea22f..bf7047d 100644
--- a/arch/x86/kernel/step.c
+++ b/arch/x86/kernel/step.c
@@ -148,11 +148,7 @@ static void write_debugctlmsr(struct task_struct *child, unsigned long val)
 	if (child != current)
 		return;
 
-#ifdef CONFIG_X86_64
 	wrmsrl(MSR_IA32_DEBUGCTLMSR, val);
-#else
-	wrmsr(MSR_IA32_DEBUGCTLMSR, val, 0);
-#endif
 }
 
 /*
-- 
1.5.4.rc2.1164.g6451



