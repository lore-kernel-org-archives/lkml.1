Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYHTWeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYHTWeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 18:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbYHTWeG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 18:34:06 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47298 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753128AbYHTWeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 18:34:05 -0400
Date: Wed, 20 Aug 2008 15:33:59 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       ego@in.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH -tip/core/rcu] fixes to include/linux/rcupreempt.h
Message-ID: <20080820223359.GL6758@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080801211002.GM14851@linux.vnet.ibm.com> <alpine.DEB.1.10.0808201215330.27481@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0808201215330.27481@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 12:16:44PM -0400, Steven Rostedt wrote:
> 
> Sorry for the late post, I'm finally looking at all my -rt mail.
> 
> 
> On Fri, 1 Aug 2008, Paul E. McKenney wrote:
> 
> > Hello!
> > 
> > Compared tip/core/rcu to my latest patchset, and found the following
> > issues:
> > 
> > o	the memory barrier in rcu_exit_nohz() somehow got out of place
> > 	(it is correct in mainline as of 2.6.26-rc7).
> > 
> > o	There is a duplicate declaration of rcu_dyntick_sched.
> > 
> > The attached patch fixes these.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> > 
> > diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
> > index f04b64e..84678bf 100644
> > --- a/include/linux/rcupreempt.h
> > +++ b/include/linux/rcupreempt.h
> > @@ -111,7 +111,6 @@ extern struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu);
> >  struct softirq_action;
> >  
> >  #ifdef CONFIG_NO_HZ
> > -DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
> 
> In -rt we deleted the first declaration. Is rcu_dyntick_sched defined on
> !CONFIG_NO_HZ?

It builds for me in current tip/core/rcu without the above
DECLARE_PER_CPU().  And the reason is the call_rcu_sched() function, which
requires rcu_dyntick_sched.sched_qs and rcu_dyntick_sched.sched_qs_snap
be defined even if !CONFIG_NO_HZ.

I suppose I could remove the other elements from the rcu_dyntick_sched
structure if !CONFIG_NO_HZ.  Worthwhile?

							Thanx, Paul

> -- Steve
> 
> >  
> >  static inline void rcu_enter_nohz(void)
> >  {
> > @@ -122,8 +121,8 @@ static inline void rcu_enter_nohz(void)
> >  
> >  static inline void rcu_exit_nohz(void)
> >  {
> > -	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
> >  	__get_cpu_var(rcu_dyntick_sched).dynticks++;
> > +	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
> >  	WARN_ON(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1));
> >  }
> >  
> > 
