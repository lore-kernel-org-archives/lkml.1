Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbZFSFhC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbZFSFhC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 01:37:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752049AbZFSFgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 01:36:54 -0400
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:33566 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953AbZFSFgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 01:36:53 -0400
Date: Fri, 19 Jun 2009 11:06:29 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 2/2] ksym_tracer:Handle machine stall when cat
	trace_pipe for ksym tracer
Message-ID: <20090619053629.GA18550@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090616225257.041883212@prasadkr_t60p.in.ibm.com> <20090616230527.GC14753@in.ibm.com> <20090617051235.GD7411@nowhere> <20090618172522.GA4590@in.ibm.com> <20090619033031.GH7903@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090619033031.GH7903@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 19, 2009 at 05:30:31AM +0200, Frederic Weisbecker wrote:
> On Thu, Jun 18, 2009 at 10:55:22PM +0530, K.Prasad wrote:
> > On Wed, Jun 17, 2009 at 07:12:36AM +0200, Frederic Weisbecker wrote:
> > > On Wed, Jun 17, 2009 at 04:35:27AM +0530, K.Prasad wrote:
> > > > 'trace_pipe' does not handle a TRACE_TYPE_PARTIAL_LINE well and causes the
> > > > machine to stall.
> > > 
> > > 
> > > 
> > > No, if it stalls here, it means it handles it well :)
> > >
> > 
> > Okay. As stated earlier, the cause is an incorrect
> > TRACE_TYPE_PARTIAL_LINE return.
> >  
> > > > While a TRACE_TYPE_UNHANDLED return causes the tracer to
> > > > output unrelated data, a TRACE_TYPE_HANDLED return presents a clean output
> > > > (minus all partial traces).
> > > > 
> > > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > > > ---
> > > >  kernel/trace/trace_ksym.c |    6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > > 
> > > > Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> > > > ===================================================================
> > > > --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
> > > > +++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> > > > @@ -389,6 +389,12 @@ static enum print_line_t ksym_trace_outp
> > > >  
> > > >  	trace_assign_type(field, entry);
> > > >  
> > > > +	/*
> > > > +	 * Return early without any output if we don't have sufficient
> > > > +	 * information
> > > > +	 */
> > > > +	if ((!field->ksym_hbp->info.type) || (!field->ip))
> > > > +		return TRACE_TYPE_HANDLED;
> > > 
> > > 
> > > 
> > > Yeah that seems a good fix. But such silent ignored traces may
> > > hide bugs (current or futures).
> > > Is it a common situation to have a zero ip or an undefined
> > > breakpoint type? How can that happen?
> > > 
> > > Thanks.
> > >
> > 
> > When a symbol is removed from ksym's trace list, it causes
> > unregistration of the breakpoints and the breakpoint structure is
> > kfree()-ed.
> > 
> > Now, looking at the relevant code in ksym_hbp_handler() in trace_ksym.c
> > 
> >  88         entry = ring_buffer_event_data(event);
> >  89         strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
> >  90         entry->ksym_hbp = hbp;
> >  91         entry->ip = instruction_pointer(regs);
> >  92         strlcpy(entry->p_name, current->comm, TASK_COMM_LEN);
> > 
> > While the ksym_name and p_name fields are copied into the ring buffer,
> > only a pointer to the structure is provided (in line 90). So, when
> > ksym_hbp is unregistered the fields contained in it, namely 'type' and
> > 'ip' are lost (I'm not sure how the fields beyond 'field->ksym_hbp' is
> > accessible in ksym_trace_output() when it is supposed to be already
> > free).
> 
> 
> 
> If they are freed, they could still be available if the memory place
> hasn't been touched by someone else since you kfree'ed it.
> 
> But that's buggy and dangerous :)
> 
> 
> 
> > This patch would cause an early return when such is the case. I also
> > plan to remove the 'default case' in ksym_trace_output() as it was meant
> > to handle a zero value for type (other values are eliminated at the time
> > of breakpoint registration itself).
> > 
> > Please find a patch below that eliminates the two issues of output
> > concatenation and machine stall, excepting for one issue which I'm
> > unable to reason out.
> > 
> > A 'cat trace_pipe' done immediately after removal of an entry (without a
> > preceding 'cat trace') terminates only with a SIGTERM (kill <pid>) and
> > not a SIGINT (Ctrl+C). However, if the trace buffer receives any new
> > data subsequently, it responds to the Ctrl+C signal. I would be glad to
> > receive your suggestions in this regard.
> 
> 
> Hmm, weird...
> 
> 
> > 
> > ===================================================================
> > --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
> > +++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> > @@ -388,6 +388,12 @@ static enum print_line_t ksym_trace_outp
> >  		return TRACE_TYPE_UNHANDLED;
> >  
> >  	trace_assign_type(field, entry);
> > +	/*
> > +	 * Return early without any output if we don't have sufficient
> > +	 * information
> > +	 */
> > +	if ((!field->ksym_hbp->info.type) || (!field->ip))
> > +		return TRACE_TYPE_HANDLED;
> >  
> 
> 
> 
> No I still think it's dangerous, it may dereference a freed pointer.
> 
> 
> 
> >  	ret = trace_seq_printf(s, "%-15s %-5d %-3d %-20s ",
> > field->p_name,
> >  				entry->pid, iter->cpu,
> > field->ksym_name);
> > @@ -401,10 +407,7 @@ static enum print_line_t ksym_trace_outp
> >  	case HW_BREAKPOINT_RW:
> >  		ret = trace_seq_printf(s, " RW ");
> >  		break;
> > -	default:
> > -		return TRACE_TYPE_PARTIAL_LINE;
> >  	}
> > -
> >  	if (!ret)
> >  		return TRACE_TYPE_PARTIAL_LINE;
> >  
> > Thanks,
> > K.Prasad
> > 
> 
> 
> What do you think about the full copy I suggested before?
> That would solve these issues in a simple way and would be
> _much_ more safe.
> 
> If you try this, tell me if you still have such signal issue.
> 
> Thanks.
>

I introduced a new structure to contain the data for the ring buffer and
did a copy operation. But I am able to still re-create the issue. Here's
a patch that does a copy of the trace data (when a breakpoint exception
is hit).

I will formally send this patch for inclusion into -tip tree after some
more testing (and yes, it indeed solves the problem of output
concatenation and machine stall!).


Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
+++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
@@ -71,7 +71,7 @@ void ksym_hbp_handler(struct hw_breakpoi
 {
 	struct ring_buffer_event *event;
 	struct trace_array *tr;
-	struct trace_ksym *entry;
+	struct trace_ksym_rb *entry;
 	int pc;
 
 	if (!ksym_tracing_enabled)
@@ -87,7 +87,7 @@ void ksym_hbp_handler(struct hw_breakpoi
 
 	entry = ring_buffer_event_data(event);
 	strlcpy(entry->ksym_name, hbp->info.name, KSYM_SYMBOL_LEN);
-	entry->ksym_hbp = hbp;
+	memcpy(&(entry->ksym_hbp), hbp, sizeof(struct hw_breakpoint));
 	entry->ip = instruction_pointer(regs);
 	strlcpy(entry->p_name, current->comm, TASK_COMM_LEN);
 #ifdef CONFIG_PROFILE_KSYM_TRACER
@@ -380,7 +380,7 @@ static enum print_line_t ksym_trace_outp
 {
 	struct trace_entry *entry = iter->ent;
 	struct trace_seq *s = &iter->seq;
-	struct trace_ksym *field;
+	struct trace_ksym_rb *field;
 	char str[KSYM_SYMBOL_LEN];
 	int ret;
 
@@ -394,17 +394,14 @@ static enum print_line_t ksym_trace_outp
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
-	switch (field->ksym_hbp->info.type) {
+	switch (field->ksym_hbp.info.type) {
 	case HW_BREAKPOINT_WRITE:
 		ret = trace_seq_printf(s, " W  ");
 		break;
 	case HW_BREAKPOINT_RW:
 		ret = trace_seq_printf(s, " RW ");
 		break;
-	default:
-		return TRACE_TYPE_PARTIAL_LINE;
 	}
-
 	if (!ret)
 		return TRACE_TYPE_PARTIAL_LINE;
 
Index: linux-2.6-tip.hbkpt/kernel/trace/trace.h
===================================================================
--- linux-2.6-tip.hbkpt.orig/kernel/trace/trace.h
+++ linux-2.6-tip.hbkpt/kernel/trace/trace.h
@@ -216,15 +216,21 @@ struct syscall_trace_exit {
 extern int process_new_ksym_entry(char *ksymname, int op, unsigned long addr);
 
 struct trace_ksym {
-	struct trace_entry	ent;
 	struct hw_breakpoint	*ksym_hbp;
 	unsigned long		ksym_addr;
-	unsigned long		ip;
 #ifdef CONFIG_PROFILE_KSYM_TRACER
 	unsigned long		counter;
 #endif
 	struct hlist_node	ksym_hlist;
 	char			ksym_name[KSYM_NAME_LEN];
+};
+
+/* Ring buffer's copy of the breakpoint data */
+struct trace_ksym_rb {
+	struct trace_entry	ent;
+	struct hw_breakpoint	ksym_hbp;
+	unsigned long		ip;
+	char			ksym_name[KSYM_NAME_LEN];
 	char			p_name[TASK_COMM_LEN];
 };
 
@@ -343,7 +349,7 @@ extern void __ftrace_bad_type(void);
 			  TRACE_SYSCALL_ENTER);				\
 		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
 			  TRACE_SYSCALL_EXIT);				\
-		IF_ASSIGN(var, ent, struct trace_ksym, TRACE_KSYM);	\
+		IF_ASSIGN(var, ent, struct trace_ksym_rb, TRACE_KSYM);	\
 		__ftrace_bad_type();					\
 	} while (0)
 
 
