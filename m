Return-Path: <linux-kernel-owner+w=401wt.eu-S1754274AbZE3INd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbZE3INd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 04:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752007AbZE3INL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 04:13:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43139 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZE3INI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 04:13:08 -0400
Date: Sat, 30 May 2009 04:13:03 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Roland McGrath <roland@redhat.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH -tip v8 5/7] x86: add pt_regs register and stack access
	APIs
Message-ID: <20090530081303.GB15755@infradead.org>
References: <20090529000326.17532.70868.stgit@localhost.localdomain> <20090529000347.17532.34038.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529000347.17532.34038.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You might want to run this past linux-arch to make sure this is suitable
for other architectures.

> --- a/arch/x86/include/asm/ptrace.h
> +++ b/arch/x86/include/asm/ptrace.h
> @@ -7,6 +7,7 @@
>  
>  #ifdef __KERNEL__
>  #include <asm/segment.h>
> +#include <asm/page_types.h>
>  #endif

I really wonder if we should split asm/ptrace.h into one file
just defining pt_regs both for userspace and the kernel, and one with
all kinds of register access helpers and maybe another one for the
ptrace architecture interface.

Unforuntately we would have to keep the ptrace.h name for the one
carrying pt_regs as it's exposed to userland.

> +static inline unsigned long get_register(struct pt_regs *regs, unsigned offset)
> +{

I woner if all these names aren't a bit generic.  Shoud we maybe add a
regs_ prefix to make it clear it operates on a pt_regs register set?

Also some kerneldoc documentation for all these helpers would be nice.

> +/* Get Nth argument at function call */
> +static inline unsigned long get_argument_nth(struct pt_regs *regs, unsigned n)
> +{
> +#ifdef CONFIG_X86_32
> +#define NR_REGPARMS 3

I think completely separate version for 32 vs 64 bit for this one would
be cleaner.

> +	if (n < NR_REGPARMS) {
> +		switch (n) {
> +		case 0: return regs->ax;
> +		case 1: return regs->dx;
> +		case 2: return regs->cx;
> +		}

Normal kernel style would be

		switch (n) {
		case 0:
			return regs->ax;
		case 1:
			return regs->dx;
		case 2:
			return regs->cx;
		}

> +#define REG_OFFSET(r) offsetof(struct pt_regs, r)
> +#define REG_OFFSET_NAME(r) {.name = #r, .offset = REG_OFFSET(r)}
> +#define REG_OFFSET_END {.name = NULL, .offset = 0}

At least the REG_OFFSET macro seems superflous to me.

