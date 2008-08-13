Return-Path: <linux-kernel-owner+w=401wt.eu-S1754565AbYHMG0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565AbYHMG0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 02:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYHMG0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 02:26:30 -0400
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:48649 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYHMG03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 02:26:29 -0400
Date: Wed, 13 Aug 2008 11:54:56 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dwilder@us.ibm.com, hch@infradead.org
Subject: Re: [Patch 2/2] Renaming lib/trace.[ch] files to
	kernel/relay_debugfs.[ch] and enhancements
Message-ID: <20080813062456.GA3731@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20080804040439.GA6415@in.ibm.com> <20080804040809.GC6415@in.ibm.com> <20080812223251.53a09f43.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080812223251.53a09f43.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2008 at 10:32:51PM -0700, Andrew Morton wrote:
> On Mon, 4 Aug 2008 09:38:09 +0530 "K.Prasad" <prasad@linux.vnet.ibm.com> wrote:
> 
> > This patch renames the lib/trace.[ch] files to
> > kernel/relay_debugfs.[ch]. Also present are the changes to rename the
> > "trace_*" functions to "relay_*".
> > 
> > Two new functions which provide an easy-to-use interface for relay
> > called relay_printk() and relay_dump() are also introduced (earlier
> > called as trace_printk() and trace_dump()).
> 
> akpm2:/usr/src/25> make M=samples     
>   LD      samples/kobject/built-in.o
>   CC [M]  samples/kobject/kobject-example.o
>   CC [M]  samples/kobject/kset-example.o
>   LD      samples/kprobes/built-in.o
>   CC [M]  samples/kprobes/kprobe_example.o
>   CC [M]  samples/kprobes/jprobe_example.o
>   CC [M]  samples/kprobes/kretprobe_example.o
>   LD      samples/markers/built-in.o
>   CC [M]  samples/markers/probe-example.o
>   CC [M]  samples/markers/marker-example.o
>   LD      samples/relay/built-in.o
>   CC [M]  samples/relay/fork_trace.o
> make[2]: *** No rule to make target `samples/relay/fork_new_trace.c', needed by `samples/relay/fork_new_trace.o'.  Stop.

Found that the build breakage is due to fork_new_trace.c still lying in
samples/trace/ directory.

Kindly apply the patch below which moves samples/trace/fork_new_trace.c
to samples/relay/. Also remove the empty directory samples/trace (unable
to show the same in the diff).

I have verified that the build happens fine after applying this patch on
an x86 machine with default configs.

Thanks,
K.Prasad

Moves fork_new_trace.c file into samples/relay directory.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 samples/relay/fork_new_trace.c |   99 +++++++++++++++++++++++++++++++++++++++++
 samples/trace/fork_new_trace.c |   99 -----------------------------------------
 2 files changed, 99 insertions(+), 99 deletions(-)

Index: linux-2.6.27-rc1-mm1/samples/relay/fork_new_trace.c
===================================================================
--- /dev/null
+++ linux-2.6.27-rc1-mm1/samples/relay/fork_new_trace.c
@@ -0,0 +1,99 @@
+/*
+ * An example of using trace in a kprobes module
+ *
+ * Copyright (C) 2008 IBM Inc.
+ *
+ * K.Prasad <prasad@linux.vnet.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ *
+ * -------
+ * This module creates a trace channel and places a kprobe
+ * on the function do_fork(). The value of current->pid is written to
+ * the trace channel each time the kprobe is hit..
+ *
+ * How to run the example:
+ * $ mount -t debugfs /debug
+ * $ insmod fork_new_trace.ko
+ *
+ * To view the data produced by the module:
+ * $ cat /debug/relay_example/do_fork/trace0
+ *
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/relay_debugfs.h>
+
+#define SAMPLE_PARENT_DIR "relay_new_example"
+#define PROBE_POINT "do_fork"
+
+static struct kprobe kp;
+static struct relay_printk_data *tpk;
+
+static int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	relay_printk(tpk, "%d\n", current->pid);
+	return 0;
+}
+
+int init_module(void)
+{
+	int ret = 0;
+	int len_parent_dir, len_dir;
+
+	/* setup the kprobe */
+	kp.pre_handler = handler_pre;
+	kp.post_handler = NULL;
+	kp.fault_handler = NULL;
+	kp.symbol_name = PROBE_POINT;
+	ret = register_kprobe(&kp);
+	if (ret) {
+		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
+		return ret;
+	}
+
+	len_parent_dir = strlen(SAMPLE_PARENT_DIR) + 1;
+	/* Initialising len_dir to the larger of the two dir names */
+	len_dir = strlen("kprobe_struct") + 1;
+
+	tpk = kzalloc(sizeof(*tpk), GFP_KERNEL);
+	if (!tpk)
+		ret = 1;
+
+	tpk->parent_dir = SAMPLE_PARENT_DIR;
+
+	/* Let's do a binary dump of struct kprobe using relay_dump */
+	tpk->dir = "kprobes_struct";
+	tpk->flags = RELAY_GLOBAL_CHANNEL;
+	relay_dump(tpk, &kp, sizeof(kp));
+
+	/* Now change the directory to collect fork pid data */
+	tpk->dir = PROBE_POINT;
+
+	if (ret)
+		printk(KERN_ERR "Unable to find required free memory. "
+				"Trace new sample module loading aborted");
+	return ret;
+}
+
+void cleanup_module(void)
+{
+	unregister_kprobe(&kp);
+
+	/* Just a single cleanup call passing the parent dir string */
+	relay_cleanup_all(SAMPLE_PARENT_DIR);
+}
+MODULE_LICENSE("GPL");
Index: linux-2.6.27-rc1-mm1/samples/trace/fork_new_trace.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/samples/trace/fork_new_trace.c
+++ /dev/null
@@ -1,99 +0,0 @@
-/*
- * An example of using trace in a kprobes module
- *
- * Copyright (C) 2008 IBM Inc.
- *
- * K.Prasad <prasad@linux.vnet.ibm.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- *
- * -------
- * This module creates a trace channel and places a kprobe
- * on the function do_fork(). The value of current->pid is written to
- * the trace channel each time the kprobe is hit..
- *
- * How to run the example:
- * $ mount -t debugfs /debug
- * $ insmod fork_new_trace.ko
- *
- * To view the data produced by the module:
- * $ cat /debug/relay_example/do_fork/trace0
- *
- */
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/kprobes.h>
-#include <linux/relay_debugfs.h>
-
-#define SAMPLE_PARENT_DIR "relay_new_example"
-#define PROBE_POINT "do_fork"
-
-static struct kprobe kp;
-static struct relay_printk_data *tpk;
-
-static int handler_pre(struct kprobe *p, struct pt_regs *regs)
-{
-	relay_printk(tpk, "%d\n", current->pid);
-	return 0;
-}
-
-int init_module(void)
-{
-	int ret = 0;
-	int len_parent_dir, len_dir;
-
-	/* setup the kprobe */
-	kp.pre_handler = handler_pre;
-	kp.post_handler = NULL;
-	kp.fault_handler = NULL;
-	kp.symbol_name = PROBE_POINT;
-	ret = register_kprobe(&kp);
-	if (ret) {
-		printk(KERN_ERR "fork_trace: register_kprobe failed\n");
-		return ret;
-	}
-
-	len_parent_dir = strlen(SAMPLE_PARENT_DIR) + 1;
-	/* Initialising len_dir to the larger of the two dir names */
-	len_dir = strlen("kprobe_struct") + 1;
-
-	tpk = kzalloc(sizeof(*tpk), GFP_KERNEL);
-	if (!tpk)
-		ret = 1;
-
-	tpk->parent_dir = SAMPLE_PARENT_DIR;
-
-	/* Let's do a binary dump of struct kprobe using relay_dump */
-	tpk->dir = "kprobes_struct";
-	tpk->flags = TRACE_GLOBAL_CHANNEL;
-	relay_dump(tpk, &kp, sizeof(kp));
-
-	/* Now change the directory to collect fork pid data */
-	tpk->dir = PROBE_POINT;
-
-	if (ret)
-		printk(KERN_ERR "Unable to find required free memory. "
-				"Trace new sample module loading aborted");
-	return ret;
-}
-
-void cleanup_module(void)
-{
-	unregister_kprobe(&kp);
-
-	/* Just a single cleanup call passing the parent dir string */
-	relay_cleanup_all(SAMPLE_PARENT_DIR);
-}
-MODULE_LICENSE("GPL");
