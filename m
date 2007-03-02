Return-Path: <linux-kernel-owner+w=401wt.eu-S964834AbXCBTcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964834AbXCBTcy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 14:32:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965185AbXCBTcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 14:32:54 -0500
Received: from mail.screens.ru ([213.234.233.54]:50144 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964834AbXCBTcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 14:32:53 -0500
Date: Fri, 2 Mar 2007 22:32:19 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Paul Mundt <lethal@linux-sh.org>, John Reiser <jreiser@BitWagon.com>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
Message-ID: <20070302193219.GA87@tv-sign.ru>
References: <20070301175207.GA849@tv-sign.ru> <20070302034800.GA12530@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302034800.GA12530@linux-sh.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02, Paul Mundt wrote:
>
> On Thu, Mar 01, 2007 at 08:52:07PM +0300, Oleg Nesterov wrote:
> > >
> > > @@ -105,10 +107,25 @@ int arch_setup_additional_pages(struct l
> > >  {
> > >  	struct mm_struct *mm = current->mm;
> > >  	unsigned long addr;
> > > +	unsigned long flags;
> > >  	int ret;
> > >
> > > +	switch (vdso_enabled) {
> > > +	case 0:  /* none */
> > > +		return 0;
> > 
> > This means we don't initialize mm->context.vdso and ->sysenter_return.
> > 
> > Is it ok? For example, setup_rt_frame() uses VDSO_SYM(&__kernel_rt_sigreturn),
> > sysenter_past_esp pushes ->sysenter_return on stack.
>
> The setup_rt_frame() case is fairly straightforward, both PPC and SH
> already check to make sure there's a valid context before trying to use
> VDSO_SYM(), I'm not sure why x86 doesn't.
>
> Though I wonder if there's any point in checking binfmt->hasvdso here?
> There shouldn't be a valid mm->context.vdso in the !hasvdso case..

setup_rt_frame() is obviously wrong? Surely it must check ->hasvdso like
setup_frame() does! Otherwise, we will have SIGSEGV on SA_SIGINFO if
->load_binary() does not call arch_setup_additional_pages(), no?

If no, what ->hasvdso is?

> Someone else will have to comment on ->sysenter_return.

It is needed for sysexit. If we don't use sysenter (and we shouldn't, because
syscall_page is not mapped), we don't need to initialize it. Note also that
sys_execve() sets TIF_IRET, so we are safe even if sys_execve() was called
using __kernel_vsyscall.

Still, I don't understand why we don't pass NEW_AUX_ENT(AT_SYSINFO) when
vdso_enabled == 0. We don't need linux-gate.so to use __kernel_vsyscall,
we have FIX_VDSO. In that case we should s/PAGE_KERNEL_RO/PAGE_READONLY/
of course. I guess the reason is some magic in glibc.

Oleg.

