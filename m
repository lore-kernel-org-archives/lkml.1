Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab0BQLor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 06:44:47 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:22359 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab0BQLm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 06:42:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=KvS6yc4l87hK/WkQNBtOiDWF0wqt6tCgj0MlXZn532D77CXuFGGahW5tpSVdbFqQVv
         slSt9EDTCrMTfZteaZwv9EuZzjk9H6yk64RG0RM53o0o1vsk5PjFrgR6n4GCRGY28xPf
         bJ7ZwFks2ZY3PLtWg7MdOdlIXd2/cLmMhswv0=
From: Luca Barbieri <luca@luca-barbieri.com>
To: mingo@elte.hu
Cc: hpa@zytor.com, a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Luca Barbieri <luca@luca-barbieri.com>
Subject: [PATCH 02/10] x86: add support for relative CALL and JMP in alternatives
Date: Wed, 17 Feb 2010 12:42:34 +0100
Message-Id: <1266406962-17463-3-git-send-email-luca@luca-barbieri.com>
X-Mailer: git-send-email 1.6.6.1.476.g01ddb
In-Reply-To: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
References: <1266406962-17463-1-git-send-email-luca@luca-barbieri.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently CALL and JMP cannot be used in alternatives because the
relative offset would be wrong.

This patch uses the existing x86 instruction parser to parse the
alternative sequence and fix up the displacements.

This allows to implement this feature with minimal code.

Signed-off-by: Luca Barbieri <luca@luca-barbieri.com>
---
 arch/x86/kernel/alternative.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index de7353c..7464c7e 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -17,6 +17,7 @@
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 #include <asm/fixmap.h>
+#include <asm/insn.h>
 
 #define MAX_PATCH_LEN (255-1)
 
@@ -195,6 +196,26 @@ extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern u8 *__smp_locks[], *__smp_locks_end[];
 static void *text_poke_early(void *addr, const void *opcode, size_t len);
 
+/* Fix call instruction displacements */
+static void __init_or_module fixup_relative_addresses(char *buf, size_t size, size_t adj)
+{
+	struct insn insn;
+	char *p = buf;
+	char *end = p + size;
+	while (p < end) {
+		kernel_insn_init(&insn, p);
+		insn_get_opcode(&insn);
+
+		/* CALL or JMP near32 */
+		if (insn.opcode.bytes[0] == 0xe8 || insn.opcode.bytes[0] == 0xe9) {
+			size_t disp_off = insn.next_byte - insn.kaddr;
+			*(unsigned *)(p + disp_off) += adj;
+		}
+		insn_get_length(&insn);
+		p += insn.length;
+	}
+}
+
 /* Replace instructions with better alternatives for this CPU type.
    This runs before SMP is initialized to avoid SMP problems with
    self modifying code. This implies that assymetric systems where
@@ -223,6 +244,7 @@ void __init_or_module apply_alternatives(struct alt_instr *start,
 		}
 #endif
 		memcpy(insnbuf, a->replacement, a->replacementlen);
+		fixup_relative_addresses(insnbuf, a->replacementlen, a->replacement - instr);
 		add_nops(insnbuf + a->replacementlen,
 			 a->instrlen - a->replacementlen);
 		text_poke_early(instr, insnbuf, a->instrlen);
-- 
1.6.6.1.476.g01ddb

