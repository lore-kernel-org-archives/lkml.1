Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZHXUek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZHXUek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 16:34:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbZHXUek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 16:34:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60931 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbZHXUej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 16:34:39 -0400
Message-ID: <4A92F93F.8000502@zytor.com>
Date: Mon, 24 Aug 2009 13:34:07 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, kjwinchester@gmail.com,
       tglx@linutronix.de, borislav.petkov@amd.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, AMD: Disable wrongly set X86_FEATURE_LAHF_LM
 CPUID bit
References: <1250251594-8348-2-git-send-email-borislav.petkov@amd.com> <tip-c74cb13b94118ec89e48849806356b67caa5ff86@git.kernel.org> <20090816064132.GA16278@elte.hu> <20090816214934.GB7765@liondog.tnic> <4A8EDC02.8000508@zytor.com> <20090822163750.GA31631@liondog.tnic>
In-Reply-To: <20090822163750.GA31631@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2009 09:37 AM, Borislav Petkov wrote:
> On Fri, Aug 21, 2009 at 10:40:18AM -0700, H. Peter Anvin wrote:
>> If we're going to modify the paravirt_crap for yet another MSR
>> operation, then let's at least make it something like "write_msr_edi"
>> and have it take a parameter for the EDI value.  Perhaps we should let
>> it set EBX and ESI as well (and the same for the read operation, even
>> though it already exists.)
> 
> Ok, how about making all rdmsr* variants indirectly call into a
> native_read_msr_safe_reg() helper which takes esi and edi as additional
> arguments. There was no room for ebx since paravirt has a PVOP_CALL4
> macro which takes the largest number of args - 4 and I am lazy, of
> course, to implement a PVOP_CALL5 thing :o)
> 
> The wrmsr variants could be done similarly.
> 
> Suggestions, comments?
> 

Looks reasonable... although part of me wonders if having a pointer to
an array containing the entire register file in and out is even better,
of if I'm just overengineering at this point.

Note that the only difference between "rdmsr" and "wrmsr" is the actual
opcode being executed at this point...

/*
 * int native_rdmsr_safe_regs(u32 gprs[8]);
 *
 * 32-bit implementation
 *
 */
ENTRY(native_rdmsr_safe_regs)
	push	%ebx
	push	%ebp
	push	%esi
	push	%edi
	push	$0		/* Return value */
	push	%eax
	movl	4(%eax), %ecx
	movl	8(%eax), %edx
	movl	12(%eax), %ebx
	movl	20(%eax), %ebp
	movl	24(%eax), %esi
	movl	28(%eax), %edi
	movl	(%eax), %eax
1:	rdmsr
2:	push	%eax
	movl	4(%esp), %eax
	pop	(%eax)
	addl	$4, %esp
	movl	%ecx, 4(%eax)
	movl	%edx, 8(%eax)
	movl	%ebx, 12(%eax)
	movl	%ebp, 20(%eax)
	movl	%esi, 24(%eax)
	movl	%edi, 28(%eax)
	pop	%eax
	pop	%edi
	pop	%esi
	pop	%ebp
	pop	%ebx
	ret
3:
	movl	$-EIO, 4(%esp)
	jmp	2b
	__ASM_EX_SEC
	.balign	4
	.long	1b, 3b
	.previous
EXIT(native_rdmsr_safe_regs)

/*
 * int native_rdmsr_safe_regs(u32 gprs[8]);
 *
 * 64-bit implementation
 *
 */
ENTRY(native_rdmsr_safe_regs)
	push	%rbx
	push	%rbp
	push	$0		/* Return value */
	push	%rdi
	movl	(%rdi), %eax
	movl	4(%rdi), %ecx
	movl	8(%rdi), %edx
	movl	12(%rdi), %ebx
	movl	20(%rdi), %ebp
	movl	24(%rdi), %esi
	movl	28(%rdi), %edi
1:	rdmsr
2:	movl	%edi, %r10
	pop	%rdi
	movl	%eax, (%rdi)
	movl	%ecx, 4(%rdi)
	movl	%edx, 8(%rdi)
	movl	%ebx, 12(%rdi)
	movl	%ebp, 20(%rdi)
	movl	%esi, 24(%rdi)
	movl	%r10d, 28(%rdi)
	pop	%rax
	pop	%rbp
	pop	%rbx
	ret
3:
	movq	$-EIO, 8(%esp)
	jmp	2b
	__ASM_EX_SEC
	.balign	4
	.long	1b, 3b
	.previous
EXIT(native_rdmsr_safe_regs)
