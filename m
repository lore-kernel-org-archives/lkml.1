Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbYA3Jh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbYA3Jh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760017AbYA3Jcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:32:42 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54457 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758377AbYA3Jcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:32:39 -0500
Subject: Re: [PATCH 17/22 -v7] mcount tracer for wakeup latency timings.
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Jan Kiszka <jan.kiszka@siemens.com>, John Stultz <johnstul@us.ibm.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20080130031842.783183063@goodmis.org>
References: <20080130031521.258552785@goodmis.org>
	 <20080130031842.783183063@goodmis.org>
Content-Type: text/plain
Date: Wed, 30 Jan 2008 10:31:09 +0100
Message-Id: <1201685469.28547.172.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-29 at 22:15 -0500, Steven Rostedt wrote:

> +static void notrace __wakeup_reset(struct tracing_trace *tr)
> +{
> +	struct tracing_trace_cpu *data;
> +	int cpu;
> +
> +	assert_spin_locked(&wakeup_lock);
> +
> +	for_each_possible_cpu(cpu) {
> +		data = tr->data[cpu];
> +		tracing_reset(data);
> +	}
> +
> +	wakeup_cpu = -1;
> +	wakeup_prio = -1;
> +	if (wakeup_task) {
> +		put_task_struct(wakeup_task);
> +		tracing_stop_function_trace();
> +	}
> +
> +	wakeup_task = NULL;
> +
> +	/*
> +	 * Don't let the trace_enabled = 1 show up before
> +	 * the wakeup_task is reset.
> +	 */
> +	smp_wmb();
> +}

Another un-balanced barrier.

