Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab0CFD2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 22:28:16 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:47220 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab0CFD2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 22:28:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kW6guWUfRxlBPmZxABxEgiQJiP+yDjgDYpps56GLckc7VuNTMGYfR4MejWj6zOJPvf
         kvHUC58cGo++EgHdU5dz5N7h5VGsm/tzOzYFec2fae8iCNBGTmiAYtdM5EREk2T2bhe0
         33Q68iqIneVi0ooYCM8zm605ZU+tEc8wKPVCM=
Date: Sat, 6 Mar 2010 04:28:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/2] ftrace - add ftrace function_graph support on ARM
Message-ID: <20100306032811.GI5244@nowhere>
References: <4B91A25E.5030707@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B91A25E.5030707@am.sony.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 05, 2010 at 04:31:26PM -0800, Tim Bird wrote:
> +++ b/arch/arm/kernel/ftrace_graph.c
> @@ -0,0 +1,46 @@
> +/*
> + * function graph tracing support.
> + *
> + * Copyright (C) 2009 Tim Bird <tim.bird@am.sony.com>
> + *
> + * For licencing details, see COPYING.
> + *
> + * Defines routine needed for ARM return trampoline for tracing
> + * function exits.
> + */
> +
> +#include <linux/ftrace.h>
> +
> +/*
> + * Hook the return address and push it in the stack of return addrs
> + * in current thread info.
> + */
> +void prepare_ftrace_return(unsigned long *parent, unsigned long self_addr,
> +			   unsigned long frame_pointer)
> +{
> +	unsigned long old;
> +
> +	struct ftrace_graph_ent trace;
> +	unsigned long return_hooker = (unsigned long)
> +				&return_to_handler;
> +
> +	if (unlikely(atomic_read(&current->tracing_graph_pause)))
> +		return;
> +
> +	old = *parent;
> +	*parent = return_hooker;
> +
> +	if (ftrace_push_return_trace(old, self_addr, &trace.depth,
> +		    frame_pointer) == -EBUSY) {
> +		*parent = old;
> +		return;
> +	}
> +
> +	trace.func = self_addr;
> +
> +	/* Only trace if the calling function expects to */
> +	if (!ftrace_graph_entry(&trace)) {
> +		current->curr_ret_stack--;
> +		*parent = old;
> +	}
> +}




This could have been done in ftrace.c

Other than that,
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks.

