Return-Path: <linux-kernel-owner+w=401wt.eu-S1752068AbZJWUlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752068AbZJWUlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 16:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZJWUlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 16:41:19 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:46057 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbZJWUlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 16:41:18 -0400
Message-ID: <4AE214E8.9020406@us.ibm.com>
Date: Fri, 23 Oct 2009 13:41:12 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: dino@in.ibm.com
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>, stable@kernel.org
Subject: Re: [patch -rt] Fix infinite loop with 2.6.31.4-rt14 V2
References: <20091023134700.GA5578@in.ibm.com> <4AE1D802.6050906@us.ibm.com> <20091023200858.GA7011@in.ibm.com>
In-Reply-To: <20091023200858.GA7011@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dinakar Guniguntala wrote:
 > Application threads calling futex_wait_requeue_pi run in an infinite loop
 > in the kernel if the futex value changes during the call. The following
 > patch fixes the problem.

The key bit here being that EAGAIN == EWOULDBLOCK - who thought that was 
a good idea?

 >
 > Signed-off-by: Dinakar Guniguntala <dino@in.ibm.com>
 > Cc: Thomas Gleixner <tglx@linutronix.de>
 > Cc: Darren Hart <dvhltc@us.ibm.com>

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>

Adding the usual CC list for futexes as well as stable:

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: John Stultz <johnstul@us.ibm.com>
CC: stable@kernel.org

 >
 > ---
 >  kernel/futex.c |    9 ++++++---
 >  1 file changed, 6 insertions(+), 3 deletions(-)
 >
 > Index: linux-2.6.31.4-rt14-lbf-f1/kernel/futex.c
 > ===================================================================
 > --- linux-2.6.31.4-rt14-lbf-f1.orig/kernel/futex.c
 > +++ linux-2.6.31.4-rt14-lbf-f1/kernel/futex.c
 > @@ -2188,6 +2188,12 @@ retry:
 >  	spin_lock(&hb->lock);
 >  	ret = handle_early_requeue_pi_wakeup(hb, &q, &key2, to);
 >  	spin_unlock(&hb->lock);
 > +	if (ret == -EAGAIN) {
 > +		/* Retry on spurious wakeup */
 > +		put_futex_key(fshared, &q.key);
 > +		put_futex_key(fshared, &key2);
 > +		goto retry;
 > +	}
 >  	if (ret)
 >  		goto out_put_keys;
 >
 > @@ -2264,9 +2270,6 @@ out_put_keys:
 >  out_key2:
 >  	put_futex_key(fshared, &key2);
 >
 > -	/* Spurious wakeup ? */
 > -	if (ret == -EAGAIN)
 > -		goto retry;
 >  out:
 >  	if (to) {
 >  		hrtimer_cancel(&to->timer);


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
