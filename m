Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbXJCUPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbXJCUPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 16:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXJCUPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 16:15:45 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:33107 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700AbXJCUPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 16:15:44 -0400
Date: Wed, 03 Oct 2007 22:15:16 +0200 (CEST)
Message-Id: <20071003.221516.55722278.anders@bostrom.dyndns.org>
To: torvalds@linux-foundation.org
Cc: cebbert@redhat.com, arjan@linux.intel.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: high load average when idle
From: Anders =?iso-8859-1?Q?Bostr=F6m?= <anders@bostrom.dyndns.org>
In-Reply-To: <alpine.LFD.0.999.0710031058320.3579@woody.linux-foundation.org>
References: <20071002162613.54c3ef43@laptopd505.fenrus.org>
	<4703D212.6040304@redhat.com>
	<alpine.LFD.0.999.0710031058320.3579@woody.linux-foundation.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.250.207.59
X-Scan-Result: No virus found in message 1IdAd8-00048O-3E.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1IdAd8-00048O-3E 40aabea05d7cf89c65b0cedc7cf9856d
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "LT" == Linus Torvalds <torvalds@linux-foundation.org> writes:

 LT> On Wed, 3 Oct 2007, Chuck Ebbert wrote:
 >> 
 >> But we reduce the number of samples because some ticks just never
 >> happen when the timers get rounded:
 >> 
 >> No rounding:
 >> 
 >> tick ............... tick
 >> 1 running            1 running
 >> 
 >> Rounded:
 >> 
 >> tick
 >> 2 running
 >> 
 >> In the first case the average is 1, but it's 2 in the second.

 LT> In fact, I think this is it!

 LT> The load average is not calculated every tick, because that's not just 
 LT> expensive, but we also want to have some time-based decay. So it's 
 LT> calculated every LOAD_FREQ ticks.

 LT> And guess what: LOAD_FREQ is defined to be exactly five seconds.

 LT> So imagine if the timer gets to be in sync with another event that happens 
 LT> every five seconds - let's pick at random a 5-second JBD transaction 
 LT> thing?

 LT> Anders - does this idiotic patch make a difference for you?

Yes, it does, it fixes the load average!!! I guess we have something
here!

Why does this problem only show up on my computer? Any idea?

/ Anders

 LT> Without this, I can easily imagine that the rounding code tends to try to 
 LT> round to an even second, and the load-average code generally also runs at 
 LT> even seconds!

 LT> 		Linus

 LT> ---
 LT>  include/linux/sched.h |    2 +-
 LT>  1 files changed, 1 insertions(+), 1 deletions(-)

 LT> diff --git a/include/linux/sched.h b/include/linux/sched.h
 LT> index a01ac6d..643de0f 100644
 LT> --- a/include/linux/sched.h
 LT> +++ b/include/linux/sched.h
 LT> @@ -113,7 +113,7 @@ extern unsigned long avenrun[];		/* Load averages */
 
 LT>  #define FSHIFT		11		/* nr of bits of precision */
 LT>  #define FIXED_1		(1<<FSHIFT)	/* 1.0 as fixed-point */
 LT> -#define LOAD_FREQ	(5*HZ)		/* 5 sec intervals */
 LT> +#define LOAD_FREQ	(5*HZ+1)	/* ~5 sec intervals */
 LT>  #define EXP_1		1884		/* 1/exp(5sec/1min) as fixed-point */
 LT>  #define EXP_5		2014		/* 1/exp(5sec/5min) */
 LT>  #define EXP_15		2037		/* 1/exp(5sec/15min) */
