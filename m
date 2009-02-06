Return-Path: <linux-kernel-owner+w=401wt.eu-S1760174AbZBFRWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760174AbZBFRWY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 12:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZBFRWN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 12:22:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56856 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbZBFRWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 12:22:12 -0500
Date: Fri, 6 Feb 2009 12:22:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/4] nmi: add generic nmi tracking state
In-Reply-To: <20090206091039.d0acb680.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0902061216370.22636@gandalf.stny.rr.com>
References: <20090206065352.940088243@goodmis.org> <20090206065437.986292747@goodmis.org> <20090205231215.412def47.akpm@linux-foundation.org> <alpine.DEB.1.10.0902060822440.10059@gandalf.stny.rr.com> <20090206091039.d0acb680.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 6 Feb 2009, Andrew Morton wrote:
> > 
> > That would be fun to implement. Not the in_nmi code, but the handling of 
> > nested NMIs. How would you be able to save the state when the NMI occurred 
> > without being preempted by another NMI?
> 
> Like with normal interrupts?

Normal interrupts can enable interrupts again, while in the handler, as 
well as disable them.

> 
> As long as the number of sources is finite, nested NMIs could work OK.

I guess you would need a mechanism to enable and disable NMIs.

> 
> > I think the arch that has nested NMIs will have many more issues to solve 
> > in the kernel than this one.
> 
> I have a vague memory that x86 can do this.
> 
> <googles a bit>
> 
> What's all this about?
> https://www.x86-64.org/pipermail/discuss/2005-October/007010.html

Yuck, masking Non Maskable Interrupts?

> http://kerneltrap.org/index.php?q=mailarchive/linux-kernel/2008/2/12/830704/thread

It looks like it calls nmi_exit, so the code would dec it.

> 
> I expect that even if it is possible, we can live without it.
> 
> And if I'm wrong, it'll be easy to accommodate by adding a new counter
> into the task_struct or thread_struct.

Yeah, the bug on would trigger as soon as we do that, and we could
easily update the code when that time comes.

> 
> Does your above implementation make in_interrupt() return true if
> in_nmi()?  I think it doesn't, but should?

The "in_nmi()" is set when we do nmi_enter, and nmi_enter also calls 
irq_enter which makes in_interrupt() true. I thought adding the in_nmi 
condition to in_interrupt would be redundant.

-- Steve

