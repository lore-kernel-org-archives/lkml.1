Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab0CAWXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 17:23:48 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:51943 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596Ab0CAWXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 17:23:46 -0500
X-Authority-Analysis: v=1.0 c=1 a=MrHG-AeuP_8A:10 a=7U3hwN5JcxgA:10 a=c3UhvUrGXVP5EW_R0EoA:9 a=LvD_wubONiL-MY8-c0wA:7 a=89T51M3cvj7Zc0EQ472tg0VcIsEA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [GIT PULL] x86/cpu changes for v2.6.34
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1267472522.10871.14.camel@gandalf.stny.rr.com>
References: <20100227150942.GA6394@elte.hu>
	 <alpine.LFD.2.00.1002281205320.27475@localhost.localdomain>
	 <alpine.LFD.2.00.1002281239550.3637@localhost.localdomain>
	 <20100301080058.GA8049@elte.hu> <20100301131701.GA5562@nowhere>
	 <alpine.LFD.2.00.1003010843050.3616@localhost.localdomain>
	 <1267472522.10871.14.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 01 Mar 2010 17:23:43 -0500
Message-ID: <1267482223.10871.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 14:42 -0500, Steven Rostedt wrote:

> As Frederic has said you can use 'ftrace=function_graph' on the kernel
> command line. It will be initialized in early_initcall (which I believe
> is before CPUs are set up. Then add a tracing_off() after the trouble
> code. You can make the trace buffers bigger with the kernel command
> line:
> 
> 	trace_buf_size=10000000
> 
> The above will make the trace buffer 10Meg per CPU. Unlike the
> "buffer_size_kb" file, this number is in bytes, even though it will
> round to the nearest page. (I probably should make this into kb, and
> rename it to trace_buf_size_kb, and deprecate trace_buf_size).
> 
> Then you can cat out /debug/tracing/trace, and search for large
> latencies in the timestamps.

I just tried the above and it doesn't work. The ring buffer gets
allocated with the early_initcall(), so trace_printk()'s will work. But
the function and function graph tracers don't get registered until the
device_initcall().

If you are still interested, this patch will allow you to run the
function graph tracer before smp_init(). You still need to add
"ftrace=function_graph" on the kernel command line.

It's a hack, but I tried it out and it worked.

-- Steve



diff --git a/init/main.c b/init/main.c
index 4cb47a1..b334663 100644
--- a/init/main.c
+++ b/init/main.c
@@ -868,8 +868,15 @@ static int __init kernel_init(void * unused)
 	do_pre_smp_initcalls();
 	start_boot_trace();
 
+	{
+		int init_graph_trace(void);
+		init_graph_trace();
+	}
+	trace_printk("start\n");
 	smp_init();
 	sched_init_smp();
+	trace_printk("end\n");
+	tracing_off();
 
 	do_basic_setup();
 
diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index aaf580c..f18cad8 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -1214,11 +1214,11 @@ static struct tracer graph_trace __read_mostly = {
 #endif
 };
 
-static __init int init_graph_trace(void)
+__init int init_graph_trace(void)
 {
 	max_bytes_for_cpu = snprintf(NULL, 0, "%d", nr_cpu_ids - 1);
 
 	return register_tracer(&graph_trace);
 }
 
-device_initcall(init_graph_trace);
+//device_initcall(init_graph_trace);


