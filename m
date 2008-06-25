Return-Path: <linux-kernel-owner+w=401wt.eu-S1759153AbYFYEnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbYFYEnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 00:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755849AbYFYEh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 00:37:27 -0400
Received: from 9.sub-70-198-159.myvzw.com ([70.198.159.9]:37441 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754764AbYFYEhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 00:37:18 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 33 of 36] x86_64: ia32entry: replace privileged instructions
	with pvops
X-Mercurial-Node: dab2b47265e6167ae7251a69c2f09763de6eaf5a
Message-Id: <dab2b47265e6167ae725.1214367569@localhost>
In-Reply-To: <patchbomb.1214367536@localhost>
Date: Wed, 25 Jun 2008 00:19:29 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace privileged instructions with the corresponding pvops in
ia32entry.S.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/ia32/ia32entry.S |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -98,14 +98,14 @@
 	CFI_SIGNAL_FRAME
 	CFI_DEF_CFA	rsp,0
 	CFI_REGISTER	rsp,rbp
-	swapgs
+	SWAPGS
 	movq	%gs:pda_kernelstack, %rsp
 	addq	$(PDA_STACKOFFSET),%rsp	
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs, here we enable it straight after entry:
 	 */
-	sti	
+	ENABLE_INTERRUPTS(CLBR_NONE)
  	movl	%ebp,%ebp		/* zero extension */
 	pushq	$__USER32_DS
 	CFI_ADJUST_CFA_OFFSET 8
@@ -147,7 +147,7 @@
 	call	*ia32_sys_call_table(,%rax,8)
 	movq	%rax,RAX-ARGOFFSET(%rsp)
 	GET_THREAD_INFO(%r10)
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl	$_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
 	jnz	int_ret_from_sys_call
@@ -210,7 +210,7 @@
 	CFI_DEF_CFA	rsp,PDA_STACKOFFSET
 	CFI_REGISTER	rip,rcx
 	/*CFI_REGISTER	rflags,r11*/
-	swapgs
+	SWAPGS
 	movl	%esp,%r8d
 	CFI_REGISTER	rsp,r8
 	movq	%gs:pda_kernelstack,%rsp
@@ -218,7 +218,7 @@
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs and here we enable it straight after entry:
 	 */
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	SAVE_ARGS 8,1,1
 	movl 	%eax,%eax	/* zero extension */
 	movq	%rax,ORIG_RAX-ARGOFFSET(%rsp)
@@ -251,7 +251,7 @@
 	call *ia32_sys_call_table(,%rax,8)
 	movq %rax,RAX-ARGOFFSET(%rsp)
 	GET_THREAD_INFO(%r10)
-	cli
+	DISABLE_INTERRUPTS(CLBR_NONE)
 	TRACE_IRQS_OFF
 	testl $_TIF_ALLWORK_MASK,threadinfo_flags(%r10)
 	jnz  int_ret_from_sys_call
@@ -319,12 +319,12 @@
 	/*CFI_REL_OFFSET	rflags,EFLAGS-RIP*/
 	/*CFI_REL_OFFSET	cs,CS-RIP*/
 	CFI_REL_OFFSET	rip,RIP-RIP
-	swapgs
+	SWAPGS
 	/*
 	 * No need to follow this irqs on/off section: the syscall
 	 * disabled irqs and here we enable it straight after entry:
 	 */
-	sti
+	ENABLE_INTERRUPTS(CLBR_NONE)
 	movl %eax,%eax
 	pushq %rax
 	CFI_ADJUST_CFA_OFFSET 8


