Return-Path: <linux-kernel-owner+w=401wt.eu-S934036AbZDBJGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036AbZDBJGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758031AbZDBJGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:06:35 -0400
Received: from mail-gx0-f160.google.com ([209.85.217.160]:33646 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755772AbZDBJGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:06:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ckGf6E+anBZyR7OvunithNl0gJRFjyDUGOnk9vCOdSEwVT8Z0ehFbk0KQievIk02+s
         8MJQ3uiOj8g5FyozJsXc+sR9Yb492t3mq06wDZYllMlLcC6fyoZwfO0JWRcbosHtuxDG
         1YX5B0cs4uufsWCMyBf5wRmoD1qYIFTAjdxCw=
Subject: Re: [PATCH 4/4] tracing/filters: use ring_buffer_discard_commit
 for discarded events
From: Tom Zanussi <tzanussi@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090402053522.834546042@goodmis.org>
References: <20090402052721.013878388@goodmis.org>
	 <20090402053522.834546042@goodmis.org>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 04:06:27 -0500
Message-Id: <1238663187.6621.13.camel@bookworm>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

Great to see this!  I updated my filter removal rcu patch, made some
changes to the filter_check_discard() to work with the new
ring_buffer_discard_commit() and made the necessary changes to the
ftrace tracers as well - see the patch below, which has only been
touch-tested at this point.  It seemed to work at first, but then
produced an oops, which may well be a problem related to the changes I
made.  I'll look into it more tomorrow night, and will also fix up this
patch and repost it if it basically looks ok.  I'll post the oops and
the lines of code that it refers to just in case it it rings a bell...

Tom

[  240.461982] ------------[ cut here ]------------
[  240.461993] WARNING: at kernel/trace/ring_buffer.c:1610
ring_buffer_discard_commit+0xfa/0x100()
[  240.462003] Hardware name: Inspiron 1501 
[  240.462009] Modules linked in: aes_x86_64 aes_generic rfkill_input
radeon drm binfmt_misc rfcomm bridge stp bnep sco l2cap bluetooth ppdev
cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_ondemand
freq_table cpufreq_conservative sbs sbshc pci_slot container af_packet
iptable_filter ip_tables x_tables parport_pc lp parport joydev
snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss
snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event arc4 snd_seq ecb snd_timer dcdbas sdhci_pci psmouse
hid_logitech evdev b43 snd_seq_device sdhci mmc_core ricoh_mmc pcspkr
serio_raw k8temp snd rfkill i2c_piix4 mac80211 soundcore snd_page_alloc
cfg80211 led_class i2c_core input_polldev video output wmi battery ac
button shpchp pci_hotplug usbhid hid ext2 mbcache sr_mod cdrom
pata_atiixp pata_acpi sd_mod crc_t10dif sg b44 ehci_hcd mii ohci_hcd
ata_generic ahci ssb usbcore libata scsi_mod thermal processor fan fuse
[  240.462259] Pid: 6143, comm: bash Not tainted 2.6.29-tip #35
[  240.462267] Call Trace:
[  240.462280]  [<ffffffff8025c5c8>] warn_slowpath+0xd8/0x130
[  240.462291]  [<ffffffff802c2be5>] ? rb_reserve_next_event+0x45/0x360
[  240.462304]  [<ffffffff802c6fc1>] ? trace_buffer_lock_reserve
+0x51/0x70
[  240.462316]  [<ffffffff802c12ea>] ? ring_buffer_unlock_commit
+0x5a/0x60
[  240.462329]  [<ffffffff802c2be5>] ? rb_reserve_next_event+0x45/0x360
[  240.462340]  [<ffffffff802c30cb>] ? ring_buffer_lock_reserve
+0x9b/0xe0
[  240.462354]  [<ffffffff8035f42b>] ? dnotify_parent+0xb/0xc0
[  240.462365]  [<ffffffff8032af65>] ? vfs_write+0x155/0x1d0
[  240.462375]  [<ffffffff802c1e2a>] ring_buffer_discard_commit
+0xfa/0x100
[  240.462386]  [<ffffffff8035f42b>] ? dnotify_parent+0xb/0xc0
[  240.462396]  [<ffffffff802c843b>] trace_function+0xab/0xc0
[  240.462406]  [<ffffffff8032af65>] ? vfs_write+0x155/0x1d0
[  240.462416]  [<ffffffff802cc9c6>] function_trace_call+0x86/0xe0
[  240.462429]  [<ffffffff80213056>] ftrace_call+0x5/0x2b
[  240.462439]  [<ffffffff8035f430>] ? dnotify_parent+0x10/0xc0
[  240.462449]  [<ffffffff8032af65>] vfs_write+0x155/0x1d0
[  240.462459]  [<ffffffff8032b9e7>] sys_write+0x57/0xb0
[  240.462469]  [<ffffffff80213372>] system_call_fastpath+0x16/0x1b
[  240.462479] ---[ end trace 94aeeb5f59624105 ]---

  1592 void ring_buffer_discard_commit(struct ring_buffer *buffer,
   1593                                 struct ring_buffer_event *event)
   1594 {
   1595         struct ring_buffer_per_cpu *cpu_buffer;
   1596         unsigned long new_index, old_index;
   1597         struct buffer_page *bpage;
   1598         unsigned long index;
   1599         unsigned long addr;
   1600         int cpu;
   1601 
   1602         /* The event is discarded regardless */
   1603         ring_buffer_event_discard(event);
   1604 
   1605         /*
   1606          * This must only be called if the event has not been
   1607          * committed yet. Thus we can assume that preemption
   1608          * is still disabled.
   1609          */
   1610         RB_WARN_ON(buffer, !preempt_count());


---
 kernel/trace/kmemtrace.c            |   10 +++----
 kernel/trace/trace.c                |   44 ++++++++++++++++++----------------
 kernel/trace/trace.h                |   24 +++++++++++++++----
 kernel/trace/trace_branch.c         |    5 +--
 kernel/trace/trace_events_filter.c  |   15 +++++++----
 kernel/trace/trace_events_stage_3.h |    5 +---
 kernel/trace/trace_hw_branches.c    |    4 +-
 kernel/trace/trace_power.c          |    8 +++---
 8 files changed, 64 insertions(+), 51 deletions(-)

diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
index 4a5f053..2c4c8fd 100644
--- a/kernel/trace/kmemtrace.c
+++ b/kernel/trace/kmemtrace.c
@@ -290,9 +290,8 @@ void kmemtrace_mark_alloc_node(enum kmemtrace_type_id type_id,
 	entry->gfp_flags = gfp_flags;
 	entry->node	=	node;
 
-	filter_check_discard(call, entry, event);
-
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(tr, call, entry, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
 }
 EXPORT_SYMBOL(kmemtrace_mark_alloc_node);
 
@@ -317,9 +316,8 @@ void kmemtrace_mark_free(enum kmemtrace_type_id type_id,
 	entry->call_site = call_site;
 	entry->ptr = ptr;
 
- 	filter_check_discard(call, entry, event);
-
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+ 	if (!filter_check_discard(tr, call, entry, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
 }
 EXPORT_SYMBOL(kmemtrace_mark_free);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index d89489c..9347965 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -169,6 +169,11 @@ ns2usecs(cycle_t nsec)
  */
 static struct trace_array	global_trace;
 
+struct trace_array *get_global_trace(void)
+{
+	return &global_trace;
+}
+
 static DEFINE_PER_CPU(struct trace_array_cpu, global_trace_cpu);
 
 cycle_t ftrace_now(int cpu)
@@ -928,9 +933,8 @@ trace_function(struct trace_array *tr,
 	entry->ip			= ip;
 	entry->parent_ip		= parent_ip;
 
-	filter_check_discard(call, entry, event);
-
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(tr, call, entry, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 }
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -952,8 +956,8 @@ static int __trace_graph_entry(struct trace_array *tr,
 		return 0;
 	entry	= ring_buffer_event_data(event);
 	entry->graph_ent			= *trace;
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(global_trace.buffer, event);
+	if (!filter_check_discard(&global_trace, call, entry, event))
+		ring_buffer_unlock_commit(global_trace.buffer, event);
 
 	return 1;
 }
@@ -976,8 +980,8 @@ static void __trace_graph_return(struct trace_array *tr,
 		return;
 	entry	= ring_buffer_event_data(event);
 	entry->ret				= *trace;
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(global_trace.buffer, event);
+	if (!filter_check_discard(&global_trace, call, entry, event))
+		ring_buffer_unlock_commit(global_trace.buffer, event);
 }
 #endif
 
@@ -1013,8 +1017,8 @@ static void __ftrace_trace_stack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace(&trace);
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(tr, call, entry, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 #endif
 }
 
@@ -1061,8 +1065,8 @@ static void ftrace_trace_userstack(struct trace_array *tr,
 	trace.entries		= entry->caller;
 
 	save_stack_trace_user(&trace);
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(tr, call, entry, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 #endif
 }
 
@@ -1123,9 +1127,8 @@ tracing_sched_switch_trace(struct trace_array *tr,
 	entry->next_state		= next->state;
 	entry->next_cpu	= task_cpu(next);
 
-	filter_check_discard(call, entry, event);
-
-	trace_buffer_unlock_commit(tr, event, flags, pc);
+	if (!filter_check_discard(tr, call, entry, event))
+		trace_buffer_unlock_commit(tr, event, flags, pc);
 }
 
 void
@@ -1151,9 +1154,8 @@ tracing_sched_wakeup_trace(struct trace_array *tr,
 	entry->next_state		= wakee->state;
 	entry->next_cpu			= task_cpu(wakee);
 
-	filter_check_discard(call, entry, event);
-
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(tr, call, entry, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 	ftrace_trace_stack(tr, flags, 6, pc);
 	ftrace_trace_userstack(tr, flags, pc);
 }
@@ -1294,8 +1296,8 @@ int trace_vbprintk(unsigned long ip, const char *fmt, va_list args)
 	entry->fmt			= fmt;
 
 	memcpy(entry->buf, trace_buf, sizeof(u32) * len);
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(tr, call, entry, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
 out_unlock:
 	__raw_spin_unlock(&trace_buf_lock);
@@ -1350,8 +1352,8 @@ int trace_vprintk(unsigned long ip, const char *fmt, va_list args)
 
 	memcpy(&entry->buf, trace_buf, len);
 	entry->buf[len] = 0;
-	filter_check_discard(call, entry, event);
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(tr, call, entry, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
  out_unlock:
 	__raw_spin_unlock(&trace_buf_lock);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2f16866..0c79a49 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -848,17 +848,29 @@ extern int filter_parse(char **pbuf, struct filter_pred *pred);
 extern int filter_add_pred(struct ftrace_event_call *call,
 			   struct filter_pred *pred);
 extern void filter_free_preds(struct ftrace_event_call *call);
-extern int filter_match_preds(struct ftrace_event_call *call, void *rec);
+extern int filter_match_preds(struct filter_pred **preds, void *rec);
 extern void filter_free_subsystem_preds(struct event_subsystem *system);
 extern int filter_add_subsystem_pred(struct event_subsystem *system,
 				     struct filter_pred *pred);
 
-static inline void
-filter_check_discard(struct ftrace_event_call *call, void *rec,
+static inline int
+filter_check_discard(struct trace_array *trace,
+		     struct ftrace_event_call *call,
+		     void *rec,
 		     struct ring_buffer_event *event)
 {
-	if (unlikely(call->preds) && !filter_match_preds(call, rec))
-		ring_buffer_event_discard(event);
+	struct filter_pred **preds;
+	int discarded = 0;
+
+	rcu_read_lock();
+	preds = rcu_dereference(call->preds);
+	if (unlikely(preds) && !filter_match_preds(preds, rec)) {
+		ring_buffer_discard_commit(trace->buffer, event);
+		discarded = 1;
+	}
+	rcu_read_unlock();
+
+	return discarded;
 }
 
 #define __common_field(type, item)					\
@@ -899,6 +911,8 @@ do {									\
 		__trace_printk(ip, fmt, ##args);			\
 } while (0)
 
+extern struct trace_array *get_global_trace(void);
+
 #undef TRACE_EVENT_FORMAT
 #define TRACE_EVENT_FORMAT(call, proto, args, fmt, tstruct, tpfmt)	\
 	extern struct ftrace_event_call event_##call;
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index 25e618a..a36e4d5 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -74,9 +74,8 @@ probe_likely_condition(struct ftrace_branch_data *f, int val, int expect)
 	entry->line = f->line;
 	entry->correct = val == expect;
 
-	filter_check_discard(call, entry, event);
-
-	ring_buffer_unlock_commit(tr->buffer, event);
+	if (!filter_check_discard(tr, call, entry, event))
+		ring_buffer_unlock_commit(tr->buffer, event);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 470ad94..f7f8469 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -83,14 +83,14 @@ static int filter_pred_string(struct filter_pred *pred, void *event)
 }
 
 /* return 1 if event matches, 0 otherwise (discard) */
-int filter_match_preds(struct ftrace_event_call *call, void *rec)
+int filter_match_preds(struct filter_pred **preds, void *rec)
 {
 	int i, matched, and_failed = 0;
 	struct filter_pred *pred;
 
 	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		if (call->preds[i]) {
-			pred = call->preds[i];
+		if (preds[i]) {
+			pred = preds[i];
 			if (and_failed && !pred->or)
 				continue;
 			matched = pred->fn(pred, rec);
@@ -162,13 +162,16 @@ void filter_free_pred(struct filter_pred *pred)
 
 void filter_free_preds(struct ftrace_event_call *call)
 {
+	struct filter_pred **preds;
 	int i;
 
 	if (call->preds) {
+		preds = call->preds;
+		rcu_assign_pointer(call->preds, NULL);
+		synchronize_rcu();
 		for (i = 0; i < MAX_FILTER_PRED; i++)
-			filter_free_pred(call->preds[i]);
-		kfree(call->preds);
-		call->preds = NULL;
+			filter_free_pred(preds[i]);
+		kfree(preds);
 	}
 }
 
diff --git a/kernel/trace/trace_events_stage_3.h b/kernel/trace/trace_events_stage_3.h
index d2f34bf..97a9e1e 100644
--- a/kernel/trace/trace_events_stage_3.h
+++ b/kernel/trace/trace_events_stage_3.h
@@ -222,11 +222,8 @@ static void ftrace_raw_event_##call(proto)				\
 									\
 	assign;								\
 									\
-	if (call->preds && !filter_match_preds(call, entry))		\
-		trace_current_buffer_discard_commit(event);		\
-	else								\
+	if (!filter_check_discard(get_global_trace(), call, entry, event)) \
 		trace_nowake_buffer_unlock_commit(event, irq_flags, pc); \
-									\
 }									\
 									\
 static int ftrace_raw_reg_event_##call(void)				\
diff --git a/kernel/trace/trace_hw_branches.c b/kernel/trace/trace_hw_branches.c
index e6b275b..7ade2f8 100644
--- a/kernel/trace/trace_hw_branches.c
+++ b/kernel/trace/trace_hw_branches.c
@@ -195,8 +195,8 @@ void trace_hw_branch(u64 from, u64 to)
 	entry->ent.type = TRACE_HW_BRANCHES;
 	entry->from = from;
 	entry->to   = to;
-	filter_check_discard(call, entry, event);
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(tr, call, entry, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
 
  out:
 	atomic_dec(&tr->data[cpu]->disabled);
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
index 8ce7d7d..ed506a1 100644
--- a/kernel/trace/trace_power.c
+++ b/kernel/trace/trace_power.c
@@ -55,8 +55,8 @@ static void probe_power_end(struct power_trace *it)
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
-	filter_check_discard(call, entry, event);
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(tr, call, entry, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
 }
@@ -87,8 +87,8 @@ static void probe_power_mark(struct power_trace *it, unsigned int type,
 		goto out;
 	entry	= ring_buffer_event_data(event);
 	entry->state_data = *it;
-	filter_check_discard(call, entry, event);
-	trace_buffer_unlock_commit(tr, event, 0, 0);
+	if (!filter_check_discard(tr, call, entry, event))
+		trace_buffer_unlock_commit(tr, event, 0, 0);
  out:
 	preempt_enable();
 }
-- 
1.5.6.3





