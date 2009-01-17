Return-Path: <linux-kernel-owner+w=401wt.eu-S1760686AbZASNYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686AbZASNYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 08:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759318AbZASNYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 08:24:31 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58950 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758413AbZASNY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 08:24:27 -0500
Date: Sat, 17 Jan 2009 18:22:48 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] ftrace interface for blktrace
Message-ID: <20090117202247.GK6562@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
References: <20090116181611.GE6562@ghostprotocols.net> <20090117133737.GA8413@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117133737.GA8413@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 17, 2009 at 02:37:39PM +0100, Frederic Weisbecker escreveu:
> On Fri, Jan 16, 2009 at 04:16:11PM -0200, Arnaldo Carvalho de Melo wrote:
> > Hi Jens,
> > 
> > 	The patch below adds a ftrace interface for blktrace, allowing
> > people to use it without any required userspace tools, using sysfs to setup the
> > act_mask, pid, start_lba, end_lba.
> > 	Example usage:
> > 
> > [root@f10-1 ~]# mount -t debugfs none /sys/kernel/debug/
> > [root@f10-1 ~]# ls /sys/block/sda/sda1/trace/
> > act_mask  enable  end_lba  pid  start_lba
> 
> 
> That reminds me it would be good to provide a more powerful tracer options
> Api, to set numeric or string values for the options, like the kernel
> parameters..... So you would avoid to implement your own way to do it.
> I should put my hands into it one day.

I thought about that as well, and did a very quick (as in almost didn't)
look at other places in the kernel for list of strings to bitmap
facilities, but couldn't find after some 5 or 10 seconds :-)
 
> > [root@f10-1 ~]# cat /sys/kernel/debug/tracing/available_tracers 
> > blk function_graph wakeup function sched_switch nop
> > [root@f10-1 ~]# echo blk > /sys/kernel/debug/tracing/current_tracer 
> > [root@f10-1 ~]# cat /sys/kernel/debug/tracing/trace
> > # tracer: blk
> > #
> > # DEV   CPU TIMESTAMP     PID ACT FLG
> > #  |     |     |           |   |   |
> > [root@f10-1 ~]# echo 1 > /sys/block/sda/sda1/trace/enable 
> > [root@f10-1 ~]# tail /sys/kernel/debug/tracing/trace
> >   8,1    0   143.070085  1208  P  NS [tail]
> >   8,1    0   143.070087  1208  I RBS 4154375 + 8 [tail]
> >   8,1    0   143.070091  1208  A WBS 4155391 + 16 <- (8,1) 4155328
> >   8,1    0   143.070091  1208  Q   R 4155391 + 16 [tail]
> >   8,1    0   143.070094  1208  G  RB 4155391 + 16 [tail]
> >   8,1    0   143.070094  1208  I RBS 4155391 + 16 [tail]
> >   8,1    0   143.070097  1208  U  WS [tail] 2
> >   8,1    0   143.070101  1208  D  WB 4154375 + 8 [tail]
> >   8,1    0   143.070341  1208  D  WB 4155391 + 16 [tail]
> >   8,1    0   143.070635     0  C  RS 4154375 + 8 [0]
> 
> 
> nice!

echo verbose > /d/tracing/iter_ctrl

will, in the next patchset, convert those one (or two) action (ACT)
codes into something more intelligible for the block layer impaired :)
 
> 
> > [root@f10-1 ~]#
> > 
> > 	Filters can be set using:
> > 
> > [root@f10-1 ~]# echo write,sync > /sys/block/sda/sda1/trace/act_mask 
> > [root@f10-1 ~]# cat /sys/block/sda/sda1/trace/act_mask 
> > 0xa
> 
> That would be better to see the thing as a string, like you set it.

Agreed, will do, was just impatient enough to get the patch posted after
too much context switching over last week
 
> > 	One can go on interactively adding more filters, for instance:
> > 
> > [root@f10-1 ~]# echo `pidof kjournald` > /sys/block/sda/sda1/trace/pid
> > [root@f10-1 ~]# cat /sys/block/sda/sda1/trace/pid
> > 423
> 
> 
> Or why not simply kjournald? :-)

Unsure, perhaps

kjournald(423)

if iter_ctrl has "verbose"?
 
> 
> > 	And use the existing ftrace infrastructure to, for instance,
> > replicate the btrace (blktrace -o - | blkparse) functionality by simply
> > using cat:
> > 
> > [root@f10-1 ~]# cat /sys/kernel/debug/tracing/trace_pipe 
> >   8,1    0   457.253356   423  A WBS 6335 + 8 <- (8,1) 6272
> >   8,1    0   457.253360   423  Q   R 6335 + 8 [kjournald]
> >   8,1    0   457.253367   423  G  RB 6335 + 8 [kjournald]
> >   8,1    0   457.253372   423  I RBS 6335 + 8 [kjournald]
> >   8,1    0   457.253376   423  A WBS 6343 + 8 <- (8,1) 6280
> >   8,1    0   457.253376   423  Q   R 6343 + 8 [kjournald]
> >   8,1    0   457.253378   423  M   W 6343 + 8 [kjournald]
> >   8,1    0   457.253380   423  A WBS 6351 + 8 <- (8,1) 6288
> > CONTROL+C
> > [root@f10-1 ~]#
> > 
> > 	This patch was done on Linus tree, I'll now work with it on
> > linux-tip so that I can experiment with binary tracing, i.e to ask for
> > the output of /sys/kernel/debug/tracing/trace_pipe to be raw, exactly
> > the one provide by relayfs based variant, so that we will be able to
> > continue using blkparse to validate the trace entries, as a debugging
> > aid.
> 
> 
> But I guess there will be some changes to bring on the tracing to make
> it support binary flow...

I have to do some checking, but probably there will still be interest in
having the kernel to do as little as possible for high volume tracing
and let the, in this case, already existing raw post processing tools to
do the pretty-printing in userspace.
 
> > 	Also there are other interesting things that one gets from using
> > the ftrace infrastructure, such as being able to set see traffic that
> > happens in just a cpuset (/sys/kernel/debug/tracing/tracing_cpumask),
> > and others that I plan to add such as what Steve did in "[PATCH 2/2]
> > ftrace: add stack trace to function tracer", so that we could have
> > things like (made up example):
> > 
> > [root@f10-1 ~]# cat /sys/kernel/debug/tracing/trace_pipe 
> >   8,1    0   457.253356   423  A WBS 6335 + 8 <- (8,1) 6272
> >   8,1    0   457.253360   423  Q   R 6335 + 8 [kjournald]
> >   8,1    0   457.253367   423  G  RB 6335 + 8 [kjournald]
> >   8,1    0   457.253372   423  I RBS 6335 + 8 [kjournald]
> >  <= sync_buffer
> >  <= __wait_on_bit
> >  <= out_of_line_wait_on_bit
> >  <= __wait_on_buffer
> >  <= sync_dirty_buffer
> >  <= journal_commit_transaction
> >  <= kjournald
> >   8,1    0   457.253376   423  A WBS 6343 + 8 <- (8,1) 6280
> >   8,1    0   457.253376   423  Q   R 6343 + 8 [kjournald]
> >   8,1    0   457.253378   423  M   W 6343 + 8 [kjournald]
> >   8,1    0   457.253380   423  A WBS 6351 + 8 <- (8,1) 6288
> 
> 
> Cool, but I guess you will not need this ftrace plugin to do it.
> stack traces entries for tracing are already supported for a while.

Pardon my ignorance, but how could one combine blk + stack_trace without
any kind of support in the blk tracer? Of course I even _expect_ that
this be possible without much ado, but I haven't got to that
enlightenment yet :-)
 
> > 	More polishing is needed, I wrote the patch this way just to
> > show where things are different, with new code, for registering the
> > tracer, bits stolen from the userspace blktrace, allowing config via
> > sysfs at the bottom.
> > 
> > 	Ideally we would move this to kernel/trace/block.c, break it
> > into smaller self contained patches, etc.
> > 
> > Comments?
> > 
> > - Arnaldo
> > 
> >  block/blktrace.c      |  578 +++++++++++++++++++++++++++++++++++++++++++++++++-
> >  fs/partitions/check.c |    7 
> >  2 files changed, 583 insertions(+), 2 deletions(-)
> > 
> > diff --git a/block/blktrace.c b/block/blktrace.c
> > index b0a2cae..10985f9 100644
> > --- a/block/blktrace.c
> > +++ b/block/blktrace.c
> > @@ -25,9 +25,13 @@
> >  #include <linux/time.h>
> >  #include <trace/block.h>
> >  #include <asm/uaccess.h>
> > +#include <../kernel/trace/trace.h>
> 
> 
> Yeah, it really needs to be moved on kernel/trace :-)
> 
> 
> >  static unsigned int blktrace_seq __read_mostly = 1;
> >  
> > +static struct trace_array *blk_tr;
> > +static int __read_mostly  blk_tracer_enabled;
> > +
> >  /* Global reference count of probes */
> >  static DEFINE_MUTEX(blk_probe_mutex);
> >  static atomic_t blk_probes_ref = ATOMIC_INIT(0);
> > @@ -43,6 +47,9 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
> >  {
> >  	struct blk_io_trace *t;
> >  
> > +	if (!bt->rchan)
> > +		return;
> > +
> >  	t = relay_reserve(bt->rchan, sizeof(*t) + len);
> >  	if (t) {
> >  		const int cpu = smp_processor_id();
> > @@ -90,6 +97,9 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
> >  	unsigned long flags;
> >  	char *buf;
> >  
> > +	if (!bt->msg_data)
> > +		return;
> > +
> >  	local_irq_save(flags);
> >  	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
> >  	va_start(args, fmt);
> > @@ -131,13 +141,14 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
> >  		     int rw, u32 what, int error, int pdu_len, void *pdu_data)
> >  {
> >  	struct task_struct *tsk = current;
> > +	struct ring_buffer_event *event = NULL;
> >  	struct blk_io_trace *t;
> >  	unsigned long flags;
> >  	unsigned long *sequence;
> >  	pid_t pid;
> >  	int cpu;
> >  
> > -	if (unlikely(bt->trace_state != Blktrace_running))
> > +	if (unlikely(bt->trace_state != Blktrace_running || !blk_tracer_enabled))
> >  		return;
> >  
> >  	what |= ddir_act[rw & WRITE];
> > @@ -158,6 +169,25 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
> >  	 */
> >  	local_irq_save(flags);
> 
> 
> Is the local_irq_save still needed here? Note that the ring buffer is safe by itself.

Oh well, I didn't even tried to check that, just used a template from
the ctx tracer from some time ago, will recheck that
 
> > +	if (blk_tr) {
> > +		struct trace_array_cpu *data;
> > +
> > +		tracing_record_cmdline(current);
> > +		cpu = raw_smp_processor_id();
> 
> 
> I think you can use smp_processor_id(). There is no risk of tracing recursion here.

another c'n'p mindless oversight
 
> 
> > +		data = blk_tr->data[cpu];
> > +
> > +		if (unlikely(atomic_read(&data->disabled)))
> > +			goto out_local_irq_restore;
> > +
> > +		event = ring_buffer_lock_reserve(blk_tr->buffer,
> > +						 sizeof(*t) + pdu_len, &flags);
> > +		if (!event)
> > +			goto out_local_irq_restore;
> > +		
> > +		t = ring_buffer_event_data(event);
> > +		goto record_it;
> > +	}
> > +
> >  	if (unlikely(tsk->btrace_seq != blktrace_seq))
> >  		trace_note_tsk(bt, tsk);
> >  
> > @@ -169,19 +199,26 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
> >  		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
> >  		t->sequence = ++(*sequence);
> >  		t->time = ktime_to_ns(ktime_get());
> 
> You already have a timestamp for each entry on the ring buffer.

I know that, and please notice that this is only taken if we're using
the old relay based stuff (hint, look at the goto)

> > +		t->cpu = cpu;
> 
> 
> Ditto. But perhaps you can be preempted between the block action and the trace insertion.
> I'm not sure of the context here.. So perhaps you must keep it.

Ditto

> 
> > +record_it:
> >  		t->sector = sector;
> >  		t->bytes = bytes;
> >  		t->action = what;
> >  		t->pid = pid;
> >  		t->device = bt->dev;
> > -		t->cpu = cpu;
> >  		t->error = error;
> >  		t->pdu_len = pdu_len;
> >  
> >  		if (pdu_len)
> >  			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
> > +
> > +		if (blk_tr) {
> > +			ring_buffer_unlock_commit(blk_tr->buffer, event, flags);
> > +			trace_wake_up();
> > +		}
> >  	}
> >  
> > +out_local_irq_restore:
> >  	local_irq_restore(flags);
> >  }
> >  
> > @@ -888,3 +925,540 @@ static void blk_unregister_tracepoints(void)
> >  
> >  	tracepoint_synchronize_unregister();
> >  }
> > +
> > +/*
> > + * struct blk_io_tracer formatting routines
> > + */
> > +
> > +static void fill_rwbs(char *rwbs, struct blk_io_trace *t)
> > +{
> > +        int i = 0;
> > +
> > +        if (t->action & BLK_TC_DISCARD)	   rwbs[i++] = 'D';
> > +        else if (t->action & BLK_TC_WRITE) rwbs[i++] = 'W';
> > +        else if (t->bytes)		   rwbs[i++] = 'R';
> > +        else				   rwbs[i++] = 'N';
> > +
> > +        if (t->action & BLK_TC_AHEAD)	   rwbs[i++] = 'A';
> > +        if (t->action & BLK_TC_BARRIER)	   rwbs[i++] = 'B';
> > +        if (t->action & BLK_TC_SYNC)	   rwbs[i++] = 'S';
> > +        if (t->action & BLK_TC_META)	   rwbs[i++] = 'M';
> > +
> > +        rwbs[i] = '\0';
> > +}
> > +
> > +static inline void *pdu_start(struct blk_io_trace *t)
> > +{
> > +	return t + 1;
> > +}
> > +
> > +static inline u32 t_sec(const struct blk_io_trace *t)
> > +{
> > +	return t->bytes >> 9;
> > +}
> > +
> > +static __u64 get_pdu_int(struct blk_io_trace *t)
> > +{
> > +	__u64 *val = pdu_start(t);
> > +
> > +	return be64_to_cpu(*val);
> > +}
> > +
> > +static void get_pdu_remap(struct blk_io_trace *t, struct blk_io_trace_remap *r)
> > +{
> > +	struct blk_io_trace_remap *__r = pdu_start(t);
> > +	__u64 sector = __r->sector;
> > +
> > +	r->device = be32_to_cpu(__r->device);
> > +	r->device_from = be32_to_cpu(__r->device_from);
> > +	r->sector = be64_to_cpu(sector);
> > +}
> > +
> > +static int blk_log_action(struct trace_iterator *iter, struct blk_io_trace *t,
> > +			  const char *act)
> > +{
> > +	char rwbs[6];
> > +	unsigned long long ts	= ns2usecs(iter->ts);
> > +	unsigned long usec_rem	= do_div(ts, USEC_PER_SEC);
> > +	unsigned secs		= (unsigned long)ts;
> > +
> > +	fill_rwbs(rwbs, t);
> > +	return trace_seq_printf(&iter->seq,
> > +				"%3d,%-3d %2d %5d.%06lu %5u %2s %3s ",
> > +				MAJOR(t->device), MINOR(t->device), iter->cpu,
> > +				secs, usec_rem, t->pid, act, rwbs);
> > +}
> > +
> > +static int blk_log_generic(struct trace_iterator *iter, struct blk_io_trace *t,
> > +			   const char *act)
> > +{
> > +	int ret = blk_log_action(iter, t, act);
> > +	if (ret) {
> > +		const char *cmd = trace_find_cmdline(t->pid);
> > +
> > +		if (t_sec(t))
> > +			ret = trace_seq_printf(&iter->seq, "%llu + %u [%s]\n",
> > +					       (unsigned long long)t->sector,
> > +					       t_sec(t), cmd);
> > +		else
> > +			ret = trace_seq_printf(&iter->seq, "[%s]\n", cmd);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int blk_log_with_err(struct trace_iterator *iter, struct blk_io_trace *t,
> > +			    const char *act)
> > +{
> > +	int ret = blk_log_action(iter, t, act);
> > +	if (ret) {
> > +		if (t_sec(t))
> > +			ret = trace_seq_printf(&iter->seq, "%llu + %u [%d]\n",
> > +					       (unsigned long long)t->sector,
> > +					       t_sec(t), t->error);
> > +		else
> > +			ret = trace_seq_printf(&iter->seq, "%llu [%d]\n",
> > +					       (unsigned long long)t->sector,
> > +					       t->error);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int blk_log_remap(struct trace_iterator *iter, struct blk_io_trace *t)
> > +{
> > +	int ret = blk_log_action(iter, t, "A");
> > +	if (ret) {
> > +		struct blk_io_trace_remap r = { .device = 0, };
> > +
> > +		get_pdu_remap(t, &r);
> > +		t->device = r.device_from;
> > +		ret = trace_seq_printf(&iter->seq, "%llu + %u <- (%d,%d) %llu\n",
> > +				       (unsigned long long)t->sector,
> > +				       t_sec(t), MAJOR(r.device), MINOR(r.device),
> > +				       (unsigned long long)r.sector);
> > +	}
> > +	return ret;
> > +}
> > +
> > +static int blk_log_plug(struct trace_iterator *iter, struct blk_io_trace *t)
> > +{
> > +	int ret = blk_log_action(iter, t, "P");
> > +	if (ret)
> > +		ret = trace_seq_printf(&iter->seq, "[%s]\n",
> > +				       trace_find_cmdline(t->pid));
> > +	return ret;
> > +}
> > +
> > +static int blk_log_unplug(struct trace_iterator *iter, struct blk_io_trace *t,
> > +			  const char *act)
> > +{
> > +	int ret = blk_log_action(iter, t, act);
> > +	if (ret)
> > +		ret = trace_seq_printf(&iter->seq, "[%s] %u\n",
> > +				       trace_find_cmdline(t->pid),
> > +				       get_pdu_int(t));
> > +	return ret;
> > +}
> > +
> > +static int blk_log_split(struct trace_iterator *iter, struct blk_io_trace *t,
> > +			 const char *act)
> > +{
> > +	int ret = blk_log_action(iter, t, act);
> > +	if (ret)
> > +		ret = trace_seq_printf(&iter->seq, "%llu / %u [%s]\n",
> > +				       (unsigned long long)t->sector,
> > +				       get_pdu_int(t),
> > +				       trace_find_cmdline(t->pid));
> > +	return ret;
> > +}
> > +
> > +/*
> > + * struct tracer operations
> > + */
> > +
> > +static void blk_tracer_print_header(struct seq_file *m)
> > +{
> > +	seq_puts(m, "# DEV   CPU TIMESTAMP     PID ACT FLG\n"
> > +		    "#  |     |     |           |   |   |\n");
> > +}
> > +
> > +static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
> > +{
> > +	struct trace_seq *s = &iter->seq;
> > +	struct blk_io_trace *t = (struct blk_io_trace *)iter->ent;
> > +	const u16 what = t->action & ((1 << BLK_TC_SHIFT) - 1);
> > +	int ret;
> > +
> > +	switch (what) {
> > +	case __BLK_TA_ISSUE:	    ret = blk_log_generic(iter, t, "D"); break;
> > +	case __BLK_TA_INSERT:	    ret = blk_log_generic(iter, t, "I"); break;
> > +	case __BLK_TA_QUEUE:	    ret = blk_log_generic(iter, t, "Q"); break;
> > +	case __BLK_TA_BOUNCE:	    ret = blk_log_generic(iter, t, "B"); break;
> > +	case __BLK_TA_BACKMERGE:    ret = blk_log_generic(iter, t, "M"); break;
> > +	case __BLK_TA_FRONTMERGE:   ret = blk_log_generic(iter, t, "F"); break;
> > +	case __BLK_TA_GETRQ:	    ret = blk_log_generic(iter, t, "G"); break;
> > +	case __BLK_TA_SLEEPRQ:	    ret = blk_log_generic(iter, t, "S"); break;
> > +	case __BLK_TA_REQUEUE:	    ret = blk_log_with_err(iter, t, "R"); break;
> > +	case __BLK_TA_COMPLETE:	    ret = blk_log_with_err(iter, t, "C"); break;
> > +	case __BLK_TA_PLUG:	    ret = blk_log_plug(iter, t); break;
> > +	case __BLK_TA_UNPLUG_IO:    ret = blk_log_unplug(iter, t, "U"); break;
> > +	case __BLK_TA_UNPLUG_TIMER: ret = blk_log_unplug(iter, t, "UT"); break;
> > +	case __BLK_TA_REMAP:	    ret = blk_log_remap(iter, t); break;
> > +	case __BLK_TA_SPLIT:	    ret = blk_log_split(iter, t, "X"); break;
> > +	default:
> > +		ret = trace_seq_printf(s, "Bad pc action %x\n", what);
> > +		break;
> > +	}
> > +
> > +	if (ret == 0)
> > +		return TRACE_TYPE_PARTIAL_LINE;
> > +
> > +	return TRACE_TYPE_HANDLED;
> > +}
> > +
> > +static void blk_tracer_start(struct trace_array *tr)
> > +{
> > +	int cpu;
> > +
> > +	tr->time_start = ftrace_now(tr->cpu);
> > +
> > +	for_each_online_cpu(cpu)
> > +		tracing_reset(tr, cpu);
> > +
> > +	mutex_lock(&blk_probe_mutex);
> > +	if (atomic_add_return(1, &blk_probes_ref) == 1)
> > +		if (blk_register_tracepoints())
> > +			atomic_dec(&blk_probes_ref);
> > +	mutex_unlock(&blk_probe_mutex);
> 
> 
> Is this mutex really needed? You already use an atomic test that make
> your wall.
> 
> 
> > +}
> > +
> > +static int blk_tracer_init(struct trace_array *tr)
> > +{
> > +	blk_tr = tr;
> > +	blk_tracer_start(tr);
> > +	mutex_lock(&blk_probe_mutex);
> > +	blk_tracer_enabled++;
> 
> 
> I think you will not have more than one blk_tracer_init() call
> while your tracer is enabled.
> 
> So, unless there are other callsites that use your tracer, I guess this counter
> is useless.

Groan... I'll have to think about this and go over the other tracers as well...
 
> > +	mutex_unlock(&blk_probe_mutex);
> > +	return 0;
> > +}
> > +
> > +static void blk_tracer_stop(struct trace_array *tr)
> > +{
> > +	mutex_lock(&blk_probe_mutex);
> > +	if (atomic_dec_and_test(&blk_probes_ref))
> > +		blk_unregister_tracepoints();
> > +	mutex_unlock(&blk_probe_mutex);
> > +}
> > +
> > +static void blk_tracer_reset(struct trace_array *tr)
> > +{
> > +	if (!atomic_read(&blk_probes_ref))
> > +		return;
> > +
> > +	mutex_lock(&blk_probe_mutex);
> > +	blk_tracer_enabled--;
> > +	WARN_ON(blk_tracer_enabled < 0);
> 
> 
> Ditto, I don't think that can happen.
> 
> 
> > +	mutex_unlock(&blk_probe_mutex);
> > +
> > +	blk_tracer_stop(tr);
> > +}
> > +
> > +static struct tracer blk_tracer __read_mostly = {
> > +	.name		= "blk",
> > +	.init		= blk_tracer_init,
> > +	.reset		= blk_tracer_reset,
> > +	.start		= blk_tracer_start,
> > +	.stop		= blk_tracer_stop,
> > +	.print_header	= blk_tracer_print_header,
> > +	.print_line	= blk_tracer_print_line,
> > +};
> > +
> > +static int __init init_blk_tracer(void)
> > +{
> > +	return register_tracer(&blk_tracer);
> > +}
> > +
> > +device_initcall(init_blk_tracer);
> > +
> > +static int blk_trace_remove_queue(struct request_queue *q)
> > +{
> > +	struct blk_trace *bt;
> > +
> > +	bt = xchg(&q->blk_trace, NULL);
> > +	if (bt == NULL)
> > +		return -EINVAL;
> > +
> > +	kfree(bt);
> > +	return 0;
> > +}
> > +
> > +/*
> > + * Setup everything required to start tracing
> > + */
> > +static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
> > +{
> > +	struct blk_trace *old_bt, *bt = NULL;
> > +	int ret;
> > +
> > +	ret = -ENOMEM;
> > +	bt = kzalloc(sizeof(*bt), GFP_KERNEL);
> > +	if (!bt)
> > +		goto err;
> > +
> > +	bt->dev = dev;
> > +	bt->act_mask = (u16)-1;
> 
> That looks strange on a first view.
> Why not ~0 ? But that doesn't really matter...
> 
> > +	bt->end_lba = -1ULL;
> > +	bt->trace_state = Blktrace_running;
> > +
> > +	old_bt = xchg(&q->blk_trace, bt);
> > +	if (old_bt != NULL) {
> > +		(void)xchg(&q->blk_trace, old_bt);
> > +		kfree(bt)
> > +		ret = -EBUSY;
> > +	}
> > +	return 0;
> > +err:
> > +	return ret;
> > +}
> > +
> > +/*
> > + * sysfs interface to enable and configure tracing
> > + */
> > +
> > +static ssize_t sysfs_blk_trace_enable_show(struct device *dev,
> > +					   struct device_attribute *attr,
> > +					   char *buf)
> > +{
> > +	struct hd_struct *p = dev_to_part(dev);
> > +	struct block_device *bdev;
> > +	ssize_t ret = -ENXIO;
> > +
> > +	lock_kernel();
> 
> Ouch, I hope you will add a comment to explain why you are using the bkl
> here, I guess this is block related but I'm not sure of anything :-)

Look at my response to Jens, and more importantly, to whatever answers
he provides for my questions there :-)

> > +	bdev = bdget(part_devt(p));
> > +	if (bdev != NULL) {
> > +		struct request_queue *q = bdev_get_queue(bdev);
> > +
> > +		if (q != NULL) {
> > +			mutex_lock(&bdev->bd_mutex);
> > +			ret = sprintf(buf, "%u\n", !!q->blk_trace);
> 
> I guess you can be a bit racy here and drop the mutex. That wouldn't matter.
> 
> > +			mutex_unlock(&bdev->bd_mutex);
> > +		}
> > +
> > +		bdput(bdev);
> > +	}
> > +
> > +	unlock_kernel();
> > +	return ret;
> > +}
> > +
> > +static ssize_t sysfs_blk_trace_enable_store(struct device *dev,
> > +					    struct device_attribute *attr,
> > +					    const char *buf, size_t count)
> > +{
> > +	struct block_device *bdev;
> > +	struct request_queue *q;
> > +	struct hd_struct *p;
> > +	int value;
> > +	ssize_t ret = -ENXIO;
> > +
> > +	if (count == 0 || sscanf(buf, "%d", &value) != 1)
> > +		goto out;
> > +
> > +	lock_kernel();
> > +	p = dev_to_part(dev);
> > +	bdev = bdget(part_devt(p));
> > +	if (bdev == NULL)
> > +		goto out_unlock_kernel;
> > +
> > +	q = bdev_get_queue(bdev);
> > +	if (q == NULL)
> > +		goto out_bdput;
> > +
> > +	mutex_lock(&bdev->bd_mutex);
> > +	if (value)
> > +		ret = blk_trace_setup_queue(q, bdev->bd_dev);
> > +	else
> > +		ret = blk_trace_remove_queue(q);
> > +	mutex_unlock(&bdev->bd_mutex);
> > +
> > +	if (ret == 0)
> > +		ret = count;
> > +out_bdput:
> > +	bdput(bdev);
> > +out_unlock_kernel:
> > +	unlock_kernel();
> > +out:
> > +	return ret;
> > +}
> > +
> > +static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
> > +					 struct device_attribute *attr,
> > +					 char *buf);
> > +static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
> > +					  struct device_attribute *attr,
> > +					  const char *buf, size_t count);
> > +#define BLK_TRACE_DEVICE_ATTR(_name) \
> > +	DEVICE_ATTR(_name, S_IRUGO | S_IWUSR, \
> > +		    sysfs_blk_trace_attr_show, \
> > +		    sysfs_blk_trace_attr_store)
> > +
> > +static DEVICE_ATTR(enable, S_IRUGO | S_IWUSR,
> > +		   sysfs_blk_trace_enable_show, sysfs_blk_trace_enable_store);
> > +static BLK_TRACE_DEVICE_ATTR(act_mask);
> > +static BLK_TRACE_DEVICE_ATTR(pid);
> > +static BLK_TRACE_DEVICE_ATTR(start_lba);
> > +static BLK_TRACE_DEVICE_ATTR(end_lba);
> > +
> > +static struct attribute *blk_trace_attrs[] = {
> > +	&dev_attr_enable.attr,
> > +	&dev_attr_act_mask.attr,
> > +	&dev_attr_pid.attr,
> > +	&dev_attr_start_lba.attr,
> > +	&dev_attr_end_lba.attr,
> > +	NULL
> > +};
> > +
> > +struct attribute_group blk_trace_attr_group = {
> > +	.name  = "trace",
> > +	.attrs = blk_trace_attrs,
> > +};
> > +
> > +static int blk_str2act_mask(const char *str)
> > +{
> > +	int mask = 0;
> > +	char *copy = kstrdup(str, GFP_KERNEL), *s;
> > +
> > +	if (copy == NULL)
> > +		return -ENOMEM;
> > +
> > +	s = strstrip(copy);
> > +
> > +	while (1) {
> > +		char *sep = strchr(s, ',');
> > +
> > +		if (sep != NULL)
> > +			*sep = '\0';
> > +
> > +		if (strcasecmp(s, "barrier") == 0)
> > +			mask |= BLK_TC_BARRIER;
> > +		else if (strcasecmp(s, "complete") == 0)
> > +			mask |= BLK_TC_COMPLETE;
> > +		else if (strcasecmp(s, "fs") == 0)
> > +			mask |= BLK_TC_FS;
> > +		else if (strcasecmp(s, "issue") == 0)
> > +			mask |= BLK_TC_ISSUE;
> > +		else if (strcasecmp(s, "pc") == 0)
> > +			mask |= BLK_TC_PC;
> > +		else if (strcasecmp(s, "queue") == 0)
> > +			mask |= BLK_TC_QUEUE;
> > +		else if (strcasecmp(s, "read") == 0)
> > +			mask |= BLK_TC_READ;
> > +		else if (strcasecmp(s, "requeue") == 0)
> > +			mask |= BLK_TC_REQUEUE;
> > +		else if (strcasecmp(s, "sync") == 0)
> > +			mask |= BLK_TC_SYNC;
> > +		else if (strcasecmp(s, "write") == 0)
> > +			mask |= BLK_TC_WRITE;
> > +
> > +		if (sep == NULL)
> > +			break;
> > +
> > +		s = sep + 1;
> > +	}
> > +	kfree(copy);
> > +
> > +	return mask;
> > +}
> > +
> > +static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
> > +					 struct device_attribute *attr,
> > +					 char *buf)
> > +{
> > +	struct hd_struct *p = dev_to_part(dev);
> > +	struct request_queue *q;
> > +	struct block_device *bdev;
> > +	ssize_t ret = -ENXIO;
> > +
> > +	lock_kernel();
> > +	bdev = bdget(part_devt(p));
> > +	if (bdev == NULL)
> > +		goto out_unlock_kernel;
> > +
> > +	q = bdev_get_queue(bdev);
> > +	if (q == NULL)
> > +		goto out_bdput;
> > +	mutex_lock(&bdev->bd_mutex);
> > +	if (q->blk_trace == NULL)
> > +		ret = sprintf(buf, "disabled\n");
> > +	else if (attr == &dev_attr_act_mask)
> > +		ret = sprintf(buf, "%#x\n", q->blk_trace->act_mask);
> > +	else if (attr == &dev_attr_pid)
> > +		ret = sprintf(buf, "%u\n", q->blk_trace->pid);
> > +	else if (attr == &dev_attr_start_lba)
> > +		ret = sprintf(buf, "%llu\n", q->blk_trace->start_lba);
> > +	else if (attr == &dev_attr_end_lba)
> > +		ret = sprintf(buf, "%llu\n", q->blk_trace->end_lba);
> > +	mutex_unlock(&bdev->bd_mutex);
> > +out_bdput:
> > +	bdput(bdev);
> > +out_unlock_kernel:
> > +	unlock_kernel();
> > +	return ret;
> > +}
> > +
> > +static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
> > +					  struct device_attribute *attr,
> > +					  const char *buf, size_t count)
> > +{
> > +	struct block_device *bdev;
> > +	struct request_queue *q;
> > +	struct hd_struct *p;
> > +	u64 value;
> > +	ssize_t ret = -ENXIO;
> > +
> > +	if (count == 0)
> > +		goto out;
> > +
> > +	if (attr == &dev_attr_act_mask) {
> > +		if (sscanf(buf, "%llx", &value) != 1) {
> > +			/* Assume it is a list of trace category names */
> > +			value = blk_str2act_mask(buf);
> > +			if (value < 0)
> > +				goto out;
> > +		}
> > +	} else if (sscanf(buf, "%llu", &value) != 1)
> > +		goto out;
> > +
> > +	lock_kernel();
> > +	p = dev_to_part(dev);
> > +	bdev = bdget(part_devt(p));
> > +	if (bdev == NULL)
> > +		goto out_unlock_kernel;
> > +
> > +	q = bdev_get_queue(bdev);
> > +	if (q == NULL)
> > +		goto out_bdput;
> > +
> > +	mutex_lock(&bdev->bd_mutex);
> > +	ret = 0;
> > +	if (q->blk_trace == NULL)
> > +		ret = blk_trace_setup_queue(q, bdev->bd_dev);
> > +
> > +	if (ret == 0) {
> > +		if (attr == &dev_attr_act_mask)
> > +			q->blk_trace->act_mask = value;
> > +		else if (attr == &dev_attr_pid)
> > +			q->blk_trace->pid = value;
> > +		else if (attr == &dev_attr_start_lba)
> > +			q->blk_trace->start_lba = value;
> > +		else if (attr == &dev_attr_end_lba)
> > +			q->blk_trace->end_lba = value;
> > +		ret = count;
> > +	}
> > +	mutex_unlock(&bdev->bd_mutex);
> > +out_bdput:
> > +	bdput(bdev);
> > +out_unlock_kernel:
> > +	unlock_kernel();
> > +out:
> > +	return ret;
> > +}
> > diff --git a/fs/partitions/check.c b/fs/partitions/check.c
> > index 6d72024..01714ef 100644
> > --- a/fs/partitions/check.c
> > +++ b/fs/partitions/check.c
> > @@ -268,6 +268,10 @@ ssize_t part_fail_store(struct device *dev,
> >  }
> >  #endif
> >  
> > +#ifdef CONFIG_BLK_DEV_IO_TRACE
> > +extern struct attribute_group blk_trace_attr_group;
> > +#endif
> > +
> >  static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
> >  static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
> >  static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
> > @@ -294,6 +298,9 @@ static struct attribute_group part_attr_group = {
> >  
> >  static struct attribute_group *part_attr_groups[] = {
> >  	&part_attr_group,
> > +#ifdef CONFIG_BLK_DEV_IO_TRACE
> > +	&blk_trace_attr_group,
> > +#endif
> >  	NULL
> >  };
> 
> 
> 
> This tracer looks good :-)

Thanks!

I hope that by dropping the requirement to a userspace bit (be it big or
small) we can set a record for such kind of tracing infrastructure now
that tracepoints are being proposed left and right.

After all, somebody said that userspace is just a test case for the
kernel, and for things like developer assists...

- Arnaldo
