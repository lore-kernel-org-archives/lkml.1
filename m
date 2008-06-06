Return-Path: <linux-kernel-owner+w=401wt.eu-S1757932AbYFFOTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757932AbYFFOTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYFFOTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:19:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbYFFOTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:19:33 -0400
Message-ID: <484944CA.902@redhat.com>
Date: Fri, 06 Jun 2008 10:08:10 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 2/2] kprobes: add tests for register_kprobes
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add testcases for *probe batch registration (register_kprobes)
to kprobes sanity tests.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Jim Keniston <jkenisto@us.ibm.com>
CC: David Miller <davem@davemloft.net>
---
 tests/test_kprobes.c |  182 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 182 insertions(+)

Index: 2.6.26-rc2-mm1/tests/test_kprobes.c
===================================================================
--- 2.6.26-rc2-mm1.orig/tests/test_kprobes.c
+++ 2.6.26-rc2-mm1/tests/test_kprobes.c
@@ -23,6 +23,7 @@
 static u32 rand1, preh_val, posth_val, jph_val;
 static int errors, handler_errors, num_tests;
 static u32 (*target)(u32 value);
+static u32 (*target2)(u32 value);

 static noinline u32 kprobe_target(u32 value)
 {
@@ -81,6 +82,81 @@ static int test_kprobe(void)
 	return 0;
 }

+static noinline u32 kprobe_target2(u32 value)
+{
+	return (value / div_factor) + 1;
+}
+
+static int kp_pre_handler2(struct kprobe *p, struct pt_regs *regs)
+{
+	preh_val = (rand1 / div_factor) + 1;
+	return 0;
+}
+
+static void kp_post_handler2(struct kprobe *p, struct pt_regs *regs,
+		unsigned long flags)
+{
+	if (preh_val != (rand1 / div_factor) + 1) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"incorrect value in post_handler2\n");
+	}
+	posth_val = preh_val + div_factor;
+}
+
+static struct kprobe kp2 = {
+	.symbol_name = "kprobe_target2",
+	.pre_handler = kp_pre_handler2,
+	.post_handler = kp_post_handler2
+};
+
+static int test_kprobes(void)
+{
+	int ret;
+	struct kprobe *kps[2] = {&kp, &kp2};
+
+	ret = register_kprobes(kps, 2);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_kprobes returned %d\n", ret);
+		return ret;
+	}
+
+	ret = target(rand1);
+
+	if (preh_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kprobe pre_handler not called\n");
+		handler_errors++;
+	}
+
+	if (posth_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kprobe post_handler not called\n");
+		handler_errors++;
+	}
+
+	preh_val = 0;
+	posth_val = 0;
+	ret = target2(rand1);
+
+	if (preh_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kprobe pre_handler2 not called\n");
+		handler_errors++;
+	}
+
+	if (posth_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kprobe post_handler2 not called\n");
+		handler_errors++;
+	}
+
+	unregister_kprobes(kps, 2);
+	return 0;
+
+}
+
 static u32 j_kprobe_target(u32 value)
 {
 	if (value != rand1) {
@@ -121,6 +197,41 @@ static int test_jprobe(void)
 	return 0;
 }

+static struct jprobe jp2 = {
+	.entry          = j_kprobe_target,
+	.kp.symbol_name = "kprobe_target2"
+};
+
+static int test_jprobes(void)
+{
+	int ret;
+	struct jprobe *jps[2] = {&jp, &jp2};
+
+	ret = register_jprobes(jps, 2);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_jprobes returned %d\n", ret);
+		return ret;
+	}
+
+	ret = target(rand1);
+	if (jph_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"jprobe handler not called\n");
+		handler_errors++;
+	}
+
+	jph_val = 0;
+	ret = target2(rand1);
+	if (jph_val == 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"jprobe handler2 not called\n");
+		handler_errors++;
+	}
+	unregister_jprobes(jps, 2);
+
+	return 0;
+}
 #ifdef CONFIG_KRETPROBES
 static u32 krph_val;

@@ -176,6 +287,61 @@ static int test_kretprobe(void)

 	return 0;
 }
+
+static int return_handler2(struct kretprobe_instance *ri, struct pt_regs *regs)
+{
+	unsigned long ret = regs_return_value(regs);
+
+	if (ret != (rand1 / div_factor) + 1) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"incorrect value in kretprobe handler2\n");
+	}
+	if (krph_val == 0) {
+		handler_errors++;
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"call to kretprobe entry handler failed\n");
+	}
+
+	krph_val = rand1;
+	return 0;
+}
+
+static struct kretprobe rp2 = {
+	.handler	= return_handler2,
+	.entry_handler  = entry_handler,
+	.kp.symbol_name = "kprobe_target2"
+};
+
+static int test_kretprobes(void)
+{
+	int ret;
+	struct kretprobe *rps[2] = {&rp, &rp2};
+
+	ret = register_kretprobes(rps, 2);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_kretprobe returned %d\n", ret);
+		return ret;
+	}
+
+	ret = target(rand1);
+	if (krph_val != rand1) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kretprobe handler not called\n");
+		handler_errors++;
+	}
+
+	krph_val = 0;
+	ret = target2(rand1);
+	if (krph_val != rand1) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"kretprobe handler2 not called\n");
+		handler_errors++;
+	}
+	unregister_kretprobes(rps, 2);
+	return 0;
+}
 #endif /* CONFIG_KRETPROBES */

 int init_test_probes(void)
@@ -183,6 +349,7 @@ int init_test_probes(void)
 	int ret;

 	target = kprobe_target;
+	target2 = kprobe_target2;

 	do {
 		rand1 = random32();
@@ -195,15 +362,30 @@ int init_test_probes(void)
 		errors++;

 	num_tests++;
+	ret = test_kprobes();
+	if (ret < 0)
+		errors++;
+
+	num_tests++;
 	ret = test_jprobe();
 	if (ret < 0)
 		errors++;

+	num_tests++;
+	ret = test_jprobes();
+	if (ret < 0)
+		errors++;
+
 #ifdef CONFIG_KRETPROBES
 	num_tests++;
 	ret = test_kretprobe();
 	if (ret < 0)
 		errors++;
+
+	num_tests++;
+	ret = test_kretprobes();
+	if (ret < 0)
+		errors++;
 #endif /* CONFIG_KRETPROBES */

 	if (errors)
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

