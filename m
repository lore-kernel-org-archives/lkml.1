Return-Path: <linux-kernel-owner+w=401wt.eu-S1756173AbZBHAUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173AbZBHAUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 19:20:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbZBHAUE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 19:20:04 -0500
Received: from tomts16.bellnexxia.net ([209.226.175.4]:63378 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754106AbZBHAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 19:20:03 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAB6yjUlMQWt2/2dsb2JhbACBbspphBoG
Date: Sat, 7 Feb 2009 19:19:56 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org,
       Robert Wisniewski <bob@watson.ibm.com>
Subject: Re: [RFC git tree] Userspace RCU (urcu) for Linux (repost)
Message-ID: <20090208001956.GB5282@Krystal>
References: <20090206030543.GB8560@Krystal> <20090206045841.GA12995@Krystal> <20090206130640.GB10918@linux.vnet.ibm.com> <20090206163432.GF10918@linux.vnet.ibm.com> <20090207151028.GA11150@linux.vnet.ibm.com> <20090207221627.GA26162@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090207221627.GA26162@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:19:47 up 38 days, 17 min,  3 users,  load average: 0.27, 0.58,
	0.54
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Sat, Feb 07, 2009 at 07:10:28AM -0800, Paul E. McKenney wrote:
> > So, how to fix?  Here are some approaches:
> > 
> > o	Make urcu_publish_content() do two parity flips rather than one.
> > 	I use this approach in my rcu_rcpg, rcu_rcpl, and rcu_rcpls
> > 	algorithms in CodeSamples/defer.
> > 
> > o	Use a single free-running counter, in a manner similar to rcu_nest,
> > 	as suggested earlier.  This one is interesting, as I rely on a
> > 	read-side memory barrier to handle the long-preemption case.
> > 	However, if you believe that any thread that waits several minutes
> > 	between executing adjacent instructions must have been preempted
> > 	(which the memory barriers that are required to do a context
> > 	switch), then a compiler barrier suffices.  ;-)
> > 
> > Of course, the probability of seeing this failure during test is quite
> > low, since it is unlikely that thread 0 would run just long enough to
> > execute its signal handler.  However, it could happen.  And if you were
> > to adapt this algorithm for use in a real-time application, then priority
> > boosting could cause this to happen naturally.
> 
> And here is a patch, taking the first approach.  It also exposes a
> synchronize_rcu() API that is used by the existing urcu_publish_content()
> API.  This allows easier handling of structures that are referenced by
> more than one pointer.  And should also allow to be more easily plugged
> into my rcutorture test.  ;-)
> 

Merged, thanks !

Mathieu

> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
>  urcu.c |   39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/urcu.c b/urcu.c
> index e401d8d..1a276ce 100644
> --- a/urcu.c
> +++ b/urcu.c
> @@ -113,13 +113,35 @@ void wait_for_quiescent_state(int parity)
>  	force_mb_all_threads();
>  }
>  
> +static void switch_qparity(void)
> +{
> +	int prev_parity;
> +
> +	/* All threads should read qparity before accessing data structure. */
> +	/* Write ptr before changing the qparity */
> +	force_mb_all_threads();
> +	prev_parity = switch_next_urcu_qparity();
> +
> +	/*
> +	 * Wait for previous parity to be empty of readers.
> +	 */
> +	wait_for_quiescent_state(prev_parity);
> +}
> +
> +void synchronize_rcu(void)
> +{
> +	rcu_write_lock();
> +	switch_qparity();
> +	switch_qparity();
> +	rcu_write_unlock();
> +}
> +
>  /*
>   * Return old pointer, OK to free, no more reference exist.
>   * Called under rcu_write_lock.
>   */
>  void *urcu_publish_content(void **ptr, void *new)
>  {
> -	int prev_parity;
>  	void *oldptr;
>  
>  	/*
> @@ -134,19 +156,10 @@ void *urcu_publish_content(void **ptr, void *new)
>  	 */
>  	oldptr = *ptr;
>  	*ptr = new;
> -	/* All threads should read qparity before ptr */
> -	/* Write ptr before changing the qparity */
> -	force_mb_all_threads();
> -	prev_parity = switch_next_urcu_qparity();
>  
> -	/*
> -	 * Wait for previous parity to be empty of readers.
> -	 */
> -	wait_for_quiescent_state(prev_parity);
> -	/*
> -	 * Deleting old data is ok !
> -	 */
> -	
> +	switch_qparity();
> +	switch_qparity();
> +
>  	return oldptr;
>  }
>  
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
