Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbZCZXyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbZCZXyT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761846AbZCZXxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:53:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52703 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762319AbZCZXx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:53:29 -0400
Date: Thu, 26 Mar 2009 19:53:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing/ftrace: factorize the tracing files creation
In-Reply-To: <1238109938-11840-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0903261949480.1917@gandalf.stny.rr.com>
References: <1238109938-11840-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Mar 2009, Frederic Weisbecker wrote:

> Impact: cleanup
> 
> Most of the tracing files creation follow the same pattern:
> 
> ret = debugfs_create_file(...)
> if (!ret)
> 	pr_warning("Couldn't create ... entry\n")
> 
> Unify it!
> 

I could have sworn I did this before. I found this patch with the 
timestamp dated Feb 8, 2008.  This is even before we came up with the name 
"ftrace" and I was still calling it "mcount".

Oh well, it somehow never got out :-(

I'll Ack yours ;-)


Old patch:

From: Steven Rostedt <srostedt@redhat.com>
Subject: clean up trace debugfs error messages

The debugfs creation had a bunch of cut and paste errors
in the prints. This patch creates a single function to
create the debugfs file and print out the error if it
fails.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/trace.c |   53 +++++++++++++++++++++------------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

Index: linux-mcount.git/kernel/trace/trace.c
===================================================================
--- linux-mcount.git.orig/kernel/trace/trace.c	2008-02-08 12:04:29.000000000 -0500
+++ linux-mcount.git/kernel/trace/trace.c	2008-02-08 14:39:43.000000000 -0500
@@ -1394,63 +1394,54 @@ struct dentry *tracing_init_dentry(void)
 	return d_tracer;
 }
 
+static __init void
+tracing_debugfs_create_file(const char *name, mode_t mode,
+			    struct dentry *parent, void *data,
+			    const struct file_operations *fops)
+{
+	struct dentry *entry;
+
+	entry = debugfs_create_file(name, mode, parent, data, fops);
+	if (!entry)
+		pr_warning("Could not create debugfs '%s' entry\n", name);
+}
+
 static __init void tracer_init_debugfs(void)
 {
 	struct dentry *d_tracer;
-	struct dentry *entry;
 
 	d_tracer = tracing_init_dentry();
 
-	entry = debugfs_create_file("tracing_enabled", 0644, d_tracer,
+	tracing_debugfs_create_file("tracing_enabled", 0644, d_tracer,
 				    &global_trace, &tracing_ctrl_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'tracing_enabled' entry\n");
 
-	entry = debugfs_create_file("iter_ctrl", 0644, d_tracer,
+
+	tracing_debugfs_create_file("iter_ctrl", 0644, d_tracer,
 				    NULL, &tracing_iter_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'iter_ctrl' entry\n");
 
-	entry = debugfs_create_file("latency_trace", 0444, d_tracer,
+	tracing_debugfs_create_file("latency_trace", 0444, d_tracer,
 				    &global_trace, &tracing_lt_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'latency_trace' entry\n");
 
-	entry = debugfs_create_file("trace", 0444, d_tracer,
+	tracing_debugfs_create_file("trace", 0444, d_tracer,
 				    &global_trace, &tracing_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
 
-	entry = debugfs_create_file("available_tracers", 0444, d_tracer,
+	tracing_debugfs_create_file("available_tracers", 0444, d_tracer,
 				    &global_trace, &show_traces_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
 
-	entry = debugfs_create_file("current_tracer", 0444, d_tracer,
+	tracing_debugfs_create_file("current_tracer", 0444, d_tracer,
 				    &global_trace, &set_tracer_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs 'trace' entry\n");
 
-	entry = debugfs_create_file("tracing_max_latency", 0644, d_tracer,
+	tracing_debugfs_create_file("tracing_max_latency", 0644, d_tracer,
 				    &tracing_max_latency,
 				    &tracing_max_lat_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'tracing_max_latency' entry\n");
 
-	entry = debugfs_create_file("tracing_thresh", 0644, d_tracer,
+	tracing_debugfs_create_file("tracing_thresh", 0644, d_tracer,
 				    &tracing_thresh, &tracing_max_lat_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'tracing_threash' entry\n");
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-	entry = debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
+	tracing_debugfs_create_file("dyn_ftrace_total_info", 0444, d_tracer,
 				    &ftrace_update_tot_cnt,
 				    &tracing_read_long_fops);
-	if (!entry)
-		pr_warning("Could not create debugfs "
-			   "'dyn_ftrace_total_info' entry\n");
 #endif
 }
 
