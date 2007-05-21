Return-Path: <linux-kernel-owner+w=401wt.eu-S1763427AbXEUWMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763427AbXEUWMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:12:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758151AbXEUWMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:12:37 -0400
Received: from www.osadl.org ([213.239.205.134]:47688 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758058AbXEUWMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:12:36 -0400
Subject: Re: [patch 43/69] i386: HPET, check if the counter works
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Andi Kleen <ak@suse.de>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       guilherme@centralinf.com.br, johnstul@us.ibm.com
In-Reply-To: <20070521145719.739bb8eb.akpm@linux-foundation.org>
References: <20070521191612.800400000@sous-sol.org>
	 <20070521191740.534306000@sous-sol.org> <1179777535.12708.37.camel@chaos>
	 <20070521145719.739bb8eb.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 22 May 2007 00:12:32 +0200
Message-Id: <1179785552.12708.79.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 14:57 -0700, Andrew Morton wrote:
> On Mon, 21 May 2007 21:58:55 +0200
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > The warning in the NOHZ code, which triggers when a CPU goes idle with
> > softirqs pending can fill up the logs quite quickly. Rate limit the
> > output until we found the root cause of that problem.
> > 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> > 
> > Index: linux-2.6.21/kernel/time/tick-sched.c
> > ===================================================================
> > --- linux-2.6.21.orig/kernel/time/tick-sched.c
> > +++ linux-2.6.21/kernel/time/tick-sched.c
> > @@ -167,9 +167,15 @@ void tick_nohz_stop_sched_tick(void)
> >  		goto end;
> >  
> >  	cpu = smp_processor_id();
> > -	if (unlikely(local_softirq_pending()))
> > -		printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
> > -		       local_softirq_pending());
> > +	if (unlikely(local_softirq_pending())) {
> > +		static int ratelimit;
> > +
> > +		if (ratelimit < 10) {
> > +			printk(KERN_ERR "NOHZ: local_softirq_pending %02x\n",
> > +			       local_softirq_pending());
> > +			ratelimit++;
> > +		}
> > +	}
> 
> that's not a "rate" limit.  I resist the temptation to rename it to "limit"
> to keep mainline and -stable in sync, and coz it's temporary (we hope).

Point taken.

	tglx


