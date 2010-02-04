Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab0BDJ5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:57:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:60117 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389Ab0BDJ5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 04:57:04 -0500
Date: Thu, 4 Feb 2010 09:55:40 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jkenisto@us.ibm.com, ananth@in.ibm.com,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, compudj@krystal.dyndns.org, jbaron@redhat.com,
       tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu,
       systemtap@sources.redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, ananth@in.ibm.com,
       dle-develop@lists.sourceforge.net, fweisbec@gmail.com,
       rostedt@goodmis.org, compudj@krystal.dyndns.org, jbaron@redhat.com,
       tglx@linutronix.de, mhiramat@redhat.com, systemtap@sources.redhat.com,
       mingo@elte.hu
In-Reply-To: <20100202214918.4694.94179.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100202214918.4694.94179.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Check probe address is reserved
Message-ID: <tip-4554dbcb85a4ed2abaa2b6fa15649b796699ec89@git.kernel.org>
Git-Commit-ID: 4554dbcb85a4ed2abaa2b6fa15649b796699ec89
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 04 Feb 2010 09:55:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4554dbcb85a4ed2abaa2b6fa15649b796699ec89
Gitweb:     http://git.kernel.org/tip/4554dbcb85a4ed2abaa2b6fa15649b796699ec89
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Tue, 2 Feb 2010 16:49:18 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 4 Feb 2010 09:36:19 +0100

kprobes: Check probe address is reserved

Check whether the address of new probe is already reserved by
ftrace or alternatives (on x86) when registering new probe.
If reserved, it returns an error and not register the probe.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: przemyslaw@pawelczyk.it
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jason Baron <jbaron@redhat.com>
LKML-Reference: <20100202214918.4694.94179.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/kprobes.c |    3 +++
 kernel/kprobes.c          |    4 +++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 9453815..5de9f4a 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -337,6 +337,9 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)
 
 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
+	if (alternatives_text_reserved(p->addr, p->addr))
+		return -EINVAL;
+
 	if (!can_probe((unsigned long)p->addr))
 		return -EILSEQ;
 	/* insn: must be on special executable page on x86. */
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 9907a03..c3340e8 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -44,6 +44,7 @@
 #include <linux/debugfs.h>
 #include <linux/kdebug.h>
 #include <linux/memory.h>
+#include <linux/ftrace.h>
 
 #include <asm-generic/sections.h>
 #include <asm/cacheflush.h>
@@ -703,7 +704,8 @@ int __kprobes register_kprobe(struct kprobe *p)
 
 	preempt_disable();
 	if (!kernel_text_address((unsigned long) p->addr) ||
-	    in_kprobes_functions((unsigned long) p->addr)) {
+	    in_kprobes_functions((unsigned long) p->addr) ||
+	    ftrace_text_reserved(p->addr, p->addr)) {
 		preempt_enable();
 		return -EINVAL;
 	}
