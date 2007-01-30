Return-Path: <linux-kernel-owner+w=401wt.eu-S965514AbXA3OhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965514AbXA3OhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:37:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965513AbXA3OhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:37:04 -0500
Received: from il.qumranet.com ([62.219.232.206]:39324 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965518AbXA3OhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:37:01 -0500
Subject: [PATCH 1/11] KVM: optimize inline assembly
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:37:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130143700.0BB04A0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

forms like "0(%rsp)" generate an instruction with an unnecessary one byte
displacement under certain circumstances.  replace with the equivalent 
"(%rsp)".

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/drivers/kvm/vmx.c
===================================================================
--- linux-2.6.orig/drivers/kvm/vmx.c
+++ linux-2.6/drivers/kvm/vmx.c
@@ -1784,10 +1784,10 @@ again:
 		"kvm_vmx_return: "
 		/* Save guest registers, load host registers, keep flags */
 #ifdef CONFIG_X86_64
-		"xchg %3,     0(%%rsp) \n\t"
+		"xchg %3,     (%%rsp) \n\t"
 		"mov %%rax, %c[rax](%3) \n\t"
 		"mov %%rbx, %c[rbx](%3) \n\t"
-		"pushq 0(%%rsp); popq %c[rcx](%3) \n\t"
+		"pushq (%%rsp); popq %c[rcx](%3) \n\t"
 		"mov %%rdx, %c[rdx](%3) \n\t"
 		"mov %%rsi, %c[rsi](%3) \n\t"
 		"mov %%rdi, %c[rdi](%3) \n\t"
@@ -1802,24 +1802,24 @@ again:
 		"mov %%r15, %c[r15](%3) \n\t"
 		"mov %%cr2, %%rax   \n\t"
 		"mov %%rax, %c[cr2](%3) \n\t"
-		"mov 0(%%rsp), %3 \n\t"
+		"mov (%%rsp), %3 \n\t"
 
 		"pop  %%rcx; pop  %%r15; pop  %%r14; pop  %%r13; pop  %%r12;"
 		"pop  %%r11; pop  %%r10; pop  %%r9;  pop  %%r8;"
 		"pop  %%rbp; pop  %%rdi; pop  %%rsi;"
 		"pop  %%rdx; pop  %%rbx; pop  %%rax \n\t"
 #else
-		"xchg %3, 0(%%esp) \n\t"
+		"xchg %3, (%%esp) \n\t"
 		"mov %%eax, %c[rax](%3) \n\t"
 		"mov %%ebx, %c[rbx](%3) \n\t"
-		"pushl 0(%%esp); popl %c[rcx](%3) \n\t"
+		"pushl (%%esp); popl %c[rcx](%3) \n\t"
 		"mov %%edx, %c[rdx](%3) \n\t"
 		"mov %%esi, %c[rsi](%3) \n\t"
 		"mov %%edi, %c[rdi](%3) \n\t"
 		"mov %%ebp, %c[rbp](%3) \n\t"
 		"mov %%cr2, %%eax  \n\t"
 		"mov %%eax, %c[cr2](%3) \n\t"
-		"mov 0(%%esp), %3 \n\t"
+		"mov (%%esp), %3 \n\t"
 
 		"pop %%ecx; popa \n\t"
 #endif
