Return-Path: <linux-kernel-owner+w=401wt.eu-S1758242AbZGGUU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbZGGUU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 16:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755298AbZGGUUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 16:20:17 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:59236 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbZGGUUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 16:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AQBkF5SuCQrR9iu2HE7LSB9FK1sYW0k5UrfYjw4nAsZHFqfz3H/dEHf6zXqem0Ykjw
         fF0Q8DR9fhfkKO6Ig2zgEBH2UtMbco6oAak0w1p9si1O1ItstxI28OmkcABQg2cedU/L
         k5dwZ9rHZsRBeARWgphsyoYWFgL+t7wC84OK4=
Date: Tue, 7 Jul 2009 22:20:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>, Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH -tip -v10 7/7] tracing: add kprobe-based event tracer
Message-ID: <20090707202008.GE6184@nowhere>
References: <20090701010838.32547.62843.stgit@localhost.localdomain> <20090701010923.32547.74203.stgit@localhost.localdomain> <20090707073103.GA6173@nowhere> <4A53A830.3000305@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A53A830.3000305@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 03:55:28PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
> >> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> >> index 206cb7d..65945eb 100644
> >> --- a/kernel/trace/trace.h
> >> +++ b/kernel/trace/trace.h
> >> @@ -45,6 +45,8 @@ enum trace_type {
> >>  	TRACE_POWER,
> >>  	TRACE_BLK,
> >>  	TRACE_KSYM,
> >> +	TRACE_KPROBE,
> >> +	TRACE_KRETPROBE,
> >>  
> >>  	__TRACE_LAST_TYPE,
> >>  };
> >> @@ -227,6 +229,22 @@ struct trace_ksym {
> >>  	char			ksym_name[KSYM_NAME_LEN];
> >>  	char			p_name[TASK_COMM_LEN];
> >>  };
> >> +#define TRACE_KPROBE_ARGS 6
> >> +
> >> +struct kprobe_trace_entry {
> >> +	struct trace_entry	ent;
> >> +	unsigned long		ip;
> >> +	int			nargs;
> >> +	unsigned long		args[TRACE_KPROBE_ARGS];
> > 
> > 
> > 
> > I see that you actually make use of arg as a dynamic sizeable
> > array.
> > For clarity, args[TRACE_KPROBE_ARGS] could be args[0].
> > 
> > It's just a neat and wouldn't affect the code nor the data
> > but would be clearer for readers of that code.
> 
> Hmm. In that case, I think we'll need a new macro for field
> definition, like TRACE_FIELD_ZERO(type, item).



You mean that for trace_define_field() to describe fields of events?
Actually the fields should be defined dynamically depending on how
is built the kprobe event (which arguments are requested, how many,
etc..).

Frederic.


 
> >> +};
> >> +
> >> +struct kretprobe_trace_entry {
> >> +	struct trace_entry	ent;
> >> +	unsigned long		func;
> >> +	unsigned long		ret_ip;
> >> +	int			nargs;
> >> +	unsigned long		args[TRACE_KPROBE_ARGS];
> >> +};
> > 
> > 
> > ditto
> > 
> > 
> >   
> >>  /*
> >>   * trace_flag_type is an enumeration that holds different
> >> @@ -344,6 +362,10 @@ extern void __ftrace_bad_type(void);
> >>  		IF_ASSIGN(var, ent, struct syscall_trace_exit,		\
> >>  			  TRACE_SYSCALL_EXIT);				\
> >>  		IF_ASSIGN(var, ent, struct trace_ksym, TRACE_KSYM);	\
> >> +		IF_ASSIGN(var, ent, struct kprobe_trace_entry,		\
> >> +			  TRACE_KPROBE);				\
> >> +		IF_ASSIGN(var, ent, struct kretprobe_trace_entry,	\
> >> +			  TRACE_KRETPROBE);				\
> >>  		__ftrace_bad_type();					\
> >>  	} while (0)
> >>  
> >> diff --git a/kernel/trace/trace_event_types.h b/kernel/trace/trace_event_types.h
> >> index 6db005e..ec2e6f3 100644
> >> --- a/kernel/trace/trace_event_types.h
> >> +++ b/kernel/trace/trace_event_types.h
> >> @@ -175,4 +175,24 @@ TRACE_EVENT_FORMAT(kmem_free, TRACE_KMEM_FREE, kmemtrace_free_entry, ignore,
> >>  	TP_RAW_FMT("type:%u call_site:%lx ptr:%p")
> >>  );
> >>  
> >> +TRACE_EVENT_FORMAT(kprobe, TRACE_KPROBE, kprobe_trace_entry, ignore,
> >> +	TRACE_STRUCT(
> >> +		TRACE_FIELD(unsigned long, ip, ip)
> >> +		TRACE_FIELD(int, nargs, nargs)
> >> +		TRACE_FIELD_SPECIAL(unsigned long args[TRACE_KPROBE_ARGS],
> >> +				    args, TRACE_KPROBE_ARGS, args)
> >> +	),
> >> +	TP_RAW_FMT("%08lx: args:0x%lx ...")
> >> +);
> >> +
> >> +TRACE_EVENT_FORMAT(kretprobe, TRACE_KRETPROBE, kretprobe_trace_entry, ignore,
> >> +	TRACE_STRUCT(
> >> +		TRACE_FIELD(unsigned long, func, func)
> >> +		TRACE_FIELD(unsigned long, ret_ip, ret_ip)
> >> +		TRACE_FIELD(int, nargs, nargs)
> >> +		TRACE_FIELD_SPECIAL(unsigned long args[TRACE_KPROBE_ARGS],
> >> +				    args, TRACE_KPROBE_ARGS, args)
> >> +	),
> >> +	TP_RAW_FMT("%08lx <- %08lx: args:0x%lx ...")
> >> +);
> >>  #undef TRACE_SYSTEM
> >> diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
> >> new file mode 100644
> >> index 0000000..0951512
> >> --- /dev/null
> >> +++ b/kernel/trace/trace_kprobe.c
> >> @@ -0,0 +1,1183 @@
> >> +/*
> >> + * kprobe based kernel tracer
> >> + *
> >> + * Created by Masami Hiramatsu <mhiramat@redhat.com>
> >> + *
> >> + * This program is free software; you can redistribute it and/or modify
> >> + * it under the terms of the GNU General Public License version 2 as
> >> + * published by the Free Software Foundation.
> >> + *
> >> + * This program is distributed in the hope that it will be useful,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >> + * GNU General Public License for more details.
> >> + *
> >> + * You should have received a copy of the GNU General Public License
> >> + * along with this program; if not, write to the Free Software
> >> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> >> + */
> >> +
> >> +#include <linux/module.h>
> >> +#include <linux/uaccess.h>
> >> +#include <linux/kprobes.h>
> >> +#include <linux/seq_file.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/smp.h>
> >> +#include <linux/debugfs.h>
> >> +#include <linux/types.h>
> >> +#include <linux/string.h>
> >> +#include <linux/ctype.h>
> >> +#include <linux/ptrace.h>
> >> +
> >> +#include "trace.h"
> >> +#include "trace_output.h"
> >> +
> >> +#define MAX_ARGSTR_LEN 63
> >> +
> >> +/* currently, trace_kprobe only supports X86. */
> >> +
> >> +struct fetch_func {
> >> +	unsigned long (*func)(struct pt_regs *, void *);
> >> +	void *data;
> >> +};
> >> +
> >> +static __kprobes unsigned long call_fetch(struct fetch_func *f,
> >> +					  struct pt_regs *regs)
> >> +{
> >> +	return f->func(regs, f->data);
> >> +}
> >> +
> >> +/* fetch handlers */
> >> +static __kprobes unsigned long fetch_register(struct pt_regs *regs,
> >> +					      void *offset)
> >> +{
> >> +	return regs_get_register(regs, (unsigned)((unsigned long)offset));
> >> +}
> >> +
> >> +static __kprobes unsigned long fetch_stack(struct pt_regs *regs,
> >> +					   void *num)
> >> +{
> >> +	return regs_get_kernel_stack_nth(regs, (unsigned)((unsigned long)num));
> > 
> > 
> > You seem to often use unsigned as an implicit type.
> > Would be better to explicitly use unsigned int.
> 
> Agreed.
> 
> > Anyway, I guess we can merge it in -tip and give it a try.
> 
> Thank you!
> 
> 
> -- 
> Masami Hiramatsu
> 
> Software Engineer
> Hitachi Computer Products (America), Inc.
> Software Solutions Division
> 
> e-mail: mhiramat@redhat.com
> 

