Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654Ab0ARR16@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0ARR16 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:27:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145Ab0ARR1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:27:54 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34562 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755127Ab0ARRU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:20:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uUJy5wVTYjeaSnenYPGAU9mQus9YgKULr3pRJUjlQGLWjjVORYtEwCsTdVMFceS2Oi
         PIlyLm8tT8w4NM+sgtU54H2qRX9W9Oe95TjxizoemZsQAeYNNZlYpMaT5+DZWCNYu6yq
         SyXVPyKMsRlXtgHEUf3tZSkfAr9KxGy8acmc8=
Date: Mon, 18 Jan 2010 18:20:23 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf_event: cleanup for event profile buffer
	operation
Message-ID: <20100118172021.GL10364@nowhere>
References: <4B54654A.4090601@cn.fujitsu.com> <4B5465D8.9070203@cn.fujitsu.com> <4B548A9A.1020806@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B548A9A.1020806@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 18, 2010 at 11:21:46AM -0500, Masami Hiramatsu wrote:
> Xiao Guangrong wrote:
> > Introduce ftrace_profile_buf_begin() and ftrace_profile_buf_end() to
> > operate event profile buffer, clean up redundant code
> > 
> > Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> [...]
> 
> > diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
> > index 9e25573..f0fa16b 100644
> > --- a/kernel/trace/trace_event_profile.c
> > +++ b/kernel/trace/trace_event_profile.c
> > @@ -9,11 +9,8 @@
> >  #include "trace.h"
> >  
> >  
> > -char *perf_trace_buf;
> > -EXPORT_SYMBOL_GPL(perf_trace_buf);
> > -
> > -char *perf_trace_buf_nmi;
> > -EXPORT_SYMBOL_GPL(perf_trace_buf_nmi);
> > +static char *perf_trace_buf;
> > +static char *perf_trace_buf_nmi;
> >  
> >  typedef typeof(char [FTRACE_MAX_PROFILE_SIZE]) perf_trace_t ;
> >  
> > @@ -120,3 +117,56 @@ void ftrace_profile_disable(int event_id)
> >  	}
> >  	mutex_unlock(&event_mutex);
> >  }
> > +
> > +void *ftrace_profile_buf_begin(int size, unsigned short type, int *rctxp,
> > +			       unsigned long *irq_flags)
> > +{
> > +	struct trace_entry *entry;
> > +	char *trace_buf, *raw_data;
> > +	int pc, cpu;
> > +
> > +	pc = preempt_count();
> > +
> > +	/* Protect the per cpu buffer, begin the rcu read side */
> > +	local_irq_save(*irq_flags);
> > +
> > +	*rctxp = perf_swevent_get_recursion_context();
> > +	if (*rctxp < 0)
> > +		goto err_recursion;
> > +
> > +	cpu = smp_processor_id();
> > +
> > +	if (in_nmi())
> > +		trace_buf = rcu_dereference(perf_trace_buf_nmi);
> > +	else
> > +		trace_buf = rcu_dereference(perf_trace_buf);
> > +
> > +	if (!trace_buf)
> > +		goto err;
> > +
> > +	raw_data = per_cpu_ptr(trace_buf, cpu);
> > +
> > +	/* zero the dead bytes from align to not leak stack to user */
> > +	*(u64 *)(&raw_data[size - sizeof(u64)]) = 0ULL;
> > +
> > +	entry = (struct trace_entry *)raw_data;
> > +	tracing_generic_entry_update(entry, *irq_flags, pc);
> > +	entry->type = type;
> > +
> > +	return raw_data;
> > +err:
> > +	perf_swevent_put_recursion_context(*rctxp);
> > +err_recursion:
> > +	local_irq_restore(*irq_flags);
> > +	return NULL;
> > +}
> > +
> > +void ftrace_profile_buf_end(void *raw_data, int size, int rctx, u64 addr,
> > +			    u64 count, unsigned long irq_flags)
> > +{
> > +	struct trace_entry *entry = raw_data;
> > +
> > +	perf_tp_event(entry->type, addr, count, raw_data, size);
> > +	perf_swevent_put_recursion_context(rctx);
> > +	local_irq_restore(irq_flags);
> > +}
> 
> Hmm, could you make it inline-functions or add __kprobes?
> Because it is called from kprobes, we don't want to probe
> the function which will be called from kprobes handlers itself.
> 
> (IMHO, from the viewpoint of performance, inline-function
>  could be better.)
> 
> Thank you,



Yeah, may be inline ftrace_profile_buf_end, would be better.
But we shouldn't inline ftrace_profile_buf_begin() I guess,
considering its size.

While at it, may be let's choose more verbose names
like

ftrace_profile_buf_fill() and ftrace_profile_buf_submit().

Also, profile is a bit of a misnomer. Not a problem since
ftrace_profile_templ_##call() is already a misnomer, but
we should start a bit of a rename. Sometimes, perf only
profiles trace events as counters and sometimes it records
the raw samples too.

So, as more generic names, I would suggest:

ftrace_perf_buf_fill() and ftrace_perf_buf_submit().

At least it's unambiguous, I hope...

