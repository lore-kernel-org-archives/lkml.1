Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbZAEAIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbZAEAIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 19:08:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZAEAIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 19:08:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56449 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZAEAIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 19:08:22 -0500
Message-ID: <49614F62.5070006@kernel.org>
Date: Sun, 04 Jan 2009 16:08:02 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@linux-foundation.org, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [4/5] Use asm stubs for 32bit sigreturn codes
References: <200901051236.281008835@firstfloor.org> <20090104233641.6F5723E6652@basil.firstfloor.org>
In-Reply-To: <20090104233641.6F5723E6652@basil.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 32bit sigreturn/rt_sigreturn currently uses some magic casting
> with assumptions about the stack layout
> to simulate call by reference for the pt_regs structure on the 
> stack. This is fragile, non standard and according to reports 
> breaks with LLVM at least. I suppose it could break in
> future gcc versions too when their stack layout changes.
> 
> So instead of having this magic in C do it in small
> assembler stubs similar to what x86-64 does (which
> always passes a pointer to pt_regs for such functions)
> 
> This also leads to cleaner code.
> 

It's wrong, however:

#define asmlinkage CPP_ASMLINKAGE __attribute__((regparm(0)))

> +ENTRY(stub_sigreturn)
> +	movl %esp,%eax
> +	jmp sys_sigreturn
> +END(stub_sigreturn)

This assumes regparm=3, i.e !asmlinkage.

> -asmlinkage unsigned long sys_sigreturn(unsigned long __unused)
> +asmlinkage unsigned long sys_sigreturn(struct pt_regs *regs)
>  {
>  	struct sigframe __user *frame;
> -	struct pt_regs *regs;
>  	unsigned long ax;
>  	sigset_t set;
>  
> -	regs = (struct pt_regs *) &__unused;
>  	frame = (struct sigframe __user *)(regs->sp - 8);
>  
>  	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
> @@ -212,7 +210,7 @@
>  	return 0;
>  }

I think we already have a patch in the tree that changes this to:

asmlinkage unsigned long sys_sigreturn(struct pt_regs regs)

... although doing it as a pointer is better, but requires a change to
the asmlinkage thing.

Getting rid of __attribute__((regparm(0))) for asmlinkage on i386 would
definitely be good, but is a bigger thing than only these couple of
functions.

	-hpa
