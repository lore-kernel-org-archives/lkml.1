Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbZAPOsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbZAPOsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 09:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756810AbZAPOsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 09:48:03 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34189 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235AbZAPOsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 09:48:01 -0500
Subject: Re: [patch 1/5] x86, ftrace, hw-branch-tracer: support hotplug cpus
From: Steven Rostedt <srostedt@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, ak@linux.jf.intel.com
In-Reply-To: <20090116115051.A29998@sedona.ch.intel.com>
References: <20090116115051.A29998@sedona.ch.intel.com>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 16 Jan 2009 09:47:33 -0500
Message-Id: <1232117253.21980.74.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-01-16 at 11:50 +0100, Markus Metzger wrote:

>  static void bts_trace_print_header(struct seq_file *m)
>  {
>  	seq_puts(m,
> @@ -107,18 +173,34 @@
>  {
>  	struct ring_buffer_event *event;
>  	struct hw_branch_entry *entry;
> -	unsigned long irq;
> +	unsigned long irq1, irq2;
> +	int cpu;
> +
> +	if (unlikely(!tr))
> +		return;
> +
> +	if (unlikely(!trace_hw_branches_enabled))
> +		return;
> +
> +	local_irq_save(irq1);
> +	cpu = raw_smp_processor_id();
> +	if (atomic_inc_return(&tr->data[cpu]->disabled) != 1)
> +		goto out;
>  
> -	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq);
> +	event = ring_buffer_lock_reserve(tr->buffer, sizeof(*entry), &irq2);
>  	if (!event)
>  		return;

You need a goto out here, otherwise you leave with interrupts disabled.

Doing 'echo 0 > /debug/tracing/tracing_on' will guarantee that you hit
this return.

-- Steve

>  	entry	= ring_buffer_event_data(event);
>  	tracing_generic_entry_update(&entry->ent, 0, from);
>  	entry->ent.type = TRACE_HW_BRANCHES;
> -	entry->ent.cpu = smp_processor_id();
> +	entry->ent.cpu = cpu;
>  	entry->from = from;
>  	entry->to   = to;
> -	ring_buffer_unlock_commit(tr->buffer, event, irq);
> +	ring_buffer_unlock_commit(tr->buffer, event, irq2);
> +
> + out:
> +	atomic_dec(&tr->data[cpu]->disabled);
> +	local_irq_restore(irq1);
>  }
>  
>  static void trace_bts_at(struct trace_array *tr,
> @@ -142,6 +224,11 @@
>  	}
>  }
>  
> +

