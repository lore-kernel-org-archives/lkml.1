Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbXD0Oe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbXD0Oe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbXD0Oe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:34:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36745 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752683AbXD0Oe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:34:26 -0400
Date: Fri, 27 Apr 2007 10:34:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Berg <johannes@sipsolutions.net>
cc: Pavel Machek <pavel@ucw.cz>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Adrian Bunk <bunk@stusta.de>,
       <suspend2-devel@lists.suspend2.net>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [linux-pm] driver power operations (was Re: suspend2 merge)
In-Reply-To: <1177669279.7828.55.camel@johannes.berg>
Message-ID: <Pine.LNX.4.44L0.0704271008540.3430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2007, Johannes Berg wrote:

> Look at it now:
> 
>  * FREEZE       Quiesce operations so that a consistent image can be saved;
>  *              but do NOT otherwise enter a low power device state, and do
>  *              NOT emit system wakeup events.
>  *
>  * PRETHAW      Quiesce as if for FREEZE; additionally, prepare for restoring
>  *              the system from a snapshot taken after an earlier FREEZE.
>  *              Some drivers will need to reset their hardware state instead
>  *              of preserving it, to ensure that it's never mistaken for the
>  *              state which that earlier snapshot had set up.
> 
> Why is prethaw even necessary? As far as I can tell it's only necessary
> because resume() can't tell you whether you just want to thaw or need to
> reset since it doesn't tell you at what point it's invoked.

I think you're wrong here.  It's a little hard to say because the 
terminology is confusing and not yet standardized.

For the sake of argument, let's call the stages of STD and STR by these 
names (also noted are the current PSMG values):

	Suspend to disk:
	"prepare to create snapshot" (= FREEZE)
	"continue after snapshot" (= RESUME)

	Resume from disk:
	"prepare to restore snapshot" (= PRETHAW)
	"continue after restore" (= RESUME)

	Suspend to RAM:
	"suspend" (= SUSPEND)
	"resume" (= RESUME)

The real reason for adding PRETHAW was that drivers couldn't distinguish
between "continue after restore" and "resume", other than by examining the
device's state -- since the PM core doesn't pass any information to the
resume() method.

I suppose we could have modified the "prepare to create snapshot" code 
instead, but doing so would mean that "continue after snapshot" and 
"continue after restore" would always do the same thing, which is not 
necessarily a good idea.

Anyway, based on this analysis it seems reasonable to have Six (6) method 
pointers.  Suggested names (in the same order as above):

	pre_snaphot()
	post_snapshot()
	pre_restore()
	post_restore()
	suspend()
	resume()

People apparently assume that pre_snapshot() and pre_restore() would 
always do the same thing and hence be redundant.  I'm not so sure; time 
will tell.  Doing it this way certainly is more clear.

Then there's the question of having early_ and late_ versions of some of 
these things (i.e., one called with interrupts enabled, the other with 
interrupts disabled).  I don't know to what extent that would be 
necessary; perhaps the each method call should occur in two phases with 
the interrupt-enable status changed in between.  Then the interrupt-enable 
setting could be passed as an argument.

Alan Stern

