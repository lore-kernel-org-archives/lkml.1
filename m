Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbZKYQ5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbZKYQ5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 11:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZKYQ5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 11:57:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879AbZKYQ5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 11:57:01 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v6 11/11] [RFC] kprobes/x86: Use text_poke_fixup() for
	jump optimization
To: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>, Andi Kleen <andi@firstfloor.org>,
       Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date: Wed, 25 Nov 2009 11:56:35 -0500
Message-ID: <20091125165635.6073.70212.stgit@harusame>
In-Reply-To: <20091125165510.6073.48721.stgit@harusame>
References: <20091125165510.6073.48721.stgit@harusame>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use text_poke_fixup() for jump optimization instead of text_poke_smp().

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Anders Kaseorg <andersk@ksplice.com>
Cc: Tim Abbott <tabbott@ksplice.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Jason Baron <jbaron@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
---

 arch/x86/kernel/kprobes.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index d865f8c..33e15cf 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -1376,12 +1376,8 @@ int __kprobes arch_optimize_kprobe(struct optimized_kprobe *op)
 	jmp_code[0] = RELATIVEJUMP_OPCODE;
 	*(s32 *)(&jmp_code[1]) = rel;
 
-	/*
-	 * text_poke_smp doesn't support NMI/MCE code modifying.
-	 * However, since kprobes itself also doesn't support NMI/MCE
-	 * code probing, it's not a problem.
-	 */
-	text_poke_smp(op->kp.addr, jmp_code, RELATIVEJUMP_SIZE);
+	text_poke_fixup(op->kp.addr, jmp_code, RELATIVEJUMP_SIZE,
+			op->optinsn.insn);
 	return 0;
 }
 
@@ -1393,7 +1389,7 @@ void __kprobes arch_unoptimize_kprobe(struct optimized_kprobe *op)
 	/* Set int3 to first byte for kprobes */
 	buf[0] = BREAKPOINT_INSTRUCTION;
 	memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
-	text_poke_smp(op->kp.addr, buf, RELATIVEJUMP_SIZE);
+	text_poke_fixup(op->kp.addr, buf, RELATIVEJUMP_SIZE, op->optinsn.insn);
 }
 
 static int  __kprobes setup_detour_execution(struct kprobe *p,


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
