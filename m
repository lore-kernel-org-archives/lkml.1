Return-Path: <linux-kernel-owner+w=401wt.eu-S1754668AbZDIN44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668AbZDIN44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 09:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZDIN4r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 09:56:47 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47760 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbZDIN4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 09:56:46 -0400
Date: Thu, 9 Apr 2009 09:56:26 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Zhaolei <zhaolei@cn.fujitsu.com>, "David S. Miller" <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Steven Rostedt ;" <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] Tracepoint: Make skb tracepoint use TRACE_EVENT macro
Message-ID: <20090409135626.GA5716@hmsreliant.think-freely.org>
References: <49DD90D2.5020604@cn.fujitsu.com> <20090409064041.GA6666@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409064041.GA6666@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 08:40:41AM +0200, Ingo Molnar wrote:
> 
> * Zhaolei <zhaolei@cn.fujitsu.com> wrote:
> 
> > TRACE_EVENT is more unify and generic for define a tracepoint.
> > It also add ftrace support for this tracepoint.
> > 
> > Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> > ---
> >  include/trace/skb.h               |    4 +--
> >  include/trace/skb_event_types.h   |   38 +++++++++++++++++++++++++++++++++++++
> >  include/trace/trace_event_types.h |    1 +
> >  include/trace/trace_events.h      |    1 +
> >  4 files changed, 41 insertions(+), 3 deletions(-)
> >  create mode 100644 include/trace/skb_event_types.h
> 
> I've Cc:-ed more networking folks, the acks of them are needed.
> 
> David, Neil: the point of this patch is to make the kfree_skb() 
> tracepoint show up in the general event tracing framework that got 
> introduced upstream in this merge window.
> 
> One advantage is that this event will/can show up under the function 
> graph tracer and other generic tracers as well:
> 
>      0)               |          handle_IRQ_event() {
>      0)               |            /* irq_handler_entry: irq=48 handler=eth0 */
>      0)               |            e1000_intr() {
>      0)   0.926 us    |              __napi_schedule();
>      0)   3.888 us    |            }
>      0)               |            /* irq_handler_exit: irq=48 return=handled */
>      0)   0.655 us    |            runqueue_is_locked();
>      0)               |            __wake_up() {
>      0)   0.831 us    |              _spin_lock_irqsave();
> 
> This tracepoint [when enabled] would show up as:
> 
>    skbaddr=%p protocol=%u location=%p
> 
> Another advantage is that its output can also be high-bandwidth 
> per-cpu zero-copy traced via a no-vsprintf direct tracing path and 
> via splice(), using the /debug/tracing/per_cpu/cpu*/trace_pipe_raw 
> mechanism. (this is what the TP_fast_assign() portion of the 
> TRACE_EVENT() macro achieves. )
> 
> Yet another advantage is that such tracepoints also show up under 
> /debug/tracing/events/. For example the existing IRQ-handler-exit 
> tracepoint shows up as:
> 
>  aldebaran:/debug/tracing/events/irq/irq_handler_exit> ls -l
>  total 0
>  -rw-r--r-- 1 root root 0 2009-04-08 08:56 enable
>  -rw-r--r-- 1 root root 0 2009-04-08 08:56 filter
>  -r--r--r-- 1 root root 0 2009-04-08 08:56 format
>  -r--r--r-- 1 root root 0 2009-04-08 08:56 id
> 
> It can be toggled on/off, its format is exposed in a user-space-tool 
> parse-able way:
> 
>  aldebaran:/debug/tracing/events/irq/irq_handler_exit> cat format
> 
> name: irq_handler_exit
> ID: 27
> format:
> 	field:unsigned char common_type;	offset:0;	size:1;
> 	field:unsigned char common_flags;	offset:1;	size:1;
> 	field:unsigned char common_preempt_count;	offset:2;	size:1;
> 	field:int common_pid;	offset:4;	size:4;
> 	field:int common_tgid;	offset:8;	size:4;
> 
> 	field:int irq;	offset:12;	size:4;
> 	field:int ret;	offset:16;	size:4;
> 
> print fmt: "irq=%d return=%s", __entry->irq, __entry->ret ? "handled" : "unhandled"
> 
> The 'filter' file can be used to dynamically add optional filter 
> expressions, which are evaluated by the kernel at the tracepoint to 
> filter data. For example:
> 
>    echo 'irq == 1' > filter
> 
> Restricts this IRQ tracepoint to keyboard interrupts only. Doing:
> 
>    echo '|| irq == 0' >> filter
> 
>    cat filter 
>    irq == 1
>    || irq == 0
> 
> extends the filter expression to also include timer interrupts. Etc. 
> 
> All the fields enumerated in the 'format' descriptor can be used in 
> the filter language. (there's also per subsystem filter expression 
> to simplify the handling of a group of tracepoints, and other 
> details.)
> 
> There's no fastpath overhead difference to old-style tracepoints in 
> the disabled case, except some additional off-site section size 
> increase. External tools can still hook in as well.
> 
> 	Ingo
> 

I think this seems like a reasonable idea, as long as the sites that register a
hook for the tracepoint don't need to be updated (and it looks like they dont).
I do have one nit though: include/trace/skb.h has been emptied and now includes
include/trace/skb_event_types.h instead.  For the sake of neatness I'd say we
should either not make that change, and just dump the contents of
skb_event_types.h into trace/skb.h, or alternatively, remove trace/skb.h
entirely, and have files that need trace/skb.h include skb_event_types.h
instead.  Do that and it has my ACK.

Thanks
Neil

