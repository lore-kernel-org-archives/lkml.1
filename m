Return-Path: <linux-kernel-owner+w=401wt.eu-S1752044AbYLSQQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbYLSQQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 11:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751320AbYLSQQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 11:16:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:45448 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbYLSQQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 11:16:35 -0500
Date: Fri, 19 Dec 2008 11:16:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mike Travis <travis@sgi.com>
cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] cpumask: convert kernel trace functions
In-Reply-To: <20081219160145.272814000@polaris-admin.engr.sgi.com>
Message-ID: <alpine.DEB.1.10.0812191114070.28744@gandalf.stny.rr.com>
References: <20081219160144.697518000@polaris-admin.engr.sgi.com> <20081219160145.272814000@polaris-admin.engr.sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 19 Dec 2008, Mike Travis wrote:

> Impact: Reduce memory usage, use new cpumask API.
> 
> Convert kernel trace functions to use struct cpumask.
> 

[..]

>  #define for_each_buffer_cpu(buffer, cpu)		\
> -	for_each_cpu_mask(cpu, buffer->cpumask)
> +	for_each_cpu(cpu, buffer->cpumask)
>  
>  #define TS_SHIFT	27
>  #define TS_MASK		((1ULL << TS_SHIFT) - 1)
> @@ -262,7 +262,7 @@ struct ring_buffer {
>  	unsigned			pages;
>  	unsigned			flags;
>  	int				cpus;
> -	cpumask_t			cpumask;
> +	cpumask_var_t			cpumask;
>  	atomic_t			record_disabled;
>  
>  	struct mutex			mutex;
> @@ -453,6 +453,9 @@ struct ring_buffer *ring_buffer_alloc(un
>  	if (!buffer)
>  		return NULL;
>  
> +	if (!alloc_cpumask_var(&buffer->cpumask, GFP_KERNEL))
> +		goto fail_free_buffer;
> +


How does this save memory if we just allocate a cpumask var everytime
we allocate a ring buffer?  Is cpumask_var_t a mask of possible CPUS and 
not NR_CPUS?

Otherwise, I see this as just adding one extra pointer.

-- Steve
