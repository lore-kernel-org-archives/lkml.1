Return-Path: <linux-kernel-owner+w=401wt.eu-S1030621AbXCBWTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621AbXCBWTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 17:19:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030630AbXCBWTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 17:19:04 -0500
Received: from mail.screens.ru ([213.234.233.54]:44176 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030621AbXCBWTB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 17:19:01 -0500
Date: Sat, 3 Mar 2007 01:18:54 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: John Reiser <jreiser@BitWagon.com>
Cc: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Paul Mundt <lethal@linux-sh.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
Message-ID: <20070302221854.GA162@tv-sign.ru>
References: <20070301175207.GA849@tv-sign.ru> <45E891E6.7090807@BitWagon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45E891E6.7090807@BitWagon.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, John Reiser wrote:
>
> Oleg Nesterov wrote:
> > John Reiser wrote:
> 
> >>+	switch (vdso_enabled) {
> >>+	case 0:  /* none */
> >>+		return 0;
> > 
> > 
> > This means we don't initialize mm->context.vdso and ->sysenter_return.
> > 
> > Is it ok? For example, setup_rt_frame() uses VDSO_SYM(&__kernel_rt_sigreturn),
> > sysenter_past_esp pushes ->sysenter_return on stack.
> 
> Paul Mundt has commented on setup_rt_frame() and provided a patch which
> bullet-proofs that area.  I will include that patch into the next revision.

Confused. I still think his patch incomplete. Don't we need the same check
in setup_rt_frame() ?

> The value of ->sysenter_return is interpreted in user space by the
> sysexit instruction; nobody else cares what the value is.  The kernel
> is not required to provide a good value when vdso_enabled is zero,

Yes sure.

> Both context.vdso and sysenter_return could be set to zero whenever
> vdso_enabled is zero; those two values might even be defaulted.
> I'll add such a change to the next revision of the patch, if you'll
> defend it against claims of "unnecessary code."

context.vdso == NULL after mm_alloc(). I don't see a "good" arch dependent
function to clear ->sysenter_return (if we really need this). May be
flush_thread().

> > Note also that load_elf_binary does
> > 
> > 	arch_setup_additional_pages()
> > 	create_elf_tables()
> > 
> > , looks like application can crash after exec if vdso_enabled changes from 0
> > to 1 in between.
> 
> Correct.  Changing vdso_enabled from 0 to non-zero must be prepared
> to lose this race if it is not prevented.  Ordinarily it won't matter
> because the administrator will perform such changes at a "quiet" time.

I agree, this problem is mostly theoretical, but I believe it is hardly
possible to document what the "quiet" time is ;)

How about

	 #define ARCH_DLINFO
	-do if (vdso_enabled) {
	+do if (VDSO_BASE) {
?

Oleg.

