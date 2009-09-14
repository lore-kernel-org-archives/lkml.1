Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZINQfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZINQfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbZINQfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:35:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:53315 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbZINQef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:34:35 -0400
Message-Id: <20090914163437.724034552@goodmis.org>
References: <20090914163355.162375454@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 14 Sep 2009 12:34:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Parag Warudkar <parag.lkml@gmail.com>
Subject: [PATCH 6/6] tracing: make testing syscall events a separate configuration
Content-Disposition: inline; filename=0006-tracing-make-testing-syscall-events-a-separate-confi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Parag noticed that the number of event tests has increased tremendously:

grep "Testing event" dmesg.31rc9 |wc -l
100

grep "Testing event" dmesg.31git |wc -l
1172

This is due to the testing of every syscall event when ftrace self
test is enabled. This adds a bit more time to kernel boot up and can
affect development by slowing down the time it takes between reboots.

This option makes the testing of the syscall events into a separate
config, to still be able to test most of ftrace internals at boot up
but not have to wait for all the syscall events to be tested.

The syscall event testing only tests the enabling and disabling of
the trace point, since the syscalls are not executed. What really needs
to be done is to somehow have a userspace tool test the syscall tracepoints
as well.

Reported-by: Parag Warudkar <parag.lkml@gmail.com>
LKML-Reference: <f7848160909130815l3e768a30n3b28808bbe5c254b@mail.gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/Kconfig        |   12 ++++++++++++
 kernel/trace/trace_events.c |   12 ++++++++++++
 2 files changed, 24 insertions(+), 0 deletions(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 1ea0d12..aa002ce 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -469,6 +469,18 @@ config FTRACE_STARTUP_TEST
 	  functioning properly. It will do tests on all the configured
 	  tracers of ftrace.
 
+config EVENT_TRACE_TEST_SYSCALLS
+	bool "Run selftest on syscall events"
+	depends on FTRACE_STARTUP_TEST
+	help
+	 This option will also enable testing every syscall event.
+	 It only enables the event and disables it and runs various loads
+	 with the event enabled. This adds a bit more time for kernel boot
+	 up since it runs this on every system call defined.
+
+	 TBD - enable a way to actually call the syscalls as we test their
+	       events
+
 config MMIOTRACE
 	bool "Memory mapped IO tracing"
 	depends on HAVE_MMIOTRACE_SUPPORT && PCI
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0fa8f9f..787f0fb 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1326,6 +1326,18 @@ static __init void event_trace_self_tests(void)
 		if (!call->regfunc)
 			continue;
 
+/*
+ * Testing syscall events here is pretty useless, but
+ * we still do it if configured. But this is time consuming.
+ * What we really need is a user thread to perform the
+ * syscalls as we test.
+ */
+#ifndef CONFIG_EVENT_TRACE_TEST_SYSCALLS
+		if (call->system &&
+		    strcmp(call->system, "syscalls") == 0)
+			continue;
+#endif
+
 		pr_info("Testing event %s: ", call->name);
 
 		/*
-- 
1.6.3.3

-- 
