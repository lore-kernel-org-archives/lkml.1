Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZACEwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZACEwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:52:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757048AbZACEwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:52:33 -0500
Received: from kumera.dghda.com ([80.68.90.171]:52314 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZACEwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:52:33 -0500
From: "Duane Griffin" <duaneg@dghda.com>
Date: Sat, 3 Jan 2009 04:52:28 +0000
To: Chris Adams <cmadams@hiwaay.net>
Cc: Duane Griffin <duaneg@dghda.com>, Linas Vepstas <linasvepstas@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Re: Bug: Status/Summary of slashdot leap-second crash
	on new years 2008-2009
Message-ID: <20090103045227.GA5994@dastardly.home.dghda.com>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com> <20090103002114.GA1538533@hiwaay.net> <20090103022358.GA2454@dastardly.home.dghda.com> <20090103044143.GB1538533@hiwaay.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103044143.GB1538533@hiwaay.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 10:41:43PM -0600, Chris Adams wrote:
> Once upon a time, Duane Griffin <duaneg@dghda.com> said:
> > On Fri, Jan 02, 2009 at 06:21:14PM -0600, Chris Adams wrote:
> > > In any case, the quick-n-dirty fix would be to not try to printk while
> > > holding xtime_lock (I think the NTP code is the only thing that does).
> > > However, it would be nice to still get the leap second notification, so
> > > some other fix would be better I guess.
> > 
> > How about just moving the printk out of the lock? I.e. something like
> > this:
> 
> Well, you've only fixed the inserting a leap second case, not the
> removing a leap second case.  AFAIK we've never actually had a leap
> second removed, but it could happen (and the code is already there), so
> it should be fixed as well.

Quite right...

> Also, I didn't notice the locking was right there in the ntp_leap_second
> function in the 2.6.26.6 kernel I was looking at, because I've also been
> looking at the 2.6.9-based RHEL 4 kernel (which is a good bit different;
> the lock is held outside the function, so it wouldn't be easy to drop it
> for the printk).  I guess that's Red Hat's (and other long-term support
> vendors') problem.  The simplest thing for them is still probably to
> just remove the printks.
> 
> Here's a patch that moves both prinkts outside the lock.  I am unable to
> make a kernel with this patch crash on a leap second insertion or
> deletion.
> -- 
> Chris Adams <cmadams@hiwaay.net>
> Systems and Network Administrator - HiWAAY Internet Services
> I don't speak for anybody but myself - that's enough trouble.
> 
> 
> From: Chris Adams <cmadams@hiwaay.net>
> 
> The code to handle leap seconds printks an information message when the
> second is inserted or deleted.  It does this while holding xtime_lock.
> However, printk wakes up klogd, and in some cases, the scheduler tries
> to get the current kernel time, trying to get xtime_lock (which results
> in a deadlock).  This moved the printks outside of the lock.
> 
> Signed-off-by: Chris Adams <cmadams@hiwaay.net>
> ---
> diff -urpN linux-2.6.28-git5-vanilla/kernel/time/ntp.c linux-2.6.28-git5/kernel/time/ntp.c
> --- linux-2.6.28-git5-vanilla/kernel/time/ntp.c	2009-01-02 22:09:34.000000000 -0600
> +++ linux-2.6.28-git5/kernel/time/ntp.c	2009-01-02 22:11:23.000000000 -0600
> @@ -130,6 +130,7 @@ void ntp_clear(void)
>  static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
>  {
>  	enum hrtimer_restart res = HRTIMER_NORESTART;
> +	int msg = 0;
>  
>  	write_seqlock(&xtime_lock);
>  
> @@ -140,8 +141,7 @@ static enum hrtimer_restart ntp_leap_sec
>  		xtime.tv_sec--;
>  		wall_to_monotonic.tv_sec++;
>  		time_state = TIME_OOP;
> -		printk(KERN_NOTICE "Clock: "
> -		       "inserting leap second 23:59:60 UTC\n");
> +		msg = 1;
>  		hrtimer_add_expires_ns(&leap_timer, NSEC_PER_SEC);
>  		res = HRTIMER_RESTART;
>  		break;
> @@ -150,8 +150,7 @@ static enum hrtimer_restart ntp_leap_sec
>  		time_tai--;
>  		wall_to_monotonic.tv_sec--;
>  		time_state = TIME_WAIT;
> -		printk(KERN_NOTICE "Clock: "
> -		       "deleting leap second 23:59:59 UTC\n");
> +		msg = 2;
>  		break;
>  	case TIME_OOP:
>  		time_tai++;
> @@ -166,6 +165,17 @@ static enum hrtimer_restart ntp_leap_sec
>  
>  	write_sequnlock(&xtime_lock);
>  
> +	switch (msg) {
> +	case 1:
> +		printk(KERN_NOTICE "Clock: "
> +		       "inserting leap second 23:59:60 UTC\n");
> +		break;
> +	case 2:
> +		printk(KERN_NOTICE "Clock: "
> +		       "deleting leap second 23:59:59 UTC\n");
> +		break;
> +	}
> +
>  	return res;
>  }
>  

How about instead of a switch statement, assigning the message to a
variable and printing that. I.e. something like:

static enum hrtimer_restart ntp_leap_second(struct hrtimer *timer)
{
	enum hrtimer_restart res = HRTIMER_NORESTART;
	const char *msg = NULL;

	...
		msg = "Clock: inserting leap second 23:59:60 UTC";
	...
		msg = "Clock: deleting leap second 23:59:59 UTC";
	...

        if (msg)
                printk(KERN_NOTICE "%s\n", msg);

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
