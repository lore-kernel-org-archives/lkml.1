Return-Path: <linux-kernel-owner+w=401wt.eu-S1753260AbZFEBE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbZFEBE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 21:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbZFEBEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 21:04:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbZFEBEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:04:52 -0400
Date: Thu, 4 Jun 2009 18:04:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       jason.wessel@windriver.com, kgdb-bugreport@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kgdbts: unify/generalize gdb breakpoint adjustment
Message-Id: <20090604180420.2805fcdd.akpm@linux-foundation.org>
In-Reply-To: <8bd0f97a0906041755q7588ba76l1e4e1eb8bdbe336@mail.gmail.com>
References: <1243927050-30685-1-git-send-email-vapier@gentoo.org>
	<20090604175030.55cc4a68.akpm@linux-foundation.org>
	<8bd0f97a0906041755q7588ba76l1e4e1eb8bdbe336@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Jun 2009 20:55:40 -0400
Mike Frysinger <vapier.adi@gmail.com> wrote:

> On Thu, Jun 4, 2009 at 20:50, Andrew Morton wrote:
> > On Tue, __2 Jun 2009 03:17:30 -0400
> > Mike Frysinger <vapier@gentoo.org> wrote:
> >
> >> + __ __ instruction_pointer(&kgdbts_regs) += offset;
> >
> > instruction_pointer() cannot be used as an lvalue, thankfully.
> >
> > x86_64:
> >
> > drivers/misc/kgdbts.c: In function 'check_and_rewind_pc':
> > drivers/misc/kgdbts.c:306: error: invalid lvalue in assignment
> 
> should be easy to fix:
> --- a/arch/x86/include/asm/ptrace.h
> +++ b/arch/x86/include/asm/ptrace.h
> @@ -236,10 +236,7 @@
>  #endif
>  }
> 
> -static inline unsigned long instruction_pointer(struct pt_regs *regs)
> -{
> -   return regs->ip;
> -}
> +#define instruction_pointer(regs) ((regs)->ip)
> 
>  static inline unsigned long frame_pointer(struct pt_regs *regs)
>  {

argh, that's soooooo tasteless.  Look, this:

	instruction_pointer(&kgdbts_regs) += offset;

is just daft.  It's not C!  It makes no sense to define something which
looks like a function and to then assign values to it.  It means that
instruction_pointer() _must_ be implemented as a macro, violating basic
concepts of encapsualtion/layering/hiding/etc.

Doing

void instruction_pointer_set(struct pt_regs *regs, some_suitable_type val);

will save many vomit bags.
