Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbYJQO4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbYJQO4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 10:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbYJQO4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 10:56:34 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55206 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbYJQO4d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 10:56:33 -0400
Date: Fri, 17 Oct 2008 07:56:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, serue@us.ibm.com,
       sds@tycho.nsa.gov, jmorris@namei.org, chrisw@sous-sol.org,
       dhowells@redhat.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, haradats@nttdata.co.jp,
       akpm@linux-foundation.org
Subject: Re: [TOMOYO #10 (linux-next) 7/8] File operation restriction part.
Message-ID: <20081017145630.GC6706@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081009042814.398846861@nttdata.co.jp> <20081009042922.939610141@nttdata.co.jp> <20081009164836.GA5480@us.ibm.com> <200810120909.GDF95392.SQOFFFHVtOMOJL@I-love.SAKURA.ne.jp> <20081015012916.GF6874@linux.vnet.ibm.com> <48F6BD8E.4050402@nttdata.co.jp> <20081016151003.GA6772@linux.vnet.ibm.com> <48F84DAB.4060002@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F84DAB.4060002@nttdata.co.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 05:32:43PM +0900, Kentaro Takeda wrote:
> Quoting from http://lkml.org/lkml/2008/2/2/255
> > Similarly, the smp_read_barrier_depends() is only for initialization
> > of something that is about to enter the list.  As with the smp_wmb()
> > primitive, smp_read_barrier_depends() also is not to protect against
> > freeing.  Instead, it is rcu_read_lock() and rcu_read_unlock() that
> > protect against freeing.
>
> We don't need to use rcu_read_lock() and rcu_read_unlock() because 
> we don't free elements in a list. I see.

Agreed!

> However, to ensure the reader gets up-to-date value, we need to use 
> smp_read_barrier_depends() (which is expanded to "mb()" for SMP on 
> Alpha, "read_barrier_depends()" for SMP on H8300, "((void)0)" for SMP 
> on M68K-nommu, "((void)0)" for M68K, "do { } while (0)" otherwise) 
> whenever the reader fetches an element in a list.

Yep.  You will also need the ACCESS_ONCE() on the pointer fetch in order
to suppress aggressive compiler optimizations.  The rcu_dereference()
primitive packages them up nicely.

> Paul E. McKenney wrote:
> > But fair enough.  How about the following?
> > 
> > 	#define worm_dereference()	rcu_dereference()
> > 	#define worm_assign_pointer()	rcu_assign_pointer()
> > 
> So, I understood that the rcu_dereference() and rcu_assign_pointer() 
> are not only for RCU. They are needed to ensure the reader gets 
> up-to-date value. Then, their names should be var_dereference() and 
> var_assign_pointer() or something, shouldn't they? The "rcu_" prefix 
> and comments on rcu_dereference in include/linux/rcupdate.h sound for 
> me that they are used for variables protected by RCU locking 
> mechanism only...

Well, there are 200+ uses of rcu_dereference() for RCU, so it would
99.5%+ accurate to retain the "rcu_" prefix.  ;-)

Once we have several non-RCU uses, we can probably do a much better
job of coming up with a good name for the underlying independent-of-RCU
primitive.  So we should stick with rcu_dereference() as the name of the
underlying primitive for now, and re-evaluate the naming in a year or
after another five non-RCU uses of rcu_dereference() appear, whichever
comes later.  (My current guess for names are "pointer_subscribe()"
for rcu_dereference() and "pointer_publish()" for rcu_assign_pointer(),
but who knows?)

Fair enough?

> You are suggesting to explicitly call rcu_assign_pointer() (which 
> will call smp_wmb()) and rcu_dereference() (which will call 
> smp_read_barrier_depends()). But I think that the various cache 
> invalidations driven by the workload will call rcu_assign_pointer() 
> and rcu_dereference() sooner or later. So, if the reader can tolerate 
> reading non-up-to-date value (in fact, TOMOYO can), isn't there a 
> choice to omit rcu_assign_pointer() and rcu_dereference() (which will 
> cost "mb()" for SMP on Alpha)?

TOMOYO can tolerate reading the complete garbage that would appear if
the pointer was assigned before the pointed-to fields are initialized?
I must confess that I am having a hard time believing that.  Please
explain how this works.

							Thanx, Paul
