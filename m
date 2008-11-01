Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbYKATy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbYKATy1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 15:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYKATyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 15:54:19 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3816 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752159AbYKATyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 15:54:19 -0400
Date: Sat, 1 Nov 2008 15:54:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arjan van de Ven <arjan@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: (BUG?) round_jiffies() is non-monotonic on SMP
In-Reply-To: <20081101092905.443a2dc5@infradead.org>
Message-ID: <Pine.LNX.4.44L0.0811011541040.24707-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2008, Arjan van de Ven wrote:

> > If this is known, is it regarded as a potential problem?  It certainly
> > seems likely that some code somewhere depends on timeouts expiring in
> > the correct order.
> 
> I don't think timeouts EVER have that guarantee between different cpus;
> even if you don't round the timeouts.
> After all, your CPU A can be in some delay loop with irqs off for
> longer than the delta was, and boom.. the timers fire in different
> order.

Why is that?  The fact that CPU A is busy might mean that the timer
routines run on some other CPU... but they should still be called in
the correct order.

Is it possible for timer 1 to expire before timer 2 but the handler
gets interrupted, with the result that timer 2's handler runs to
completion on a different CPU before timer 1's handler has managed to
execute more than a couple of instructions?  If it is then I agree,
timer-ordering requirements between CPUs don't make much sense.

I don't understand all the details of how timers work on SMP systems,
so maybe some subtlety has escaped me.  For instance, there's no
guarantee AFAIK that the system clocks on two different CPUs will be
synchronized with each other.  But wouldn't it be surprising if they
differed by more than a couple of milliseconds?

> If we ever have such ordering requirements in the kernel that
> don't handle this... they're a bug...

I don't know of any examples.

> > P.S.: As a related matter, it seems very odd that we don't have a 
> > round_jiffies_up() routine.  Surely there are plenty of places where
> > it doesn't matter if an event is a little late but where the event
> > must not be early.  (I know two such places offhand.)  Any objection
> > to having one added?
> 
> no objection per se, but I would almost argue we should convert such
> places to range timers....
> that way the kernel can, rather an aligning them, group them with other
> activity.

Come to think of it, is there any good reason why round_jiffies()  
doesn't always round up?  It seems a lot safer.

Alan Stern

