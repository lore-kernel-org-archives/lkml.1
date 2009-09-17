Return-Path: <linux-kernel-owner+w=401wt.eu-S1759674AbZIQHsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674AbZIQHsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759307AbZIQHrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:47:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:48478 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759289AbZIQHrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:47:49 -0400
Date: Thu, 17 Sep 2009 07:47:38 GMT
From: tip-bot for Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org, parag.lkml@gmail.com, hpa@zytor.com,
       mingo@redhat.com, rostedt@goodmis.org, srostedt@redhat.com,
       tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, parag.lkml@gmail.com,
       linux-kernel@vger.kernel.org, rostedt@goodmis.org, srostedt@redhat.com,
       tglx@linutronix.de
In-Reply-To: <f7848160909130815l3e768a30n3b28808bbe5c254b@mail.gmail.com>
References: <f7848160909130815l3e768a30n3b28808bbe5c254b@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: make testing syscall events a separate configuration
Message-ID: <tip-1f5a6b45416694ff8c0d04625f1a438a0e380add@git.kernel.org>
Git-Commit-ID: 1f5a6b45416694ff8c0d04625f1a438a0e380add
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 17 Sep 2009 07:47:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1f5a6b45416694ff8c0d04625f1a438a0e380add
Gitweb:     http://git.kernel.org/tip/1f5a6b45416694ff8c0d04625f1a438a0e380add
Author:     Steven Rostedt <srostedt@redhat.com>
AuthorDate: Mon, 14 Sep 2009 11:58:24 -0400
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Mon, 14 Sep 2009 11:58:24 -0400

tracing: make testing syscall events a separate configuration

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
