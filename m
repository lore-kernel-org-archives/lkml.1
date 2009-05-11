Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbZEKOgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbZEKOgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 10:36:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbZEKOfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 10:35:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbZEKOfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 10:35:32 -0400
Date: Mon, 11 May 2009 10:35:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Masami Hiramatsu <mhiramat@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH -tip v5 7/7] tracing: add arguments support on kprobe-based
 event tracer
In-Reply-To: <20090509004916.5505.64914.stgit@localhost.localdomain>
Message-ID: <alpine.DEB.2.00.0905111030160.14976@gandalf.stny.rr.com>
References: <20090509004829.5505.38720.stgit@localhost.localdomain> <20090509004916.5505.64914.stgit@localhost.localdomain>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 May 2009, Masami Hiramatsu wrote:

> Support following probe arguments and add fetch functions on kprobe-based
> event tracer.
> 
>   %REG  : Fetch register REG
>   sN    : Fetch Nth entry of stack (N >= 0)
>   @ADDR : Fetch memory at ADDR (ADDR should be in kernel)
>   @SYM[+|-offs] : Fetch memory at SYM +|- offs (SYM should be a data symbol)
>   aN    : Fetch function argument. (N >= 0)
>   rv    : Fetch return value.
>   ra    : Fetch return address.
>   +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> 
>  Documentation/trace/ftrace.txt |   47 +++-
>  kernel/trace/trace_kprobe.c    |  431 ++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 441 insertions(+), 37 deletions(-)
> 
> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> index 2b8ead6..ce91398 100644
> --- a/Documentation/trace/ftrace.txt

The Documentation/trace/ftrace.txt file is getting too big. Could you make 
a separate "Documentation/trace/kprobes.txt file, and split out the 
kprobe bits.

Thanks,

-- Steve


> +++ b/Documentation/trace/ftrace.txt
> @@ -1329,17 +1329,34 @@ current_tracer, instead of that, just set probe points via
>  /debug/tracing/kprobe_events.
>  
>  Synopsis of kprobe_events:
> -  p SYMBOL[+offs|-offs]|MEMADDR	: set a probe
> -  r SYMBOL[+0]			: set a return probe
> +  p SYMBOL[+offs|-offs]|MEMADDR [FETCHARGS]	: set a probe
> +  r SYMBOL[+0] [FETCHARGS]			: set a return probe
> +
> + FETCHARGS:
> +  %REG	: Fetch register REG
> +  sN	: Fetch Nth entry of stack (N >= 0)
> +  @ADDR	: Fetch memory at ADDR (ADDR should be in kernel)
> +  @SYM[+|-offs]	: Fetch memory at SYM +|- offs (SYM should be a data symbol)
> +  aN	: Fetch function argument. (N >= 0)(*)
> +  rv	: Fetch return value.(**)
> +  ra	: Fetch return address.(**)
> +  +|-offs(FETCHARG) : fetch memory at FETCHARG +|- offs address.(***)
> +
> +  (*) aN may not correct on asmlinkaged functions and at the middle of
> +      function body.
> +  (**) only for return probe.
> +  (***) this is useful for fetching a field of data structures.
>  
>  E.g.
> -  echo p sys_open > /debug/tracing/kprobe_events
> +  echo p do_sys_open a0 a1 a2 a3 > /debug/tracing/kprobe_events
>  
> - This sets a kprobe on the top of sys_open() function.
> + This sets a kprobe on the top of do_sys_open() function with recording
> +1st to 4th arguments.
>  
> -  echo r sys_open >> /debug/tracing/kprobe_events
> +  echo r do_sys_open rv ra >> /debug/tracing/kprobe_events
>  
> - This sets a kretprobe on the return point of sys_open() function.
> + This sets a kretprobe on the return point of do_sys_open() function with
> +recording return value and return address.
>  
>    echo > /debug/tracing/kprobe_events
>  
