Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750AbYIPULa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750AbYIPULa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 16:11:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYIPULW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 16:11:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:46560 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbYIPULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 16:11:21 -0400
Date: Tue, 16 Sep 2008 16:11:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Pekka Paalanen <pq@iki.fi>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH 5/7] mmiotrace: handle TRACE_PRINT entries.
In-Reply-To: <20080916220227.4db173f5@daedalus.pq.iki.fi>
Message-ID: <alpine.DEB.1.10.0809161609520.7650@gandalf.stny.rr.com>
References: <48B1D5CA.8000607@gmail.com> <c62985530808270259i491e32e2r40adf719e32e4086@mail.gmail.com> <20080827212130.4b8365a8@daedalus.pq.iki.fi> <c62985530808280304x389cb958vff24b5d11f22d35c@mail.gmail.com> <20080828214256.296e34ec@daedalus.pq.iki.fi>
 <c62985530809040920v3c47b57ds40dfd400168bd501@mail.gmail.com> <20080904203058.7e57729e@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809041407140.2431@gandalf.stny.rr.com> <20080915224707.76b2cca0@daedalus.pq.iki.fi> <alpine.DEB.1.10.0809151556260.22620@gandalf.stny.rr.com>
 <20080916215416.16aee2dd@daedalus.pq.iki.fi> <20080916220227.4db173f5@daedalus.pq.iki.fi>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 16 Sep 2008, Pekka Paalanen wrote:

> From 6a458e250857907e16cb16799392fccbfd5f0f4a Mon Sep 17 00:00:00 2001
> From: Pekka Paalanen <pq@iki.fi>
> Date: Sun, 17 Aug 2008 18:15:13 +0300
> Subject: [PATCH] mmiotrace: handle TRACE_PRINT entries.
> 
> Also make trace_seq_print_cont() non-static, and add a newline if the
> seq buffer can't hold all data.
> 
> Signed-off-by: Pekka Paalanen <pq@iki.fi>
> ---
>  kernel/trace/trace.c           |   31 +++++++++++--------------------
>  kernel/trace/trace.h           |   19 +++++++++++++++++++
>  kernel/trace/trace_mmiotrace.c |   23 +++++++++++++++++++++++
>  3 files changed, 53 insertions(+), 20 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 406de9c..7e7154f 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -200,23 +200,6 @@ unsigned long nsecs_to_usecs(unsigned long nsecs)
>  }
>  
>  /*
> - * trace_flag_type is an enumeration that holds different
> - * states when a trace occurs. These are:
> - *  IRQS_OFF	- interrupts were disabled
> - *  NEED_RESCED - reschedule is requested
> - *  HARDIRQ	- inside an interrupt handler
> - *  SOFTIRQ	- inside a softirq handler
> - *  CONT	- multiple entries hold the trace item
> - */
> -enum trace_flag_type {
> -	TRACE_FLAG_IRQS_OFF		= 0x01,
> -	TRACE_FLAG_NEED_RESCHED		= 0x02,
> -	TRACE_FLAG_HARDIRQ		= 0x04,
> -	TRACE_FLAG_SOFTIRQ		= 0x08,
> -	TRACE_FLAG_CONT			= 0x10,
> -};
> -
> -/*
>   * TRACE_ITER_SYM_MASK masks the options in trace_flags that
>   * control the output of kernel symbols.
>   */
> @@ -1517,12 +1500,16 @@ lat_print_timestamp(struct trace_seq *s, unsigned long long abs_usecs,
>  
>  static const char state_to_char[] = TASK_STATE_TO_CHAR_STR;
>  
> -static void
> -trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
> +/*
> + * The message is supposed to contain an ending newline.
> + * If the printing stops prematurely, try to add a newline of our own.
> + */
> +void trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
>  {
>  	struct trace_array *tr = iter->tr;
>  	struct trace_array_cpu *data = tr->data[iter->cpu];
>  	struct trace_entry *ent;
> +	bool ok = true;

hmm, since when did the kernel have type bool?

>  
>  	ent = trace_entry_idx(tr, data, iter, iter->cpu);
>  	if (!ent || ent->type != TRACE_CONT) {
> @@ -1531,10 +1518,14 @@ trace_seq_print_cont(struct trace_seq *s, struct trace_iterator *iter)
>  	}
>  
>  	do {
> -		trace_seq_printf(s, "%s", ent->cont.buf);
> +		if (ok)
> +			ok = (trace_seq_printf(s, "%s", ent->cont.buf) > 0);
>  		__trace_iterator_increment(iter, iter->cpu);
>  		ent = trace_entry_idx(tr, data, iter, iter->cpu);
>  	} while (ent && ent->type == TRACE_CONT);
> +
> +	if (!ok)
> +		trace_seq_putc(s, '\n');
>  }
>  

-- Steve
