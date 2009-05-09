Return-Path: <linux-kernel-owner+w=401wt.eu-S1754052AbZEIBKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbZEIBKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 21:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZEIBKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 21:10:10 -0400
Received: from ppp121-45-82-25.lns10.adl6.internode.on.net ([121.45.82.25]:36001
	"EHLO homer.shelbyville.oz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751039AbZEIBKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 21:10:09 -0400
Date: Sat, 9 May 2009 10:10:09 +0930
From: Ron <ron@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix for sched_clock() when using jiffies
Message-ID: <20090509004009.GZ5417@homer.shelbyville.oz>
References: <20081126150645.GA28153@homer.shelbyville.oz> <1227712598.4454.199.camel@twins> <20081126153152.GB28153@homer.shelbyville.oz> <20081128144039.GG28138@elte.hu> <20090508132449.GV5417@homer.shelbyville.oz> <20090508200444.GA22132@homer.shelbyville.oz> <20090508160142.ad89944f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508160142.ad89944f.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ron@debian.org
X-SA-Exim-Scanned: No (on homer.shelbyville.oz); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 04:01:42PM -0700, Andrew Morton wrote:
> On Sat, 9 May 2009 05:34:44 +0930
> Ron <ron@debian.org> wrote:
> 
> >  
> > Account for the initial offset to the jiffy count.
> > 
> > Signed-off-by: Ron Lee <ron@debian.org>
> > 
> > ---
> >  kernel/sched_clock.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
> > index a0b0852..a1567b1 100644
> > --- a/kernel/sched_clock.c
> > +++ b/kernel/sched_clock.c
> > @@ -37,7 +37,8 @@
> >   */
> >  unsigned long long __attribute__((weak)) sched_clock(void)
> >  {
> > -	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
> > +	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> > +					* (NSEC_PER_SEC / HZ);
> >  }
> >  
> >  static __read_mostly int sched_clock_running;
> 
> Why?  I assume that you encountered some problem which was fixed
> by this patch.  What was that problem?

This was a resend of a patch that seemed to get a thumbs up, except
for whitespace damage in what I originally sent, but which apparently
then didn't get applied.  The original context to it was:

 I'm in the process of updating a port for an ARM based chip we've been
 working on, from 2.6.22-rc4'ish to the current HEAD of Linus' tree, and
 I started seeing the following:

 [    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
 [42949372.970000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)

 The reason appears to be that printk_clock() has been replaced with a
 call to cpu_clock, which in our case currently falls back to the default
 (weak) implementation of sched_clock() that uses jiffies -- but doesn't
 account for the initial offset of the jiffy count.  The following simple
 patch fixes it for me, in line with what printk_clock used to do.

I've since created a 'real' implementation of sched_clock for our port,
so it's no longer an issue for us, but someone else reported this on
#kernelnewbies yesterday, so I figured it was worth forwarding a clean
patch for it once again.

Cheers,
Ron


