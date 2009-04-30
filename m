Return-Path: <linux-kernel-owner+w=401wt.eu-S1762867AbZD3OWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762867AbZD3OWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 10:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZD3OWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 10:22:35 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:36945 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbZD3OWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 10:22:35 -0400
Date: Thu, 30 Apr 2009 10:12:54 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yuriy Lalym <ylalym@gmail.com>, Tejun Heo <tj@kernel.org>,
       ltt-dev@lists.casi.polymtl.ca,
       Andrew Morton <akpm@linux-foundation.org>, thomas.pi@arcor.dea,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [ltt-dev] [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430141211.GB5922@Krystal>
Message-ID: <alpine.DEB.1.10.0904301009530.14178@qirst.com>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal> <20090430062140.GA9559@elte.hu> <20090430063306.GA27431@Krystal> <20090430065055.GA16277@elte.hu>
 <alpine.DEB.1.10.0904300926530.22262@qirst.com> <20090430141211.GB5922@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009, Mathieu Desnoyers wrote:

> > The 3 variants on x86 generate the same instructions. On other platforms
> > they would need to be able to fallback in various way depending on the
> > availability of instructions that are atomic vs. preempt or irqs.
> >
>
> The problem here, as we did figure out a while ago with the atomic
> slub we worked on a while ago, is that if we have the following code :
>
> local_irq_save
> var++
> var++
> local_irq_restore
>
> that we would like to turn into irq-safe percpu variant with this
> semantic :
>
> percpu_add_irqsafe(var)
> percpu_add_irqsafe(var)
>
> We are generating two irq save/restore in the fallback, which will be
> slow.
>
> However, we could do the following trick :
>
> percpu_irqsave(flags);
> percpu_add_irq(var);
> percpu_add_irq(var);
> percpu_irqrestore(flags);

Hmmm.I do not remember any of those double ops in the patches that I did a
while back for this. It does not make sense either because atomic per cpu
ops are only atomic for a single instruction. You are trying to extend
that so that multiple "atomic" instructions are now atomic.

