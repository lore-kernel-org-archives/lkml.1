Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbXD0PQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbXD0PQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 11:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755983AbXD0PQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 11:16:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57169 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755982AbXD0PQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 11:16:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-pm@lists.linux-foundation.org
Subject: Re: [linux-pm] driver power operations (was Re: suspend2 merge)
Date: Fri, 27 Apr 2007 17:12:09 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Johannes Berg <johannes@sipsolutions.net>,
       Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       suspend2-devel@lists.suspend2.net, Mike Galbraith <efault@gmx.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Con Kolivas <kernel@kolivas.org>, Adrian Bunk <bunk@stusta.de>,
       Thomas Gleixner <tglx@linutronix.de>, Pavel Machek <pavel@ucw.cz>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
References: <Pine.LNX.4.44L0.0704271008540.3430-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0704271008540.3430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704271712.10437.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 27 April 2007 16:34, Alan Stern wrote:
> On Fri, 27 Apr 2007, Johannes Berg wrote:
> 
> > Look at it now:
> > 
> >  * FREEZE       Quiesce operations so that a consistent image can be saved;
> >  *              but do NOT otherwise enter a low power device state, and do
> >  *              NOT emit system wakeup events.
> >  *
> >  * PRETHAW      Quiesce as if for FREEZE; additionally, prepare for restoring
> >  *              the system from a snapshot taken after an earlier FREEZE.
> >  *              Some drivers will need to reset their hardware state instead
> >  *              of preserving it, to ensure that it's never mistaken for the
> >  *              state which that earlier snapshot had set up.
> > 
> > Why is prethaw even necessary? As far as I can tell it's only necessary
> > because resume() can't tell you whether you just want to thaw or need to
> > reset since it doesn't tell you at what point it's invoked.
> 
> I think you're wrong here.  It's a little hard to say because the 
> terminology is confusing and not yet standardized.
> 
> For the sake of argument, let's call the stages of STD and STR by these 
> names (also noted are the current PSMG values):
> 
> 	Suspend to disk:
> 	"prepare to create snapshot" (= FREEZE)
> 	"continue after snapshot" (= RESUME)
> 
> 	Resume from disk:
> 	"prepare to restore snapshot" (= PRETHAW)
> 	"continue after restore" (= RESUME)
> 
> 	Suspend to RAM:
> 	"suspend" (= SUSPEND)
> 	"resume" (= RESUME)
> 
> The real reason for adding PRETHAW was that drivers couldn't distinguish
> between "continue after restore" and "resume", other than by examining the
> device's state -- since the PM core doesn't pass any information to the
> resume() method.
> 
> I suppose we could have modified the "prepare to create snapshot" code 
> instead, but doing so would mean that "continue after snapshot" and 
> "continue after restore" would always do the same thing, which is not 
> necessarily a good idea.
> 
> Anyway, based on this analysis it seems reasonable to have Six (6) method 
> pointers.  Suggested names (in the same order as above):
> 
> 	pre_snaphot()
> 	post_snapshot()
> 	pre_restore()
> 	post_restore()
> 	suspend()
> 	resume()
> 
> People apparently assume that pre_snapshot() and pre_restore() would 
> always do the same thing and hence be redundant.  I'm not so sure; time 
> will tell.  Doing it this way certainly is more clear.

How do we differentiate between post_snapshot() and post_restore()?
I mean, after the restore we're entering the same code path as after the
snapshot, so do we use a global var for this purpose?

Rafael
