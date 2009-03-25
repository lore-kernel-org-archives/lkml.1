Return-Path: <linux-kernel-owner+w=401wt.eu-S1761478AbZCYNYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761478AbZCYNYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbZCYNYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:24:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37187 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807AbZCYNY3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:24:29 -0400
Date: Wed, 25 Mar 2009 09:24:25 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@au1.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, maneesh@linux.vnet.ibm.com,
       Roland McGrath <roland@redhat.com>
Subject: Re: [Patch 11/11] ftrace plugin for kernel symbol tracing using HW
 Breakpoint interfaces - v3
In-Reply-To: <20090325063517.GA5825@in.ibm.com>
Message-ID: <alpine.DEB.2.00.0903250923340.5675@gandalf.stny.rr.com>
References: <20090324152028.754123712@K.Prasad> <20090324152811.GL17918@in.ibm.com> <20090325063517.GA5825@in.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 25 Mar 2009, K.Prasad wrote:

> On Tue, Mar 24, 2009 at 08:58:11PM +0530, K.Prasad wrote:
> > This patch adds an ftrace plugin to detect and profile memory access over
> > kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> > addresses.
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> > ---
> >  kernel/trace/Kconfig          |   21 +
> >  kernel/trace/Makefile         |    1 
> >  kernel/trace/trace.h          |   25 +
> >  kernel/trace/trace_ksym.c     |  555 ++++++++++++++++++++++++++++++++++++++++++
> >  kernel/trace/trace_selftest.c |   36 ++
> >  5 files changed, 638 insertions(+)
> >
> 
> Submitting the revised patch 11/11 and not reposting the entire
> patchset.
> 
> Changelog
> ---------
> - Checking for the appropriate tracer type in the .print_line handler function
> 
> Please find the new patch below.
> 
> Thanks,
> K.Prasad
> 
> 
> ftrace plugin for kernel symbol tracing using HW Breakpoint interfaces - v2
> 
> This patch adds an ftrace plugin to detect and profile memory access over
> kernel variables. It uses HW Breakpoint interfaces to 'watch memory
> addresses.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com> 
> ---
>  kernel/trace/Kconfig          |   21 +
>  kernel/trace/Makefile         |    1 
>  kernel/trace/trace.h          |   25 +
>  kernel/trace/trace_ksym.c     |  558 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/trace/trace_selftest.c |   36 ++
>  5 files changed, 641 insertions(+)
> 
> +static enum print_line_t ksym_trace_output(struct trace_iterator *iter)
> +{
> +	struct trace_entry *entry = iter->ent;
> +	struct trace_seq *s = &iter->seq;
> +	struct trace_ksym *field;
> +	char str[KSYM_SYMBOL_LEN];
> +	int ret;
> +
> +	if (entry->type != TRACE_KSYM)
> +		return TRACE_TYPE_UNHANDLED;

Looks good.

Acked-by:Steven Rostedt <srostedt@redhat.com>

Thanks,

-- Steve

> +
> +	trace_assign_type(field, entry);
> +
> +	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ", field->p_name,
> +				entry->pid, iter->cpu, field->ksym_name);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	switch (field->ksym_hbp->info.type) {
> +	case HW_BREAKPOINT_WRITE:
> +		ret = trace_seq_printf(s, " W  ");
> +		break;
> +	case HW_BREAKPOINT_RW:
> +		ret = trace_seq_printf(s, " RW ");
> +		break;
> +	default:
> +		return TRACE_TYPE_PARTIAL_LINE;
> +	}
> +
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	sprint_symbol(str, field->ip);
> +	ret = trace_seq_printf(s, "%-20s\n", str);
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +
> +	return TRACE_TYPE_HANDLED;
> +}
> +
