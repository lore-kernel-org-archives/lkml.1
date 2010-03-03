Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab0CCQrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 11:47:39 -0500
Received: from ms01.sssup.it ([193.205.80.99]:43835 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754757Ab0CCQrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 11:47:35 -0500
Date: Wed, 3 Mar 2010 18:00:14 +0100
From: Fabio Checconi <fchecconi@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sched: enforce per-cpu utilization limits on runtime
 balancing
Message-ID: <20100303170014.GP2490@gandalf.sssup.it>
References: <cover.1266931410.git.fabio@helm.retis>
 <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
 <1267129703.22519.559.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267129703.22519.559.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-10-28)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Peter Zijlstra <peterz@infradead.org>
> Date: Thu, Feb 25, 2010 09:28:23PM +0100
>
> On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> > +#ifdef CONFIG_SMP
> > +static inline unsigned long rt_init_free_bw(void)
> > +{
> > +       unsigned long used = to_ratio(global_rt_period(), global_rt_runtime());
> > +
> > +       return to_ratio(RUNTIME_INF, RUNTIME_INF) - used;
> > +}
> > +#endif
> 
> > +static void __rt_restart_balancing(void)
> > +{
> > +       unsigned long used, global, free;
> > +       struct rq *rq;
> > +       int i;
> > +
> > +       used = rt_used_bandwidth();
> > +       global = to_ratio(RUNTIME_INF, RUNTIME_INF);
> > +
> > +       free = global - used;
> 
> 
> We take the max as RUNTIME_INF instead of global_rt_* so that we can
> move runtime around and fully saturate a single cpu (given there is
> enough free to compensate on other cpus) ?

The only reason I've used RUNTIME_INF instead of global_rt_* is for the
!GROUP_SCHED case, where using the global_rt_* values would make balancing
have no effect at all (the initial value for def_rt_bandwidth already
uses the maximum bw on each cpu) .  The current throttling implementation
in this case still tries to concentrate bw on a single cpu, and I wanted
to replicate the same behaviour.

Should I go for the global_rt_* values and add some #ifdef unreadability
to avoid the balancing overhead in the !GROUP_SCHED case?
