Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbZBZQpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbZBZQpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 11:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbZBZQpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 11:45:15 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:47342 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754527AbZBZQpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 11:45:13 -0500
Date: Thu, 26 Feb 2009 08:45:09 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Bharata B Rao <bharata.rao@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuacct: add a branch prediction
Message-ID: <20090226164509.GB6634@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <49A6501B.7040604@cn.fujitsu.com> <20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com> <49A65455.4030204@cn.fujitsu.com> <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com> <344eb09a0902260210y44c0684by9b22f041116d3f7c@mail.gmail.com> <18f6db017e5d44596e828e0753f28e75.squirrel@webmail-b.css.fujitsu.com> <1235645076.4645.4781.camel@laptop> <934198669efa83e838a52284e2c4f8b5.squirrel@webmail-b.css.fujitsu.com> <1235647682.4948.15.camel@laptop> <145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <145d0010d65060bb089d5a87e06cbd0d.squirrel@webmail-b.css.fujitsu.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 26, 2009 at 09:06:24PM +0900, KAMEZAWA Hiroyuki wrote:
> Peter Zijlstra wrote：
> > On Thu, 2009-02-26 at 20:17 +0900, KAMEZAWA Hiroyuki wrote:
> >> Peter Zijlstra wrote：
> >> > On Thu, 2009-02-26 at 19:28 +0900, KAMEZAWA Hiroyuki wrote:
> >> >
> >> >> Taking hierarchy mutex while reading will make read-side stable.
> >> >
> >> > We're talking about scheduling here, taking a mutex to stop scheduling
> >> > won't work, nor will it be acceptible to use anything that will.
> >> >
> >> No mutex is necessary, anyway.
> >> hierarchy-walker function completely works well under rcu read lock,
> >> if small jitter is allowed.
> >
> > Right, should be doable -- and looking at the code, we have this
> > horrible 32 bit exception in there that locks the rq in order to read
> > the 64bit value.
> >
> > Would be grand to get rid of that,. how bad would it be for userspace to
> > get the occasionally fubarred value?
> >
> >From view of user-support saler, if terrible broken value is reported,
> it will be user-incident and annoy me(us) ;)
> 
> I'd like to get rid of rq->lock, too..Hmm.. some routine like
> atomic64_read() can help this ? (But I don't want to use atomic_t here..)

atomic64_read() will not help you on a 32-bit machine.  Here is the
sequence of events that will cause the aforementioned user incidents and
consequent annoyance:

o	The value of the counter is (2^32)-1, or 0xffffffff.

o	CPU 0 reads the high-order 32 bits of the counter, getting zero.

o	CPU 1 increments the low-order 32 bits of the counter, resulting
	in zero, but notes that there is a carry out of this field.

o	CPU 0 reads the low-order 32 bits of the counter, getting zero.

o	CPU 1 increments the high-order 32 bits of the counter, so that
	the new value of the counter is 2^32, or 0x100000000.

So CPU 0 gets a value that is -way- off.

The usual trick is something like the following for counter read:

1.	Read the high-order 32 bits of the counter.

2.	Do a memory barrier, smp_mb().

3.	Read the low-order 32 bits of the counter.

4.	Do another memory barrier, again smp_mb().

5.	Read the high-order 32 bits of the counter again.

	If it is the same as the value obtained in step 1 (or the previous
	execution of step 5), then we are done.  (This works even in case
	of complete 64-bit overflow, though we should be very lucky to
	live that long!)  Otherwise, go to step 2.

But it is also necessary to modify the counter update:

1.	Increment the low-order 32 bits of the counter.  If no overflow
	occurred, we are done, otherwise, continue through this sequence
	of steps.

2.	Do a memory barrier, smp_mb().

3.	Increment the high-order 32 bits of the counter.

How to detect overflow in step 1?  Well, if we are incrementing, we can
just test for the new value being zero.  Otherwise, if we are adding
a 32-bit number, if the new value of the low-order 32 bits of counter
is less than the old value, overflow occurred (but make sure that the
comparison is unsigned!).

This all assumes that you are adding a 32-bit quantity to the counter.
Adding 64-bit values is not much harder.

Does this approach work for you?

							Thanx, Paul

> > But aside from that, the cpu controller itself is also summing directly
> > up the hierarchy, so cpuacct doing the same doesn't seem odd.
> >
> I'll post some idea if I can think of something reasonable.
> But I tend to hesitate to modify sched.c ;)
> 
> Thanks,
> -Kame
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
