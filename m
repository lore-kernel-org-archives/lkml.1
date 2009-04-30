Return-Path: <linux-kernel-owner+w=401wt.eu-S1763686AbZD3QX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763686AbZD3QX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761570AbZD3QXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:23:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40824 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761552AbZD3QXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:23:19 -0400
Date: Thu, 30 Apr 2009 09:13:44 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Christoph Lameter <cl@linux.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
 redirty_page_for_writepage()
In-Reply-To: <20090430154255.GA3714@elte.hu>
Message-ID: <alpine.LFD.2.00.0904300901490.3395@localhost.localdomain>
References: <20090430024303.GB19875@Krystal> <alpine.DEB.1.10.0904300921290.22262@qirst.com> <20090430133859.GB8329@elte.hu> <alpine.DEB.1.10.0904300938220.22262@qirst.com> <20090430141446.GD14696@elte.hu> <alpine.DEB.1.10.0904301013110.14178@qirst.com>
 <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com> <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com> <20090430154255.GA3714@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Apr 2009, Ingo Molnar wrote:
> 
> nice. Do these all get called with irqs off, all the time?

There are lots of non-irq-off cases where non-atomic counters are safe. A 
couple of reasons:

 - counters that just don't care enough. Some statistics are very 
   important to always be exact, others are "helpful" but performance is 
   more important than being exactly right.

 - counters simply not accessed (or at least changed) from interrupts at 
   all. This is very common for some cases, notably "user event" stats. 
   They may need preemption support, but nothing fancier.

 - counters that are "idempotent" wrt interrupts. For example, anything 
   that will always count up and then down again in a paired fashion 
   (think kernel lock counter, preemption counter etc) is inherently safe 
   as a per-cpu counter without needing any protection at all, since any 
   interrupts may _change_ them, but will always change them back, so even 
   if a non-atomic sequence gets interrupted, it doesn't matter.

In fact, I'd argue that for a per-cpu counter, the whole _point_ of the 
exercise is almost always performance, so locked sequences would be bad to 
assume. The fact that x86 can do "atomic" per-cpu accesses with basically 
zero cost (by virtue of it's rmw memory ops) is unusual.

Most other architectures will have a very hard time making such counters 
cheap, since for them, there "irq atomicity" (expensive irq disable or 
store conditional) or "SMP atomicity" (the same fairly expensive 
store-conditional or something even worse).

				Linus
