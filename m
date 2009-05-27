Return-Path: <linux-kernel-owner+w=401wt.eu-S1764530AbZE0HpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764530AbZE0HpN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:45:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763354AbZE0HmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:42:22 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64832 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1764265AbZE0HmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:42:21 -0400
Message-ID: <4A1CEF06.2080201@cn.fujitsu.com>
Date: Wed, 27 May 2009 15:43:02 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
       Zhaolei <zhaolei@cn.fujitsu.com>, kosaki.motohiro@jp.fujitsu.com,
       fweisbec@gmail.com
Subject: Re: [PATCH 3/3] ftrace: add tracepoint for itimer
References: <4A16767D.8030907@cn.fujitsu.com> <alpine.DEB.2.00.0905261239580.26705@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905261239580.26705@gandalf.stny.rr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Steven Rostedt wrote:
> 
> On Fri, 22 May 2009, Xiao Guangrong wrote:
> 
>> This patch can trace itimer start/expire/cancle event
>>
>> Example ftrace output:
>>            <...>-4183  [001] 66533.730163: itimer_start: task=main which=0 it_value=13000000000 it_interval=0
>>           <idle>-0     [001] 66546.698154: itimer_expire: task=main which=0
>>            <...>-4183  [000] 66546.698533: itimer_cancel: task=main which=0
>>
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>> ---
>>  include/trace/events/timer.h |   66 ++++++++++++++++++++++++++++++++++++++++++
>>  kernel/itimer.c              |   17 +++++++++--
>>  kernel/posix-cpu-timers.c    |    3 ++
>>  3 files changed, 83 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/trace/events/timer.h b/include/trace/events/timer.h
>> index e5dc9d5..767c703 100644
>> --- a/include/trace/events/timer.h
>> +++ b/include/trace/events/timer.h
>> @@ -175,6 +175,72 @@ TRACE_EVENT(hrtimer_cancel,
>>  	TP_printk("timer=%p func=%pf", __entry->timer, __entry->function)
>>  );
>>  
>> +TRACE_EVENT(itimer_start,
>> +
>> +	TP_PROTO(int which, struct itimerval *value),
>> +
>> +	TP_ARGS(which, value),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	int,			which		)
>> +		__field(	unsigned long long,	it_value	)
>> +		__field(	unsigned long long,	it_interval	)
>> +		__string(	comm,   		current->comm   )
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->which		= which;
>> +		__entry->it_value	= (which == ITIMER_REAL ?
>> +			ktime_to_ns(timeval_to_ktime(value->it_value)) :
>> +			timeval_to_cputime(&value->it_value));
>> +		 __entry->it_interval 	= (which == ITIMER_REAL ?
>> +			ktime_to_ns(timeval_to_ktime(value->it_interval)) :
>> +			timeval_to_cputime(&value->it_interval));
> 
> Wouldn't it be faster to do these time conversions in the printk instead
> of the trace point?
> 

Hi Steven:

Thank for you review, I will correct it.
:-)

>> +		__assign_str(comm, current->comm);
>> +	),
>> +
>> +	TP_printk("task=%s which=%d it_value=%llu it_interval=%llu", __get_str(comm),
>> +		  __entry->which, __entry->it_value, __entry->it_interval)
>> +);
>> +
>> +TRACE_EVENT(itimer_expire,
>> +
>> +	TP_PROTO(int which, struct task_struct *task),
>> +
>> +	TP_ARGS(which, task),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(  int ,	which		)
>> +		__string( comm,	task->comm	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->which	 = which;
>> +		__assign_str(comm, task->comm);
>> +	),
>> +
>> +	TP_printk("task=%s which=%d", __get_str(comm), __entry->which)
>> +);
>> +
>> +TRACE_EVENT(itimer_cancel,
>> +
>> +	TP_PROTO(int which),
>> +
>> +	TP_ARGS(which),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(  int ,	which		)
>> +		__string( comm, current->comm	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->which	= which;
>> +		__assign_str(comm, current->comm);
>> +	),
>> +
>> +	TP_printk("task=%s which=%d", __get_str(comm), __entry->which)
>> +);
>> +
>>  #endif /*  _TRACE_TIMER_H */
>>  
>>  /* This part must be outside protection */
>> diff --git a/kernel/itimer.c b/kernel/itimer.c
>> index 58762f7..1d2dd64 100644
>> --- a/kernel/itimer.c
>> +++ b/kernel/itimer.c
>> @@ -12,6 +12,7 @@
>>  #include <linux/time.h>
>>  #include <linux/posix-timers.h>
>>  #include <linux/hrtimer.h>
>> +#include <trace/events/timer.h>
>>  
>>  #include <asm/uaccess.h>
>>  
>> @@ -123,6 +124,7 @@ enum hrtimer_restart it_real_fn(struct hrtimer *timer)
>>  	struct signal_struct *sig =
>>  		container_of(timer, struct signal_struct, real_timer);
>>  
>> +	trace_itimer_expire(ITIMER_REAL, pid_task(sig->leader_pid, PIDTYPE_PID));
>>  	kill_pid_info(SIGALRM, SEND_SIG_PRIV, sig->leader_pid);
>>  
>>  	return HRTIMER_NORESTART;
>> @@ -168,8 +170,11 @@ again:
>>  			tsk->signal->it_real_incr =
>>  				timeval_to_ktime(value->it_interval);
>>  			hrtimer_start(timer, expires, HRTIMER_MODE_REL);
>> -		} else
>> +			trace_itimer_start(ITIMER_REAL, value);
>> +		} else{
>>  			tsk->signal->it_real_incr.tv64 = 0;
>> +			trace_itimer_cancel(ITIMER_REAL);
>> +		}
>>  
>>  		spin_unlock_irq(&tsk->sighand->siglock);
>>  		break;
>> @@ -186,7 +191,10 @@ again:
>>  						   jiffies_to_cputime(1));
>>  			set_process_cpu_timer(tsk, CPUCLOCK_VIRT,
>>  					      &nval, &cval);
>> -		}
>> +			trace_itimer_start(ITIMER_VIRTUAL, value);
>> +		}else
>> +			trace_itimer_cancel(ITIMER_VIRTUAL);
>> +
>>  		tsk->signal->it_virt_expires = nval;
>>  		tsk->signal->it_virt_incr = ninterval;
>>  		spin_unlock_irq(&tsk->sighand->siglock);
>> @@ -208,7 +216,10 @@ again:
>>  						   jiffies_to_cputime(1));
>>  			set_process_cpu_timer(tsk, CPUCLOCK_PROF,
>>  					      &nval, &cval);
>> -		}
>> +			trace_itimer_start(ITIMER_PROF, value);
>> +		}else
>> +			trace_itimer_cancel(ITIMER_PROF);
>> +
>>  		tsk->signal->it_prof_expires = nval;
>>  		tsk->signal->it_prof_incr = ninterval;
>>  		spin_unlock_irq(&tsk->sighand->siglock);
>> diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
>> index bece7c0..edb4e8c 100644
>> --- a/kernel/posix-cpu-timers.c
>> +++ b/kernel/posix-cpu-timers.c
>> @@ -8,6 +8,7 @@
>>  #include <linux/math64.h>
>>  #include <asm/uaccess.h>
>>  #include <linux/kernel_stat.h>
>> +#include <trace/events/timer.h>
>>  
>>  /*
>>   * Called after updating RLIMIT_CPU to set timer expiration if necessary.
>> @@ -1160,6 +1161,7 @@ static void check_process_timers(struct task_struct *tsk,
>>  				sig->it_prof_expires = cputime_add(
>>  					sig->it_prof_expires, ptime);
>>  			}
>> +			trace_itimer_expire(ITIMER_PROF, tsk);
>>  			__group_send_sig_info(SIGPROF, SEND_SIG_PRIV, tsk);
>>  		}
>>  		if (!cputime_eq(sig->it_prof_expires, cputime_zero) &&
>> @@ -1176,6 +1178,7 @@ static void check_process_timers(struct task_struct *tsk,
>>  				sig->it_virt_expires = cputime_add(
>>  					sig->it_virt_expires, utime);
>>  			}
>> +			trace_itimer_expire(ITIMER_VIRTUAL, tsk);
>>  			__group_send_sig_info(SIGVTALRM, SEND_SIG_PRIV, tsk);
>>  		}
>>  		if (!cputime_eq(sig->it_virt_expires, cputime_zero) &&
>> -- 
>> 1.6.1.2
>>
>>
> 
> 
