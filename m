Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbZJQKGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbZJQKGL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Oct 2009 06:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbZJQKGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Oct 2009 06:06:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:33101 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbZJQKGA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Oct 2009 06:06:00 -0400
Date: Sat, 17 Oct 2009 10:05:42 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20091017000744.16556.27881.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20091017000744.16556.27881.stgit@dhcp-100-2-132.bos.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/probes] x86: Add AMD prefetch and 3DNow! opcodes to opcode map
Message-ID: <tip-d1baf5a5a6088e2991b7dbbd370ff200bd6615ce@git.kernel.org>
Git-Commit-ID: d1baf5a5a6088e2991b7dbbd370ff200bd6615ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 17 Oct 2009 10:05:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1baf5a5a6088e2991b7dbbd370ff200bd6615ce
Gitweb:     http://git.kernel.org/tip/d1baf5a5a6088e2991b7dbbd370ff200bd6615ce
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Fri, 16 Oct 2009 20:07:44 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 17 Oct 2009 09:53:59 +0200

x86: Add AMD prefetch and 3DNow! opcodes to opcode map

Add AMD prefetch and 3DNow! opcode including FEMMS. Since 3DNow!
uses the last immediate byte as an opcode extension byte, x86
insn just treats the extenstion byte as an immediate byte
instead of a part of opcode (insn_get_opcode() decodes first
"0x0f 0x0f" bytes.)

Users who are interested in analyzing 3DNow! opcode still can
decode it by analyzing the immediate byte.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20091017000744.16556.27881.stgit@dhcp-100-2-132.bos.redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
