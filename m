Return-Path: <linux-kernel-owner+w=401wt.eu-S1754865AbXK0CkQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbXK0CkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 21:40:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbXK0CkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 21:40:04 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:50395 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbXK0CkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 21:40:02 -0500
Date: Mon, 26 Nov 2007 18:39:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: James Huang <James.Huang@watchguard.com>
Cc: linux-kernel@vger.kernel.org, Manfred Spraul <manfred@colorfullife.com>,
       jamesclhuang@yahoo.com, ego@in.ibm.com
Subject: Re: __rcu_process_callbacks() in Linux 2.6
Message-ID: <20071127023958.GF9136@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <590353.52909.qm@web83819.mail.sp1.yahoo.com> <F474D80A8B96F34D8D70C85A98D6FC178D8BE7@VS02SE.wgti.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F474D80A8B96F34D8D70C85A98D6FC178D8BE7@VS02SE.wgti.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2007 at 02:48:08PM -0800, James Huang wrote:
> 
> > -----Original Message-----
> > From: James Huang [mailto:jamesclhuang@yahoo.com]
> > Sent: Monday, November 26, 2007 2:21 PM
> > To: James Huang
> > Subject: Fw: __rcu_process_callbacks() in Linux 2.6
> > 
> > ----- Forwarded Message ----
> > From: Manfred Spraul <manfred@colorfullife.com>
> > To: James Huang <jamesclhuang@yahoo.com>
> > Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>; linux-
> > kernel@vger.kernel.org
> > Sent: Monday, November 26, 2007 10:28:37 AM
> > Subject: __rcu_process_callbacks() in Linux 2.6
> > 
> > Hi James,
> > 
> > If I understand the issue correctly, then the race is:
> > 
> > step 1: cpu 1: starts a new rcu batch (i.e. rcp->cur++, smb_mb)
> > 
> > step 2: cpu 2: completes the quiet state
> > step 3: cpu 2: reads pointer 0x123 (ptr to a rcu protected struct)
> > 
> > step 4: cpu 3: call_rcu(0x123): rcu protected struct added to
> rdp->nxtlist
> > step 5: cpu 3: moves a new batch into rdp->curlist, rdp->batch = rcp-
> > >cur+1.
> > xxxxxxxxxxxxxxx Problem: where is the smp_rmb() that guarantees that
> > xxxxxxxxxxxxxxx  update to rcp->cur from step 1 is seen by cpu 3?
> > step 6: cpu 3: completes quiet state
> > step 7: cpu 3: struct 0x123 destroyed
> > 
> > step 8: cpu 2: accesses pointer 0x123, but the struct is already
> destroyed
> > 
> > James: Is that the race?
> 
> 
> [James Huang] 
> 
> Yes, this is the race condition that I am concerned about.
> 
> 
> > 
> > I agree with Paul, there are smb_rmb's on cpu 3 between Step 1 and
> Step 5:
> > Either the test_and_set_bit in tasklet_action for rcu_process_callback
> > if step 4 happens before the tasklet or somewhere in the irq handler
> > path if step 4 happens in an irq handler that interrupted
> > rcu_process_callback.
> > 
> > Thus theoretically no additional smb_rmb() should be necessary.
> > What is missing is proper documentation.
> > 
> 
> 
> [James Huang] 
> 
> Is it true that a smb_rmb() before a read operation (say from variable
> X) will guarantee that the read will always retrieve the most "current"
> value of X?   I can not find such a guarantee in atomic_ops.txt or
> memory-barriers.txt under Linux's documentation directory.  What is
> described in both documents is relative ordering, e.g.
> 
>             CPU1                       CPU2
>            ------                     ------
>           write X = x1
>           smp_wmb()  
>           write Y = y1 
> 
>                                       read Y
>                                       smp_rmb()
>                                       read X
> 
> Then CPU2 will read X with a value of x1 if it reads Y with a value of
> y1.
> 
> Please point me to the right section in the document if smp_rmb() does
> provide such a guarantee.

You are correct, smp_rmb() is about ordering rather than about any sort
of immediacy.  For one thing, it can be quite difficult to say exactly what
the most "current" version of X might be at a given point in time from
the viewpoint of a given CPU -- the different CPUs might well disagree as
to what the "current" version is for awhile (though they are guaranteed
to come to agreement).

> Thanks,
> -- James Huang
> 
> > I'm analyzing the code right now:
> > Is it really true that typically a cpu only completes data in every
> other
> > rcu
> > cycle? I.e. that most structures are stored in the rcu callback list
> until
> > two
> > quiet states happened?

That is correct.  This does mean that we should be able to leverage
locking primitives and memory barriers executed from the scheduling
clock interrupt.

> > I've tried to track the values of rcp->cur and rdp->batch.
> > If next_pending is set, then cpu_quiet() immetiately starts
> > the next rcu cycle and a cpu cannot both complete the currently
> > pending rcu callbacks and add new callbacks to the next cycle,
> > thus a cpu only takes part in every other rcu cycle.
> > 
> > The oocalc file is at
> > http://www.colorfullife.com/~manfred/rcu.ods
> > http://www.colorfullife.com/~manfred/rcu.pdf
> > 
> > Is that analysis correct? Perhaps the whole code should be rewritten?

I believe that the sequencing in spreadsheet is correct (and thank
you very much for going through it!!!), but it seems to be silent on
memory-barrier issues.

I also believe that Gautham's new CPU-hotplug setup will make
it possible to simplify the code quite a bit.  And given that the
grace-period-detection code is not on any sort of hot code path, it should
be possible to use a less-aggressive design, perhaps one using straight
locking to guard the shared structures.  Also, we are working in the
-rt implementation on a scheme that allows CPUs to stay asleep through
a grace period without the heavy overhead that is otherwise required to
interact with them.  The trick is to maintain a per-CPU counter that is
incremented on each entry and exit to low-power state.  But I would like
to get this right in -rt before trying it in Classic RCU.  ;-)

						Thanx, Paul
