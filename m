Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833Ab0BOPix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:38:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab0BOPiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:38:52 -0500
Date: Mon, 15 Feb 2010 10:38:37 -0500
From: Don Zickus <dzickus@redhat.com>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, peterz@infradead.org,
       gorcunov@gmail.com, aris@redhat.com
Subject: Re: [PATCH 3/4] nmi_watchdog: fallback to software events when no
 hardware pmu detected
Message-ID: <20100215153837.GL3062@redhat.com>
References: <1266013161-31197-1-git-send-email-dzickus@redhat.com>
 <1266013161-31197-3-git-send-email-dzickus@redhat.com>
 <20100215003341.GH13769@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215003341.GH13769@brick.ozlabs.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 11:33:41AM +1100, Paul Mackerras wrote:
> On Fri, Feb 12, 2010 at 05:19:20PM -0500, Don Zickus wrote:
> 
> > diff --git a/kernel/nmi_watchdog.c b/kernel/nmi_watchdog.c
> > index 73c1954..4f23505 100644
> > --- a/kernel/nmi_watchdog.c
> > +++ b/kernel/nmi_watchdog.c
> > @@ -166,8 +166,12 @@ cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
> >  		wd_attr.sample_period = hw_nmi_get_sample_period();
> >  		event = perf_event_create_kernel_counter(&wd_attr, hotcpu, -1, wd_overflow);
> >  		if (IS_ERR(event)) {
> > -			printk(KERN_ERR "nmi watchdog failed to create perf event on %i: %p\n", hotcpu, event);
> > -			return NOTIFY_BAD;
> > +			wd_attr.type = PERF_TYPE_SOFTWARE;
> > +			event = perf_event_create_kernel_counter(&wd_attr, hotcpu, -1, wd_overflow);
> 
> Here you don't explicitly set wd_attr.config or wd_attr.sample_period
> for the software event.  So PERF_COUNT_HW_CPU_CYCLES (which is 0)
> becomes PERF_COUNT_SW_CPU_CLOCK (also 0).  Which is either a happy
> accident or really really subtle. :)  I suggest you either set
> wd_attr.config or add a comment pointing out that you are using the
> fact that PERF_COUNT_HW_CPU_CYCLES == PERF_COUNT_SW_CPU_CLOCK.
> 
> Also you don't explicitly set wd_attr.sample_period, so it will be
> whatever hw_nmi_get_sample_period() returned, except now measured in
> nanoseconds rather than (presumably) cpu clock cycles.  Are you aiming
> for 1 interrupt per second?  If so you should set .sample_period to
> NSEC_PER_SEC.

Hmm, good points, I'll work on that and add it to my next round of
changes.

Thanks,
Don
