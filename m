Return-Path: <linux-kernel-owner+w=401wt.eu-S1756520AbZBIRNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520AbZBIRNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 12:13:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754251AbZBIRNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 12:13:36 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:9454 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZBIRNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:13:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wsteCjus5F4lWAiwMQfibzKkN/T+g/uH/KsudrT0M28zArqGYTs29EZnuyhBJIlHjL
         B68BIQVNB1HQKebPJNpWTddCiETbHXN//F4Kqu153h6kKq3UNOizH6SyG/9f5i1DbyNT
         fywvMlPDm4xEXsOrIKXdliR5oFhi6q05k2oAk=
MIME-Version: 1.0
In-Reply-To: <1234186798-16820-4-git-send-email-tj@kernel.org>
References: <1234186798-16820-1-git-send-email-tj@kernel.org>
	 <1234186798-16820-4-git-send-email-tj@kernel.org>
Date: Mon, 9 Feb 2009 12:13:33 -0500
Message-ID: <73c1f2160902090913n20283872r2cb5ae774560d047@mail.gmail.com>
Subject: Re: [PATCH 03/11] x86: fix math_emu register frame access
From: Brian Gerst <brgerst@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: hpa@zytor.com, jeremy@goop.org, tglx@linutronix.de, mingo@elte.hu,
       linux-kernel@vger.kernel.org, x86@kernel.org, rusty@rustcorp.com.au
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 8:39 AM, Tejun Heo <tj@kernel.org> wrote:
> do_device_not_available() is the handler for #NM and it declares that
> it takes a unsigned long and calls math_emu(), which takes a long
> argument and surprisingly expects the stack frame starting at the zero
> argument would match struct math_emu_info, which isn't true regardless
> of configuration in the current code.
>
> This patch makes do_device_not_available() take struct pt_regs like
> other exception handlers and initialize struct math_emu_info with
> pointer to it and pass pointer to the math_emu_info to math_emulate()
> like normal C functions do.  This way, unless gcc makes a copy of
> struct pt_regs in do_device_not_available(), the register frame is
> correctly accessed regardless of kernel configuration or compiler
> used.
>
> This doesn't fix all math_emu problems but it at least gets it
> somewhat working.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
>
> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index afb46c0..84bdf8f 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -900,7 +900,7 @@ asmlinkage void math_state_restore(void)
>  EXPORT_SYMBOL_GPL(math_state_restore);
>
>  #ifndef CONFIG_MATH_EMULATION
> -asmlinkage void math_emulate(long arg)
> +void math_emulate(struct math_emu_info *info)

You forgot to drop the asmlinkage from the prototype in traps.h.

>  {
>        printk(KERN_EMERG
>                "math-emulation not enabled and no coprocessor found.\n");
> @@ -910,16 +910,19 @@ asmlinkage void math_emulate(long arg)
>  }
>  #endif /* CONFIG_MATH_EMULATION */
>
> -dotraplinkage void __kprobes
> -do_device_not_available(struct pt_regs *regs, long error)
> +dotraplinkage void __kprobes do_device_not_available(struct pt_regs regs)

Why did you change this to pass by value?  This is called from the
generic trap handler (error_code), which already passes the pt_regs
pointer in %eax.

--
Brian Gerst
