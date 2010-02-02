Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab0BBVmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 16:42:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756822Ab0BBVmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 16:42:05 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 3/4] kprobes: Check probe address is reserved
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       =?utf-8?q?Przemys=C5=82aw?= =?utf-8?q?Pawe=C5=82czyk?= 
	<przemyslaw@pawelczyk.it>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jason Baron <jbaron@redhat.com>
Date: Tue, 02 Feb 2010 16:49:18 -0500
Message-ID: <20100202214918.4694.94179.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20100202214856.4694.72709.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check whether the address of new probe is already reserved by ftrace
or alternatives (on x86) when registering new probe.
If reserved, it returns an error and not register the probe.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Przemysław Pawełczyk <przemyslaw@pawelczyk.it>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
CC: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Jason Baron <jbaron@redhat.com>
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


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
