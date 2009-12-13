Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbZLMVum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbZLMVum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 16:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZLMVum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 16:50:42 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:55352 "HELO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751966AbZLMVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 16:50:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lLXxYz4Ezb3iPg1F8zFLBR+g69eVh59m5TRHqyPBCaMwQm4RjV8cOP9B5ffwJaIWWX
         KqT0sOrBwNd80e/BxcVoKAUPPGw4/v/qXsjVjTKHIIPYwqWJq3qI2nq/pLwKSlmnICi8
         ZSw0yLOycnm8KsmjW/a3kk7Vj0bVWyTml1AQI=
Date: Sun, 13 Dec 2009 16:04:38 -0600
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org
Subject: [PATCH] x86: Fix kprobes build with non-gawk awk
Message-ID: <20091213220437.GA27718@progeny.tock>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: x86@kernel.org
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
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
-- 
1.6.5.4

