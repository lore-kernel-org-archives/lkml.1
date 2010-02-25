Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934055Ab0BYVnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:43:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:50433 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933929Ab0BYVnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:43:43 -0500
Subject: Re: [PATCH 2/3] sched: enforce per-cpu utilization limits on
 runtime balancing
From: Peter Zijlstra <peterz@infradead.org>
To: Fabio Checconi <fchecconi@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Dhaval Giani <dhaval@retis.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org,
       Fabio Checconi <fabio@gandalf.sssup.it>
In-Reply-To: <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
References: <cover.1266931410.git.fabio@helm.retis>
	 <91b76b9b7555024d9afd7264eeae1b2db6a5e74c.1266931410.git.fabio@helm.retis>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Feb 2010 21:28:25 +0100
Message-ID: <1267129705.22519.561.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-23 at 19:56 +0100, Fabio Checconi wrote:
> +static u64 from_ratio(unsigned long ratio, u64 period)
> +{
> +       return (ratio * period) >> 20;
> +}
> +
> +/*
> + * Try to move *diff units of runtime from src to dst, checking
> + * that the utilization does not exceed the global limits on the
> + * destination cpu.  Returns true if the migration succeeded, leaving
> + * in *diff the actual amount of runtime moved, false on failure, which
> + * means that no more bandwidth can be migrated to rt_rq.
> + */
> +static int rt_move_bw(struct rt_rq *src, struct rt_rq *dst,
> +                      s64 *diff, u64 rt_period)
> +{
> +       struct rq *rq = rq_of_rt_rq(dst), *src_rq = rq_of_rt_rq(src);
> +       struct rt_edf_tree *dtree = &rq->rt.rt_edf_tree;
> +       struct rt_edf_tree *stree = &src_rq->rt.rt_edf_tree;
> +       unsigned long bw_to_move;
> +       int ret = 0;
> +
> +       double_spin_lock(&dtree->rt_bw_lock, &stree->rt_bw_lock);
> +
> +       if (dtree->rt_free_bw) {
> +               bw_to_move = to_ratio(rt_period, *diff);
> +               if (bw_to_move > dtree->rt_free_bw) {
> +                       bw_to_move = dtree->rt_free_bw;
> +                       *diff = from_ratio(bw_to_move, rt_period);
> +               }
> +
> +               stree->rt_free_bw -= bw_to_move;
> +               dtree->rt_free_bw += bw_to_move;
> +               ret = 1;
> +       }
> +
> +       double_spin_unlock(&dtree->rt_bw_lock, &stree->rt_bw_lock);
> +
> +       return ret;
> +} 

The from_ratio() stuff smells like numerical instability for
->rt_free_bw, I can't see anything that would, given sufficient balance
cycles keep the sum of rt_free_bw over the cpus equal to what it started
out with.

