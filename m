Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbZC0Oj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbZC0Oj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 10:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757188AbZC0Ojm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 10:39:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44382 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756334AbZC0Ojm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 10:39:42 -0400
Date: Fri, 27 Mar 2009 15:35:56 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, juan.villacis@intel.com, ak@linux.jf.intel.com
Subject: Re: [patch 4/14] x86, ds: wait before freeing the DS configuration
Message-ID: <20090327143556.GE14504@redhat.com>
References: <20090327095840.A11187@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327095840.A11187@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27, Markus Metzger wrote:
>
> --- git-tip.orig/arch/x86/kernel/ds.c	2009-03-27 07:59:23.000000000 +0100
> +++ git-tip/arch/x86/kernel/ds.c	2009-03-27 08:00:41.000000000 +0100
> @@ -783,6 +783,14 @@ void ds_release_bts(struct bts_tracer *t
>  
>  	ds_suspend_bts(tracer);
>  
> +	/*
> +	 * We must wait for the suspend to take effect before we may
> +	 * free the tracer and the ds configuration.
> +	 */
> +	if (tracer->ds.context->task &&
> +	    (tracer->ds.context->task != current))
> +		wait_task_inactive(tracer->ds.context->task, 0);
> +

Since you didn't replay yet, I will just repeat my question ;)

I am not sure I understand the problem. From the changelog:

        If the children are currently executing, the buffer
        may be freed while the hardware is still tracing.
        This might cause the hardware to overwrite memory.

So, the problem is that ds.context->task must not be running before we
can start to disable/free ds, yes? Something like ds_switch_to() should
be completed, right?

In that case I don't really understand how wait_task_inactive() can help.
If the task is killed it can be scheduled again, right after
wait_task_inactive() returns.

Also. This function is called from ptrace_bts_exit_tracer(), when the
tracee is not stopped. In this case wait_task_inactive() can spin forever.
For example, if the tracee simply does "for (;;) ;" it never succeeds.


If my understanding of the problem is wrong, could you please explain
it for dummies?

Oleg.

