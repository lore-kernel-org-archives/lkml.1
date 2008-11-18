Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYKRRVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYKRRVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 12:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYKRRVV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 12:21:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:65026 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbYKRRVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 12:21:21 -0500
Date: Tue, 18 Nov 2008 12:21:19 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: ftrace: preemptoff selftest not working
In-Reply-To: <20081118170635.GB4417@osiris.boeblingen.de.ibm.com>
Message-ID: <alpine.DEB.1.10.0811181220530.15003@gandalf.stny.rr.com>
References: <20081118125359.GA4417@osiris.boeblingen.de.ibm.com> <alpine.DEB.1.10.0811180826510.15003@gandalf.stny.rr.com> <20081118135221.GE31146@elte.hu> <alpine.DEB.1.10.0811180931270.15003@gandalf.stny.rr.com> <20081118144751.GA30358@elte.hu>
 <20081118170635.GB4417@osiris.boeblingen.de.ibm.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 18 Nov 2008, Heiko Carstens wrote:
> > 
> > we can drop it in selected initcalls just fine. Its only role is 
> > old-style init functions racing with other async contexts of 
> > themselves.
> 
> Something like below works fine for me...
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

> ---
> 
>  kernel/trace/trace.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux-2.6/kernel/trace/trace.c
> ===================================================================
> --- linux-2.6.orig/kernel/trace/trace.c
> +++ linux-2.6/kernel/trace/trace.c
> @@ -482,6 +482,13 @@ int register_tracer(struct tracer *type)
>  	}
>  
>  #ifdef CONFIG_FTRACE_STARTUP_TEST
> +	/*
> +	 * When this gets called we hold the BKL which means that preemption
> +	 * is disabled. Various trace selftests however need to disable
> +	 * and enable preemption for successful tests. So we drop the BKL here
> +	 * and grab it after the tests again.
> +	 */
> +	unlock_kernel();
>  	if (type->selftest) {
>  		struct tracer *saved_tracer = current_trace;
>  		struct trace_array *tr = &global_trace;
> @@ -515,6 +522,7 @@ int register_tracer(struct tracer *type)
>  		}
>  		printk(KERN_CONT "PASSED\n");
>  	}
> +	lock_kernel();
>  #endif
>  
>  	type->next = trace_types;
> 
> 
