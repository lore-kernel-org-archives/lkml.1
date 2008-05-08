Return-Path: <linux-kernel-owner+w=401wt.eu-S1765451AbYEHXUf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765451AbYEHXUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 19:20:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbYEHXUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 19:20:15 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38235 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbYEHXUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 19:20:13 -0400
Date: Thu, 8 May 2008 16:19:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, joe@perches.com,
       davem@davemloft.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm][v2] ratelimit rewrite
Message-ID: <20080508231952.GC13851@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080506022558.GA2904@darkstar.te-china.tietoenator.com> <20080508122514.63482a06.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080508122514.63482a06.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2008 at 12:25:14PM -0700, Andrew Morton wrote:
> On Tue, 6 May 2008 10:25:58 +0800
> Dave Young <hidave.darkstar@gmail.com> wrote:
> 
> >  static inline void rcu_enter_nohz(void)
> >  {
> > +	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
> >  	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
> >  	__get_cpu_var(rcu_dyntick_sched).dynticks++;
> > -	WARN_ON_SECS(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, 10);
> > +	WARN_ON_RATELIMIT(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, &rs);
> >  }
> >  
> >  static inline void rcu_exit_nohz(void)
> >  {
> > +	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
> >  	__get_cpu_var(rcu_dyntick_sched).dynticks++;
> >  	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
> > -	WARN_ON_SECS(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1), 10);
> > +	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1),
> > +			&rs);
> 
> Why are we altering the RCU code in this patch, btw?  It seems fairly
> random that we happened to choose these particular WARN_ONs.  Do they have
> a history of triggering?

Yep -- there was a bug in this code a few months ago that was the
motivation for Dave's WARN_ON_RATELIMIT().  The bug has since been fixed,
so I would not expect this to trigger anymore, though.

							Thanx, Paul
