Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbZJQAH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbZJQAH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 20:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZJQAH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 20:07:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbZJQAHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 20:07:25 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip tracing/kprobes 4/9] x86: Add AMD prefetch and 3DNow!
	opcodes to opcode map
To: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Date: Fri, 16 Oct 2009 20:07:44 -0400
Message-ID: <20091017000744.16556.27881.stgit@dhcp-100-2-132.bos.redhat.com>
In-Reply-To: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000711.16556.69935.stgit@dhcp-100-2-132.bos.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add AMD prefetch and 3DNow! opcode including FEMMS. Since 3DNow!
uses the last immediate byte as an opcode extension byte, x86 insn
just treats the extenstion byte as an immediate byte instead of
a part of opcode (insn_get_opcode() decodes first "0x0f 0x0f"
bytes.)
Users who are interested in analyzing 3DNow! opcode still can
decode it by analyzing the immediate byte.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
---

 arch/x86/lib/x86-opcode-map.txt |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index e7285d8..894497f 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -306,9 +306,10 @@ Referrer: 2-byte escape
 0a:
 0b: UD2 (1B)
 0c:
-0d: NOP Ev
-0e:
-0f:
+0d: NOP Ev | GrpP
+0e: FEMMS
+# 3DNow! uses the last imm byte as opcode extension.
+0f: 3DNow! Pq,Qq,Ib
 # 0x0f 0x10-0x1f
 10: movups Vps,Wps | movss Vss,Wss (F3) | movupd Vpd,Wpd (66) | movsd Vsd,Wsd (F2)
 11: movups Wps,Vps | movss Wss,Vss (F3) | movupd Wpd,Vpd (66) | movsd Wsd,Vsd (F2)
@@ -813,6 +814,12 @@ GrpTable: Grp16
 3: prefetch T2
 EndTable
 
+# AMD's Prefetch Group
+GrpTable: GrpP
+0: PREFETCH
+1: PREFETCHW
+EndTable
+
 GrpTable: GrpPDLK
 0: MONTMUL
 1: XSHA1


-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com
