Return-Path: <linux-kernel-owner+w=401wt.eu-S1760116AbYHTQRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760116AbYHTQRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbYHTQQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:16:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36816 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932AbYHTQQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:16:45 -0400
Date: Wed, 20 Aug 2008 12:16:44 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       ego@in.ibm.com, dvhltc@us.ibm.com, niv@us.ibm.com
Subject: Re: [PATCH -tip/core/rcu] fixes to include/linux/rcupreempt.h
In-Reply-To: <20080801211002.GM14851@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.1.10.0808201215330.27481@gandalf.stny.rr.com>
References: <20080801211002.GM14851@linux.vnet.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for the late post, I'm finally looking at all my -rt mail.


On Fri, 1 Aug 2008, Paul E. McKenney wrote:

> Hello!
> 
> Compared tip/core/rcu to my latest patchset, and found the following
> issues:
> 
> o	the memory barrier in rcu_exit_nohz() somehow got out of place
> 	(it is correct in mainline as of 2.6.26-rc7).
> 
> o	There is a duplicate declaration of rcu_dyntick_sched.
> 
> The attached patch fixes these.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
> 
> diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
> index f04b64e..84678bf 100644
> --- a/include/linux/rcupreempt.h
> +++ b/include/linux/rcupreempt.h
> @@ -111,7 +111,6 @@ extern struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu);
>  struct softirq_action;
>  
>  #ifdef CONFIG_NO_HZ
> -DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);

In -rt we deleted the first declaration. Is rcu_dyntick_sched defined on
!CONFIG_NO_HZ?

-- Steve

>  
>  static inline void rcu_enter_nohz(void)
>  {
> @@ -122,8 +121,8 @@ static inline void rcu_enter_nohz(void)
>  
>  static inline void rcu_exit_nohz(void)
>  {
> -	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
>  	__get_cpu_var(rcu_dyntick_sched).dynticks++;
> +	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
>  	WARN_ON(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1));
>  }
>  
> 
