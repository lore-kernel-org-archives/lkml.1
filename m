Return-Path: <linux-kernel-owner+w=401wt.eu-S1755513AbZFRRZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbZFRRZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 13:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZFRRZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 13:25:31 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60229 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbZFRRZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 13:25:30 -0400
Date: Thu, 18 Jun 2009 22:55:22 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 2/2] ksym_tracer:Handle machine stall when cat
	trace_pipe for ksym tracer
Message-ID: <20090618172522.GA4590@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090616225257.041883212@prasadkr_t60p.in.ibm.com> <20090616230527.GC14753@in.ibm.com> <20090617051235.GD7411@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090617051235.GD7411@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 07:12:36AM +0200, Frederic Weisbecker wrote:
> On Wed, Jun 17, 2009 at 04:35:27AM +0530, K.Prasad wrote:
> > 'trace_pipe' does not handle a TRACE_TYPE_PARTIAL_LINE well and causes the
> > machine to stall.
> 
> 
> 
> No, if it stalls here, it means it handles it well :)
>

Okay. As stated earlier, the cause is an incorrect
TRACE_TYPE_PARTIAL_LINE return.
 
> > While a TRACE_TYPE_UNHANDLED return causes the tracer to
> > output unrelated data, a TRACE_TYPE_HANDLED return presents a clean output
> > (minus all partial traces).
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > ---
> >  kernel/trace/trace_ksym.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> > ===================================================================
> > --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
> > +++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> > @@ -389,6 +389,12 @@ static enum print_line_t ksym_trace_outp
> >  
> >  	trace_assign_type(field, entry);
> >  
> > +	/*
> > +	 * Return early without any output if we don't have sufficient
> > +	 * information
> > +	 */
> > +	if ((!field->ksym_hbp->info.type) || (!field->ip))
> > +		return TRACE_TYPE_HANDLED;
> 
> 
> 
> Yeah that seems a good fix. But such silent ignored traces may
> hide bugs (current or futures).
> Is it a common situation to have a zero ip or an undefined
> breakpoint type? How can that happen?
> 
> Thanks.
>

When a symbol is removed from ksym's trace list, it causes
unregistration of the breakpoints and the breakpoint structure is
kfree()-ed.

Now, looking at the relevant code in ksym_hbp_handler() in trace_ksym.c

 88         entry = ring_buffer_event_data(event);
 89         strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
 90         entry->ksym_hbp = hbp;
 91         entry->ip = instruction_pointer(regs);
 92         strlcpy(entry->p_name, current->comm, TASK_COMM_LEN);

While the ksym_name and p_name fields are copied into the ring buffer,
only a pointer to the structure is provided (in line 90). So, when
ksym_hbp is unregistered the fields contained in it, namely 'type' and
'ip' are lost (I'm not sure how the fields beyond 'field->ksym_hbp' is
accessible in ksym_trace_output() when it is supposed to be already
free).

This patch would cause an early return when such is the case. I also
plan to remove the 'default case' in ksym_trace_output() as it was meant
to handle a zero value for type (other values are eliminated at the time
of breakpoint registration itself).

Please find a patch below that eliminates the two issues of output
concatenation and machine stall, excepting for one issue which I'm
unable to reason out.

A 'cat trace_pipe' done immediately after removal of an entry (without a
preceding 'cat trace') terminates only with a SIGTERM (kill <pid>) and
not a SIGINT (Ctrl+C). However, if the trace buffer receives any new
data subsequently, it responds to the Ctrl+C signal. I would be glad to
receive your suggestions in this regard.

===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
+++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
@@ -388,6 +388,12 @@ static enum print_line_t ksym_trace_outp
 		return TRACE_TYPE_UNHANDLED;
 
 	trace_assign_type(field, entry);
+	/*
+	 * Return early without any output if we don't have sufficient
+	 * information
+	 */
+	if ((!field->ksym_hbp->info.type) || (!field->ip))
+		return TRACE_TYPE_HANDLED;
 
 	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ",
field->p_name,
 				entry->pid, iter->cpu,
field->ksym_name);
@@ -401,10 +407,7 @@ static enum print_line_t ksym_trace_outp
 	case HW_BREAKPOINT_RW:
 		ret = trace_seq_printf(s, " RW ");
 		break;
-	default:
-		return TRACE_TYPE_PARTIAL_LINE;
 	}
-
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
Thanks,
K.Prasad

