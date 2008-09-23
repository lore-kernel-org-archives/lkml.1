Return-Path: <linux-kernel-owner+w=401wt.eu-S1751351AbYIWJcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbYIWJcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:32:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbYIWJci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:32:38 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:10284 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYIWJch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:32:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=IGJGUkCa6dI/kmVYla+Qk/C1pZF88LpTZXApz3M7ipZPPaL0fv0npi2/FrP87CweTK
         NKTk7DTZrF27eHN4jN3zVVCIO9qFxXvEnNJEEgvrXgGREt3MfEVeDbt5vt9MZ5SZQ8Do
         gCOZ2Oat/VfzRxtJKDCoJAEqGApfz17SBgC7k=
Message-ID: <48D8C71A.7080204@gmail.com>
Date: Tue, 23 Sep 2008 11:38:18 +0100
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Steven Noonan <steven@uplinklabs.net>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [Patch -tip 4/4] Tracing/ftrace: Launch initcall tracing after pre-smp
 initcalls.
Content-Type: multipart/mixed;
 boundary="------------060703030105030100090102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060703030105030100090102
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Launch the initcall tracing inside the initcall_debug area. Old printk have not been
removed to keep the old way of initcall tracing for backward compatibility.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---

--------------060703030105030100090102
Content-Type: text/plain;
 name="patch4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch4.diff"

diff --git a/init/main.c b/init/main.c
index a9e36fb..a90d4f5 100644
--- a/init/main.c
+++ b/init/main.c
@@ -724,9 +724,12 @@ int do_one_initcall(initcall_t fn)
 	ktime_t t0, t1, delta;
 	char msgbuf[64];
 	int result;
+	struct initcall_trace it;
 
 	if (initcall_debug) {
-		printk("calling  %pF @ %i\n", fn, task_pid_nr(current));
+		it.caller = task_pid_nr(current);
+		it.func = fn;
+		printk("calling  %pF @ %i\n", fn, it.caller);
 		t0 = ktime_get();
 	}
 
@@ -735,9 +738,11 @@ int do_one_initcall(initcall_t fn)
 	if (initcall_debug) {
 		t1 = ktime_get();
 		delta = ktime_sub(t1, t0);
-
+		it.result = result;
+		it.duration = (unsigned long long) delta.tv64 >> 20;
 		printk("initcall %pF returned %d after %Ld msecs\n", fn,
-			result, (unsigned long long) delta.tv64 >> 20);
+			result, it.duration);
+		trace_initcall(&it);
 	}
 
 	msgbuf[0] = 0;
@@ -947,6 +952,7 @@ static int __init kernel_init(void * unused)
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
+	start_initcall_trace();
 
 	smp_init();
 	sched_init_smp();

--------------060703030105030100090102--
