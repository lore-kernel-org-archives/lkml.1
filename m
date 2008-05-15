Return-Path: <linux-kernel-owner+w=401wt.eu-S1763959AbYEOVQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763959AbYEOVQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbYEOVPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:15:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754694AbYEOVPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:15:54 -0400
Date: Thu, 15 May 2008 14:15:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>, geert@linux-m68k.org,
       zippel@linux-m68k.org, schwab@suse.de, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH] init - fix building bug and potential buffer overflow
In-Reply-To: <20080515134928.83b2d948.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805151406030.3019@woody.linux-foundation.org>
References: <20080514154402.GF6902@cvg> <20080515105803.7c9ab8c7.akpm@linux-foundation.org> <20080515180528.GC7481@cvg> <Pine.LNX.4.64.0805152132530.22059@anakin> <aa79d98a0805151322s20a2bb34x4491bcacfcef310@mail.gmail.com>
 <20080515134928.83b2d948.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 May 2008, Andrew Morton wrote:
> 
> (yeah, I normally parenthesise sizeof too, but this provided 80-col
> salvation)

Why?

The nice way to provide 80-col salvation is to just fix the code. Instead 
of having complex nested loops, have a really trivial outer loop like

	for (call = __initcall_start; call < __initcall_end; call++)
		do_one_initcall(*call);

and then the code to actually do one of the initcalls is much simpler to 
read, and because it's not as indented, the 80-column issues just go away.

IOW, something like this (the diff looks ugly, but the end result is 
better).

Talking about cleanups, why the *hell* does print_fn_descriptor_symbol() 
take an "unsigned long", when every single user would want to give it a 
pointer?

Would somebody please want to move that cast into the macro (or better 
yet, make it an inline function that takes a 'void *'), and remove all the 
casts from the callers?

		Linus

---
 init/main.c |   78 +++++++++++++++++++++++++++++++----------------------------
 1 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/init/main.c b/init/main.c
index f406fef..0a1d65e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -695,53 +695,57 @@ __setup("initcall_debug", initcall_debug_setup);
 
 extern initcall_t __initcall_start[], __initcall_end[];
 
-static void __init do_initcalls(void)
+static void __init do_one_initcall(initcall_t call)
 {
-	initcall_t *call;
 	int count = preempt_count();
+	ktime_t t0, t1, delta;
+	char msgbuf[64];
+	int result;
+
+	if (initcall_debug) {
+		print_fn_descriptor_symbol("calling  %s()\n",
+				(unsigned long) call);
+		t0 = ktime_get();
+	}
 
-	for (call = __initcall_start; call < __initcall_end; call++) {
-		ktime_t t0, t1, delta;
-		char msgbuf[40];
-		int result;
+	result = call();
 
-		if (initcall_debug) {
-			print_fn_descriptor_symbol("calling  %s()\n",
-					(unsigned long) *call);
-			t0 = ktime_get();
-		}
+	if (initcall_debug) {
+		t1 = ktime_get();
+		delta = ktime_sub(t1, t0);
 
-		result = (*call)();
+		print_fn_descriptor_symbol("initcall %s()",
+				(unsigned long) call);
+		printk(" returned %d after %Ld msecs\n", result,
+			(unsigned long long) delta.tv64 >> 20);
+	}
 
-		if (initcall_debug) {
-			t1 = ktime_get();
-			delta = ktime_sub(t1, t0);
+	msgbuf[0] = 0;
 
-			print_fn_descriptor_symbol("initcall %s()",
-					(unsigned long) *call);
-			printk(" returned %d after %Ld msecs\n", result,
-				(unsigned long long) delta.tv64 >> 20);
-		}
+	if (result && result != -ENODEV && initcall_debug)
+		sprintf(msgbuf, "error code %d ", result);
 
-		msgbuf[0] = 0;
+	if (preempt_count() != count) {
+		strlcat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
+		preempt_count() = count;
+	}
+	if (irqs_disabled()) {
+		strlcat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
+		local_irq_enable();
+	}
+	if (msgbuf[0]) {
+		print_fn_descriptor_symbol(KERN_WARNING "initcall %s()",
+				(unsigned long) call);
+		printk(" returned with %s\n", msgbuf);
+	}
+}
 
-		if (result && result != -ENODEV && initcall_debug)
-			sprintf(msgbuf, "error code %d ", result);
+static void __init do_initcalls(void)
+{
+	initcall_t *call;
 
-		if (preempt_count() != count) {
-			strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
-			preempt_count() = count;
-		}
-		if (irqs_disabled()) {
-			strncat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
-			local_irq_enable();
-		}
-		if (msgbuf[0]) {
-			print_fn_descriptor_symbol(KERN_WARNING "initcall %s()",
-					(unsigned long) *call);
-			printk(" returned with %s\n", msgbuf);
-		}
-	}
+	for (call = __initcall_start; call < __initcall_end; call++)
+		do_one_initcall(*call);
 
 	/* Make sure there is no pending stuff from the initcall sequence */
 	flush_scheduled_work();
