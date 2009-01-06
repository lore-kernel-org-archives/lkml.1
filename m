Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbZAFVmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbZAFVmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 16:42:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbZAFVmd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 16:42:33 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46037 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907AbZAFVmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 16:42:32 -0500
Date: Tue, 6 Jan 2009 13:42:29 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH][RFC]: mutex: adaptive spin
Message-ID: <20090106214229.GD6741@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <87r63ljzox.fsf@basil.nowhere.org> <20090103191706.GA2002@parisc-linux.org> <1231093310.27690.5.camel@twins> <20090104184103.GE2002@parisc-linux.org> <1231242031.11687.97.camel@twins> <20090106121052.GA27232@elte.hu> <4963584A.4090805@novell.com> <20090106131643.GA15228@elte.hu> <1231248041.11687.107.camel@twins> <49636799.1010109@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49636799.1010109@novell.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2009 at 09:15:53AM -0500, Gregory Haskins wrote:
> Peter Zijlstra wrote:
> > On Tue, 2009-01-06 at 14:16 +0100, Ingo Molnar wrote:
> >   
> >> * Gregory Haskins <ghaskins@novell.com> wrote:
> >>
> >>     
> >>> Ingo Molnar wrote:
> >>>       
> >>>> There's no time or spin-rate based heuristics in this at all (i.e. these 
> >>>> mutexes are not 'adaptive' at all!),
> >>>>         
> >>> FYI: The original "adaptive" name was chosen in the -rt implementation 
> >>> to reflect that the locks can adaptively spin or sleep, depending on 
> >>> conditions.  I realize this is in contrast to the typical usage of the 
> >>> term when it is in reference to the spin-time being based on some 
> >>> empirical heuristics, etc as you mentioned.  Sorry for the confusion.
> >>>       
> >> the current version of the -rt spinny-mutexes bits were mostly written by 
> >> Steve, right? Historically it all started out with a more classic 
> >> "adaptive mutexes" patchset so the name stuck i guess.
> >>     
> >
> > Yeah, Gregory and co. started with the whole thing and showed there was
> > significant performance to be gained, after that Steve rewrote it from
> > scratch reducing it to this minimalist heuristic, with help from Greg.
> >
> > (At least, that is how I remember it, please speak up if I got things
> > wrong)
> >   
> Thats pretty accurate IIUC.  The concept and original patches were
> written by myself, Peter Morreale and Sven Dietrich (cc'd).  However,
> Steve cleaned up our patch before accepting it into -rt (we had extra
> provisions for things like handling conditional compilation and run-time
> disablement which he did not care for), but its otherwise the precise
> core concept we introduced.  I think Steven gave a nice attribution to
> that fact in the prologue, however.  And I also ACKed his cleanup, so I
> think all is well from my perspective.
> 
> As a historical note: It should be mentioned that Steven also introduced
> a really brilliant optimization to use RCU for the owner tracking that
> the original patch as submitted by my team did not have.  However, it
> turned out to inadvertently regress performance due to the way
> preempt-rcu's rcu_read_lock() works so it had to be reverted a few weeks
> later to the original logic that we submitted (even though on paper his
> ideas in that area were superior to ours).  So whats in -rt now really
> is more or less our patch sans the conditional crap, etc. 

Preemptable RCU needs to be faster.  Got it -- and might have a way
to do it by eliminating the irq disabling and cutting way back on the
number of operations that must be performed.  It would probably still
be necessary to access the task structure.

Or is something other than the raw performance of rcu_read_lock() and
rcu_read_unlock() at issue here?

							Thanx, Paul

> Hope that helps!
> 
> -Greg
> 


