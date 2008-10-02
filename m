Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbYJBFUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbYJBFUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 01:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751921AbYJBFUL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 01:20:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60237 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYJBFUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 01:20:10 -0400
Date: Thu, 2 Oct 2008 01:20:08 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jon Masters <jonathan@jonmasters.org>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 5/5] genirq: make irq threading robust
In-Reply-To: <1222908751.31183.79.camel@perihelion.int.jonmasters.org>
Message-ID: <alpine.DEB.1.10.0810020111450.11373@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de>  <20081001223302.210089249@linutronix.de> <1222908751.31183.79.camel@perihelion.int.jonmasters.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 1 Oct 2008, Jon Masters wrote:

> On Wed, 2008-10-01 at 23:02 +0000, Thomas Gleixner wrote:
> 
> > To make sure that a crashed irq thread does not cause more trouble
> > when the irq code tries to wake up a gone thread or the device code
> > calling free_irq and trying to kthread_stop the dead thread, we plug a
> > pointer to irqaction into task_struct, which is evaluated in
> > do_exit(). When the thread crashes the do_exit code marks the thread
> > as DIED in irqaction->flags to prevent further wakeups from the
> > interrupt handler code.
> 
> > @@ -1301,6 +1301,7 @@ struct task_struct {
> >  	int latency_record_count;
> >  	struct latency_record latency_record[LT_SAVECOUNT];
> >  #endif
> > +	struct irqaction *irqaction;
> >  };
> 
> Is that going to fly? For the vast majority of task_structs this is now
> a wasted 4/8 bytes that won't be used.

Perhaps we could convert parts of the task_struct into a union.
There is quite a lot of things that I'm not sure kernel threads use.

fpu_counter? well, it is only one byte.
binfmt?

Do kernel threads use group_leader?

What about the ptraced items?

group ids/info on kernel threads?

do kernel threads need robust futex info?

This was just a quick look at the task struct. Perhaps we could separate
out kernel only and user space only info and bring the total size down?

Although I'm not sure how much is there that is kernel_thread only :-/
Of course this irqaction will be.

-- Steve
