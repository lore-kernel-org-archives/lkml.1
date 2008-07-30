Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbYG3Bpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbYG3Bpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbYG3Bn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:43:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38337 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbYG3Bnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:43:53 -0400
Message-Id: <20080730014351.248109376@goodmis.org>
References: <20080730012939.885172468@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 21:29:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 4/5] ftrace: do not trace nmi callers in kernel directory
Content-Disposition: inline; filename=ftrace-no-trace-nmi-kernel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dynamic ftrace code performs run time modification of the code text
section. This is not safe to do unless all other CPUS are halted. Because
there is no good way to halt NMIs while doing the modification, we must
make sure that the NMIs will not execute code that will be modified.

This patch adds notrace annotation to functions called by NMIs in the
kernel directory.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/Makefile |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-tip.git/kernel/Makefile
===================================================================
--- linux-tip.git.orig/kernel/Makefile	2008-07-29 20:13:14.000000000 -0400
+++ linux-tip.git/kernel/Makefile	2008-07-29 20:33:51.000000000 -0400
@@ -15,6 +15,8 @@ CFLAGS_REMOVE_sched.o = -mno-spe
 
 ifdef CONFIG_FTRACE
 # Do not trace debug files and internal ftrace files
+CFLAGS_REMOVE_kprobes.o = -pg
+CFLAGS_REMOVE_test_kprobes.o = -pg
 CFLAGS_REMOVE_lockdep.o = -pg
 CFLAGS_REMOVE_lockdep_proc.o = -pg
 CFLAGS_REMOVE_mutex-debug.o = -pg
@@ -22,6 +24,11 @@ CFLAGS_REMOVE_rtmutex-debug.o = -pg
 CFLAGS_REMOVE_cgroup-debug.o = -pg
 CFLAGS_REMOVE_sched_clock.o = -pg
 CFLAGS_REMOVE_sched.o = -mno-spe -pg
+ifdef CONFIG_DYNAMIC_FTRACE
+# NMI called files
+CFLAGS_REMOVE_notifier.o = -pg
+CFLAGS_REMOVE_spinlock.o = -pg
+endif
 endif
 
 obj-$(CONFIG_PROFILING) += profile.o

-- 
