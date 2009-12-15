Return-Path: <linux-kernel-owner+w=401wt.eu-S933632AbZLOUbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632AbZLOUbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:31:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933622AbZLOUbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:31:46 -0500
Received: from hera.kernel.org ([140.211.167.34]:34963 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738AbZLOUbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:31:45 -0500
Date: Tue, 15 Dec 2009 20:30:40 GMT
From: tip-bot for Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, jkenisto@us.ibm.com, jrnieder@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jkenisto@us.ibm.com, fweisbec@gmail.com, jrnieder@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091213220437.GA27718@progeny.tock>
References: <20091213220437.GA27718@progeny.tock>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix kprobes build with non-gawk awk
Message-ID: <tip-23637568ad0c9b5ab0ad27d2f2f26d1e9282c527@git.kernel.org>
Git-Commit-ID: 23637568ad0c9b5ab0ad27d2f2f26d1e9282c527
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23637568ad0c9b5ab0ad27d2f2f26d1e9282c527
Gitweb:     http://git.kernel.org/tip/23637568ad0c9b5ab0ad27d2f2f26d1e9282c527
Author:     Jonathan Nieder <jrnieder@gmail.com>
AuthorDate: Sun, 13 Dec 2009 16:04:38 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Dec 2009 20:35:49 +0100

x86: Fix kprobes build with non-gawk awk

The instruction attribute table generator fails when run by mawk
or original-awk:

 $ mawk -f arch/x86/tools/gen-insn-attr-x86.awk \
	arch/x86/lib/x86-opcode-map.txt > /dev/null
 Semantic error at 240: Second IMM error
 $ echo $?
 1

Line 240 contains "c8: ENTER Iw,Ib", which indicates that this
instruction has two immediate operands, the second of which is
one byte.  The script loops through the immediate operands using
a for loop.

Unfortunately, there is no guarantee in awk that a for (variable
in array) loop will return the indices in increasing order.
Internally, both original-awk and mawk iterate over a hash table
for this purpose, and both implementations happen to produce the
index 2 before 1.  The supposed second immediate operand is more
than one byte wide, producing the error.

So loop over the indices in increasing order instead.  As a
side-effect, with mawk this means the silly two-entry hash table
never has to be built.

Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Acked-by Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091213220437.GA27718@progeny.tock>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/tools/gen-insn-attr-x86.awk |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
index e34e92a..7a68506 100644
--- a/arch/x86/tools/gen-insn-attr-x86.awk
+++ b/arch/x86/tools/gen-insn-attr-x86.awk
@@ -226,12 +226,12 @@ function add_flags(old,new) {
 }
 
 # convert operands to flags.
-function convert_operands(opnd,       i,imm,mod)
+function convert_operands(count,opnd,       i,j,imm,mod)
 {
 	imm = null
 	mod = null
-	for (i in opnd) {
-		i  = opnd[i]
+	for (j = 1; j <= count; j++) {
+		i = opnd[j]
 		if (match(i, imm_expr) == 1) {
 			if (!imm_flag[i])
 				semantic_error("Unknown imm opnd: " i)
@@ -282,8 +282,8 @@ function convert_operands(opnd,       i,imm,mod)
 		# parse one opcode
 		if (match($i, opnd_expr)) {
 			opnd = $i
-			split($(i++), opnds, ",")
-			flags = convert_operands(opnds)
+			count = split($(i++), opnds, ",")
+			flags = convert_operands(count, opnds)
 		}
 		if (match($i, ext_expr))
 			ext = $(i++)
