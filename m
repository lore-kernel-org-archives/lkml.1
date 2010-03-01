Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab0CARwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:52:40 -0500
Received: from mail.perches.com ([173.55.12.10]:1237 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab0CARwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:52:37 -0500
Subject: [PATCH] kernel/trace: Use pr_<level> consistently
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 01 Mar 2010 09:52:35 -0800
Message-ID: <1267465955.12641.100.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are existing uses of pr_<level>,
convert the rest of the printks to match.

Except for complete sentences, consistently use no periods at EOM
Coalesce long formats
Add spaces to coalesced formats when words were run together
Add newlines to some messages
Fix message grammar "are failed" and typo "Faild"

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/trace/ftrace.c             |   12 +++----
 kernel/trace/ring_buffer.c        |    9 ++---
 kernel/trace/trace.c              |   21 ++++++-------
 kernel/trace/trace_branch.c       |    9 ++----
 kernel/trace/trace_events.c       |   53 ++++++++++++++-------------------
 kernel/trace/trace_kprobe.c       |   58 +++++++++++++++++-------------------
 kernel/trace/trace_ksym.c         |    6 +--
 kernel/trace/trace_mmiotrace.c    |    2 +-
 kernel/trace/trace_output.c       |    6 ++--
 kernel/trace/trace_sched_switch.c |    9 ++----
 kernel/trace/trace_sched_wakeup.c |   12 ++-----
 kernel/trace/trace_selftest.c     |   53 ++++++++++++++++-----------------
 kernel/trace/trace_stat.c         |    3 +-
 kernel/trace/trace_syscalls.c     |    6 +--
 14 files changed, 114 insertions(+), 145 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 8378357..53d83c1 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -821,8 +821,7 @@ static __init void ftrace_profile_debugfs(struct dentry *d_tracer)
 	entry = debugfs_create_file("function_profile_enabled", 0644,
 				    d_tracer, NULL, &ftrace_profile_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'function_profile_enabled' entry\n");
+		pr_warning("Could not create debugfs 'function_profile_enabled' entry\n");
 }
 
 #else /* CONFIG_FUNCTION_PROFILER */
@@ -960,10 +959,10 @@ static void print_ip_ins(const char *fmt, unsigned char *p)
 {
 	int i;
 
-	printk(KERN_CONT "%s", fmt);
+	pr_cont("%s", fmt);
 
 	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
-		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
+		pr_cont("%s%02x", i ? ":" : "", p[i]);
 }
 
 static void ftrace_bug(int failed, unsigned long ip)
@@ -979,7 +978,7 @@ static void ftrace_bug(int failed, unsigned long ip)
 		pr_info("ftrace failed to modify ");
 		print_ip_sym(ip);
 		print_ip_ins(" actual: ", (unsigned char *)ip);
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 		break;
 	case -EPERM:
 		FTRACE_WARN_ON_ONCE(1);
@@ -3266,8 +3265,7 @@ static int start_graph_tracing(void)
 	if (!ret) {
 		ret = register_trace_sched_switch(ftrace_graph_probe_sched_switch);
 		if (ret)
-			pr_info("ftrace_graph: Couldn't activate tracepoint"
-				" probe to kernel_sched_switch\n");
+			pr_info("ftrace_graph: Couldn't activate tracepoint probe to kernel_sched_switch\n");
 	}
 
 	kfree(ret_stack_list);
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 8c1b2d2..9a32277 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1971,11 +1971,10 @@ rb_add_time_stamp(struct ring_buffer_per_cpu *cpu_buffer,
 	int ret;
 
 	if (unlikely(*delta > (1ULL << 59) && !once++)) {
-		printk(KERN_WARNING "Delta way too big! %llu"
-		       " ts=%llu write stamp = %llu\n",
-		       (unsigned long long)*delta,
-		       (unsigned long long)*ts,
-		       (unsigned long long)cpu_buffer->write_stamp);
+		pr_warning("Delta way too big! %llu ts=%llu write stamp = %llu\n",
+			   (unsigned long long)*delta,
+			   (unsigned long long)*ts,
+			   (unsigned long long)cpu_buffer->write_stamp);
 		WARN_ON(1);
 	}
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 032c57c..669e46f 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -720,8 +720,7 @@ __acquires(kernel_lock)
 	for (t = trace_types; t; t = t->next) {
 		if (strcmp(type->name, t->name) == 0) {
 			/* already found */
-			pr_info("Tracer %s already registered\n",
-				type->name);
+			pr_info("Tracer %s already registered\n", type->name);
 			ret = -1;
 			goto out;
 		}
@@ -759,13 +758,13 @@ __acquires(kernel_lock)
 		/* the test is responsible for resetting too */
 		current_trace = saved_tracer;
 		if (ret) {
-			printk(KERN_CONT "FAILED!\n");
+			pr_cont("FAILED!\n");
 			goto out;
 		}
 		/* Only reset on passing, to avoid touching corrupted buffers */
 		tracing_reset_online_cpus(tr);
 
-		printk(KERN_CONT "PASSED\n");
+		pr_cont("PASSED\n");
 	}
 #endif
 
@@ -782,15 +781,15 @@ __acquires(kernel_lock)
 	if (strncmp(default_bootup_tracer, type->name, MAX_TRACER_SIZE))
 		goto out_unlock;
 
-	printk(KERN_INFO "Starting tracer '%s'\n", type->name);
+	pr_info("Starting tracer '%s'\n", type->name);
 	/* Do we want this tracer to start on bootup? */
 	tracing_set_tracer(type->name);
 	default_bootup_tracer = NULL;
 	/* disable other selftests, since this will break it. */
 	tracing_selftest_disabled = 1;
 #ifdef CONFIG_FTRACE_STARTUP_TEST
-	printk(KERN_INFO "Disabling FTRACE selftests due to running tracer '%s'\n",
-	       type->name);
+	pr_info("Disabling FTRACE selftests due to running tracer '%s'\n",
+		type->name);
 #endif
 
  out_unlock:
@@ -4472,7 +4471,7 @@ __init static int tracer_alloc_buffers(void)
 	global_trace.buffer = ring_buffer_alloc(ring_buf_size,
 						   TRACE_BUFFER_FLAGS);
 	if (!global_trace.buffer) {
-		printk(KERN_ERR "tracer: failed to allocate ring buffer!\n");
+		pr_err("tracer: failed to allocate ring buffer!\n");
 		WARN_ON(1);
 		goto out_free_cpumask;
 	}
@@ -4483,7 +4482,7 @@ __init static int tracer_alloc_buffers(void)
 	max_tr.buffer = ring_buffer_alloc(ring_buf_size,
 					     TRACE_BUFFER_FLAGS);
 	if (!max_tr.buffer) {
-		printk(KERN_ERR "tracer: failed to allocate max ring buffer!\n");
+		pr_err("tracer: failed to allocate max ring buffer!\n");
 		WARN_ON(1);
 		ring_buffer_free(global_trace.buffer);
 		goto out_free_cpumask;
@@ -4535,8 +4534,8 @@ __init static int clear_boot_tracer(void)
 	if (!default_bootup_tracer)
 		return 0;
 
-	printk(KERN_INFO "ftrace bootup tracer '%s' not registered.\n",
-	       default_bootup_tracer);
+	pr_info("ftrace bootup tracer '%s' not registered\n",
+		default_bootup_tracer);
 	default_bootup_tracer = NULL;
 
 	return 0;
diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
index b9bc4d4..5a01f27 100644
--- a/kernel/trace/trace_branch.c
+++ b/kernel/trace/trace_branch.c
@@ -189,8 +189,7 @@ __init static int init_branch_tracer(void)
 
 	ret = register_ftrace_event(&trace_branch_event);
 	if (!ret) {
-		printk(KERN_WARNING "Warning: could not register "
-				    "branch events\n");
+		pr_warning("Warning: could not register branch events\n");
 		return 1;
 	}
 	return register_tracer(&branch_trace);
@@ -341,8 +340,7 @@ __init static int init_annotated_branch_stats(void)
 
 	ret = register_stat_tracer(&annotated_branch_stats);
 	if (!ret) {
-		printk(KERN_WARNING "Warning: could not register "
-				    "annotated branches stats\n");
+		pr_warning("Warning: could not register annotated branches stats\n");
 		return 1;
 	}
 	return 0;
@@ -397,8 +395,7 @@ __init static int all_annotated_branch_stats(void)
 
 	ret = register_stat_tracer(&all_branch_stats);
 	if (!ret) {
-		printk(KERN_WARNING "Warning: could not register "
-				    "all branches stats\n");
+		pr_warning("Warning: could not register all branches stats\n");
 		return 1;
 	}
 	return 0;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 3f972ad..d324bc0 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -135,8 +135,8 @@ static int ftrace_event_enable_disable(struct ftrace_event_call *call,
 			ret = call->regfunc(call);
 			if (ret) {
 				tracing_stop_cmdline_record();
-				pr_info("event trace: Could not enable event "
-					"%s\n", call->name);
+				pr_info("event trace: Could not enable event %s\n",
+					call->name);
 				break;
 			}
 			call->enabled = 1;
@@ -838,8 +838,7 @@ static struct dentry *event_trace_events_dir(void)
 
 	d_events = debugfs_create_dir("events", d_tracer);
 	if (!d_events)
-		pr_warning("Could not create debugfs "
-			   "'events' directory\n");
+		pr_warning("Could not create debugfs 'events' directory\n");
 
 	return d_events;
 }
@@ -863,15 +862,13 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	/* need to create new entry */
 	system = kmalloc(sizeof(*system), GFP_KERNEL);
 	if (!system) {
-		pr_warning("No memory to create event subsystem %s\n",
-			   name);
+		pr_warning("No memory to create event subsystem %s\n", name);
 		return d_events;
 	}
 
 	system->entry = debugfs_create_dir(name, d_events);
 	if (!system->entry) {
-		pr_warning("Could not create event subsystem %s\n",
-			   name);
+		pr_warning("Could not create event subsystem %s\n", name);
 		kfree(system);
 		return d_events;
 	}
@@ -890,8 +887,8 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 
 	system->filter = kzalloc(sizeof(struct event_filter), GFP_KERNEL);
 	if (!system->filter) {
-		pr_warning("Could not allocate filter for subsystem "
-			   "'%s'\n", name);
+		pr_warning("Could not allocate filter for subsystem '%s'\n",
+			   name);
 		return system->entry;
 	}
 
@@ -900,8 +897,8 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
 	if (!entry) {
 		kfree(system->filter);
 		system->filter = NULL;
-		pr_warning("Could not create debugfs "
-			   "'%s/filter' entry\n", name);
+		pr_warning("Could not create debugfs '%s/filter' entry\n",
+			   name);
 	}
 
 	trace_create_file("enable", 0644, system->entry,
@@ -929,8 +926,8 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 
 	call->dir = debugfs_create_dir(call->name, d_events);
 	if (!call->dir) {
-		pr_warning("Could not create debugfs "
-			   "'%s' directory\n", call->name);
+		pr_warning("Could not create debugfs '%s' directory\n",
+			   call->name);
 		return -1;
 	}
 
@@ -947,8 +944,8 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
 		if (!ret)
 			ret = call->define_fields(call);
 		if (ret < 0) {
-			pr_warning("Could not initialize trace point"
-				   " events/%s\n", call->name);
+			pr_warning("Could not initialize trace point events/%s\n",
+				   call->name);
 			return ret;
 		}
 		trace_create_file("filter", 0644, call->dir, call,
@@ -973,8 +970,8 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
 		ret = call->raw_init(call);
 		if (ret < 0) {
 			if (ret != -ENOSYS)
-				pr_warning("Could not initialize trace "
-				"events/%s\n", call->name);
+				pr_warning("Could not initialize trace events/%s\n",
+					   call->name);
 			return ret;
 		}
 	}
@@ -1135,8 +1132,8 @@ static void trace_module_add_events(struct module *mod)
 			ret = call->raw_init(call);
 			if (ret < 0) {
 				if (ret != -ENOSYS)
-					pr_warning("Could not initialize trace "
-					"point events/%s\n", call->name);
+					pr_warning("Could not initialize trace point events/%s\n",
+						   call->name);
 				continue;
 			}
 		}
@@ -1255,15 +1252,13 @@ static __init int event_trace_init(void)
 				    (void *)&show_event_seq_ops,
 				    &ftrace_avail_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'available_events' entry\n");
+		pr_warning("Could not create debugfs 'available_events' entry\n");
 
 	entry = debugfs_create_file("set_event", 0644, d_tracer,
 				    (void *)&show_set_event_seq_ops,
 				    &ftrace_set_event_fops);
 	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'set_event' entry\n");
+		pr_warning("Could not create debugfs 'set_event' entry\n");
 
 	d_events = event_trace_events_dir();
 	if (!d_events)
@@ -1289,8 +1284,8 @@ static __init int event_trace_init(void)
 			ret = call->raw_init(call);
 			if (ret < 0) {
 				if (ret != -ENOSYS)
-					pr_warning("Could not initialize trace "
-					"point events/%s\n", call->name);
+					pr_warning("Could not initialize trace point events/%s\n",
+						   call->name);
 				continue;
 			}
 		}
@@ -1436,8 +1431,7 @@ static __init void event_trace_self_tests(void)
 
 		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 1);
 		if (WARN_ON_ONCE(ret)) {
-			pr_warning("error enabling system %s\n",
-				   system->name);
+			pr_warning("error enabling system %s\n", system->name);
 			continue;
 		}
 
@@ -1445,8 +1439,7 @@ static __init void event_trace_self_tests(void)
 
 		ret = __ftrace_set_clr_event(NULL, system->name, NULL, 0);
 		if (WARN_ON_ONCE(ret))
-			pr_warning("error disabling system %s\n",
-				   system->name);
+			pr_warning("error disabling system %s\n", system->name);
 
 		pr_cont("OK\n");
 	}
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 505c922..f30ce28 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -407,7 +407,7 @@ static int register_trace_probe(struct trace_probe *tp)
 	}
 	ret = register_probe_event(tp);
 	if (ret) {
-		pr_warning("Faild to register probe event(%d)\n", ret);
+		pr_warning("Failed to register probe event(%d)\n", ret);
 		goto end;
 	}
 
@@ -420,8 +420,7 @@ static int register_trace_probe(struct trace_probe *tp)
 	if (ret) {
 		pr_warning("Could not insert probe(%d)\n", ret);
 		if (ret == -EILSEQ) {
-			pr_warning("Probing address(0x%p) is not an "
-				   "instruction boundary.\n",
+			pr_warning("Probing address(0x%p) is not an instruction boundary\n",
 				   tp->rp.kp.addr);
 			ret = -EINVAL;
 		}
@@ -569,7 +568,7 @@ static int __parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 static int parse_probe_arg(char *arg, struct fetch_func *ff, int is_return)
 {
 	if (strlen(arg) > MAX_ARGSTR_LEN) {
-		pr_info("Argument is too long.: %s\n",  arg);
+		pr_info("Argument is too long: %s\n", arg);
 		return -ENOSPC;
 	}
 	return __parse_probe_arg(arg, ff, is_return);
@@ -623,8 +622,7 @@ static int create_trace_probe(int argc, char **argv)
 	else if (argv[0][0] == '-')
 		is_delete = 1;
 	else {
-		pr_info("Probe definition must be started with 'p', 'r' or"
-			" '-'.\n");
+		pr_info("Probe definition must be started with 'p', 'r' or '-'\n");
 		return -EINVAL;
 	}
 
@@ -649,12 +647,12 @@ static int create_trace_probe(int argc, char **argv)
 
 	if (is_delete) {
 		if (!event) {
-			pr_info("Delete command needs an event name.\n");
+			pr_info("Delete command needs an event name\n");
 			return -EINVAL;
 		}
 		tp = find_probe_event(event, group);
 		if (!tp) {
-			pr_info("Event %s/%s doesn't exist.\n", group, event);
+			pr_info("Event %s/%s doesn't exist\n", group, event);
 			return -ENOENT;
 		}
 		/* delete an event */
@@ -664,18 +662,18 @@ static int create_trace_probe(int argc, char **argv)
 	}
 
 	if (argc < 2) {
-		pr_info("Probe point is not specified.\n");
+		pr_info("Probe point is not specified\n");
 		return -EINVAL;
 	}
 	if (isdigit(argv[1][0])) {
 		if (is_return) {
-			pr_info("Return probe point must be a symbol.\n");
+			pr_info("Return probe point must be a symbol\n");
 			return -EINVAL;
 		}
 		/* an address specified */
 		ret = strict_strtoul(&argv[1][0], 0, (unsigned long *)&addr);
 		if (ret) {
-			pr_info("Failed to parse address.\n");
+			pr_info("Failed to parse address\n");
 			return ret;
 		}
 	} else {
@@ -684,11 +682,11 @@ static int create_trace_probe(int argc, char **argv)
 		/* TODO: support .init module functions */
 		ret = split_symbol_offset(symbol, &offset);
 		if (ret) {
-			pr_info("Failed to parse symbol.\n");
+			pr_info("Failed to parse symbol\n");
 			return ret;
 		}
 		if (offset && is_return) {
-			pr_info("Return probe must be used without offset.\n");
+			pr_info("Return probe must be used without offset\n");
 			return -EINVAL;
 		}
 	}
@@ -708,7 +706,7 @@ static int create_trace_probe(int argc, char **argv)
 	tp = alloc_trace_probe(group, event, addr, symbol, offset, argc,
 			       is_return);
 	if (IS_ERR(tp)) {
-		pr_info("Failed to allocate trace_probe.(%d)\n",
+		pr_info("Failed to allocate trace_probe (%d)\n",
 			(int)PTR_ERR(tp));
 		return PTR_ERR(tp);
 	}
@@ -724,15 +722,15 @@ static int create_trace_probe(int argc, char **argv)
 			arg = argv[i];
 
 		if (conflict_field_name(argv[i], tp->args, i)) {
-			pr_info("Argument%d name '%s' conflicts with "
-				"another field.\n", i, argv[i]);
+			pr_info("Argument%d name '%s' conflicts with another field\n",
+				i, argv[i]);
 			ret = -EINVAL;
 			goto error;
 		}
 
 		tp->args[i].name = kstrdup(argv[i], GFP_KERNEL);
 		if (!tp->args[i].name) {
-			pr_info("Failed to allocate argument%d name '%s'.\n",
+			pr_info("Failed to allocate argument%d name '%s'\n",
 				i, argv[i]);
 			ret = -ENOMEM;
 			goto error;
@@ -810,7 +808,7 @@ static int probes_seq_show(struct seq_file *m, void *v)
 	for (i = 0; i < tp->nr_args; i++) {
 		ret = probe_arg_string(buf, MAX_ARGSTR_LEN, &tp->args[i].fetch);
 		if (ret < 0) {
-			pr_warning("Argument%d decoding error(%d).\n", i, ret);
+			pr_warning("Argument%d decoding error(%d)\n", i, ret);
 			return ret;
 		}
 		seq_printf(m, " %s=%s", tp->args[i].name, buf);
@@ -880,8 +878,8 @@ static ssize_t probes_write(struct file *file, const char __user *buffer,
 			*tmp = '\0';
 			size = tmp - kbuf + 1;
 		} else if (done + size < count) {
-			pr_warning("Line length is too long: "
-				   "Should be less than %d.", WRITE_BUFSIZE);
+			pr_warning("Line length is too long: Should be less than %d\n",
+				   WRITE_BUFSIZE);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -1393,16 +1391,14 @@ static __init int init_kprobe_trace(void)
 
 	/* Event list interface */
 	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'kprobe_events' entry\n");
+		pr_warning("Could not create debugfs 'kprobe_events' entry\n");
 
 	/* Profile interface */
 	entry = debugfs_create_file("kprobe_profile", 0444, d_tracer,
 				    NULL, &kprobe_profile_ops);
 
 	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'kprobe_profile' entry\n");
+		pr_warning("Could not create debugfs 'kprobe_profile' entry\n");
 	return 0;
 }
 fs_initcall(init_kprobe_trace);
@@ -1429,13 +1425,13 @@ static __init int kprobe_trace_self_tests_init(void)
 	ret = command_trace_probe("p:testprobe kprobe_trace_selftest_target "
 				  "$stack $stack0 +0($stack)");
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on probing function entry.\n");
+		pr_warning("error on probing function entry\n");
 		warn++;
 	} else {
 		/* Enable trace point */
 		tp = find_probe_event("testprobe", KPROBE_EVENT_SYSTEM);
 		if (WARN_ON_ONCE(tp == NULL)) {
-			pr_warning("error on getting new probe.\n");
+			pr_warning("error on getting new probe\n");
 			warn++;
 		} else
 			probe_event_enable(&tp->call);
@@ -1444,13 +1440,13 @@ static __init int kprobe_trace_self_tests_init(void)
 	ret = command_trace_probe("r:testprobe2 kprobe_trace_selftest_target "
 				  "$retval");
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on probing function return.\n");
+		pr_warning("error on probing function return\n");
 		warn++;
 	} else {
 		/* Enable trace point */
 		tp = find_probe_event("testprobe2", KPROBE_EVENT_SYSTEM);
 		if (WARN_ON_ONCE(tp == NULL)) {
-			pr_warning("error on getting new probe.\n");
+			pr_warning("error on getting new probe\n");
 			warn++;
 		} else
 			probe_event_enable(&tp->call);
@@ -1463,20 +1459,20 @@ static __init int kprobe_trace_self_tests_init(void)
 
 	ret = command_trace_probe("-:testprobe");
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on deleting a probe.\n");
+		pr_warning("error on deleting a probe\n");
 		warn++;
 	}
 
 	ret = command_trace_probe("-:testprobe2");
 	if (WARN_ON_ONCE(ret)) {
-		pr_warning("error on deleting a probe.\n");
+		pr_warning("error on deleting a probe\n");
 		warn++;
 	}
 
 end:
 	cleanup_all_probes();
 	if (warn)
-		pr_cont("NG: Some tests are failed. Please check them.\n");
+		pr_warning("NG: Some tests failed. Please check them.\n");
 	else
 		pr_cont("OK\n");
 	return 0;
diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
index 94103cd..37f6b81 100644
--- a/kernel/trace/trace_ksym.c
+++ b/kernel/trace/trace_ksym.c
@@ -181,8 +181,7 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 	int ret = -ENOMEM;
 
 	if (ksym_filter_entry_count >= KSYM_TRACER_MAX) {
-		printk(KERN_ERR "ksym_tracer: Maximum limit:(%d) reached. No"
-		" new requests for tracing can be accepted now.\n",
+		pr_err("ksym_tracer: Maximum limit:(%d) reached. No new requests for tracing can be accepted now.\n",
 			KSYM_TRACER_MAX);
 		return -ENOSPC;
 	}
@@ -202,8 +201,7 @@ int process_new_ksym_entry(char *ksymname, int op, unsigned long addr)
 
 	if (IS_ERR(entry->ksym_hbp)) {
 		ret = PTR_ERR(entry->ksym_hbp);
-		printk(KERN_INFO "ksym_tracer request failed. Try again"
-					" later!!\n");
+		pr_info("ksym_tracer request failed. Try again later!!\n");
 		goto err;
 	}
 
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 0acd834..a65a000 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -148,7 +148,7 @@ static ssize_t mmio_read(struct trace_iterator *iter, struct file *filp,
 		/* XXX: This is later than where events were lost. */
 		trace_seq_printf(s, "MARK 0.000000 Lost %lu events.\n", n);
 		if (!overrun_detected)
-			pr_warning("mmiotrace has lost events.\n");
+			pr_warning("mmiotrace has lost events\n");
 		overrun_detected = true;
 		goto print_out;
 	}
diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 8e46b33..ffab488 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -749,7 +749,7 @@ int register_ftrace_event(struct trace_event *event)
 		list_add_tail(&event->list, list);
 
 	} else if (event->type > __TRACE_LAST_TYPE) {
-		printk(KERN_WARNING "Need to add type to trace.h\n");
+		pr_warning("Need to add type to trace.h\n");
 		WARN_ON(1);
 		goto out;
 	} else {
@@ -1269,8 +1269,8 @@ __init static int init_events(void)
 
 		ret = register_ftrace_event(event);
 		if (!ret) {
-			printk(KERN_WARNING "event %d failed to register\n",
-			       event->type);
+			pr_warning("event %d failed to register\n",
+				   event->type);
 			WARN_ON_ONCE(1);
 		}
 	}
diff --git a/kernel/trace/trace_sched_switch.c b/kernel/trace/trace_sched_switch.c
index 5fca0f5..7500ad5 100644
--- a/kernel/trace/trace_sched_switch.c
+++ b/kernel/trace/trace_sched_switch.c
@@ -141,22 +141,19 @@ static int tracing_sched_register(void)
 
 	ret = register_trace_sched_wakeup(probe_sched_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't activate tracepoint"
-			" probe to kernel_sched_wakeup\n");
+		pr_info("wakeup trace: Couldn't activate tracepoint probe to kernel_sched_wakeup\n");
 		return ret;
 	}
 
 	ret = register_trace_sched_wakeup_new(probe_sched_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't activate tracepoint"
-			" probe to kernel_sched_wakeup_new\n");
+		pr_info("wakeup trace: Couldn't activate tracepoint probe to kernel_sched_wakeup_new\n");
 		goto fail_deprobe;
 	}
 
 	ret = register_trace_sched_switch(probe_sched_switch);
 	if (ret) {
-		pr_info("sched trace: Couldn't activate tracepoint"
-			" probe to kernel_sched_switch\n");
+		pr_info("sched trace: Couldn't activate tracepoint probe to kernel_sched_switch\n");
 		goto fail_deprobe_wake_new;
 	}
 
diff --git a/kernel/trace/trace_sched_wakeup.c b/kernel/trace/trace_sched_wakeup.c
index 0271742..db99a58 100644
--- a/kernel/trace/trace_sched_wakeup.c
+++ b/kernel/trace/trace_sched_wakeup.c
@@ -266,29 +266,25 @@ static void start_wakeup_tracer(struct trace_array *tr)
 
 	ret = register_trace_sched_wakeup(probe_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't activate tracepoint"
-			" probe to kernel_sched_wakeup\n");
+		pr_info("wakeup trace: Couldn't activate tracepoint probe to kernel_sched_wakeup\n");
 		return;
 	}
 
 	ret = register_trace_sched_wakeup_new(probe_wakeup);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't activate tracepoint"
-			" probe to kernel_sched_wakeup_new\n");
+		pr_info("wakeup trace: Couldn't activate tracepoint probe to kernel_sched_wakeup_new\n");
 		goto fail_deprobe;
 	}
 
 	ret = register_trace_sched_switch(probe_wakeup_sched_switch);
 	if (ret) {
-		pr_info("sched trace: Couldn't activate tracepoint"
-			" probe to kernel_sched_switch\n");
+		pr_info("sched trace: Couldn't activate tracepoint probe to kernel_sched_switch\n");
 		goto fail_deprobe_wake_new;
 	}
 
 	ret = register_trace_sched_migrate_task(probe_wakeup_migrate_task);
 	if (ret) {
-		pr_info("wakeup trace: Couldn't activate tracepoint"
-			" probe to kernel_sched_migrate_task\n");
+		pr_info("wakeup trace: Couldn't activate tracepoint probe to kernel_sched_migrate_task\n");
 		return;
 	}
 
diff --git a/kernel/trace/trace_selftest.c b/kernel/trace/trace_selftest.c
index 280fea4..551f983 100644
--- a/kernel/trace/trace_selftest.c
+++ b/kernel/trace/trace_selftest.c
@@ -38,12 +38,11 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
 		 * with the ring buffer.
 		 */
 		if (loops++ > trace_buf_size) {
-			printk(KERN_CONT ".. bad ring buffer ");
+			pr_cont(".. bad ring buffer ");
 			goto failed;
 		}
 		if (!trace_valid_entry(entry)) {
-			printk(KERN_CONT ".. invalid entry %d ",
-				entry->type);
+			pr_cont(".. invalid entry %d ", entry->type);
 			goto failed;
 		}
 	}
@@ -52,7 +51,7 @@ static int trace_test_buffer_cpu(struct trace_array *tr, int cpu)
  failed:
 	/* disable tracing */
 	tracing_disabled = 1;
-	printk(KERN_CONT ".. corrupted trace buffer .. ");
+	pr_cont(".. corrupted trace buffer .. ");
 	return -1;
 }
 
@@ -96,8 +95,8 @@ static int trace_test_buffer(struct trace_array *tr, unsigned long *count)
 
 static inline void warn_failed_init_tracer(struct tracer *trace, int init_ret)
 {
-	printk(KERN_WARNING "Failed to init %s tracer, init returned %d\n",
-		trace->name, init_ret);
+	pr_warning("Failed to init %s tracer, init returned %d\n",
+		   trace->name, init_ret);
 }
 #ifdef CONFIG_FUNCTION_TRACER
 
@@ -115,7 +114,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 	int ret;
 
 	/* The ftrace test PASSED */
-	printk(KERN_CONT "PASSED\n");
+	pr_cont("PASSED\n");
 	pr_info("Testing dynamic ftrace: ");
 
 	/* enable tracing, and record the filter function */
@@ -152,7 +151,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 
 	if (count) {
 		ret = -1;
-		printk(KERN_CONT ".. filter did not filter .. ");
+		pr_cont(".. filter did not filter .. ");
 		goto out;
 	}
 
@@ -173,7 +172,7 @@ int trace_selftest_startup_dynamic_tracing(struct tracer *trace,
 
 	/* we should only have one item */
 	if (!ret && count != 1) {
-		printk(KERN_CONT ".. filter failed count=%ld ..", count);
+		pr_cont(".. filter failed count=%ld ..", count);
 		ret = -1;
 		goto out;
 	}
@@ -229,7 +228,7 @@ trace_selftest_startup_function(struct tracer *trace, struct trace_array *tr)
 	tracing_start();
 
 	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
+		pr_cont(".. no entries found ..");
 		ret = -1;
 		goto out;
 	}
@@ -264,7 +263,7 @@ static int trace_graph_entry_watchdog(struct ftrace_graph_ent *trace)
 	/* This is harmlessly racy, we want to approximately detect a hang */
 	if (unlikely(++graph_hang_thresh > GRAPH_MAX_FUNC_TEST)) {
 		ftrace_graph_stop();
-		printk(KERN_WARNING "BUG: Function graph tracer hang!\n");
+		pr_warning("BUG: Function graph tracer hang!\n");
 		if (ftrace_dump_on_oops)
 			__ftrace_dump(false);
 		return 0;
@@ -317,7 +316,7 @@ trace_selftest_startup_function_graph(struct tracer *trace,
 	tracing_start();
 
 	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
+		pr_cont(".. no entries found ..");
 		ret = -1;
 		goto out;
 	}
@@ -373,7 +372,7 @@ trace_selftest_startup_irqsoff(struct tracer *trace, struct trace_array *tr)
 	tracing_start();
 
 	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
+		pr_cont(".. no entries found ..");
 		ret = -1;
 	}
 
@@ -400,7 +399,7 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	 * so keep it in.
 	 */
 	if (preempt_count()) {
-		printk(KERN_CONT "can not test ... force ");
+		pr_cont("can not test ... force ");
 		return 0;
 	}
 
@@ -435,7 +434,7 @@ trace_selftest_startup_preemptoff(struct tracer *trace, struct trace_array *tr)
 	tracing_start();
 
 	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
+		pr_cont(".. no entries found ..");
 		ret = -1;
 	}
 
@@ -462,7 +461,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	 * so keep it in.
 	 */
 	if (preempt_count()) {
-		printk(KERN_CONT "can not test ... force ");
+		pr_cont("can not test ... force ");
 		return 0;
 	}
 
@@ -503,7 +502,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 		goto out;
 
 	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
+		pr_cont(".. no entries found ..");
 		ret = -1;
 		goto out;
 	}
@@ -531,7 +530,7 @@ trace_selftest_startup_preemptirqsoff(struct tracer *trace, struct trace_array *
 	ret = trace_test_buffer(&max_tr, &count);
 
 	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
+		pr_cont(".. no entries found ..");
 		ret = -1;
 		goto out;
 	}
@@ -597,7 +596,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	/* create a high prio thread */
 	p = kthread_run(trace_wakeup_test_thread, &isrt, "ftrace-test");
 	if (IS_ERR(p)) {
-		printk(KERN_CONT "Failed to create ftrace wakeup test thread ");
+		pr_cont("Failed to create ftrace wakeup test thread ");
 		return -1;
 	}
 
@@ -650,7 +649,7 @@ trace_selftest_startup_wakeup(struct tracer *trace, struct trace_array *tr)
 	kthread_stop(p);
 
 	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
+		pr_cont(".. no entries found ..");
 		ret = -1;
 	}
 
@@ -682,7 +681,7 @@ trace_selftest_startup_sched_switch(struct tracer *trace, struct trace_array *tr
 	tracing_start();
 
 	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
+		pr_cont(".. no entries found ..");
 		ret = -1;
 	}
 
@@ -714,7 +713,7 @@ trace_selftest_startup_sysprof(struct tracer *trace, struct trace_array *tr)
 	tracing_start();
 
 	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
+		pr_cont(".. no entries found ..");
 		ret = -1;
 	}
 
@@ -746,7 +745,7 @@ trace_selftest_startup_branch(struct tracer *trace, struct trace_array *tr)
 	tracing_start();
 
 	if (!ret && !count) {
-		printk(KERN_CONT ".. no entries found ..");
+		pr_cont(".. no entries found ..");
 		ret = -1;
 	}
 
@@ -765,7 +764,7 @@ trace_selftest_startup_hw_branches(struct tracer *trace,
 	int ret;
 
 	if (!trace->open) {
-		printk(KERN_CONT "missing open function...");
+		pr_cont("missing open function...");
 		return -1;
 	}
 
@@ -802,7 +801,7 @@ trace_selftest_startup_hw_branches(struct tracer *trace,
 	tracing_start();
 
 	if (!ret && !count) {
-		printk(KERN_CONT "no entries found..");
+		pr_cont("no entries found..");
 		ret = -1;
 	}
 
@@ -834,7 +833,7 @@ trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
 					(unsigned long)(&ksym_selftest_dummy));
 
 	if (ret < 0) {
-		printk(KERN_CONT "ksym_trace read-write startup test failed\n");
+		pr_cont("ksym_trace read-write startup test failed\n");
 		goto ret_path;
 	}
 	/* Perform a read and a write operation over the dummy variable to
@@ -854,7 +853,7 @@ trace_selftest_startup_ksym(struct tracer *trace, struct trace_array *tr)
 	 * triggering two entries in the trace buffer
 	 */
 	if (!ret && count != 2) {
-		printk(KERN_CONT "Ksym tracer startup test failed");
+		pr_cont("Ksym tracer startup test failed");
 		ret = -1;
 	}
 
diff --git a/kernel/trace/trace_stat.c b/kernel/trace/trace_stat.c
index a4bb239..5be4d73 100644
--- a/kernel/trace/trace_stat.c
+++ b/kernel/trace/trace_stat.c
@@ -309,8 +309,7 @@ static int tracing_stat_init(void)
 
 	stat_dir = debugfs_create_dir("trace_stat", d_tracing);
 	if (!stat_dir)
-		pr_warning("Could not create debugfs "
-			   "'trace_stat' entry\n");
+		pr_warning("Could not create debugfs 'trace_stat' entry\n");
 	return 0;
 }
 
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index cba47d7..6ea6c54 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -481,8 +481,7 @@ int prof_sysenter_enable(struct ftrace_event_call *call)
 	if (!sys_prof_refcount_enter)
 		ret = register_trace_sys_enter(prof_syscall_enter);
 	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall entry trace point");
+		pr_info("event trace: Could not activate syscall entry trace point\n");
 	} else {
 		set_bit(num, enabled_prof_enter_syscalls);
 		sys_prof_refcount_enter++;
@@ -556,8 +555,7 @@ int prof_sysexit_enable(struct ftrace_event_call *call)
 	if (!sys_prof_refcount_exit)
 		ret = register_trace_sys_exit(prof_syscall_exit);
 	if (ret) {
-		pr_info("event trace: Could not activate"
-				"syscall exit trace point");
+		pr_info("event trace: Could not activate syscall exit trace point\n");
 	} else {
 		set_bit(num, enabled_prof_exit_syscalls);
 		sys_prof_refcount_exit++;


