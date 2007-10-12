Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXJLTV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXJLTV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 15:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbXJLTVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 15:21:21 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40532 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670AbXJLTVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 15:21:20 -0400
Date: Fri, 12 Oct 2007 12:21:16 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Gautham R Shenoy <ego@in.ibm.com>
Cc: josh@freedesktop.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Dipankar Sarma <dipankar@in.ibm.com>,
       rostedt@goodmis.org
Subject: Re: [PATCH] Use raw_smp_processor_id() in rcu_random()
Message-ID: <20071012192116.GD8420@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071012092044.GA1138@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071012092044.GA1138@in.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2007 at 02:50:44PM +0530, Gautham R Shenoy wrote:
> 
> With CONFIG_PREEMPT=y on 2.6.23-rc8-mm2, rcu_random() calls 
> smp_processor_id() from a preemptible context, triggering the
> following kernel error.
> 
> BUG: using smp_processor_id() in preemptible [00000001] code: rcu_torture_fak/5155
> caller is rcu_random+0x16/0x39 [rcutorture]
>  [<c010612f>] dump_trace+0x68/0x1d2
>  [<c01062b1>] show_trace_log_lvl+0x18/0x2c
>  [<c0106c23>] show_trace+0xf/0x11
>  [<c0106d33>] dump_stack+0x12/0x14
>  [<c02a0a25>] debug_smp_processor_id+0xa1/0xb4
>  [<f887064c>] rcu_random+0x16/0x39 [rcutorture]
>  [<f8870cdf>] <3>BUG: using smp_processor_id() in preemptible [00000001] code: rcu_torture_fak/5156
> rcu_torture_fakewriter+0x4d/0xc5 [rcutorture]
>  [<c0139b32>] caller is rcu_random+0x16/0x39 [rcutorture]
> kthread+0x38/0x5e
>  [<c0105ca7>] kernel_thread_helper+0x7/0x10
>  =======================
>  [<c010612f>] dump_trace+0x68/0x1d2
>  [<c01062b1>] show_trace_log_lvl+0x18/0x2c
>  [<c0106c23>] show_trace+0xf/0x11
>  [<c0106d33>] dump_stack+0x12/0x14
>  [<c02a0a25>] debug_smp_processor_id+0xa1/0xb4
>  [<f887064c>] rcu_random+0x16/0x39 [rcutorture]
>  [<f8870cdf>] rcu_torture_fakewriter+0x4d/0xc5 [rcutorture]
> 
> rcu_random() can do with raw_smp_processor_id() as a parameter to cpu_clock()
> in this particular context.

Good catch!!!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
> 
> ---
>  kernel/rcutorture.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.23-rc8/kernel/rcutorture.c
> ===================================================================
> --- linux-2.6.23-rc8.orig/kernel/rcutorture.c
> +++ linux-2.6.23-rc8/kernel/rcutorture.c
> @@ -170,7 +170,8 @@ static unsigned long
>  rcu_random(struct rcu_random_state *rrsp)
>  {
>  	if (--rrsp->rrs_count < 0) {
> -		rrsp->rrs_state += (unsigned long)cpu_clock(smp_processor_id());
> +		rrsp->rrs_state +=
> +			(unsigned long)cpu_clock(raw_smp_processor_id());
>  		rrsp->rrs_count = RCU_RANDOM_REFRESH;
>  	}
>  	rrsp->rrs_state = rrsp->rrs_state * RCU_RANDOM_MULT + RCU_RANDOM_ADD;
> -- 
> Gautham R Shenoy
> Linux Technology Center
> IBM India.
> "Freedom comes with a price tag of responsibility, which is still a bargain,
> because Freedom is priceless!"
