Return-Path: <linux-kernel-owner+w=401wt.eu-S1763173AbZD3NiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763173AbZD3NiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbZD3NiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:38:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36820 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758760AbZD3NiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:38:13 -0400
Date: Thu, 30 Apr 2009 15:37:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nikanth Karthikesan <knikanth@novell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Detect and warn on atomic_inc/atomic_dec wrapping
	around
Message-ID: <20090430133757.GA8329@elte.hu>
References: <200904291221.40361.knikanth@novell.com> <200904301756.42210.knikanth@novell.com> <20090430125004.GA20047@elte.hu> <200904301859.27199.knikanth@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904301859.27199.knikanth@novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nikanth Karthikesan <knikanth@novell.com> wrote:

> > Then there could be a single, straightforward value check:
> >
> > static inline void atomic_inc(atomic_t *v)
> > {
> > 	debug_atomic_check_value(v);
> > 	raw_atomic_inc(v);
> > }
> >
> > Where debug_atomic_check_value() is just an atomic_read():
> >
> > static inline void debug_atomic_check_value(atomic_t *v)
> > {
> > 	WARN_ONCE(in_range(atomic_read(v), UINT_MAX/4, UINT_MAX/4*3),
> > 		  KERN_ERR "atomic counter check failure!");
> > }
> >
> 
> I do not understand, why UINT_MAX/4 to UINT_MAX/4*3?
> Roughly,
> UINT_MAX/4 = INT_MAX/2 
> UINT_MAX/4*3 = INT_MAX/2*3 which we will never reach with an int.

i mean:

 	WARN_ONCE(in_range((u32)atomic_read(v), UINT_MAX/4, UINT_MAX/4*3),
 		  KERN_ERR "atomic counter check failure!");

that's a single range check on an u32, selecting 'too large' and 
'too small' s32 values.

> > It's a constant check.
> >
> > If are overflowing on such a massive rate, it doesnt matter how 
> > early or late we check the value.
> 
> UINT_MAX/4 early, might be too early. And if it doesn't matter how 
> early or late, why try to be over-cautious and produce false 
> warnings. ;-)

UINT_MAX/4 is ~1 billion. If we reach a value of 1 billion we are 
leaking. Your check basically is a sharp test for the specific case 
of overflowing the boundary - but it makes the code slower (it uses 
more complex atomic ops) and uglifies it via #ifdefs as well.

It doesnt matter whether we wrap over at around +2 billion into -2 
billion, or treat the whole above-1-billion and 
below-minus-1-billion range as invalid. (other than we'll catch bugs 
sooner via this method, and have faster and cleaner code)

	Ingo
