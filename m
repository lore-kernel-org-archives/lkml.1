Return-Path: <linux-kernel-owner+w=401wt.eu-S1757850AbZEZVvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757850AbZEZVvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754197AbZEZVvD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:51:03 -0400
Received: from www.tglx.de ([62.245.132.106]:58088 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978AbZEZVvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:51:01 -0400
Date: Tue, 26 May 2009 23:50:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
cc: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com
Subject: Re: [PATCH 3/3] ftrace: add tracepoint for itimer
In-Reply-To: <4A16767D.8030907@cn.fujitsu.com>
Message-ID: <alpine.LFD.2.00.0905262344160.1762@localhost.localdomain>
References: <4A16767D.8030907@cn.fujitsu.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Xiao Guangrong wrote:
> +TRACE_EVENT(itimer_start,
> +
> +	TP_PROTO(int which, struct itimerval *value),
> +
> +	TP_ARGS(which, value),
> +
> +	TP_STRUCT__entry(
> +		__field(	int,			which		)
> +		__field(	unsigned long long,	it_value	)
> +		__field(	unsigned long long,	it_interval	)
> +		__string(	comm,   		current->comm   )
> +	),
> +
> +	TP_fast_assign(
> +		__entry->which		= which;
> +		__entry->it_value	= (which == ITIMER_REAL ?
> +			ktime_to_ns(timeval_to_ktime(value->it_value)) :
> +			timeval_to_cputime(&value->it_value));
> +		 __entry->it_interval 	= (which == ITIMER_REAL ?
> +			ktime_to_ns(timeval_to_ktime(value->it_interval)) :
> +			timeval_to_cputime(&value->it_interval));
> +		__assign_str(comm, current->comm);
> +	),

  Again, conversion of raw values needs to be done when we analyse the
  trace and not in the fast path.

....

> +		} else{
  
  } else {

  please
>  			tsk->signal->it_real_incr.tv64 = 0;
> +			trace_itimer_cancel(ITIMER_REAL);
> +		}
>  
>  		spin_unlock_irq(&tsk->sighand->siglock);
>  		break;
> @@ -186,7 +191,10 @@ again:
>  						   jiffies_to_cputime(1));
>  			set_process_cpu_timer(tsk, CPUCLOCK_VIRT,
>  					      &nval, &cval);
> -		}
> +			trace_itimer_start(ITIMER_VIRTUAL, value);
> +		}else

  Please run your patches through checkpatch.pl

Thanks,

	tglx
