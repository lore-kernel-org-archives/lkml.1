Return-Path: <linux-kernel-owner+w=401wt.eu-S1762737AbXF0TBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762737AbXF0TBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 15:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757981AbXF0TA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 15:00:57 -0400
Received: from mail.screens.ru ([213.234.233.54]:36511 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbXF0TA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 15:00:56 -0400
Date: Wed, 27 Jun 2007 22:59:52 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Chris Snook <csnook@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roman Zippel <zippel@linux-m68k.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sys_time-speedup-small-cleanup
Message-ID: <20070627185952.GA91@tv-sign.ru>
References: <20070626123424.GA259@tv-sign.ru> <46813D1C.9080107@redhat.com> <20070627112908.GB108@tv-sign.ru> <4682AAB3.6050704@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4682AAB3.6050704@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Chris Snook wrote:
>
> Oleg Nesterov wrote:
> >On 06/26, Chris Snook wrote:
> >>Oleg Nesterov wrote:
> >>>on top of sys_time-speedup.patch
> >>>
> >>>Ingo Molnar wrote:
> >>>>asmlinkage long sys_time(time_t __user * tloc)
> >>>>{
> >>>>-	time_t i;
> >>>>-	struct timeval tv;
> >>>>+	/*
> >>>>+	 * We read xtime.tv_sec atomically - it's updated
> >>>>+	 * atomically by update_wall_time(), so no need to
> >>>>+	 * even read-lock the xtime seqlock:
> >>>>+	 */
> >>>>+	time_t i = xtime.tv_sec;
> >>>>
> >>>>-	do_gettimeofday(&tv);
> >>>>-	i = tv.tv_sec;
> >>>>+	smp_rmb(); /* sys_time() results are coherent */
> >>>Why do we need this barrier? My guess it is needed to prevent
> >>>the reading of xtime.tv_sec twice, yes? In that case a simple
> >>>barrier() should be enough.
> >>Without the smp_rmb, you can potentially have a situation where one CPU 
> >>is still reading an old value from cache while another has the new value. 
> >
> >I can't understand this.
> >
> >Fisrt, smp_rmb() can't help in this case. It can't influence the preceeding
> >LOAD if it was from cache.
> >
> >Even if it could, another CPU can alter the value just after the reading
> >completes, and we have the same situation.
> >
> >Could you please clarify if I am wrong?
> >
> >Oleg.
> >
> 
> You're right, but so is Ingo's patch.  We're not trying to enforce some 
> notion of absolute time, just  make it possible for userspace to guarantee 
> that time cannot be *observed* to travel backwards.  It's still the 
> responsibility of the user to use proper synchronization in multithreaded 
> apps.  Without the smp_rmb() it would be possible on some architectures for 
> the results of the race you describe to leak across other lock-prefixed 
> instructions used to ensure monotonicity in userspace.  Relativity applies 
> to SMP timekeeping, not just space travelers, so if there's no way to prove 
> a race occurred, it doesn't matter whether or not it occurred in some frame 
> of reference.

This doesn't make sense to me, sorry. Could provide more details to explain
the race? Some ascii diagram?

I believe smp_rmb() can't make _any_ difference in this case.

Oleg.

