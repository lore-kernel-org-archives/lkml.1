Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYG3BpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYG3BpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 21:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYG3Bn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 21:43:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38327 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbYG3Bnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 21:43:53 -0400
Message-Id: <20080730014351.429739409@goodmis.org>
References: <20080730012939.885172468@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 29 Jul 2008 21:29:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>,
       Arjan van de Ven <arjan@infradead.org>
Cc: Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] ftrace: warn on NMI calling code that may be modified
Content-Disposition: inline; filename=ftrace-nmi-warning.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dynamic ftrace code performs run time modification of the code text
section. This is not safe to do unless all other CPUS are halted. Because
there is no good way to halt NMIs while doing the modification, we must
make sure that the NMIs will not execute code that will be modified.

This patch adds a warning at the location that records code text that
will be modified later by the dynamic ftracer. It also disables the
modification from happening, so that the race with the NMI will not exist.

The kernel command line parameter "ftrace_keep_on_nmi" is defined to let
the user override the disabling of ftrace, at the risk that a very slight
race condition might crash the machine.  The command line still outputs
the warning, but doesn't disable ftrace.

The race that this protects is very hard to hit, but this patch adds detection
that the race exists and disables the code to prevent it.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 kernel/trace/ftrace.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

Index: linux-tip.git/kernel/trace/ftrace.c
===================================================================
--- linux-tip.git.orig/kernel/trace/ftrace.c	2008-07-28 20:15:15.000000000 -0400
+++ linux-tip.git/kernel/trace/ftrace.c	2008-07-29 17:06:55.000000000 -0400
@@ -36,6 +36,17 @@
 int ftrace_enabled __read_mostly;
 static int last_ftrace_enabled;
 
+static int ftrace_nmi_disabled __read_mostly;
+
+/* Let the user override disabling ftrace on NMI, at their own risk. */
+static int ftrace_keep_on_nmi __read_mostly;
+static int __init ftrace_keep_on_nmi_setup(char *str)
+{
+	ftrace_keep_on_nmi = 1;
+	return 1;
+}
+__setup("ftrace_keep_on_nmi", ftrace_keep_on_nmi_setup);
+
 /*
  * ftrace_disabled is set when an anomaly is discovered.
  * ftrace_disabled is much stronger than ftrace_enabled.
@@ -341,6 +352,30 @@ ftrace_record_ip(unsigned long ip)
 	int atomic;
 	int cpu;
 
+	if (!ftrace_nmi_disabled && in_nmi()) {
+		ftrace_nmi_disabled = 1;
+		printk(KERN_WARNING
+		       "\n--------------- cut here ---------------\n");
+		printk(KERN_WARNING
+		       "WARNING: ftraced code called from NMI context ");
+		print_symbol("%s\n", ip);
+		printk(KERN_WARNING
+		       "         Please report this to the ftrace maintainer.\n");
+		if (!ftrace_keep_on_nmi) {
+			ftrace_disabled = 1;
+			printk(KERN_WARNING
+			       "         Disabling ftraced. Boot with ftrace_keep_on_nmi"
+			       " to not disable.\n");
+		} else
+			printk(KERN_WARNING
+			       "         \"ftrace_keep_on_nmi\" set. Continuing to use"
+			       " dynamic ftrace,\n"
+			       "         but the system may be unstable\n");
+		dump_stack();
+		printk(KERN_WARNING
+		       "--------------- end cut here ---------------\n");
+	}
+
 	if (!ftrace_enabled || ftrace_disabled)
 		return;
 

-- 
