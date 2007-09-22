Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbXIVEHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbXIVEHa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 00:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751029AbXIVEHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 00:07:21 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:57549 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751005AbXIVEHU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 00:07:20 -0400
Date: Fri, 21 Sep 2007 21:07:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com,
       Thomas Gleixner <tglx@linutronix.de>, a.p.zijlstra@chello.nl,
       bunk@kernel.org, ego@in.ibm.com, oleg@tv-sign.ru
Subject: Re: [PATCH RFC 3/9] RCU: Preemptible RCU
Message-ID: <20070922040705.GA11123@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070910183004.GA3299@linux.vnet.ibm.com> <20070910183412.GC3819@linux.vnet.ibm.com> <20070921144003.GC15697@goodmis.org> <20070922002607.GI9059@linux.vnet.ibm.com> <Pine.LNX.4.58.0709212044200.4791@gandalf.stny.rr.com> <20070922015324.GN9059@linux.vnet.ibm.com> <Pine.LNX.4.58.0709212257150.6217@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0709212257150.6217@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2007 at 11:15:42PM -0400, Steven Rostedt wrote:
> On Fri, 21 Sep 2007, Paul E. McKenney wrote:
> > On Fri, Sep 21, 2007 at 09:15:03PM -0400, Steven Rostedt wrote:
> > > On Fri, 21 Sep 2007, Paul E. McKenney wrote:
> > > > On Fri, Sep 21, 2007 at 10:40:03AM -0400, Steven Rostedt wrote:
> > > > > On Mon, Sep 10, 2007 at 11:34:12AM -0700, Paul E. McKenney wrote:

[ . . . ]

> > > Are we sure that adding all these grace periods stages is better than just
> > > biting the bullet and put in a memory barrier?
> >
> > Good question.  I believe so, because the extra stages don't require
> > much additional processing, and because the ratio of rcu_read_lock()
> > calls to the number of grace periods is extremely high.  But, if I
> > can prove it is safe, I will certainly decrease GP_STAGES or otherwise
> > optimize the state machine.
> 
> But until others besides yourself understand that state machine (doesn't
> really need to be me) I would be worried about applying it without
> barriers.  The barriers may add a bit of overhead, but it adds some
> confidence in the code.  I'm arguing that we have barriers in there until
> there's a fine understanding of why we fail with 3 stages and not 4.
> Perhaps you don't have a box with enough cpus to fail at 4.
> 
> I don't know how the higher ups in the kernel command line feel, but I
> think that memory barriers on critical sections are justified. But if you
> can show a proof that adding extra stages is sufficient to deal with
> CPUS moving memory writes around, then so be it. But I'm still not
> convinced that these extra stages are really solving the bug instead of
> just making it much less likely to happen.
> 
> Ingo praised this code since it had several years of testing in the RT
> tree. But that version has barriers, so this new verison without the
> barriers has not had that "run it through the grinder" feeling to it.

Fair point...  Though the -rt variant has its shortcomings as well,
such as being unusable from NMI/SMI handlers.

How about this:  I continue running the GP_STAGES=3 run on the pair of
POWER machines (which are both going strong, and I also get a document
together describing the new version (and of course apply the changes we
have discussed, and merge with recent CPU-hotplug changes -- Gautham
Shenoy is currently working this), work out a good answer to "how
big exactly does GP_STAGES need to be", test whatever that number is,
assuming it is neither 3 nor 4, and figure out why the gekko-lp1 machine
choked on GP_STAGES=3.

Then we can work out the best path forward from wherever that ends up
being.

[ . . . ]

						Thanx, Paul
