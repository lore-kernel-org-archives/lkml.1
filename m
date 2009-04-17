Return-Path: <linux-kernel-owner+w=401wt.eu-S1761115AbZDQPzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761115AbZDQPzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 11:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760064AbZDQPzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 11:55:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:36651 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758470AbZDQPzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 11:55:21 -0400
Date: Fri, 17 Apr 2009 11:55:19 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: mathieu.desnoyers@polymtl.ca, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 2/4] x86/pvops: target CREATE_TRACE_POINTS to particular
 subsystems
In-Reply-To: <1239950139-1119-3-git-send-email-jeremy@goop.org>
Message-ID: <alpine.DEB.2.00.0904171149100.14919@gandalf.stny.rr.com>
References: <1239950139-1119-1-git-send-email-jeremy@goop.org> <1239950139-1119-3-git-send-email-jeremy@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Apr 2009, Jeremy Fitzhardinge wrote:
> 
> diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
> index 75e3468..ddc62f5 100644
> --- a/include/trace/events/irq.h
> +++ b/include/trace/events/irq.h
> @@ -54,4 +54,9 @@ TRACE_FORMAT(softirq_exit,
>  #endif /*  _TRACE_IRQ_H */
>  
>  /* This part must be outside protection */
> +#ifdef CREATE_IRQ_TRACE_POINTS
> +#undef CREATE_IRQ_TRACE_POINTS	/* avoid infinite recursion */
> +#include <trace/instantiate_trace.h>
> +#else
>  #include <trace/define_trace.h>
> +#endif




> --- /dev/null
> +++ b/include/trace/instantiate_trace.h
> @@ -0,0 +1,7 @@
> +/* 
> + * trace/events/foo.h include this when their subsystem-specific
> + * CREATE_FOO_TRACE_POINTS is defined.
> + */
> +#define CREATE_TRACE_POINTS
> +#include <trace/define_trace.h>
> +#undef CREATE_TRACE_POINTS

Instead of doing it this way, what about not having this new header, and 
just do:


#ifdef CREATE_IRQ_TRACE_POINTS
#define CREATE_TRACE_POINTS
#endif
#include <trace/define_trace.h>

Heck, define_trace.h is only defined when CREATE_TRACE_POINTS is defined, 
why not just remove that and have:

#ifdef CREATE_IRQ_TRACE_POINTS
#define <trace/define_trace.h>
#endif

The whole trickery with the CREATE_TRACE_POINTS was to avoid the #if in 
the trace headers anyway. If we can't avoid it. We don't need to add more 
confusion to the mix.

-- Steve

