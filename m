Return-Path: <linux-kernel-owner+w=401wt.eu-S1760914AbZATRDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760914AbZATRDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:03:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756685AbZATRDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:03:21 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55469 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbZATRDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:03:20 -0500
Date: Tue, 20 Jan 2009 12:03:17 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arnaldo Carvalho de Melo <acme@redhat.com>
cc: Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHv2] ftrace interface for blktrace
In-Reply-To: <20090120144219.GH690@ghostprotocols.net>
Message-ID: <alpine.DEB.1.10.0901201007060.2681@gandalf.stny.rr.com>
References: <20090116181611.GE6562@ghostprotocols.net> <20090117190913.GA17722@elte.hu> <20090117191430.GA30821@kernel.dk> <20090117200804.GJ6562@ghostprotocols.net> <20090120144219.GH690@ghostprotocols.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 20 Jan 2009, Arnaldo Carvalho de Melo wrote:
> 
> Setup debugfs/tracing environment:
> 
> $ mkdir /d
> $ mount -t debugfs none /d
> $ ln -s /d/tracing /t

OK, now you are just making fun of me ;-)

> 
> Now enable tracing on the desired device, setting up filters if needed:
> 
> $ echo 1 > /sys/block/sda/sda1/trace/enable
> 
> root@f10-1 ~]# head /t/trace
> # tracer: blk
> #
>             bash-955   [000]   565.025000:   8,1    A WBS 3932975 + 8 <- (8,1) 3932912
>             bash-955   [000]   565.025000:   8,1    Q   R 3932975 + 8 [<idle>]
>             bash-955   [000]   565.025000:   8,1    G  RB 3932975 + 8 [<idle>]
>             bash-955   [000]   565.025000:   8,1    P  NS [<idle>]
>             bash-955   [000]   565.025000:   8,1    I RBS 3932975 + 8 [<idle>]
>             bash-955   [000]   565.025000:   8,1    U  WS [<idle>] 1
>             bash-955   [000]   565.025000:   8,1    D  WB 3932975 + 8 [<idle>]
>           <idle>-0     [000]   565.044000:   8,1    C  RS 3932975 + 8 [0]
> [root@f10-1 ~]#
> 
> This is the standardized format used in the sched_switch, sched_wakeup and
> other tracers.
> 
> This is done by adding a tracer option, that starts disabled, named
> "blk_classic", using this construct:
> 
> /* Select an alternative, minimalistic output than the original one */
> #define TRACE_BLK_OPT_CLASSIC   0x1
> 
> static struct tracer_opt blk_tracer_opts[] = {
>         /* Default disable the minimalistic output */
>         { TRACER_OPT(blk_classic, TRACE_BLK_OPT_CLASSIC ) },
>         { }
> };
> 
> static struct tracer_flags blk_tracer_flags = {
>         .val  = 0,
>         .opts = blk_tracer_opts,
> };
> 
> With this disabled the ->print_line in our struct tracer always returns
> TRACE_TYPE_UNHANDLED, leaving to the struct trace_event ->trace routine to
> pretty print it if the entry in the ring buffer is of type TRACE_BLK, that
> we register now in init_blk_tracer by using register_ftrace_event.
> 
> I did this because I want, at least while this patch is being considered by
> Jens and the other blktrace developers, to both to have the classic format,
> activated by:
> 
> [root@f10-1 ~]# echo blk_classic > /t/trace_options 
> [root@f10-1 ~]# cat /t/trace_options 
> print-parent nosym-offset nosym-addr noverbose noraw nohex nobin noblock nostacktrace nosched-tree ftrace_printk noftrace_preempt nobranch annotate nouserstacktrace nosym-userobj noprintk-msg-only blk_classic
> 
> So that we use struct trace -> print_line and have full control of what is
> formatted:
> 
> [root@f10-1 ~]# tail /t/trace
>   8,1    0   289.469000  1054  D  WB 526039 + 8 [ls]
>   8,1    0   289.470000     0  C  RS 526039 + 8 [1751]
>   8,1    0   289.470000  1054  A WBS 266439 + 8 <- (8,1) 266376
>   8,1    0   289.470000  1054  Q   R 266439 + 8 [ls]
>   8,1    0   289.470000  1054  G  RB 266439 + 8 [ls]
>   8,1    0   289.470000  1054  P  NS [ls]
>   8,1    0   289.470000  1054  I RBS 266439 + 8 [ls]
>   8,1    0   289.470000  1054  U  WS [ls] 1
>   8,1    0   289.470000  1054  D  WB 266439 + 8 [ls]
>   8,1    0   289.470000     0  C  RS 266439 + 8 [4295]
> [root@f10-1 ~]# 
> 
> Now back to non_classic mode...
> 
> # echo noblk_classic > /t/trace_options
> 
> ... where we can mix trace events by doing...
> 
> # echo stacktrace > /t/trace_options
> 
> ... and get something interesting:
> 
> [root@f10-1 ~]# tail /t/trace
>               ls-1060  [000]   431.697000:   8,1    A WBS 12320847 + 8 <- (8,1) 12320784
>               ls-1060  [000]   431.697000: 
>  <= submit_bio
>  <= submit_bh
>  <= __ext3_get_inode_loc
>  <= ext3_iget
>  <= ext3_lookup
>  <= do_lookup
>  <= __link_path_walk
>               ls-1060  [000]   431.697000:   8,1    Q   R 12320847 + 8 [ls]
>               ls-1060  [000]   431.697000: 
>  <= generic_make_request
>  <= submit_bio
>  <= submit_bh
>  <= __ext3_get_inode_loc
>  <= ext3_iget
>  <= ext3_lookup
>  <= do_lookup
>               ls-1060  [000]   431.697000:   8,1    G  RB 12320847 + 8 [ls]
>               ls-1060  [000]   431.697000: 
>  <= get_request
>  <= get_request_wait
>  <= __make_request
>  <= generic_make_request
>  <= submit_bio
>  <= submit_bh
>  <= __ext3_get_inode_loc
>               ls-1060  [000]   431.697000:   8,1    P  NS [ls]
>               ls-1060  [000]   431.697000: 
>  <= __make_request
>  <= generic_make_request
>  <= submit_bio
>  <= submit_bh
>  <= __ext3_get_inode_loc
>  <= ext3_iget
>  <= ext3_lookup
>               ls-1060  [000]   431.697000:   8,1    I RBS 12320847 + 8 [ls]
>               ls-1060  [000]   431.697000: 
>  <= elv_insert
>  <= __elv_add_request
>  <= __make_request
>  <= generic_make_request
>  <= submit_bio
>  <= submit_bh
>  <= __ext3_get_inode_loc
> <SNIP>
> 
> Now lets disable stacktraces:
> 
> # echo nostacktrace > /t/trace_options
> 
> And try doing things a bit more verbosely, using the TRACE_ITER_VERBOSE
> that were already part of the existing ftrace infrastructure.
> 
> # echo verbose > /t/trace_options
> # cat /t/trace_pipe 
>               ls-1065  [000]   694.325000:   8,1   remap WBS 3670207 + 8 <- (8,1) 3670144
>               ls-1065  [000]   694.325000:   8,1   queue   R 3670207 + 8 [ls]
>               ls-1065  [000]   694.325000:   8,1   getrq  RB 3670207 + 8 [ls]
>               ls-1065  [000]   694.325000:   8,1   plug  NS [ls]
>               ls-1065  [000]   694.325000:   8,1   insert RBS 3670207 + 8 [ls]
>               ls-1065  [000]   694.325000:   8,1   unplug_io  WS [ls] 1
>               ls-1065  [000]   694.325000:   8,1   issue  WB 3670207 + 8 [ls]
>           <idle>-0     [000]   694.343000:   8,1   complete  RS 3670207 + 8 [191]
> 
> Hint: look at the action (insert, unplug_io, issue, etc).
> 
> We can make it a bit more verbose using this iter flag, the above is
> just a suggestion on using the standard flags interface.
> 
> Frederic, for now I'm using t->action as the "sub-type" we discussed.
> 
> Now that we have noblk_classic mode we can actually look at the struct
> trace_event->binary() way of doing things + the
> don't-print-anything-just-call-me->binary() flag and then we could
> synthesize the old blktrace format and simply do:
> 
> cat /t/trace_pipe | blkparse -i -
> 
> As a test to check that everything is as the old blktrace(8) codebase
> expects.
> 
> Jens, there are several fields in struct blk_io_trace that could go,
> like pid, cpu, timestamp, because they are already in struct
> trace_entry, and sequence, if my understanding of what was discussed
> here is not flawed:
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2008/9/23/3375544
> 
> Patch against yesterday's linux-tip,
> 
> Comments?
> 
> - Arnaldo
> 
> diff --git a/block/blktrace.c b/block/blktrace.c
> index b0a2cae..21116c4 100644
> --- a/block/blktrace.c
> +++ b/block/blktrace.c
> @@ -25,9 +25,27 @@
>  #include <linux/time.h>
>  #include <trace/block.h>
>  #include <asm/uaccess.h>
> +#include <../kernel/trace/trace_output.h>
>  
>  static unsigned int blktrace_seq __read_mostly = 1;
>  
> +static struct trace_array *blk_tr;
> +static int __read_mostly  blk_tracer_enabled;
> +
> +/* Select an alternative, minimalistic output than the original one */
> +#define TRACE_BLK_OPT_CLASSIC 	0x1
> +
> +static struct tracer_opt blk_tracer_opts[] = {
> +	/* Default disable the minimalistic output */
> +	{ TRACER_OPT(blk_classic, TRACE_BLK_OPT_CLASSIC ) },
> +	{ }
> +};
> +
> +static struct tracer_flags blk_tracer_flags = {
> +	.val  = 0,
> +	.opts = blk_tracer_opts,
> +};
> +
>  /* Global reference count of probes */
>  static DEFINE_MUTEX(blk_probe_mutex);
>  static atomic_t blk_probes_ref = ATOMIC_INIT(0);
> @@ -43,6 +61,9 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
>  {
>  	struct blk_io_trace *t;
>  
> +	if (!bt->rchan)
> +		return;
> +
>  	t = relay_reserve(bt->rchan, sizeof(*t) + len);
>  	if (t) {
>  		const int cpu = smp_processor_id();
> @@ -90,6 +111,9 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
>  	unsigned long flags;
>  	char *buf;
>  
> +	if (!bt->msg_data)
> +		return;
> +
>  	local_irq_save(flags);
>  	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
>  	va_start(args, fmt);
> @@ -131,13 +155,14 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  		     int rw, u32 what, int error, int pdu_len, void *pdu_data)
>  {
>  	struct task_struct *tsk = current;
> +	struct ring_buffer_event *event = NULL;
>  	struct blk_io_trace *t;
>  	unsigned long flags;
>  	unsigned long *sequence;
>  	pid_t pid;
> -	int cpu;
> +	int cpu, pc = 0;
>  
> -	if (unlikely(bt->trace_state != Blktrace_running))
> +	if (unlikely(bt->trace_state != Blktrace_running || !blk_tracer_enabled))
>  		return;
>  
>  	what |= ddir_act[rw & WRITE];
> @@ -150,6 +175,24 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  	pid = tsk->pid;
>  	if (unlikely(act_log_check(bt, what, sector, pid)))
>  		return;
> +	cpu = raw_smp_processor_id();
> +
> +	if (blk_tr) {
> +		struct trace_entry *ent;
> +		tracing_record_cmdline(current);
> +
> +		event = ring_buffer_lock_reserve(blk_tr->buffer,
> +						 sizeof(*t) + pdu_len, &flags);
> +		if (!event)
> +			return;
> +		
> +		ent = ring_buffer_event_data(event);
> +		t = (struct blk_io_trace *)ent;
> +		pc = preempt_count();
> +		tracing_generic_entry_update(ent, 0, pc);
> +		ent->type = TRACE_BLK;
> +		goto record_it;
> +	}
>  
>  	/*
>  	 * A word about the locking here - we disable interrupts to reserve
> @@ -163,23 +206,33 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  
>  	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);

Do we still use relay?

-- Steve

>  	if (t) {
> -		cpu = smp_processor_id();
>  		sequence = per_cpu_ptr(bt->sequence, cpu);
>  
>  		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
>  		t->sequence = ++(*sequence);
>  		t->time = ktime_to_ns(ktime_get());
> +		t->cpu = cpu;
> +		t->pid = pid;
> +record_it:
>  		t->sector = sector;
>  		t->bytes = bytes;
>  		t->action = what;
> -		t->pid = pid;
>  		t->device = bt->dev;
> -		t->cpu = cpu;
>  		t->error = error;
>  		t->pdu_len = pdu_len;
>  
>  		if (pdu_len)
>  			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
> +
> +		if (blk_tr) {
> +			ring_buffer_unlock_commit(blk_tr->buffer, event, flags);
> +			if (pid != 0 &&
> +			    (blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC) == 0 &&
> +			    (trace_flags & TRACE_ITER_STACKTRACE) != 0)
> +				__trace_stack(blk_tr, NULL, flags, 5, pc);
> +			trace_wake_up();
> +			return;
> +		}
>  	}
>  
>  	local_irq_restore(flags);
> @@ -888,3 +941,584 @@ static void blk_unregister_tracepoints(void)
>  
>  	tracepoint_synchronize_unregister();
>  }
