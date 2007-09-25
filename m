Return-Path: <linux-kernel-owner+w=401wt.eu-S1762086AbXIYAem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762086AbXIYAem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbXIYAee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:34:34 -0400
Received: from gate.crashing.org ([63.228.1.57]:32822 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365AbXIYAee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:34:34 -0400
Subject: Re: [PATCH 2/2] powerpc: FULL_REGS on exec
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roland McGrath <roland@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       David Woodhouse <dwmw2@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070924235244.2F3BB4D04B7@magilla.localdomain>
References: <20070924235244.2F3BB4D04B7@magilla.localdomain>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 10:34:20 +1000
Message-Id: <1190680460.12382.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-09-24 at 16:52 -0700, Roland McGrath wrote:
> When PTRACE_O_TRACEEXEC is used, a ptrace call to fetch the registers at
> the PTRACE_EVENT_EXEC stop (PTRACE_PEEKUSR) will oops in CHECK_FULL_REGS.
> With recent versions, "gdb --args /bin/sh -c 'exec /bin/true'" and "run" at
> the (gdb) prompt is sufficient to produce this.  I also have written an
> isolated test case, see https://bugzilla.redhat.com/show_bug.cgi?id=301791#c15.
> 
> This change fixes the problem by clearing the low bit of pt_regs.trap in
> start_thread so that FULL_REGS is true again.  This is correct since all of
> the GPRs that "full" refers to are cleared in start_thread.

Looks good, nice catch.

> Signed-off-by: Roland McGrath <roland@redhat.com>

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  arch/powerpc/kernel/process.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
> index e477c9d..fd799d2 100644
> --- a/arch/powerpc/kernel/process.c
> +++ b/arch/powerpc/kernel/process.c
> @@ -605,6 +605,13 @@ void start_thread(struct pt_regs *regs, unsigned long start, unsigned long sp)
>  	regs->ccr = 0;
>  	regs->gpr[1] = sp;
>  
> +	/*
> +	 * We have just cleared all the nonvolatile GPRs, so make
> +	 * FULL_REGS(regs) return true.  This is necessary to allow
> +	 * ptrace to examine the thread immediately after exec.
> +	 */
> +	regs->trap &= ~1UL;
> +
>  #ifdef CONFIG_PPC32
>  	regs->mq = 0;
>  	regs->nip = start;
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev

