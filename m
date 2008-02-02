Return-Path: <linux-kernel-owner+w=401wt.eu-S1765617AbYBBWgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765617AbYBBWgu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 17:36:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762588AbYBBWgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 17:36:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:42793 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653AbYBBWgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:36:41 -0500
Date: Sat, 2 Feb 2008 23:36:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: git-commits-head@vger.kernel.org
Subject: Re: x86: fix arch/x86/kernel/test_nx.c modular build bug
Message-ID: <20080202223645.GA27546@uranus.ravnborg.org>
References: <200801310159.m0V1xU2L015772@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801310159.m0V1xU2L015772@hera.kernel.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 01:59:30AM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=18fbef9e5242e146fe0264cf719a498785102841
> Commit:     18fbef9e5242e146fe0264cf719a498785102841
> Parent:     f034347470e486835ccdcd7a5bb2ceb417be11c4
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed Jan 30 23:27:58 2008 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed Jan 30 23:27:58 2008 +0100
> 
>     x86: fix arch/x86/kernel/test_nx.c modular build bug
>     
>     fix this modular build bug:
>     
>     >   CC [M]  arch/x86/kernel/test_nx.o
>     > {standard input}: Assembler messages:
>     > {standard input}:58: Error: cannot represent relocation type BFD_RELOC_64
>     > {standard input}:59: Error: cannot represent relocation type BFD_RELOC_64
>     > make[2]: *** [arch/x86/kernel/test_nx.o] Error 1
>     > make[1]: *** [arch/x86/kernel] Error 2
>     
>     Reported-by: Adrian Bunk <bunk@kernel.org>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/test_nx.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/test_nx.c b/arch/x86/kernel/test_nx.c
> index 6d7ef11..ae0ef2e 100644
> --- a/arch/x86/kernel/test_nx.c
> +++ b/arch/x86/kernel/test_nx.c
> @@ -91,8 +91,13 @@ static noinline int test_address(void *address)
>  		".previous\n"
>  		".section __ex_table,\"a\"\n"
>  		"       .align 8\n"
> +#ifdef CONFIG_X86_32
> +		"	.long 0b\n"
> +		"	.long 2b\n"
> +#else
>  		"	.quad 0b\n"
>  		"	.quad 2b\n"
> +#endif

This should have used _ASM_PTR from asm.h:

#ifdef CONFIG_X86_32
/* 32 bits */

# define _ASM_PTR       " .long "
...
#else
/* 64 bits */

# define _ASM_PTR       " .quad "


	Sam
