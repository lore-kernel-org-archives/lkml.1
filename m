Return-Path: <linux-kernel-owner+w=401wt.eu-S1758789AbZBLTij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789AbZBLTij (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 14:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758678AbZBLTi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 14:38:29 -0500
Received: from tomts36.bellnexxia.net ([209.226.175.93]:62853 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758656AbZBLTi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 14:38:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArMEAOQFlElMQWt2/2dsb2JhbACBbtJLhBgG
Date: Thu, 12 Feb 2009 14:38:26 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux
	(repost)
Message-ID: <20090212193826.GD2047@Krystal>
References: <20090211153246.GA6694@linux.vnet.ibm.com> <20090211185203.GA29852@Krystal> <20090211200903.GG6694@linux.vnet.ibm.com> <20090211214258.GA32407@Krystal> <20090212003549.GU6694@linux.vnet.ibm.com> <20090212023308.GA21157@linux.vnet.ibm.com> <20090212040824.GA12346@Krystal> <20090212050120.GA8317@linux.vnet.ibm.com> <20090212070539.GA15896@Krystal> <20090212164621.GC6759@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090212164621.GC6759@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:29:48 up 42 days, 19:27,  6 users,  load average: 0.77, 0.40,
	0.27
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replying to a separate portion of the mail with less CC :


> On Thu, Feb 12, 2009 at 02:05:39AM -0500, Mathieu Desnoyers wrote:
> > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > On Wed, Feb 11, 2009 at 11:08:24PM -0500, Mathieu Desnoyers wrote:
> > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > > > On Wed, Feb 11, 2009 at 04:35:49PM -0800, Paul E. McKenney wrote:
> > > > > > On Wed, Feb 11, 2009 at 04:42:58PM -0500, Mathieu Desnoyers wrote:
> > > > > > > * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > > 
> > > [ . . . ]
> > > 
> > > > > And I had bugs in my model that allowed the rcu_read_lock() model
> > > > > to nest indefinitely, which overflowed into the top bit, messing
> > > > > things up.  :-/
> > > > > 
> > > > > Attached is a fixed model.  This model validates correctly (woo-hoo!).
> > > > > Even better, gives the expected error if you comment out line 180 and
> > > > > uncomment line 213, this latter corresponding to the error case I called
> > > > > out a few days ago.
> > > > > 
> > > > 
> > > > Great ! :) I added this version to the git repository, hopefully it's ok
> > > > with you ?
> > > 
> > > Works for me!
> > > 
> > > > > I will play with removing models of mb...
> > > > 
> > > > OK, I see you already did..
> > > 
> > > I continued this, and surprisingly few are actually required, though
> > > I don't fully trust the modeling of removed memory barriers.
> > 
> > On my side I cleaned up the code a lot, and actually added some barriers
> > ;) Especially in the busy loops, where we expect the other thread's
> > value to change eventually between iterations. A smp_rmb() seems more
> > appropriate that barrier(). I also added a lot of comments about
> > barriers in the code, and made the reader side much easier to review.
> > 
> > Please feel free to comment on my added code comments.
> 
> The torture test now looks much more familiar.  ;-)
> 
> I fixed some compiler warnings (in my original, sad to say), added an
> ACCESS_ONCE() to rcu_read_lock() (also in my original),

Yes, I thought about this ACCESS_ONCE during my sleep.. just did not
have to to update the source yet. :)

Merged. Thanks !

[...]

> --- a/urcu.c
> +++ b/urcu.c
> @@ -99,7 +99,8 @@ static void force_mb_single_thread(pthread_t tid)
>  	 * BUSY-LOOP.
>  	 */
>  	while (sig_done < 1)
> -		smp_rmb();	/* ensure we re-read sig-done */
> +		barrier();	/* ensure compiler re-reads sig-done */
> +				/* cache coherence guarantees CPU re-read. */

That could be a smp_rmc() ? (see other mail)

>  	smp_mb();	/* read sig_done before ending the barrier */
>  }
>  
> @@ -113,7 +114,8 @@ static void force_mb_all_threads(void)
>  	if (!reader_data)
>  		return;
>  	sig_done = 0;
> -	smp_mb();	/* write sig_done before sending the signals */
> +	/* smp_mb();	write sig_done before sending the signals */
> +			/* redundant with barriers in pthread_kill(). */

Absolutely not. pthread_kill does not send a signal to self in every
case because the writer thread has not requirement to register itself.
It *could* be registered as a reader too, but does not have to.

>  	for (index = reader_data; index < reader_data + num_readers; index++)
>  		pthread_kill(index->tid, SIGURCU);
>  	/*
> @@ -121,7 +123,8 @@ static void force_mb_all_threads(void)
>  	 * BUSY-LOOP.
>  	 */
>  	while (sig_done < num_readers)
> -		smp_rmb();	/* ensure we re-read sig-done */
> +		barrier();	/* ensure compiler re-reads sig-done */
> +				/* cache coherence guarantees CPU re-read. */

That could be a smp_rmc() ?

>  	smp_mb();	/* read sig_done before ending the barrier */
>  }
>  #endif
> @@ -181,7 +184,8 @@ void synchronize_rcu(void)
>  	 * the writer waiting forever while new readers are always accessing
>  	 * data (no progress).
>  	 */
> -	smp_mb();
> +	/* smp_mb(); Don't need this one for CPU, only compiler. */
> +	barrier();

smp_mc() ?

>  
>  	switch_next_urcu_qparity();	/* 1 -> 0 */
>  

Side-note :
on archs without cache coherency, all smp_[rw ]mb would turn into a
cache flush.

Mathieu


-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
