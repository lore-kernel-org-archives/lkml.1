Return-Path: <linux-kernel-owner+w=401wt.eu-S934662AbXEWPCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934662AbXEWPCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 11:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757697AbXEWPCb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 11:02:31 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:40449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757125AbXEWPCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 11:02:30 -0400
Date: Wed, 23 May 2007 08:00:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Patrick McHardy <kaber@trash.net>
cc: Herbert Xu <herbert@gondor.apana.org.au>, Ingo Molnar <mingo@elte.hu>,
       Anant Nitya <kernel@prachanda.info>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "David S. Miller" <davem@davemloft.net>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: bad networking related lag in v2.6.22-rc2
In-Reply-To: <4654269C.4040809@trash.net>
Message-ID: <alpine.LFD.0.98.0705230752040.3890@woody.linux-foundation.org>
References: <20070517174533.GA538@elte.hu> <200705221147.56571.kernel@prachanda.hub>
 <20070522062233.GA20002@elte.hu> <200705231110.44526.kernel@prachanda.hub>
 <20070523063052.GB26814@elte.hu> <46541DC4.4090501@trash.net>
 <20070523112559.GA24604@gondor.apana.org.au> <4654269C.4040809@trash.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 May 2007, Patrick McHardy wrote:
> 
> Yes, that looks better, thanks.

There appear to be other obvious problems in the recent "cleanups" in this 
area..

Look at

	psched_tdiff_bounded(psched_time_t tv1, psched_time_t tv2, psched_time_t bound)
	{
		return min(tv1 - tv2, bound);
	}

and compare it to the previous code:

	#define PSCHED_TDIFF_SAFE(tv1, tv2, bound) \
		min_t(long long, (tv1) - (tv2), bound)

and ponder how that "trivial cleanup" totally broke the thing. 

Hint: "psched_time_t" is an "u64". What does that mean for

	min(tv1 - tv2, bound);

again, when "tv2" is larger than tv1. It _used_ to return a negative 
value. Now it returns a positive "bound" upper bound, because "tv1-tv2" 
will be used as a huge unsigned (and thus _positive_) integer. And was 
that accidental, or done on purpose?

Sounds accidental to me, since you then want to return a "psched_tdiff_t", 
which is typedeffed to be "long".

Doesn't sound very safe to me, especially since the commit message for 
this is "[NET_SCHED]: turn PSCHED_TDIFF_SAFE into inline function", and 
there's no indication that anybody realized that it changed semantics in 
the process.

Hmm? What _should_ that thing do?

		Linus
