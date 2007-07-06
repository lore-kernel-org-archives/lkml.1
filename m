Return-Path: <linux-kernel-owner+w=401wt.eu-S1762910AbXGFLEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762910AbXGFLEY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 07:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759656AbXGFLEP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 07:04:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:54384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755843AbXGFLEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 07:04:14 -0400
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Thread Migration Preemption
References: <20070705215152.GA4865@Krystal>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Jul 2007 13:59:33 +0200
In-Reply-To: <20070705215152.GA4865@Krystal>
Message-ID: <p73myy9215m.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:

> Thread Migration Preemption
> 
> This patch adds the ability to protect critical sections from migration to
> another CPU without disabling preemption.

Good idea.

I sometimes think we could have avoided _much_ trouble
if that had been always default for processes running 
in kernel space.
 
> This will be useful to minimize the amount of preemption disabling for the -rt
> patch. It will help leveraging improvements brought by the local_t types in
> asm/local.h (see Documentation/local_ops.txt). Note that the updates done to
> variables protected by migration_disable must be either atomic or protected from
> concurrent updates done by other threads.
> 
> Typical use:
> 
> migration_disable();
> local_inc(&__get_cpu_var(&my_local_t_var));
> migration_enable();

It seems strange to have a new interface for this. We already 
have get_cpu()/put_cpu(). So why not use that?

>  	unsigned long		flags;		/* low level flags */
>  	__u32			cpu;
>  	__s32			preempt_count;	/* 0 => preemptable, <0 => BUG */
> +	int			migration_count;/* 0: can migrate, <0 => BUG */

Can you turn preempt_count into a short first and use a short? That should be enough
and cache line usage wouldn't be increased. That's ok on x86; on RISCs 
int might be faster


-Andi
