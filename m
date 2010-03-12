Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510Ab0CLTUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 14:20:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44398 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934458Ab0CLTUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 14:20:30 -0500
X-Authority-Analysis: v=1.0 c=1 a=u-VO3dv88eYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=hk975UQl4sdPOx3aeEsA:9 a=QXkWZa2v7etwlgloOekA:7 a=mIoRNMoipa9zwIp3qJyutgj9DbQA:4 a=PUjeQqilurYA:10 a=tLTP3bEmKhLEEvG3:21 a=sQYAOPUkE6vZnQOj:21
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: 2.6.33: ftrace triggers soft lockup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <4B95C2AF.7010508@cn.fujitsu.com>
References: <2375c9f91003022204p5bdab1fdj3b3500998575fc28@mail.gmail.com>
	 <1267710847.10871.102.camel@gandalf.stny.rr.com>
	 <2375c9f91003042014y17588865g8f9110e666ac2456@mail.gmail.com>
	 <2375c9f91003042316g6e774d60n90dfc4784d3b66bf@mail.gmail.com>
	 <1267801603.10871.1725.camel@gandalf.stny.rr.com>
	 <20100305171614.GC5244@nowhere>  <4B94A816.4090608@cn.fujitsu.com>
	 <1268061312.10871.1810.camel@gandalf.stny.rr.com>
	 <4B95AE4E.6060700@cn.fujitsu.com>
	 <1268101394.10871.1861.camel@gandalf.stny.rr.com>
	 <4B95C2AF.7010508@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 12 Mar 2010 14:20:27 -0500
Message-ID: <1268421627.4471.777.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-09 at 11:38 +0800, Li Zefan wrote:

> The segfault is from userspace. This is a segfault I just got:
> 
> ftrace_stack_ma[14989]: segfault at fe2e ip 00000000004474c0 sp 00007fffb97e38c0 error 4 in bash[400000+d1000]

I've spent the last few days hunting this down (and I'm still hunting).
I don't think this is caused by the function graph tracer (I triggered
it once when it was running the wakeup rt test).

One thing that I noticed so far in all my crashes is that there's two
things that seem to always be enabled.

The lock events are enabled, and more importantly, the userstacktrace
option is also enabled.

What I do is when this segfault is triggered, I save off the ring
buffer. I can retrieve the ring buffer later by echoing something into a
file I added called "swap_buffers". Below is the patch if you are
interested.

I already found fixes for the ring buffer reset crash (which I should
probably send out soon). But I've been trying to get my head around this
segfault, with no luck yet.

Oh, also, do you have "rep_good" set on the box you see this with?

$ grep rep_good /proc/cpuinfo

I also want to know the importance of that "fe2e" that it faults at.
Seems to be the address most of the time. I did get a "1" before.

Thanks!

-- Steve

---
 arch/x86/mm/fault.c        |    3 +
 kernel/trace/ring_buffer.c |    5 ++
 kernel/trace/trace.c       |   84 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 91 insertions(+), 1 deletion(-)

Index: linux-trace.git/arch/x86/mm/fault.c
===================================================================
--- linux-trace.git.orig/arch/x86/mm/fault.c	2010-01-28 13:01:31.000000000 -0500
+++ linux-trace.git/arch/x86/mm/fault.c	2010-03-12 14:11:19.000000000 -0500
@@ -676,6 +676,7 @@ no_context(struct pt_regs *regs, unsigne
 	oops_end(flags, regs, sig);
 }
 
+extern void sdr_save_trace(void);
 /*
  * Print out info about fatal segfaults, if the show_unhandled_signals
  * sysctl is set:
@@ -690,6 +691,8 @@ show_signal_msg(struct pt_regs *regs, un
 	if (!printk_ratelimit())
 		return;
 
+	sdr_save_trace();
+
 	printk("%s%s[%d]: segfault at %lx ip %p sp %p error %lx",
 		task_pid_nr(tsk) > 1 ? KERN_INFO : KERN_EMERG,
 		tsk->comm, task_pid_nr(tsk), address,
Index: linux-trace.git/kernel/trace/ring_buffer.c
===================================================================
--- linux-trace.git.orig/kernel/trace/ring_buffer.c	2010-03-09 14:14:06.000000000 -0500
+++ linux-trace.git/kernel/trace/ring_buffer.c	2010-03-11 14:30:45.000000000 -0500
@@ -3404,6 +3404,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu 
  * @buffer: The ring buffer to reset a per cpu buffer of
  * @cpu: The CPU buffer to be reset
  */
+void sdr_save_trace(void);
 void ring_buffer_reset_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
@@ -3416,8 +3417,10 @@ void ring_buffer_reset_cpu(struct ring_b
 
 	spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
 
-	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing)))
+	if (RB_WARN_ON(cpu_buffer, local_read(&cpu_buffer->committing))) {
+		sdr_save_trace();
 		goto out;
+	}
 
 	arch_spin_lock(&cpu_buffer->lock);
 
Index: linux-trace.git/kernel/trace/trace.c
===================================================================
--- linux-trace.git.orig/kernel/trace/trace.c	2010-03-09 09:32:22.000000000 -0500
+++ linux-trace.git/kernel/trace/trace.c	2010-03-12 14:11:19.000000000 -0500
@@ -44,6 +44,8 @@
 
 #define TRACE_BUFFER_FLAGS	(RB_FL_OVERWRITE)
 
+static struct ring_buffer *save_buff;
+
 /*
  * On boot up, the ring buffer is set to the minimum size, so that
  * we do not waste memory on systems that are not using tracing.
@@ -2710,6 +2712,8 @@ int tracer_init(struct tracer *t, struct
 	return t->init(tr);
 }
 
+static int saved;
+
 static int tracing_resize_ring_buffer(unsigned long size)
 {
 	int ret;
@@ -2752,11 +2756,82 @@ static int tracing_resize_ring_buffer(un
 		return ret;
 	}
 
+	if (!saved)
+		ring_buffer_resize(save_buff, size);
+
 	global_trace.entries = size;
 
 	return ret;
 }
 
+static arch_spinlock_t save_buf_lock =
+	(arch_spinlock_t)__ARCH_SPIN_LOCK_UNLOCKED;
+
+void sdr_save_trace(void)
+{
+	struct ring_buffer *buff;
+
+	arch_spin_lock(&save_buf_lock);
+	if (saved)
+		goto out;
+	trace_printk("DIED HERE (%s)\n", current_trace->name);
+	buff = global_trace.buffer;
+	global_trace.buffer = save_buff;
+	save_buff = buff;
+	tracing_off();
+	saved = 1;
+	dump_stack();
+	printk("buffer entries=%ld\n", ring_buffer_entries(save_buff));
+ out:
+	arch_spin_unlock(&save_buf_lock);
+}
+
+static void swap_buffers(void)
+{
+	struct ring_buffer *buff;
+
+	arch_spin_lock(&save_buf_lock);
+	printk("buffer entries=%ld\n", ring_buffer_entries(save_buff));
+	buff = global_trace.buffer;
+	global_trace.buffer = save_buff;
+	save_buff = buff;
+	arch_spin_unlock(&save_buf_lock);
+}
+
+
+static ssize_t
+tracing_swap_write(struct file *filp, const char __user *ubuf,
+		   size_t cnt, loff_t *ppos)
+{
+	swap_buffers();
+
+	saved = 0;
+
+	*ppos += cnt;
+
+	return cnt;
+}
+
+static ssize_t
+tracing_swap_read(struct file *filp, char __user *ubuf,
+		  size_t cnt, loff_t *ppos)
+{
+	char buf[64];
+	int r;
+
+	r = snprintf(buf, sizeof(buf), "%d\n", saved);
+	if (r > sizeof(buf))
+		r = sizeof(buf);
+	return simple_read_from_buffer(ubuf, cnt, ppos, buf, r);
+}
+
+static const struct file_operations tracing_swap_fops = {
+	.open		= tracing_open_generic,
+	.read		= tracing_swap_read,
+	.write		= tracing_swap_write,
+};
+
+
 /**
  * tracing_update_buffers - used by tracing facility to expand ring buffers
  *
@@ -4228,6 +4303,9 @@ static __init int tracer_init_debugfs(vo
 
 	d_tracer = tracing_init_dentry();
 
+	trace_create_file("swap_buffers", 0644, d_tracer,
+			&global_trace, &tracing_swap_fops);
+
 	trace_create_file("tracing_enabled", 0644, d_tracer,
 			&global_trace, &tracing_ctrl_fops);
 
@@ -4469,6 +4547,12 @@ __init static int tracer_alloc_buffers(v
 	cpumask_copy(tracing_buffer_mask, cpu_possible_mask);
 	cpumask_copy(tracing_cpumask, cpu_all_mask);
 
+	save_buff = ring_buffer_alloc(ring_buf_size, TRACE_BUFFER_FLAGS);
+	if (!save_buff) {
+		printk(KERN_ERR "failed to allocate!\n");
+		goto out_free_buffer_mask;
+	}
+
 	/* TODO: make the number of buffers hot pluggable with CPUS */
 	global_trace.buffer = ring_buffer_alloc(ring_buf_size,
 						   TRACE_BUFFER_FLAGS);


