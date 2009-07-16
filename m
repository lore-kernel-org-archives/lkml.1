Return-Path: <linux-kernel-owner+w=401wt.eu-S932663AbZGPPzq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932663AbZGPPzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 11:55:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932652AbZGPPzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 11:55:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58236 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932621AbZGPPz0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 11:55:26 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip -v12 11/11] tracing: Add kprobes event profiling interface
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>
Date: Thu, 16 Jul 2009 11:57:59 -0400
Message-ID: <20090716155759.6266.74017.stgit@localhost.localdomain>
In-Reply-To: <20090716155652.6266.39970.stgit@localhost.localdomain>
References: <20090716155652.6266.39970.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add profiling interaces for each kprobes event.

Changes from v11:
 - Fix a typo and remove redundant check.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---

 Documentation/trace/kprobetrace.txt |    8 ++++++
 kernel/trace/trace_kprobe.c         |   45 +++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/kprobetrace.txt b/Documentation/trace/kprobetrace.txt
index 437ad49..9c6be05 100644
--- a/Documentation/trace/kprobetrace.txt
+++ b/Documentation/trace/kprobetrace.txt
@@ -69,6 +69,14 @@ filter:
  names and field names for describing filters.
 
 
+Event Profiling
+---------------
+ You can check the total number of probe hits and probe miss-hits via
+/sys/kernel/debug/tracing/kprobe_profile.
+ The first column is event name, the second is the number of probe hits,
+the third is the number of probe miss-hits.
+
+
 Usage examples
 --------------
 To add a probe as a new event, write a new definition to kprobe_events
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 3444d1d..21e619f 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -178,6 +178,7 @@ struct trace_probe {
 		struct kprobe		kp;
 		struct kretprobe	rp;
 	};
+	unsigned long 		nhits;
 	const char		*symbol;	/* symbol name */
 	struct ftrace_event_call	call;
 	unsigned int		nr_args;
@@ -766,6 +767,39 @@ static const struct file_operations kprobe_events_ops = {
 	.write		= probes_write,
 };
 
+/* Probes profiling interfaces */
+static int profile_seq_show(struct seq_file *m, void *v)
+{
+	struct trace_probe *tp = v;
+
+	seq_printf(m, "%s", tp->call.name);
+
+	seq_printf(m, "\t%8lu %8lu\n", tp->nhits,
+		   probe_is_return(tp) ? tp->rp.kp.nmissed : tp->kp.nmissed);
+
+	return 0;
+}
+
+static const struct seq_operations profile_seq_op = {
+	.start  = probes_seq_start,
+	.next   = probes_seq_next,
+	.stop   = probes_seq_stop,
+	.show   = profile_seq_show
+};
+
+static int profile_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &profile_seq_op);
+}
+
+static const struct file_operations kprobe_profile_ops = {
+	.owner          = THIS_MODULE,
+	.open           = profile_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = seq_release,
+};
+
 /* Kprobe handler */
 static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 {
@@ -776,6 +810,8 @@ static __kprobes int kprobe_trace_func(struct kprobe *kp, struct pt_regs *regs)
 	unsigned long irq_flags;
 	struct ftrace_event_call *call = &tp->call;
 
+	tp->nhits++;
+
 	local_save_flags(irq_flags);
 	pc = preempt_count();
 
@@ -1152,9 +1188,18 @@ static __init int init_kprobe_trace(void)
 	entry = debugfs_create_file("kprobe_events", 0644, d_tracer,
 				    NULL, &kprobe_events_ops);
 
+	/* Event list interface */
 	if (!entry)
 		pr_warning("Could not create debugfs "
 			   "'kprobe_events' entry\n");
+
+	/* Profile interface */
+	entry = debugfs_create_file("kprobe_profile", 0444, d_tracer,
+				    NULL, &kprobe_profile_ops);
+
+	if (!entry)
+		pr_warning("Could not create debugfs "
+			   "'kprobe_profile' entry\n");
 	return 0;
 }
 fs_initcall(init_kprobe_trace);


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
