Return-Path: <linux-kernel-owner+w=401wt.eu-S1751417AbZI0SM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbZI0SM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 14:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750841AbZI0SM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 14:12:58 -0400
Received: from smtp-04.mandic.com.br ([200.225.81.151]:50526 "EHLO
	smtp-04.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbZI0SM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 14:12:58 -0400
Message-ID: <4ABFAB27.1040608@cesarb.net>
Date: Sun, 27 Sep 2009 15:12:55 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Cesar Eduardo Barros <cesarb@cesarb.net>
CC: Daniel Walker <dwalker@fifo99.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
Subject: Re: [PATCH] WARN_ONCE(): use bool for boolean flag
References: <1254059590-31690-1-git-send-email-cesarb@cesarb.net>	 <1254060189.20648.462.camel@desktop>  <4ABF8B30.5050801@cesarb.net>	 <1254070336.20648.518.camel@desktop>  <4ABF9FB4.6040608@cesarb.net> <1254072760.20648.524.camel@desktop> <4ABFA583.6030908@cesarb.net>
In-Reply-To: <4ABFA583.6030908@cesarb.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cesar Eduardo Barros escreveu:
> Daniel Walker escreveu:
>> On Sun, 2009-09-27 at 14:24 -0300, Cesar Eduardo Barros wrote:
>>
>>> In fact, I was expecting no change at all, since gcc should be able 
>>> to see it is being treated as a boolean (perhaps I am trusting gcc 
>>> too much). And to make matters even more confusing, my own test 
>>> changing all __ret_warn_once to bool and dropping the !! caused an 
>>> _increase_ of 598 bytes (x86-64 defconfig).
>>>
>>>     text    data     bss     dec     hex filename
>>> 8100553 1207148  991988 10299689         9d2929 vmlinux.warnret.before
>>> 8101119 1207180  991988 10300287         9d2b7f vmlinux.warnret.after
>>>
>>> (And yes, data increased again.)
>>
>> If this was just your regular base line config , then that is odd .. I
>> also would think worse case would be no size reduction .. I did my
>> compile test on x86-32 btw..
> 
> I will try looking at the first function which shows a difference in 
> size (which appears to be handle_irq) and see what I can find.

I just took a quick look, and it does seem to be bad code generation 
(the gcc on this machine is a bit old). The question is, is the gain in 
less buggy gcc versions enough to offset the loss in older and buggier 
gcc versions?

The function in question (stack_overflow_check() in 
arch/x86/kernel/irq_64.c) has a somewhat complex expression in the call 
to WARN_ON, which gcc seems to be pessimizing in this case (it is 
storing the boolean in a register just to test it again).

I will send the patch I am using in the next email.

gcc (Ubuntu 4.3.2-1ubuntu12) 4.3.2

--- /dev/fd/63	2009-09-27 14:59:26.124947107 -0300
+++ /dev/fd/62	2009-09-27 14:59:26.144947152 -0300
@@ -246,14 +246,14 @@
  	pushq	%rbp
  #APP
  # 14 
"/scratch/build/cesarb/linux/linux-2.6/arch/x86/include/asm/current.h" 1
-	movq %gs:per_cpu__current_task,%rcx
+	movq %gs:per_cpu__current_task,%rax
  # 0 "" 2
  #NO_APP
  	movq	%rsp, %rbp
  	pushq	%rbx
  	movl	%edi, %ebx
  	subq	$8, %rsp
-	movq	8(%rcx), %r8
+	movq	8(%rax), %r8
  	movq	152(%rsi), %rdx
  	cmpq	%r8, %rdx
  	jb	.L24
@@ -262,28 +262,40 @@
  	ja	.L24
  	leaq	400(%r8), %rax
  	cmpq	%rax, %rdx
-	jae	.L24
+	setb	%al
+	movzbl	%al, %eax
+	jmp	.L25
+.L24:
+	xorl	%eax, %eax
+.L25:
+	testl	%eax, %eax
+	je	.L26
  	cmpb	$0, __warned.21424(%rip)
-	jne	.L24
+	jne	.L26
  	movq	%rdx, %r9
-	addq	$1112, %rcx
-	movq	$.LC3, %rdx
  	movl	$47, %esi
+	movq	$.LC3, %rdx
+#APP
+# 14 
"/scratch/build/cesarb/linux/linux-2.6/arch/x86/include/asm/current.h" 1
+	movq %gs:per_cpu__current_task,%rcx
+# 0 "" 2
+#NO_APP
  	movq	$.LC0, %rdi
+	addq	$1112, %rcx
  	xorl	%eax, %eax
  	call	warn_slowpath_fmt
  	movb	$1, __warned.21424(%rip)
-.L24:
+.L26:
  	movl	%ebx, %edi
  	call	irq_to_desc
  	xorl	%edx, %edx
  	testq	%rax, %rax
-	je	.L26
+	je	.L28
  	movq	%rax, %rsi
  	movl	%ebx, %edi
  	call	*24(%rax)
  	movb	$1, %dl
-.L26:
+.L28:
  	movb	%dl, %al
  	popq	%rdx
  	popq	%rbx


-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
