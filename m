Return-Path: <linux-kernel-owner+w=401wt.eu-S1760280AbZATOmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760280AbZATOmx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 09:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbZATOmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 09:42:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56705 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbZATOml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 09:42:41 -0500
Date: Tue, 20 Jan 2009 12:42:19 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: [RFC][PATCHv2] ftrace interface for blktrace
Message-ID: <20090120144219.GH690@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20090116181611.GE6562@ghostprotocols.net> <20090117190913.GA17722@elte.hu> <20090117191430.GA30821@kernel.dk> <20090117200804.GJ6562@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090117200804.GJ6562@ghostprotocols.net>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Jan 17, 2009 at 06:08:04PM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Sat, Jan 17, 2009 at 08:14:30PM +0100, Jens Axboe escreveu:
> > On Sat, Jan 17 2009, Ingo Molnar wrote:
> > > * Arnaldo Carvalho de Melo <acme@redhat.com> wrote:
> > > > Hi Jens,
> > > > 	The patch below adds a ftrace interface for blktrace, allowing 
> > > > people to use it without any required userspace tools, using sysfs to 
> > > > setup the act_mask, pid, start_lba, end_lba.
> > > 
> > > Very nice patch!
> > > 
> > > Jens, i'm wondering what's your take on this direction is. I think the 
> > > consolidation effect is great and the built-in IO tracing capabilities are 
> > > very nice.
> > 
> > I like the current patch, from a quick look. I'll look more soonish
> > (monday). I've always liked the concept of being able to mix various
> > traces into the same stream, since it makes it MUCH easier to see what
> > on earth is going wrong. What I didn't like in the patches Acme did was
> > the enable part, I'll need to look into that. Again, from a quick look,
> > what is the BKL doing in there?!
> 
> I'm just trying to keep locking expectations in the previous, similar
> path, in block/ioctl.c, blkdev_ioctl, where we setup q->blk_trace:
> 
>         case BLKTRACESTART:
>         case BLKTRACESTOP:
>         case BLKTRACESETUP:
>         case BLKTRACETEARDOWN:
>                 lock_kernel();
>                 ret = blk_trace_ioctl(bdev, cmd, (char __user *) arg);
>                 unlock_kernel();
>                 break;
> 
> So I took the safest path and grabbed the big K lock.
>  
> > > We can still get the raw events too and do user-space post-processing, 
> > > when that is desired - so this does not limit anything that blktrace was 
> > > able to do before - it only extends on it.
> > > 
> > > Is there any particular blktrace feature you can think of that is not 
> > > present in the blktrace ftrace plugin?
> > 
> > Can't answer that yet, I'll give it a more thorough look next week.
> 
> Looking forward to that. And will get it split into multiple patches,
> hopefully by monday.

Ok, still as one patch, but with lots of improvements, lets see them
using examples:

Setup debugfs/tracing environment:

$ mkdir /d
$ mount -t debugfs none /d
$ ln -s /d/tracing /t

Now enable tracing on the desired device, setting up filters if needed:

$ echo 1 > /sys/block/sda/sda1/trace/enable

root@f10-1 ~]# head /t/trace
# tracer: blk
#
            bash-955   [000]   565.025000:   8,1    A WBS 3932975 + 8 <- (8,1) 3932912
            bash-955   [000]   565.025000:   8,1    Q   R 3932975 + 8 [<idle>]
            bash-955   [000]   565.025000:   8,1    G  RB 3932975 + 8 [<idle>]
            bash-955   [000]   565.025000:   8,1    P  NS [<idle>]
            bash-955   [000]   565.025000:   8,1    I RBS 3932975 + 8 [<idle>]
            bash-955   [000]   565.025000:   8,1    U  WS [<idle>] 1
            bash-955   [000]   565.025000:   8,1    D  WB 3932975 + 8 [<idle>]
          <idle>-0     [000]   565.044000:   8,1    C  RS 3932975 + 8 [0]
[root@f10-1 ~]#

This is the standardized format used in the sched_switch, sched_wakeup and
other tracers.

This is done by adding a tracer option, that starts disabled, named
"blk_classic", using this construct:

/* Select an alternative, minimalistic output than the original one */
#define TRACE_BLK_OPT_CLASSIC   0x1

static struct tracer_opt blk_tracer_opts[] = {
        /* Default disable the minimalistic output */
        { TRACER_OPT(blk_classic, TRACE_BLK_OPT_CLASSIC ) },
        { }
};

static struct tracer_flags blk_tracer_flags = {
        .val  = 0,
        .opts = blk_tracer_opts,
};

With this disabled the ->print_line in our struct tracer always returns
TRACE_TYPE_UNHANDLED, leaving to the struct trace_event ->trace routine to
pretty print it if the entry in the ring buffer is of type TRACE_BLK, that
we register now in init_blk_tracer by using register_ftrace_event.

I did this because I want, at least while this patch is being considered by
Jens and the other blktrace developers, to both to have the classic format,
activated by:

[root@f10-1 ~]# echo blk_classic > /t/trace_options 
[root@f10-1 ~]# cat /t/trace_options 
print-parent nosym-offset nosym-addr noverbose noraw nohex nobin noblock nostacktrace nosched-tree ftrace_printk noftrace_preempt nobranch annotate nouserstacktrace nosym-userobj noprintk-msg-only blk_classic

So that we use struct trace -> print_line and have full control of what is
formatted:

[root@f10-1 ~]# tail /t/trace
  8,1    0   289.469000  1054  D  WB 526039 + 8 [ls]
  8,1    0   289.470000     0  C  RS 526039 + 8 [1751]
  8,1    0   289.470000  1054  A WBS 266439 + 8 <- (8,1) 266376
  8,1    0   289.470000  1054  Q   R 266439 + 8 [ls]
  8,1    0   289.470000  1054  G  RB 266439 + 8 [ls]
  8,1    0   289.470000  1054  P  NS [ls]
  8,1    0   289.470000  1054  I RBS 266439 + 8 [ls]
  8,1    0   289.470000  1054  U  WS [ls] 1
  8,1    0   289.470000  1054  D  WB 266439 + 8 [ls]
  8,1    0   289.470000     0  C  RS 266439 + 8 [4295]
[root@f10-1 ~]# 

Now back to non_classic mode...

# echo noblk_classic > /t/trace_options

... where we can mix trace events by doing...

# echo stacktrace > /t/trace_options

... and get something interesting:

[root@f10-1 ~]# tail /t/trace
              ls-1060  [000]   431.697000:   8,1    A WBS 12320847 + 8 <- (8,1) 12320784
              ls-1060  [000]   431.697000: 
 <= submit_bio
 <= submit_bh
 <= __ext3_get_inode_loc
 <= ext3_iget
 <= ext3_lookup
 <= do_lookup
 <= __link_path_walk
              ls-1060  [000]   431.697000:   8,1    Q   R 12320847 + 8 [ls]
              ls-1060  [000]   431.697000: 
 <= generic_make_request
 <= submit_bio
 <= submit_bh
 <= __ext3_get_inode_loc
 <= ext3_iget
 <= ext3_lookup
 <= do_lookup
              ls-1060  [000]   431.697000:   8,1    G  RB 12320847 + 8 [ls]
              ls-1060  [000]   431.697000: 
 <= get_request
 <= get_request_wait
 <= __make_request
 <= generic_make_request
 <= submit_bio
 <= submit_bh
 <= __ext3_get_inode_loc
              ls-1060  [000]   431.697000:   8,1    P  NS [ls]
              ls-1060  [000]   431.697000: 
 <= __make_request
 <= generic_make_request
 <= submit_bio
 <= submit_bh
 <= __ext3_get_inode_loc
 <= ext3_iget
 <= ext3_lookup
              ls-1060  [000]   431.697000:   8,1    I RBS 12320847 + 8 [ls]
              ls-1060  [000]   431.697000: 
 <= elv_insert
 <= __elv_add_request
 <= __make_request
 <= generic_make_request
 <= submit_bio
 <= submit_bh
 <= __ext3_get_inode_loc
<SNIP>

Now lets disable stacktraces:

# echo nostacktrace > /t/trace_options

And try doing things a bit more verbosely, using the TRACE_ITER_VERBOSE
that were already part of the existing ftrace infrastructure.

# echo verbose > /t/trace_options
# cat /t/trace_pipe 
              ls-1065  [000]   694.325000:   8,1   remap WBS 3670207 + 8 <- (8,1) 3670144
              ls-1065  [000]   694.325000:   8,1   queue   R 3670207 + 8 [ls]
              ls-1065  [000]   694.325000:   8,1   getrq  RB 3670207 + 8 [ls]
              ls-1065  [000]   694.325000:   8,1   plug  NS [ls]
              ls-1065  [000]   694.325000:   8,1   insert RBS 3670207 + 8 [ls]
              ls-1065  [000]   694.325000:   8,1   unplug_io  WS [ls] 1
              ls-1065  [000]   694.325000:   8,1   issue  WB 3670207 + 8 [ls]
          <idle>-0     [000]   694.343000:   8,1   complete  RS 3670207 + 8 [191]

Hint: look at the action (insert, unplug_io, issue, etc).

We can make it a bit more verbose using this iter flag, the above is
just a suggestion on using the standard flags interface.

Frederic, for now I'm using t->action as the "sub-type" we discussed.

Now that we have noblk_classic mode we can actually look at the struct
trace_event->binary() way of doing things + the
don't-print-anything-just-call-me->binary() flag and then we could
synthesize the old blktrace format and simply do:

cat /t/trace_pipe | blkparse -i -

As a test to check that everything is as the old blktrace(8) codebase
expects.

Jens, there are several fields in struct blk_io_trace that could go,
like pid, cpu, timestamp, because they are already in struct
trace_entry, and sequence, if my understanding of what was discussed
here is not flawed:

http://kerneltrap.org/mailarchive/linux-kernel/2008/9/23/3375544

Patch against yesterday's linux-tip,

Comments?

- Arnaldo

diff --git a/block/blktrace.c b/block/blktrace.c
index b0a2cae..21116c4 100644
--- a/block/blktrace.c
+++ b/block/blktrace.c
@@ -25,9 +25,27 @@
 #include <linux/time.h>
 #include <trace/block.h>
 #include <asm/uaccess.h>
+#include <../kernel/trace/trace_output.h>
 
 static unsigned int blktrace_seq __read_mostly = 1;
 
+static struct trace_array *blk_tr;
+static int __read_mostly  blk_tracer_enabled;
+
+/* Select an alternative, minimalistic output than the original one */
+#define TRACE_BLK_OPT_CLASSIC 	0x1
+
+static struct tracer_opt blk_tracer_opts[] = {
+	/* Default disable the minimalistic output */
+	{ TRACER_OPT(blk_classic, TRACE_BLK_OPT_CLASSIC ) },
+	{ }
+};
+
+static struct tracer_flags blk_tracer_flags = {
+	.val  = 0,
+	.opts = blk_tracer_opts,
+};
+
 /* Global reference count of probes */
 static DEFINE_MUTEX(blk_probe_mutex);
 static atomic_t blk_probes_ref = ATOMIC_INIT(0);
@@ -43,6 +61,9 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
 {
 	struct blk_io_trace *t;
 
+	if (!bt->rchan)
+		return;
+
 	t = relay_reserve(bt->rchan, sizeof(*t) + len);
 	if (t) {
 		const int cpu = smp_processor_id();
@@ -90,6 +111,9 @@ void __trace_note_message(struct blk_trace *bt, const char *fmt, ...)
 	unsigned long flags;
 	char *buf;
 
+	if (!bt->msg_data)
+		return;
+
 	local_irq_save(flags);
 	buf = per_cpu_ptr(bt->msg_data, smp_processor_id());
 	va_start(args, fmt);
@@ -131,13 +155,14 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 		     int rw, u32 what, int error, int pdu_len, void *pdu_data)
 {
 	struct task_struct *tsk = current;
+	struct ring_buffer_event *event = NULL;
 	struct blk_io_trace *t;
 	unsigned long flags;
 	unsigned long *sequence;
 	pid_t pid;
-	int cpu;
+	int cpu, pc = 0;
 
-	if (unlikely(bt->trace_state != Blktrace_running))
+	if (unlikely(bt->trace_state != Blktrace_running || !blk_tracer_enabled))
 		return;
 
 	what |= ddir_act[rw & WRITE];
@@ -150,6 +175,24 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	pid = tsk->pid;
 	if (unlikely(act_log_check(bt, what, sector, pid)))
 		return;
+	cpu = raw_smp_processor_id();
+
+	if (blk_tr) {
+		struct trace_entry *ent;
+		tracing_record_cmdline(current);
+
+		event = ring_buffer_lock_reserve(blk_tr->buffer,
+						 sizeof(*t) + pdu_len, &flags);
+		if (!event)
+			return;
+		
+		ent = ring_buffer_event_data(event);
+		t = (struct blk_io_trace *)ent;
+		pc = preempt_count();
+		tracing_generic_entry_update(ent, 0, pc);
+		ent->type = TRACE_BLK;
+		goto record_it;
+	}
 
 	/*
 	 * A word about the locking here - we disable interrupts to reserve
@@ -163,23 +206,33 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 
 	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
 	if (t) {
-		cpu = smp_processor_id();
 		sequence = per_cpu_ptr(bt->sequence, cpu);
 
 		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
 		t->sequence = ++(*sequence);
 		t->time = ktime_to_ns(ktime_get());
+		t->cpu = cpu;
+		t->pid = pid;
+record_it:
 		t->sector = sector;
 		t->bytes = bytes;
 		t->action = what;
-		t->pid = pid;
 		t->device = bt->dev;
-		t->cpu = cpu;
 		t->error = error;
 		t->pdu_len = pdu_len;
 
 		if (pdu_len)
 			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
+
+		if (blk_tr) {
+			ring_buffer_unlock_commit(blk_tr->buffer, event, flags);
+			if (pid != 0 &&
+			    (blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC) == 0 &&
+			    (trace_flags & TRACE_ITER_STACKTRACE) != 0)
+				__trace_stack(blk_tr, NULL, flags, 5, pc);
+			trace_wake_up();
+			return;
+		}
 	}
 
 	local_irq_restore(flags);
@@ -888,3 +941,584 @@ static void blk_unregister_tracepoints(void)
 
 	tracepoint_synchronize_unregister();
 }
+
+/*
+ * struct blk_io_tracer formatting routines
+ */
+
+static void fill_rwbs(char *rwbs, const struct blk_io_trace *t)
+{
+        int i = 0;
+
+        if (t->action & BLK_TC_DISCARD)	   rwbs[i++] = 'D';
+        else if (t->action & BLK_TC_WRITE) rwbs[i++] = 'W';
+        else if (t->bytes)		   rwbs[i++] = 'R';
+        else				   rwbs[i++] = 'N';
+
+        if (t->action & BLK_TC_AHEAD)	   rwbs[i++] = 'A';
+        if (t->action & BLK_TC_BARRIER)	   rwbs[i++] = 'B';
+        if (t->action & BLK_TC_SYNC)	   rwbs[i++] = 'S';
+        if (t->action & BLK_TC_META)	   rwbs[i++] = 'M';
+
+        rwbs[i] = '\0';
+}
+
+static inline
+const struct blk_io_trace *te_blk_io_trace(const struct trace_entry *ent)
+{
+	return (const struct blk_io_trace *)ent;
+}
+
+static inline const void *pdu_start(const struct trace_entry *ent)
+{
+	return te_blk_io_trace(ent) + 1;
+}
+
+static inline u32 t_sec(const struct trace_entry *ent)
+{
+	return te_blk_io_trace(ent)->bytes >> 9;
+}
+
+static inline unsigned long long t_sector(const struct trace_entry *ent)
+{
+	return te_blk_io_trace(ent)->sector;
+}
+
+static inline __u16 t_error(const struct trace_entry *ent)
+{
+	return te_blk_io_trace(ent)->sector;
+}
+
+static __u64 get_pdu_int(const struct trace_entry *ent)
+{
+	const __u64 *val = pdu_start(ent);
+	return be64_to_cpu(*val);
+}
+
+static void get_pdu_remap(const struct trace_entry *ent,
+			  struct blk_io_trace_remap *r)
+{
+	const struct blk_io_trace_remap *__r = pdu_start(ent);
+	__u64 sector = __r->sector;
+
+	r->device = be32_to_cpu(__r->device);
+	r->device_from = be32_to_cpu(__r->device_from);
+	r->sector = be64_to_cpu(sector);
+}
+
+static int blk_log_action_iter(struct trace_iterator *iter, const char *act)
+{
+	char rwbs[6];
+	unsigned long long ts  = ns2usecs(iter->ts);
+	unsigned long usec_rem = do_div(ts, USEC_PER_SEC);
+	unsigned secs	       = (unsigned long)ts;
+	const struct trace_entry *ent = iter->ent;
+	const struct blk_io_trace *t = (const struct blk_io_trace *)ent;
+
+	fill_rwbs(rwbs, t);
+
+	return trace_seq_printf(&iter->seq,
+				"%3d,%-3d %2d %5d.%06lu %5u %2s %3s ",
+				MAJOR(t->device), MINOR(t->device), iter->cpu,
+				secs, usec_rem, ent->pid, act, rwbs);
+}
+
+static int blk_log_action_seq(struct trace_seq *s, const struct blk_io_trace *t,
+			      const char *act)
+{
+	char rwbs[6];
+	fill_rwbs(rwbs, t);
+	return trace_seq_printf(s, "%3d,%-3d %2s %3s ",
+				MAJOR(t->device), MINOR(t->device), act, rwbs);
+}
+
+static int blk_log_generic(struct trace_seq *s, const struct trace_entry *ent)
+{
+	const char *cmd = trace_find_cmdline(ent->pid);
+
+	if (t_sec(ent))
+		return trace_seq_printf(s, "%llu + %u [%s]\n",
+					t_sector(ent), t_sec(ent), cmd);
+	return trace_seq_printf(s, "[%s]\n", cmd);
+}
+
+static int blk_log_with_error(struct trace_seq *s, const struct trace_entry *ent)
+{
+	if (t_sec(ent))
+		return trace_seq_printf(s, "%llu + %u [%d]\n", t_sector(ent),
+					t_sec(ent), t_error(ent));
+	return trace_seq_printf(s, "%llu [%d]\n", t_sector(ent), t_error(ent));
+}
+
+static int blk_log_remap(struct trace_seq *s, const struct trace_entry *ent)
+{
+	struct blk_io_trace_remap r = { .device = 0, };
+
+	get_pdu_remap(ent, &r);
+	return trace_seq_printf(s, "%llu + %u <- (%d,%d) %llu\n",
+			       t_sector(ent),
+			       t_sec(ent), MAJOR(r.device), MINOR(r.device),
+			       (unsigned long long)r.sector);
+}
+
+static int blk_log_plug(struct trace_seq *s, const struct trace_entry *ent)
+{
+	return trace_seq_printf(s, "[%s]\n", trace_find_cmdline(ent->pid));
+}
+
+static int blk_log_unplug(struct trace_seq *s, const struct trace_entry *ent)
+{
+	return trace_seq_printf(s, "[%s] %llu\n", trace_find_cmdline(ent->pid),
+				get_pdu_int(ent));
+}
+
+static int blk_log_split(struct trace_seq *s, const struct trace_entry *ent)
+{
+	return trace_seq_printf(s, "%llu / %llu [%s]\n", t_sector(ent),
+				get_pdu_int(ent), trace_find_cmdline(ent->pid));
+}
+
+/*
+ * struct tracer operations
+ */
+
+static void blk_tracer_print_header(struct seq_file *m)
+{
+	if (!(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
+		return;
+	seq_puts(m, "# DEV   CPU TIMESTAMP     PID ACT FLG\n"
+		    "#  |     |     |           |   |   |\n");
+}
+
+static void blk_tracer_start(struct trace_array *tr)
+{
+	int cpu;
+
+	tr->time_start = ftrace_now(tr->cpu);
+
+	for_each_online_cpu(cpu)
+		tracing_reset(tr, cpu);
+
+	mutex_lock(&blk_probe_mutex);
+	if (atomic_add_return(1, &blk_probes_ref) == 1)
+		if (blk_register_tracepoints())
+			atomic_dec(&blk_probes_ref);
+	mutex_unlock(&blk_probe_mutex);
+}
+
+static int blk_tracer_init(struct trace_array *tr)
+{
+	blk_tr = tr;
+	blk_tracer_start(tr);
+	mutex_lock(&blk_probe_mutex);
+	blk_tracer_enabled++;
+	mutex_unlock(&blk_probe_mutex);
+	return 0;
+}
+
+static void blk_tracer_stop(struct trace_array *tr)
+{
+	mutex_lock(&blk_probe_mutex);
+	if (atomic_dec_and_test(&blk_probes_ref))
+		blk_unregister_tracepoints();
+	mutex_unlock(&blk_probe_mutex);
+}
+
+static void blk_tracer_reset(struct trace_array *tr)
+{
+	if (!atomic_read(&blk_probes_ref))
+		return;
+
+	mutex_lock(&blk_probe_mutex);
+	blk_tracer_enabled--;
+	WARN_ON(blk_tracer_enabled < 0);
+	mutex_unlock(&blk_probe_mutex);
+
+	blk_tracer_stop(tr);
+}
+
+static struct {
+	const char *act[2];
+	int 	   (*print)(struct trace_seq *s, const struct trace_entry *ent);
+} what2act[] __read_mostly = {
+	[__BLK_TA_QUEUE]	= {{  "Q", "queue" }, 	   blk_log_generic },
+	[__BLK_TA_BACKMERGE]	= {{  "M", "backmerge" },  blk_log_generic },
+	[__BLK_TA_FRONTMERGE]	= {{  "F", "frontmerge" }, blk_log_generic },
+	[__BLK_TA_GETRQ]	= {{  "G", "getrq" },	   blk_log_generic },
+	[__BLK_TA_SLEEPRQ]	= {{  "S", "sleeprq" },	   blk_log_generic },
+	[__BLK_TA_REQUEUE]	= {{  "R", "requeue" },	   blk_log_with_error },
+	[__BLK_TA_ISSUE]	= {{  "D", "issue" },	   blk_log_generic },
+	[__BLK_TA_COMPLETE]	= {{  "C", "complete" },   blk_log_with_error },
+	[__BLK_TA_PLUG]		= {{  "P", "plug" },	   blk_log_plug },
+	[__BLK_TA_UNPLUG_IO]	= {{  "U", "unplug_io" },  blk_log_unplug },
+	[__BLK_TA_UNPLUG_TIMER]	= {{ "UT", "unplug_timer" }, blk_log_unplug },
+	[__BLK_TA_INSERT]	= {{  "I", "insert" },	   blk_log_generic },
+	[__BLK_TA_SPLIT]	= {{  "X", "split" },	   blk_log_split },
+	[__BLK_TA_BOUNCE]	= {{  "B", "bounce" },	   blk_log_generic },
+	[__BLK_TA_REMAP]	= {{  "A", "remap" },	   blk_log_remap },
+};
+
+static int blk_trace_event_print(struct trace_seq *s, struct trace_entry *ent,
+				 int flags)
+{
+	const struct blk_io_trace *t = (struct blk_io_trace *)ent;
+	const u16 what = t->action & ((1 << BLK_TC_SHIFT) - 1);
+	int ret;
+
+	if (unlikely(what == 0 || what > ARRAY_SIZE(what2act)))
+		ret = trace_seq_printf(s, "Bad pc action %x\n", what);
+	else {
+		const bool long_act = !!(trace_flags & TRACE_ITER_VERBOSE);
+		ret = blk_log_action_seq(s, t, what2act[what].act[long_act]);
+		if (ret)
+			ret = what2act[what].print(s, ent);
+	}
+
+	return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+}
+
+static enum print_line_t blk_tracer_print_line(struct trace_iterator *iter)
+{
+	const struct blk_io_trace *t;
+	u16 what;
+	int ret;
+
+	if (!(blk_tracer_flags.val & TRACE_BLK_OPT_CLASSIC))
+		return TRACE_TYPE_UNHANDLED;
+
+	t = (const struct blk_io_trace *)iter->ent;
+	what = t->action & ((1 << BLK_TC_SHIFT) - 1);
+
+	if (unlikely(what == 0 || what > ARRAY_SIZE(what2act)))
+		ret = trace_seq_printf(&iter->seq, "Bad pc action %x\n", what);
+	else {
+		const bool long_act = !!(trace_flags & TRACE_ITER_VERBOSE);
+		ret = blk_log_action_iter(iter, what2act[what].act[long_act]);
+		if (ret)
+			ret = what2act[what].print(&iter->seq, iter->ent);
+	}
+
+	return ret ? TRACE_TYPE_HANDLED : TRACE_TYPE_PARTIAL_LINE;
+}
+
+static struct tracer blk_tracer __read_mostly = {
+	.name		= "blk",
+	.init		= blk_tracer_init,
+	.reset		= blk_tracer_reset,
+	.start		= blk_tracer_start,
+	.stop		= blk_tracer_stop,
+	.print_header	= blk_tracer_print_header,
+	.print_line	= blk_tracer_print_line,
+	.flags		= &blk_tracer_flags,
+};
+
+static struct trace_event trace_blk_event = {
+	.type	 	= TRACE_BLK,
+	.trace		= blk_trace_event_print,
+	.latency_trace	= blk_trace_event_print,
+	.raw		= trace_nop_print,
+	.hex		= trace_nop_print,
+	.binary		= trace_nop_print,
+};
+
+static int __init init_blk_tracer(void)
+{
+	if (!register_ftrace_event(&trace_blk_event)) {
+		pr_warning("Warning: could not register block events\n");
+		return 1;
+	}
+
+	if (register_tracer(&blk_tracer) != 0) {
+		pr_warning("Warning: could not register the block tracer\n");
+		unregister_ftrace_event(&trace_blk_event);
+		return 1;
+	}
+
+	return 0;
+}
+
+device_initcall(init_blk_tracer);
+
+static int blk_trace_remove_queue(struct request_queue *q)
+{
+	struct blk_trace *bt;
+
+	bt = xchg(&q->blk_trace, NULL);
+	if (bt == NULL)
+		return -EINVAL;
+
+	kfree(bt);
+	return 0;
+}
+
+/*
+ * Setup everything required to start tracing
+ */
+static int blk_trace_setup_queue(struct request_queue *q, dev_t dev)
+{
+	struct blk_trace *old_bt, *bt = NULL;
+	int ret;
+
+	ret = -ENOMEM;
+	bt = kzalloc(sizeof(*bt), GFP_KERNEL);
+	if (!bt)
+		goto err;
+
+	bt->dev = dev;
+	bt->act_mask = (u16)-1;
+	bt->end_lba = -1ULL;
+	bt->trace_state = Blktrace_running;
+
+	old_bt = xchg(&q->blk_trace, bt);
+	if (old_bt != NULL) {
+		(void)xchg(&q->blk_trace, old_bt);
+		kfree(bt);
+		ret = -EBUSY;
+	}
+	return 0;
+err:
+	return ret;
+}
+
+/*
+ * sysfs interface to enable and configure tracing
+ */
+
+static ssize_t sysfs_blk_trace_enable_show(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	struct block_device *bdev;
+	ssize_t ret = -ENXIO;
+
+	lock_kernel();
+	bdev = bdget(part_devt(p));
+	if (bdev != NULL) {
+		struct request_queue *q = bdev_get_queue(bdev);
+
+		if (q != NULL) {
+			mutex_lock(&bdev->bd_mutex);
+			ret = sprintf(buf, "%u\n", !!q->blk_trace);
+			mutex_unlock(&bdev->bd_mutex);
+		}
+
+		bdput(bdev);
+	}
+
+	unlock_kernel();
+	return ret;
+}
+
+static ssize_t sysfs_blk_trace_enable_store(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	struct block_device *bdev;
+	struct request_queue *q;
+	struct hd_struct *p;
+	int value;
+	ssize_t ret = -ENXIO;
+
+	if (count == 0 || sscanf(buf, "%d", &value) != 1)
+		goto out;
+
+	lock_kernel();
+	p = dev_to_part(dev);
+	bdev = bdget(part_devt(p));
+	if (bdev == NULL)
+		goto out_unlock_kernel;
+
+	q = bdev_get_queue(bdev);
+	if (q == NULL)
+		goto out_bdput;
+
+	mutex_lock(&bdev->bd_mutex);
+	if (value)
+		ret = blk_trace_setup_queue(q, bdev->bd_dev);
+	else
+		ret = blk_trace_remove_queue(q);
+	mutex_unlock(&bdev->bd_mutex);
+
+	if (ret == 0)
+		ret = count;
+out_bdput:
+	bdput(bdev);
+out_unlock_kernel:
+	unlock_kernel();
+out:
+	return ret;
+}
+
+static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf);
+static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count);
+#define BLK_TRACE_DEVICE_ATTR(_name) \
+	DEVICE_ATTR(_name, S_IRUGO | S_IWUSR, \
+		    sysfs_blk_trace_attr_show, \
+		    sysfs_blk_trace_attr_store)
+
+static DEVICE_ATTR(enable, S_IRUGO | S_IWUSR,
+		   sysfs_blk_trace_enable_show, sysfs_blk_trace_enable_store);
+static BLK_TRACE_DEVICE_ATTR(act_mask);
+static BLK_TRACE_DEVICE_ATTR(pid);
+static BLK_TRACE_DEVICE_ATTR(start_lba);
+static BLK_TRACE_DEVICE_ATTR(end_lba);
+
+static struct attribute *blk_trace_attrs[] = {
+	&dev_attr_enable.attr,
+	&dev_attr_act_mask.attr,
+	&dev_attr_pid.attr,
+	&dev_attr_start_lba.attr,
+	&dev_attr_end_lba.attr,
+	NULL
+};
+
+struct attribute_group blk_trace_attr_group = {
+	.name  = "trace",
+	.attrs = blk_trace_attrs,
+};
+
+static int blk_str2act_mask(const char *str)
+{
+	int mask = 0;
+	char *copy = kstrdup(str, GFP_KERNEL), *s;
+
+	if (copy == NULL)
+		return -ENOMEM;
+
+	s = strstrip(copy);
+
+	while (1) {
+		char *sep = strchr(s, ',');
+
+		if (sep != NULL)
+			*sep = '\0';
+
+		if (strcasecmp(s, "barrier") == 0)
+			mask |= BLK_TC_BARRIER;
+		else if (strcasecmp(s, "complete") == 0)
+			mask |= BLK_TC_COMPLETE;
+		else if (strcasecmp(s, "fs") == 0)
+			mask |= BLK_TC_FS;
+		else if (strcasecmp(s, "issue") == 0)
+			mask |= BLK_TC_ISSUE;
+		else if (strcasecmp(s, "pc") == 0)
+			mask |= BLK_TC_PC;
+		else if (strcasecmp(s, "queue") == 0)
+			mask |= BLK_TC_QUEUE;
+		else if (strcasecmp(s, "read") == 0)
+			mask |= BLK_TC_READ;
+		else if (strcasecmp(s, "requeue") == 0)
+			mask |= BLK_TC_REQUEUE;
+		else if (strcasecmp(s, "sync") == 0)
+			mask |= BLK_TC_SYNC;
+		else if (strcasecmp(s, "write") == 0)
+			mask |= BLK_TC_WRITE;
+
+		if (sep == NULL)
+			break;
+
+		s = sep + 1;
+	}
+	kfree(copy);
+
+	return mask;
+}
+
+static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct hd_struct *p = dev_to_part(dev);
+	struct request_queue *q;
+	struct block_device *bdev;
+	ssize_t ret = -ENXIO;
+
+	lock_kernel();
+	bdev = bdget(part_devt(p));
+	if (bdev == NULL)
+		goto out_unlock_kernel;
+
+	q = bdev_get_queue(bdev);
+	if (q == NULL)
+		goto out_bdput;
+	mutex_lock(&bdev->bd_mutex);
+	if (q->blk_trace == NULL)
+		ret = sprintf(buf, "disabled\n");
+	else if (attr == &dev_attr_act_mask)
+		ret = sprintf(buf, "%#x\n", q->blk_trace->act_mask);
+	else if (attr == &dev_attr_pid)
+		ret = sprintf(buf, "%u\n", q->blk_trace->pid);
+	else if (attr == &dev_attr_start_lba)
+		ret = sprintf(buf, "%llu\n", q->blk_trace->start_lba);
+	else if (attr == &dev_attr_end_lba)
+		ret = sprintf(buf, "%llu\n", q->blk_trace->end_lba);
+	mutex_unlock(&bdev->bd_mutex);
+out_bdput:
+	bdput(bdev);
+out_unlock_kernel:
+	unlock_kernel();
+	return ret;
+}
+
+static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t count)
+{
+	struct block_device *bdev;
+	struct request_queue *q;
+	struct hd_struct *p;
+	u64 value;
+	ssize_t ret = -ENXIO;
+
+	if (count == 0)
+		goto out;
+
+	if (attr == &dev_attr_act_mask) {
+		if (sscanf(buf, "%llx", &value) != 1) {
+			/* Assume it is a list of trace category names */
+			value = blk_str2act_mask(buf);
+			if (value < 0)
+				goto out;
+		}
+	} else if (sscanf(buf, "%llu", &value) != 1)
+		goto out;
+
+	lock_kernel();
+	p = dev_to_part(dev);
+	bdev = bdget(part_devt(p));
+	if (bdev == NULL)
+		goto out_unlock_kernel;
+
+	q = bdev_get_queue(bdev);
+	if (q == NULL)
+		goto out_bdput;
+
+	mutex_lock(&bdev->bd_mutex);
+	ret = 0;
+	if (q->blk_trace == NULL)
+		ret = blk_trace_setup_queue(q, bdev->bd_dev);
+
+	if (ret == 0) {
+		if (attr == &dev_attr_act_mask)
+			q->blk_trace->act_mask = value;
+		else if (attr == &dev_attr_pid)
+			q->blk_trace->pid = value;
+		else if (attr == &dev_attr_start_lba)
+			q->blk_trace->start_lba = value;
+		else if (attr == &dev_attr_end_lba)
+			q->blk_trace->end_lba = value;
+		ret = count;
+	}
+	mutex_unlock(&bdev->bd_mutex);
+out_bdput:
+	bdput(bdev);
+out_unlock_kernel:
+	unlock_kernel();
+out:
+	return ret;
+}
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index 6d72024..01714ef 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -268,6 +268,10 @@ ssize_t part_fail_store(struct device *dev,
 }
 #endif
 
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+extern struct attribute_group blk_trace_attr_group;
+#endif
+
 static DEVICE_ATTR(partition, S_IRUGO, part_partition_show, NULL);
 static DEVICE_ATTR(start, S_IRUGO, part_start_show, NULL);
 static DEVICE_ATTR(size, S_IRUGO, part_size_show, NULL);
@@ -294,6 +298,9 @@ static struct attribute_group part_attr_group = {
 
 static struct attribute_group *part_attr_groups[] = {
 	&part_attr_group,
+#ifdef CONFIG_BLK_DEV_IO_TRACE
+	&blk_trace_attr_group,
+#endif
 	NULL
 };
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 54b7278..0d6e314 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -32,6 +32,7 @@ enum trace_type {
 	TRACE_KMEM_ALLOC,
 	TRACE_KMEM_FREE,
 	TRACE_POWER,
+	TRACE_BLK,
 
 	__TRACE_LAST_TYPE,
 };
