Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbYFFOOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbYFFOOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 10:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbYFFOOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 10:14:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbYFFOOO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 10:14:14 -0400
Message-ID: <484944C8.9000208@redhat.com>
Date: Fri, 06 Jun 2008 10:08:08 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, David Miller <davem@davemloft.net>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 1/2] kprobes: indirectly call kprobe_target
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call kprobe_target indirectly. This prevents gcc to unroll
a noinline function in caller function.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
CC: Jim Keniston <jkenisto@us.ibm.com>
CC: David Miller <davem@davemloft.net>
---
I ported patches which had been discussed on
http://sources.redhat.com/bugzilla/show_bug.cgi?id=3542

 tests/test_kprobes.c |   21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

Index: 2.6.26-rc2-mm1/tests/test_kprobes.c
===================================================================
--- 2.6.26-rc2-mm1.orig/tests/test_kprobes.c
+++ 2.6.26-rc2-mm1/tests/test_kprobes.c
@@ -22,21 +22,10 @@

 static u32 rand1, preh_val, posth_val, jph_val;
 static int errors, handler_errors, num_tests;
+static u32 (*target)(u32 value);

 static noinline u32 kprobe_target(u32 value)
 {
-	/*
-	 * gcc ignores noinline on some architectures unless we stuff
-	 * sufficient lard into the function. The get_kprobe() here is
-	 * just for that.
-	 *
-	 * NOTE: We aren't concerned about the correctness of get_kprobe()
-	 * here; hence, this call is neither under !preempt nor with the
-	 * kprobe_mutex held. This is fine(tm)
-	 */
-	if (get_kprobe((void *)0xdeadbeef))
-		printk(KERN_INFO "Kprobe smoke test: probe on 0xdeadbeef!\n");
-
 	return (value / div_factor);
 }

@@ -74,7 +63,7 @@ static int test_kprobe(void)
 		return ret;
 	}

-	ret = kprobe_target(rand1);
+	ret = target(rand1);
 	unregister_kprobe(&kp);

 	if (preh_val == 0) {
@@ -121,7 +110,7 @@ static int test_jprobe(void)
 		return ret;
 	}

-	ret = kprobe_target(rand1);
+	ret = target(rand1);
 	unregister_jprobe(&jp);
 	if (jph_val == 0) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
@@ -177,7 +166,7 @@ static int test_kretprobe(void)
 		return ret;
 	}

-	ret = kprobe_target(rand1);
+	ret = target(rand1);
 	unregister_kretprobe(&rp);
 	if (krph_val != rand1) {
 		printk(KERN_ERR "Kprobe smoke test failed: "
@@ -193,6 +182,8 @@ int init_test_probes(void)
 {
 	int ret;

+	target = kprobe_target;
+
 	do {
 		rand1 = random32();
 	} while (rand1 <= div_factor);

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

