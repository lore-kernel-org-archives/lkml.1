Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbZJMD1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbZJMD1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:27:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZJMD1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:27:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44010 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZJMD1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:27:08 -0400
Subject: Re: [tip:timers/tracing] hrtimer: Add tracepoint for hrtimers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       anton@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
       zhaolei@cn.fujitsu.com, xiaoguangrong@cn.fujitsu.com,
       fweisbec@gmail.com, tglx@linutronix.de, kosaki.motohiro@jp.fujitsu.com
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-c6a2a1770245f654f35f60e1458d4356680f9519@git.kernel.org>
References: <4A7F8B2B.5020908@cn.fujitsu.com>
	 <tip-c6a2a1770245f654f35f60e1458d4356680f9519@git.kernel.org>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 12 Oct 2009 23:25:09 -0400
Message-Id: <1255404309.7113.948.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-02 at 12:18 +0000, tip-bot for Xiao Guangrong wrote:

> +/**
> + * hrtimer_start - called when the hrtimer is started
> + * @timer: pointer to struct hrtimer
> + */
> +TRACE_EVENT(hrtimer_start,
> +
> +	TP_PROTO(struct hrtimer *timer),
> +
> +	TP_ARGS(timer),
> +
> +	TP_STRUCT__entry(
> +		__field( void *,	timer		)
> +		__field( void *,	function	)
> +		__field( s64,		expires		)
> +		__field( s64,		softexpires	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->timer		= timer;
> +		__entry->function	= timer->function;
> +		__entry->expires	= hrtimer_get_expires(timer).tv64;
> +		__entry->softexpires	= hrtimer_get_softexpires(timer).tv64;
> +	),
> +
> +	TP_printk("hrtimer %p, func %pf, expires %llu, softexpires %llu",
> +		  __entry->timer, __entry->function,
> +		  (unsigned long long)ktime_to_ns((ktime_t) {
> +				  .tv64 = __entry->expires }),
> +		  (unsigned long long)ktime_to_ns((ktime_t) {
> +				  .tv64 = __entry->softexpires }))
> +);
> +

I was just fixing up the trace-cmd parser (which is also used for perf)
and came across this code. That TP_printk shows up in the format file
as:

print fmt: "hrtimer %p, func %pf, expires %llu, softexpires %llu", REC->timer, REC->function, (unsigned long long)(((ktime_t) { .tv64 = REC->expires }).tv64), (unsigned long long)(((ktime_t) { .tv64 = REC->softexpires }).tv64)

Now I'm trying to parse this with a tool so that we can have something
that can read the binary output, and be able to easily figure it out by
reading the format files. But trying to parse:

(unsigned long long)(((ktime_t) { .tv64 = REC->expires }).tv64)

Is not easy. It's basically implementing a C interpreter :-(

Is there anyway we can change that TRACE_EVENT to give us a better,
trace printk output?

-- Steve


