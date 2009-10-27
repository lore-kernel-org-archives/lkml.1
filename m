Return-Path: <linux-kernel-owner+w=401wt.eu-S1756364AbZJ0Rd0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364AbZJ0Rd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 13:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754275AbZJ0RdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 13:33:25 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37170 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754112AbZJ0RdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 13:33:25 -0400
Date: Tue, 27 Oct 2009 09:14:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>, Gregory Haskins <ghaskins@novell.com>,
       kvm@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [KVM PATCH v3 1/3] KVM: fix race in irq_routing logic
Message-ID: <20091027161433.GC6258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091026162148.23704.47286.stgit@dev.haskins.net> <20091026162157.23704.12420.stgit@dev.haskins.net> <20091027064529.GJ29477@redhat.com> <4AE6F7F7.1010302@gmail.com> <20091027140237.GM29477@redhat.com> <20091027144932.GK6645@linux.vnet.ibm.com> <4AE70B7F.5030602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE70B7F.5030602@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 27, 2009 at 11:02:23AM -0400, Gregory Haskins wrote:
> Thanks for this, Paul.
> 
> Some questions and statements below.
> 
> Paul E. McKenney wrote:
> > On Tue, Oct 27, 2009 at 04:02:37PM +0200, Gleb Natapov wrote:
> >> On Tue, Oct 27, 2009 at 09:39:03AM -0400, Gregory Haskins wrote:
> > 
> > [ . . . ]
> > 
> >>> standard RCU RSCS, which is what SRCU is designed for.  So rather than
> >>> inventing an awkward two-phased stack based solution, it's better to
> >>> reuse the provided tools, IMO.
> >>>
> >>> To flip it around:  Is there any reason why an SRCU would not work here,
> >>> and thus we were forced to use something like the stack-copy approach?
> >>>
> >> If SRCU has no disadvantage comparing to RCU why not use it always? :)
> > 
> > The disadvantages of SRCU compared to RCU include the following:
> > 
> > 1.	SRCU requires that the return value of srcu_read_lock()
> > 	be fed into srcu_read_unlock().  This is usually not a problem,
> > 	but can be painful if there are multiple levels of function
> > 	call separating the two.
> 
> Right, and this is simple/neat w.r.t. its usage in irq_routing, so no
> problem there.

Fair enough!

> > 
> > 2.	SRCU's grace periods are about 4x slower than those of RCU.
> > 	And they also don't scale all that well with extremely large
> > 	numbers of CPUs (but this can be fixed when/if it becomes a
> > 	real problem).
> 
> The irq_routing update path is extremely infrequent, so this should not
> be an issue.

Sounds good!

> > 3.	SRCU's read-side primitives are also significantly slower than
> > 	those of RCU.
> 
> Are the 10ns vs 45ns numbers that I mentioned in my last reply the
> proper ballpark?  How do these compare to an atomic-op, say an
> uncontended spinlock on modern hardware?  The assumption is that
> srcu_read_lock() should be significantly cheaper than a read-lock().  If
> its not, then we might as well use something else, I suppose.  But if
> its not, I guess you probably wouldn't have bothered to invent it in the
> first place ;)

SRCU read-side critical sections should indeed be quite a bit cheaper than
uncontended spinlock, particularly if the spinlock was last released by
some other CPU.  There are those who insist that uncontended spinlocks
and atomic operations will soon be free, but I will believe this when
I see it.  ;-)

> > 4.	SRCU does not have a call_srcu().  One could be provided, but
> > 	its semantics would be a bit strange due to the need to limit
> > 	the number of callbacks, given that general blocking is
> > 	permitted in SRCU read-side critical sections.  (And it would
> > 	take some doing to convince me to supply an SRCU!)
> 
> This is not an issue in our design.

Very good!

> > 5.	The current SRCU has no reasonable way to implement read-side
> > 	priority boosting, as there is no record of which task
> > 	is read-holding which SRCU.
> 
> Given the infrequency of the update path, I do not see this as a problem.

Sounds like you have it covered, then!

							Thanx, Paul
