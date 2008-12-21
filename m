Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbYLUIyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbYLUIyv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 03:54:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbYLUIyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 03:54:43 -0500
Received: from www.tglx.de ([62.245.132.106]:50267 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbYLUIyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 03:54:43 -0500
Date: Sun, 21 Dec 2008 09:53:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Oleg Nesterov <oleg@redhat.com>
cc: Eric Sesterhenn <snakebyte@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] Null pointer deref with hrtimer_try_to_cancel()
In-Reply-To: <20081220210401.GA14447@redhat.com>
Message-ID: <alpine.LFD.2.00.0812210950040.3376@localhost.localdomain>
References: <20081219172549.GA25722@alice> <alpine.LFD.2.00.0812202117310.3376@localhost.localdomain> <20081220210401.GA14447@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Dec 2008, Oleg Nesterov wrote:
> On 12/20, Thomas Gleixner wrote:
> >
> > +static int no_timer_create(struct k_itimer *new_timer)
> > +{
> > +	return -EOPNOTSUPP;
> > +}
> > +
> >  /*
> >   * Return nonzero if we know a priori this clockid_t value is bogus.
> >   */
> > @@ -248,6 +253,7 @@ static __init int init_posix_timers(void)
> >  		.clock_getres = hrtimer_get_res,
> >  		.clock_get = posix_get_monotonic_raw,
> >  		.clock_set = do_posix_clock_nosettime,
> > +		.timer_create = no_timer_create,
> 
> Agreed, this patch is better than mine (and thanks for your
> explanation about CLOCK_MONOTONIC_RAW).
> 
> I am not sure about -EOPNOTSUPP. To clarify, I do not claim this
> is wrong, I just do not know.
> 
> But please note that sys_timer_create() does:
> 
> 	if (invalid_clockid(which_clock))
> 		return -EINVAL;

EINVAL is wrong for timer_create(CLOCK_MONOTONIC_RAW) as clockid is
valid, just the operation of creating a timer is not supported for it.
 
> And ltp's timer_create04.c expects timer_create(MAX_CLOCKS == 4)
> returns -EINVAL.

That's because timer_create04.c does not know about
CLOCK_MONOTONIC_RAW yet.

Thanks,

	tglx
