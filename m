Return-Path: <linux-kernel-owner+w=401wt.eu-S1759561AbZDWPIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759561AbZDWPIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 11:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759473AbZDWPI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 11:08:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34318 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759517AbZDWPIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 11:08:25 -0400
Date: Thu, 23 Apr 2009 11:08:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
In-Reply-To: <alpine.DEB.2.00.0904231019001.24293@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0904231101030.24293@gandalf.stny.rr.com>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <alpine.DEB.2.00.0904222200350.24310@gandalf.stny.rr.com> <20090423082031.GA599@elte.hu>
 <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231019001.24293@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Apr 2009, Steven Rostedt wrote:
> 
> static inline void __native_flush_tlb_global(void)
> {
>         unsigned long flags;
>         unsigned long cr4;
> 
>         /*
>          * Read-modify-write to CR4 - protect it from preemption and
>          * from interrupts. (Use the raw variant because this code can
>          * be called from deep inside debugging code.)
>          */
>         raw_local_irq_save(flags);
> 
>         cr4 = read_cr4();
>         /* clear PGE */
>         write_cr4(cr4 & ~X86_CR4_PGE);
>         /* write old PGE again and flush TLBs */
>         write_cr4(cr4);
> 
>         raw_local_irq_restore(flags);
> }
> 
> 
> Each of those read_cr4 and write_cr4 can be traced. But I still do not see 
> how this can cause corruption in the current task struct.
> 
> The TLB just caches the pages we are using, not the contents inside. I 
> still do not see how this can corrupt a bit. Unless a register leaked :-/

Ah, this is a lockdep thing.

The raw_local_irq_save/restore in __native_flush_tlb_global does not 
update hardirqs_enabled.

When we call into ftrace, when we cross page bounderies, we disable 
interrupts using the normal local_irq_save/restore calls.

But when we restore, it detects that interrupts are not going to be 
enabled, and keeps hardirqs_enabled off.

The printk solved the issue because it called local_irq_restore, which set 
the variable back.

I guess there's two solutions here. One, we can change the 
raw_local_irq_enable/disable variants in __native_flush_tlb_global to the 
non-raw type (it should protect against recursion).

or we can try to make the ring buffer use the raw_local_irq variants too. 
I tried this once before, and it did cause issues.

Note, there's a "check_flags" in lockdep, but it is only called on 
locking, it is not called when we only disable/enable interrupts.

-- Steve

