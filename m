Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbZGGIJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbZGGIJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 04:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbZGGIJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 04:09:07 -0400
Received: from www.tglx.de ([62.245.132.106]:51259 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbZGGIJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 04:09:05 -0400
Date: Tue, 7 Jul 2009 10:08:56 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] optimized ktime_get[_ts] for GENERIC_TIME=y
In-Reply-To: <20090707094018.08406c49@skybase>
Message-ID: <alpine.LFD.2.00.0907071004380.19480@localhost.localdomain>
References: <20090706154933.5a1f8990@skybase> <alpine.LFD.2.00.0907062215380.19480@localhost.localdomain> <20090707094018.08406c49@skybase>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin,

On Tue, 7 Jul 2009, Martin Schwidefsky wrote:
> On Mon, 6 Jul 2009 22:31:39 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Mon, 6 Jul 2009, Martin Schwidefsky wrote:
> > > +ktime_t ktime_get(void)
> > > +{
> > > +	cycle_t cycle_now, cycle_delta;
> > > +	struct timespec time;
> > > +	unsigned long seq;
> > > +	s64 nsecs;
> > > +
> > > +	do {
> > > +		seq = read_seqbegin(&xtime_lock);
> > > +		time.tv_sec = xtime.tv_sec + wall_to_monotonic.tv_sec;
> > > +		time.tv_nsec = xtime.tv_nsec + wall_to_monotonic.tv_nsec;
> > 
> > That's actually a violation of the timespec semantics. tv_nsec can end
> > up greater than (10^9 - 1). Please use separate sec and nsec variables.
> 
> Well the tv_sec/tv_nsec fields of a timespec are long values. But its
> no problem to switch to local variables.

Right. I'm not worried about an overflow of the variable. I was about
to suggest using timespec_to_ktime() to fix the !SCALAR problem when I
noticed that the timespec is possibly not normalized. Not using a
timespec makes the code more obvious I think.

Thanks,

	tglx

