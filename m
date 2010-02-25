Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933423Ab0BYTbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:31:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:33926 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932825Ab0BYTbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:31:09 -0500
Date: Thu, 25 Feb 2010 19:29:32 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: mingo@redhat.com, andersk@ksplice.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, rostedt@goodmis.org,
       compudj@krystal.dyndns.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jkenisto@us.ibm.com,
       andi@firstfloor.org, tabbott@ksplice.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, andersk@ksplice.com, fweisbec@gmail.com,
       dle-develop@lists.sourceforge.net, rostedt@goodmis.org,
       compudj@krystal.dyndns.org, jbaron@redhat.com, tglx@linutronix.de,
       mhiramat@redhat.com, systemtap@sources.redhat.com,
       linux-kernel@vger.kernel.org, hpa@zytor.com, jkenisto@us.ibm.com,
       andi@firstfloor.org, tabbott@ksplice.com, hch@infradead.org,
       ananth@in.ibm.com, srikar@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20100225133438.6725.80273.stgit@localhost6.localdomain6>
References: <20100225133438.6725.80273.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Add text_poke_smp for SMP cross modifying code
Message-ID: <tip-3d55cc8a058ee96291d6d45b1e35121b9920eca3@git.kernel.org>
Git-Commit-ID: 3d55cc8a058ee96291d6d45b1e35121b9920eca3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 19:29:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3d55cc8a058ee96291d6d45b1e35121b9920eca3
Gitweb:     http://git.kernel.org/tip/3d55cc8a058ee96291d6d45b1e35121b9920eca3
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Thu, 25 Feb 2010 08:34:38 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 17:49:26 +0100

x86: Add text_poke_smp for SMP cross modifying code

Add generic text_poke_smp for SMP which uses stop_machine()
to synchronize modifying code.
This stop_machine() method is officially described at "7.1.3
Handling Self- and Cross-Modifying Code" on the intel's
software developer's manual 3A.

Since stop_machine() can't protect code against NMI/MCE, this
function can not modify those handlers. And also, this function
is basically for modifying multibyte-single-instruction. For
modifying multibyte-multi-instructions, we need another special
trap & detour code.

This code originaly comes from immediate values with
stop_machine() version. Thanks Jason and Mathieu!

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: systemtap <systemtap@sources.redhat.com>
Cc: DLE <dle-develop@lists.sourceforge.net>
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
LKML-Reference: <20100225133438.6725.80273.stgit@localhost6.localdomain6>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/alternative.h |    4 ++-
 arch/x86/kernel/alternative.c      |   60 ++++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/alternative.h b/arch/x86/include/asm/alternative.h
index ac80b7d..643d6ab 100644
--- a/arch/x86/include/asm/alternative.h
+++ b/arch/x86/include/asm/alternative.h
@@ -160,10 +160,12 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
  * invalid instruction possible) or if the instructions are changed from a
  * consistent state to another consistent state atomically.
  * More care must be taken when modifying code in the SMP case because of
- * Intel's errata.
+ * Intel's errata. text_poke_smp() takes care that errata, but still
+ * doesn't support NMI/MCE handler code modifying.
  * On the local CPU you need to be protected again NMI or MCE handlers seeing an
  * inconsistent instruction while you patch.
  */
 extern void *text_poke(void *addr, const void *opcode, size_t len);
+extern void *text_poke_smp(void *addr, const void *opcode, size_t len);
 
 #endif /* _ASM_X86_ALTERNATIVE_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index e63b80e..c41f13c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -7,6 +7,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/memory.h>
+#include <linux/stop_machine.h>
 #include <asm/alternative.h>
 #include <asm/sections.h>
 #include <asm/pgtable.h>
@@ -570,3 +571,62 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	local_irq_restore(flags);
 	return addr;
 }
+
+/*
+ * Cross-modifying kernel text with stop_machine().
+ * This code originally comes from immediate value.
+ */
+static atomic_t stop_machine_first;
+static int wrote_text;
+
+struct text_poke_params {
+	void *addr;
+	const void *opcode;
+	size_t len;
+};
+
+static int __kprobes stop_machine_text_poke(void *data)
+{
+	struct text_poke_params *tpp = data;
+
+	if (atomic_dec_and_test(&stop_machine_first)) {
+		text_poke(tpp->addr, tpp->opcode, tpp->len);
+		smp_wmb();	/* Make sure other cpus see that this has run */
+		wrote_text = 1;
+	} else {
+		while (!wrote_text)
+			smp_rmb();
+		sync_core();
+	}
+
+	flush_icache_range((unsigned long)tpp->addr,
+			   (unsigned long)tpp->addr + tpp->len);
+	return 0;
+}
+
+/**
+ * text_poke_smp - Update instructions on a live kernel on SMP
+ * @addr: address to modify
+ * @opcode: source of the copy
+ * @len: length to copy
+ *
+ * Modify multi-byte instruction by using stop_machine() on SMP. This allows
+ * user to poke/set multi-byte text on SMP. Only non-NMI/MCE code modifying
+ * should be allowed, since stop_machine() does _not_ protect code against
+ * NMI and MCE.
+ *
+ * Note: Must be called under get_online_cpus() and text_mutex.
+ */
+void *__kprobes text_poke_smp(void *addr, const void *opcode, size_t len)
+{
+	struct text_poke_params tpp;
+
+	tpp.addr = addr;
+	tpp.opcode = opcode;
+	tpp.len = len;
+	atomic_set(&stop_machine_first, 1);
+	wrote_text = 0;
+	stop_machine(stop_machine_text_poke, (void *)&tpp, NULL);
+	return addr;
+}
+
