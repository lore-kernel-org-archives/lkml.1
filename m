Return-Path: <linux-kernel-owner+w=401wt.eu-S1757980AbZDWRwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757980AbZDWRwf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 13:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752812AbZDWRw0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 13:52:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38105 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbZDWRwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 13:52:25 -0400
Date: Thu, 23 Apr 2009 13:52:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: various bug fixes
In-Reply-To: <49F09C35.1080006@goop.org>
Message-ID: <alpine.DEB.2.00.0904231311090.24293@gandalf.stny.rr.com>
References: <20090420222257.267399830@goodmis.org> <20090421082354.GC12512@elte.hu> <20090421094616.GA14561@elte.hu> <alpine.DEB.2.00.0904220237330.9714@gandalf.stny.rr.com> <alpine.DEB.2.00.0904222200350.24310@gandalf.stny.rr.com> <20090423082031.GA599@elte.hu>
 <alpine.DEB.2.00.0904230935060.24310@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231019001.24293@gandalf.stny.rr.com> <alpine.DEB.2.00.0904231101030.24293@gandalf.stny.rr.com> <49F09C35.1080006@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Apr 2009, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > Ah, this is a lockdep thing.
> > 
> > The raw_local_irq_save/restore in __native_flush_tlb_global does not update
> > hardirqs_enabled.
> > 
> > When we call into ftrace, when we cross page bounderies, we disable
> > interrupts using the normal local_irq_save/restore calls.
> > 
> > But when we restore, it detects that interrupts are not going to be enabled,
> > and keeps hardirqs_enabled off.
> > 
> > The printk solved the issue because it called local_irq_restore, which set
> > the variable back.
> > 
> > I guess there's two solutions here. One, we can change the
> > raw_local_irq_enable/disable variants in __native_flush_tlb_global to the
> > non-raw type (it should protect against recursion).
> > 
> > or we can try to make the ring buffer use the raw_local_irq variants too. I
> > tried this once before, and it did cause issues.
> > 
> > Note, there's a "check_flags" in lockdep, but it is only called on locking,
> > it is not called when we only disable/enable interrupts.
> >   
> 
> OK, the good news is that its not a callee-save calling convention problem,
> which is what I feared.  But it does sound pretty awkward to fix.  Does
> __native_flush_tlb_global() have to use raw_local_irq_save/restore?

No, I just investigated (and booted) without the raw versions (using the 
normal disable instead). The hooks just update variables in the task 
struct. I see no reason to have use it.

I use to use it with ftrace, but I found that issues are caused if ftrace 
called something internal that used local_irq_save.

Perhaps that is the issue. If something uses raw_local_irq_save then calls 
flush_tlb_global you might get a problem with the flags again (like we did 
here). But the only user of raw_* should be lockdep and irqsoff, and they 
should be able to deal with recursion. I don't think there should be any 
other user.

-- Steve

