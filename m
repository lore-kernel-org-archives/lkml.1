Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbZKELI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbZKELI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:08:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbZKELI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:08:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:33842 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZKELI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:08:57 -0500
Date: Thu, 5 Nov 2009 12:08:57 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] RFC x86_64 more accurate KSTK_ESP implementation
Message-ID: <20091105110857.GR31511@one.firstfloor.org>
References: <1257233486.22553.6.camel@wall-e> <20091103082843.GA27676@elte.hu> <1257239184.4889.15.camel@wall-e> <1257409189.26874.18.camel@wall-e>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257409189.26874.18.camel@wall-e>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +void update_usersp(struct pt_regs *regs)
> +{
> +	unsigned long stk = (unsigned long)task_stack_page(current);
> +	unsigned long stkp = (regs)->sp; 
> +
> +	if (((stkp < stk) || (stkp >= stk + THREAD_SIZE))
> +	    && regs->ip < PAGE_OFFSET)
> +		percpu_write(old_rsp, stkp);

This does not handle interrupt and exception stacks correctly.

Also regs->ip is never a safe check for running in user space,
because a program can set the IP to a arbitrary value for a one
instruction window.

The larger problem is also if the kernel moves to no-tick-for-non-idle
(which I guess will happen sooner or later) your method won't
work anyways, or again be arbitarily inaccurate. Even today 10ms
worst time inaccuracy for HZ=100 is rather bad, there can be a lot of stack
allocations in that time. And adding new dependencies on a regular
timer when everything else is moving away from that doesn't seem right.

Also I suspect this method won't work on preempt-rt without 
additional tweaks.

-Andi
