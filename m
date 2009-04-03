Return-Path: <linux-kernel-owner+w=401wt.eu-S935478AbZDCVWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935478AbZDCVWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 17:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbZDCVV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 17:21:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:50959 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbZDCVV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 17:21:56 -0400
Message-ID: <49D67DD9.2050008@redhat.com>
Date: Fri, 03 Apr 2009 17:21:29 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>
CC: ananth@in.ibm.com, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>, kvm@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -tip 4/6 V4.2] x86: kprobes checks safeness of insertion address.
References: <49D4F4E9.2030809@redhat.com> <20090403051854.GA4846@in.ibm.com>	 <49D63327.8020009@redhat.com> <1238779686.3568.18.camel@dyn9047018139.beaverton.ibm.com> <49D66166.9040002@redhat.com>
In-Reply-To: <49D66166.9040002@redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86: kprobes checks safeness of insertion address.

From: Masami Hiramatsu <mhiramat@redhat.com>

Ensure safeness of inserting kprobes by checking whether the specified
address is at the first byte of a instruction. This is done by decoding
probed function from its head to the probe point.

changes from v4.1:
 - update comments according to Jim's suggestion.
 - s/lookup_symbol_attrs/kallsyms_lookup/ in a comment.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/kernel/kprobes.c |   54 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)


diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 7b5169d..3d5e85f 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -48,12 +48,14 @@
 #include <linux/preempt.h>
 #include <linux/module.h>
 #include <linux/kdebug.h>
+#include <linux/kallsyms.h>

 #include <asm/cacheflush.h>
 #include <asm/desc.h>
 #include <asm/pgtable.h>
 #include <asm/uaccess.h>
 #include <asm/alternative.h>
+#include <asm/insn.h>

 void jprobe_return_end(void);

@@ -244,6 +246,56 @@ retry:
 	}
 }

+/* Recover the probed instruction at addr for further analysis. */
+static int recover_probed_instruction(kprobe_opcode_t *buf, unsigned long addr)
+{
+	struct kprobe *kp;
+	kp = get_kprobe((void *)addr);
+	if (!kp)
+		return -EINVAL;
+
+	/*
+	 * Don't use p->ainsn.insn, which could be modified -- e.g.,
+	 * by fix_riprel().
+	 */
+	memcpy(buf, kp->addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
+	buf[0] = kp->opcode;
+	return 0;
+}
+
+/* Dummy buffers for kallsyms_lookup */
+static char __dummy_buf[KSYM_NAME_LEN];
+
+/* Check if paddr is at an instruction boundary */
+static int __kprobes can_probe(unsigned long paddr)
+{
+	int ret;
+	unsigned long addr, offset = 0;
+	struct insn insn;
+	kprobe_opcode_t buf[MAX_INSN_SIZE];
+
+	/* Lookup symbol including addr */
+	if (!kallsyms_lookup(paddr, NULL, &offset, NULL, __dummy_buf))
+		return 0;
+
+	/* Decode instructions */
+	addr = paddr - offset;
+	while (addr < paddr) {
+		insn_init_kernel(&insn, (void *)addr);
+		insn_get_opcode(&insn);
+		if (OPCODE1(&insn) == BREAKPOINT_INSTRUCTION) {
+			ret = recover_probed_instruction(buf, addr);
+			if (ret)
+				return 0;
+			insn_init_kernel(&insn, buf);
+		}
+		insn_get_length(&insn);
+		addr += insn.length;
+	}
+
+	return (addr == paddr);
+}
+
 /*
  * Returns non-zero if opcode modifies the interrupt flag.
  */
@@ -359,6 +411,8 @@ static void __kprobes arch_copy_kprobe(struct kprobe *p)

 int __kprobes arch_prepare_kprobe(struct kprobe *p)
 {
+	if (!can_probe((unsigned long)p->addr))
+		return -EILSEQ;
 	/* insn: must be on special executable page on x86. */
 	p->ainsn.insn = get_insn_slot();
 	if (!p->ainsn.insn)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

