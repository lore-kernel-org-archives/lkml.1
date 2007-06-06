Return-Path: <linux-kernel-owner+w=401wt.eu-S932453AbXFFR3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453AbXFFR3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 13:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbXFFR3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 13:29:14 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:55746 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757123AbXFFR3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 13:29:12 -0400
Message-ID: <4666EEDC.409@sgi.com>
Date: Wed, 06 Jun 2007 10:29:00 -0700
From: Jay Lan <jlan@sgi.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060725)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Maxim Uvarov <muvarov@ru.mvista.com>, LKML <linux-kernel@vger.kernel.org>,
       Shailabh Nagar <nagar@watson.ibm.com>, Balbir Singh <balbir@in.ibm.com>,
       Jay Lan <jlan@cthulhu.engr.sgi.com>, Jonathan Lim <jlim@sgi.com>
Subject: Re: [PATCH] Performance Stats: Kernel patch
References: <20070605144349.4636.53260.stgit@localhost.localdomain> <20070605233841.a56c4f20.akpm@linux-foundation.org>
In-Reply-To: <20070605233841.a56c4f20.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 05 Jun 2007 14:43:50 +0000 Maxim Uvarov <muvarov@ru.mvista.com> wrote:
> 
>> Patch makes available to the user the following
>> task and process performance statistics:
>> 	* Involuntary Context Switches (task_struct->nivcsw)
>> 	* Voluntary Context Switches (task_struct->nvcsw)
>> 	           
>> Statistics information is available from:
>> 	1. taskstats interface (Documentation/accounting/)
>> 	2. /proc/PID/status (task only).
>>
>> This data is useful for detecting hyperactivity
>> patterns between processes.
>> Signed-off-by: Maxim Uvarov <muvarov@ru.mvista.com>
> 
> Thanks.
> 
> Please retain suitable cc's when discussing a patch.  I keep on having to
> find your updates on the mailing list, and then adding all the same cc's
> when I reply.
> 
> Your patch seemed to be against some horridly prehistoric kernel, so I had
> a few things to fix up.
> 
> I disagree with the term "rates" for these things.  They are counters, not
> rates.  Adjustments are below.
> 
> We still need to think about whether we missed any other fields.

My initial cut of bringing in general accounting fields was to cover
the "struct acct" in linux/acct.h. It was done so that at least data
needed by BSD accounting is in "struct taskstats".

We need to poll other interested parties into this subject, or we can
add more fields later when users of other accounting fields decide
to take advantage of the taskstats interface.

Thanks,
 - jay


> 
> 
> diff -puN Documentation/accounting/getdelays.c~taskstats-add-context-switch-counters-fix Documentation/accounting/getdelays.c
> --- a/Documentation/accounting/getdelays.c~taskstats-add-context-switch-counters-fix
> +++ a/Documentation/accounting/getdelays.c
> @@ -49,7 +49,7 @@ char name[100];
>  int dbg;
>  int print_delays;
>  int print_io_accounting;
> -int print_task_context_switch_rates;
> +int print_task_context_switch_counts;
>  __u64 stime, utime;
>  
>  #define PRINTF(fmt, arg...) {			\
> @@ -205,7 +205,7 @@ void print_delayacct(struct taskstats *t
>  	       "count", "delay total", t->swapin_count, t->swapin_delay_total);
>  }
>  
> -void task_context_switch_rates(struct taskstats *t)
> +void task_context_switch_counts(struct taskstats *t)
>  {
>  	printf("\n\nTask   %15s%15s\n"
>  	       "       %15lu%15lu\n",
> @@ -259,7 +259,7 @@ int main(int argc, char *argv[])
>  			break;
>  		case 'q':
>  			printf("printing task/process context switch rates\n");
> -			print_task_context_switch_rates = 1;
> +			print_task_context_switch_counts = 1;
>  			break;
>  		case 'w':
>  			logfile = strdup(optarg);
> @@ -402,8 +402,8 @@ int main(int argc, char *argv[])
>  							print_delayacct((struct taskstats *) NLA_DATA(na));
>  						if (print_io_accounting)
>  							print_ioacct((struct taskstats *) NLA_DATA(na));
> -						if (print_task_context_switch_rates)
> -							task_context_switch_rates((struct taskstats *) NLA_DATA(na));
> +						if (print_task_context_switch_counts)
> +							task_context_switch_counts((struct taskstats *) NLA_DATA(na));
>  						if (fd) {
>  							if (write(fd, NLA_DATA(na), na->nla_len) < 0) {
>  								err(1,"write error\n");
> diff -puN Documentation/accounting/taskstats-struct.txt~taskstats-add-context-switch-counters-fix Documentation/accounting/taskstats-struct.txt
> --- a/Documentation/accounting/taskstats-struct.txt~taskstats-add-context-switch-counters-fix
> +++ a/Documentation/accounting/taskstats-struct.txt
> @@ -22,7 +22,7 @@ There are three different groups of fiel
>      /* Extended accounting fields end */
>      Their values are collected if CONFIG_TASK_XACCT is set.
>  
> -4) Per-task and per-thread context switch rates statistics
> +4) Per-task and per-thread context switch count statistics
>  
>  Future extension should add fields to the end of the taskstats struct, and
>  should not change the relative position of each field within the struct.
> diff -puN fs/proc/array.c~taskstats-add-context-switch-counters-fix fs/proc/array.c
> --- a/fs/proc/array.c~taskstats-add-context-switch-counters-fix
> +++ a/fs/proc/array.c
> @@ -290,7 +290,9 @@ static inline char *task_cap(struct task
>  			    cap_t(p->cap_permitted),
>  			    cap_t(p->cap_effective));
>  }
> -static inline char *task_context_switch_rates(struct task_struct *p, char *buffer)
> +
> +static inline char *task_context_switch_counts(struct task_struct *p,
> +						char *buffer)
>  {
>  	return buffer + sprintf(buffer, "voluntary_ctxt_switches:\t%lu\n"
>  			    "nonvoluntary_ctxt_switches:\t%lu\n",
> @@ -316,7 +318,7 @@ int proc_pid_status(struct task_struct *
>  #if defined(CONFIG_S390)
>  	buffer = task_show_regs(task, buffer);
>  #endif
> -	buffer = task_context_switch_rates(task, buffer);
> +	buffer = task_context_switch_counts(task, buffer);
>  	return buffer - orig;
>  }
>  
> _
> 

