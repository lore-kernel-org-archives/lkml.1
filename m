Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbYFJVzH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbYFJVzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:55:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYFJVy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:54:56 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34958 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186AbYFJVyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:54:55 -0400
Message-ID: <484EF796.3000708@redhat.com>
Date: Tue, 10 Jun 2008 17:52:22 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       David Miller <davem@davemloft.net>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 2/2] kprobes: add tests for register_kprobes
References: <484944CA.902@redhat.com> <1212798986.4088.23.camel@dyn9047018139.beaverton.ibm.com>
In-Reply-To: <1212798986.4088.23.camel@dyn9047018139.beaverton.ibm.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jim,

Thank you for pointing it.

Jim Keniston wrote:
> preh_val and posth_val are being reused after test_kprobe(), which sets
> them to non-zero values.  Seems like you want to reinitialize them here
> as well as below.

Indeed, it should be initialized.
And kp.addr also have to be reinitialized, because
if both kp.addr and kp.symbol are set, kprobes returns
an error.

> Ditto jph_val for jprobes and krph_val for kretprobes.
> 
> Ack otherwise.

Thanks again,


Add testcases for *probe batch registration (register_kprobes)
to kprobes sanity tests.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Jim Keniston <jkenisto@us.ibm.com>
CC: David Miller <davem@davemloft.net>
---
 tests/test_kprobes.c |  189 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 189 insertions(+)

Index: 2.6-mm/tests/test_kprobes.c
===================================================================
--- 2.6-mm.orig/tests/test_kprobes.c
+++ 2.6-mm/tests/test_kprobes.c
@@ -23,6 +23,7 @@
 static u32 rand1, preh_val, posth_val, jph_val;
 static int errors, handler_errors, num_tests;
 static u32 (*target)(u32 value);
+static u32 (*target2)(u32 value);

 static noinline u32 kprobe_target(u32 value)
 {
@@ -81,6 +82,84 @@ static int test_kprobe(void)
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
+	kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	ret = register_kprobes(kps, 2);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_kprobes returned %d\n", ret);
+		return ret;
+	}
+
+	preh_val = 0;
+	posth_val = 0;
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
@@ -121,6 +200,43 @@ static int test_jprobe(void)
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
+	jp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	ret = register_jprobes(jps, 2);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_jprobes returned %d\n", ret);
+		return ret;
+	}
+
+	jph_val = 0;
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

@@ -176,6 +292,63 @@ static int test_kretprobe(void)

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
+	rp.kp.addr = 0; /* addr should be cleard for reusing kprobe. */
+	ret = register_kretprobes(rps, 2);
+	if (ret < 0) {
+		printk(KERN_ERR "Kprobe smoke test failed: "
+				"register_kretprobe returned %d\n", ret);
+		return ret;
+	}
+
+	krph_val = 0;
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
@@ -183,6 +356,7 @@ int init_test_probes(void)
 	int ret;

 	target = kprobe_target;
+	target2 = kprobe_target2;

 	do {
 		rand1 = random32();
@@ -195,15 +369,30 @@ int init_test_probes(void)
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



