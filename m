Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbZLUP41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbZLUP41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 10:56:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbZLUP40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 10:56:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41946 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZLUP40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 10:56:26 -0500
X-Authority-Analysis: v=1.0 c=1 a=3VcTWO7RLfwA:10 a=7U3hwN5JcxgA:10 a=mKBMVft-KihwrS45-8EA:9 a=yy3LbP1cpW1mNY2WAqgA:7 a=f1GVy3Iyhv7qSVgabQ_R8ZTdw6EA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: Fix lockdep warning in global_clock()
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1261406427.4314.155.camel@laptop>
References: <4B2F1543.8020300@cn.fujitsu.com>
	 <20091221064356.GA2378@elte.hu>  <4B2F2588.8070501@cn.fujitsu.com>
	 <1261406427.4314.155.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 21 Dec 2009 10:56:24 -0500
Message-ID: <1261410984.25193.8.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 15:40 +0100, Peter Zijlstra wrote:
> On Mon, 2009-12-21 at 15:36 +0800, Li Zefan wrote:
> 
> > +++ b/kernel/sched_clock.c
> > @@ -250,9 +250,9 @@ unsigned long long cpu_clock(int cpu)
> >         unsigned long long clock;
> >         unsigned long flags;
> > 
> > -       raw_local_irq_save(flags);
> > +       local_irq_save(flags);
> >         clock = sched_clock_cpu(cpu);
> > -       raw_local_irq_restore(flags);
> > +       local_irq_restore(flags);
> > 
> >         return clock;
> >  }
> > ===============================================
> > 
> > I guess it's still true that lower level functions can take locks?
> 
> No, I removed the locks from cpu_clock a while back.
> 

The problem isn't with locks, it's with disabling interrupts. Lockdep
keeps track of every time interrupts are disabled. If something disables
interrupts with raw_* but then calls something that disables interrupts
the normal way, lockdep will detect that interrupts are being disabled
but they already are disabled. The internal irq disabled variable in
lockdep wont match reality, and this will blow up (well, disable
lockdep).

So if cpu_clock disables interrupts with local_irq_* then so must
trace_clock_global.

-- Steve



