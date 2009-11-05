Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZKEML5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZKEML5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 07:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbZKEML5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 07:11:57 -0500
Received: from www84.your-server.de ([213.133.104.84]:50798 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbZKEML4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 07:11:56 -0500
Subject: Re: [PATCH] RFC x86_64 more accurate KSTK_ESP implementation
From: Stefani Seibold <stefani@seibold.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20091105110857.GR31511@one.firstfloor.org>
References: <1257233486.22553.6.camel@wall-e>
	 <20091103082843.GA27676@elte.hu> <1257239184.4889.15.camel@wall-e>
	 <1257409189.26874.18.camel@wall-e>
	 <20091105110857.GR31511@one.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 05 Nov 2009 13:11:03 +0100
Message-ID: <1257423063.961.10.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 05.11.2009, 12:08 +0100 schrieb Andi Kleen:
> > +void update_usersp(struct pt_regs *regs)
> > +{
> > +	unsigned long stk = (unsigned long)task_stack_page(current);
> > +	unsigned long stkp = (regs)->sp; 
> > +
> > +	if (((stkp < stk) || (stkp >= stk + THREAD_SIZE))
> > +	    && regs->ip < PAGE_OFFSET)
> > +		percpu_write(old_rsp, stkp);
> 
> This does not handle interrupt and exception stacks correctly.
> 
> Also regs->ip is never a safe check for running in user space,
> because a program can set the IP to a arbitrary value for a one
> instruction window.
> 

I think this doesn't matter, because i want only detect if it is save to
wrire the old_rsp value. There are only three places in the kernel where
this value will be writen, all of them are in the kernel. So checking if
the ip is in the kernel and the stack pointer points outside the kernel
stack of the current task will be enough. Or i am wrong?

> The larger problem is also if the kernel moves to no-tick-for-non-idle
> (which I guess will happen sooner or later) your method won't
> work anyways, or again be arbitarily inaccurate. Even today 10ms
> worst time inaccuracy for HZ=100 is rather bad, there can be a lot of stack
> allocations in that time. And adding new dependencies on a regular
> timer when everything else is moving away from that doesn't seem right.

The value is correct in case of on uni processor system. In an multi
core system it is a good approximation. A quick look into other
architectures shows that this is not a x86_64 issue. All architecture
give you only a snapshot.

But this is good enough for ps or /proc usage. If someone want an exact
value, then it is necessary to stop the task.

> 
> Also I suspect this method won't work on preempt-rt without 
> additional tweaks.
> 

That is a other issue. Let us first fix and agree about the basics.

Stefani


