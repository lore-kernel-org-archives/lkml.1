Return-Path: <linux-kernel-owner+w=401wt.eu-S1759075AbZADVOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075AbZADVOD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:14:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752059AbZADVNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:13:51 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:59412 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbZADVNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:13:50 -0500
Date: Sun, 4 Jan 2009 13:13:49 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [BUG] NULL pointer deref with rcutorture
Message-ID: <20090104211349.GS6958@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090102111819.GC6088@alice> <20090102175853.GC6842@linux.vnet.ibm.com> <20090102185303.GC5743@linux.vnet.ibm.com> <20090102195326.GF6842@linux.vnet.ibm.com> <20090102231239.GA19778@alice> <20090103015748.GL6842@linux.vnet.ibm.com> <20090103094003.GA6149@alice> <20090104013254.GG6958@linux.vnet.ibm.com> <20090104145726.GA14895@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090104145726.GA14895@alice>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2009 at 03:57:26PM +0100, Eric Sesterhenn wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Sat, Jan 03, 2009 at 10:40:03AM +0100, Eric Sesterhenn wrote:
> > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > On Sat, Jan 03, 2009 at 12:12:39AM +0100, Eric Sesterhenn wrote:
> > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > 
> > > > > I tried to apply the patch from
> > > > > http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=392ddc32982a5c661dd90dd49a3cb37f1c68b782;hp=bb799ca0202a360fa74d5f17039b9100caebdde7
> > > > > but get a message that it is already applied. Seems i already got that
> > > > > one.
> > > > 
> > > > Is your configuration able to support ftrace?
> > > 
> > > yes
> > > 
> > > > Looks like someone is (wrongly) freeing some memory that was sent to
> > > > call_rcu(), and ftrace might be one way to locate the problem.
> > > 
> > > I set the filter to call_rcu() and call_rcu_sched(), reproduced the
> > > oops, and got this in the trace file.
> > 
> > Hmmm...  The only unique ones are _rcu_barrier() used during module
> > removal by rcutorture and rt_worker_func(), which occurs near the
> > beginning of the trace.  My next step would be to trace the addresses of
> > rcu_head structures passed to call_rcu() and friends and to also trace
> > the addresses of the structures as they are invoked (where the original
> > NULL-pointer exception occurred).
> > 
> > Is this tracing something you would be interested in taking on?  My
> > test setup is having some trouble, so it would probably be a couple of
> > days before I got it working.  :-/
> 
> Just tell me what i need to do, I am not really familiar with ftrace.
> I am only able to test 2.6.28-04980-gb58602a, since current -git is not
> able to boot on this box :|

Very cool!

The idea is to have __call_rcu() in kernel/rcutree.c record the
address of the callback (argument "head") and the function (argument
"func").  In rcu_do_batch(), just before invoking list->func(list),
also record the address of the callback ("list") and the function
(again, "func").

The new ftrace package has some mechanisms for doing this, but there is
always the old-fashioned way of using printk(), for example in
rcu_do_batch():

	prefetch(next);
	if (rcu_dump_callbacks)
		printk("rcu_head=%p, func=%p\n", list, func);
	list->func(list);

Initialize rcu_dump_callbacks to zero, then use a small kernel module
(or some such) to set it to one just before running your test.

If you would like, I could rough out the code, though as noted earlier,
I currently have no way of testing it.  (Hopefully will be fixed in a
few days.)

I was wondering what should be done for ftrace plugins for RCU, I guess
I now have at least part of the answer.  ;-)

							Thanx, Paul
