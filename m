Return-Path: <linux-kernel-owner+w=401wt.eu-S1764894AbXLQV2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764894AbXLQV2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 16:28:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764822AbXLQV1S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 16:27:18 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:21847 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762408AbXLQV1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:27:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=l8eQbBrv+tscM4s+MJ52gV2pu1Ch/YJWCiJqShVmK94mWiQ8EKxAqjwVmkF9VrfEIPaUuLhKNrRJYPhgggtR/c+ugOq+keLDrZiP8aiSBgb+/8Sxlip8zVADk4gwdkAfrEe+jgG/+x0hzJ61a4Dn0l/qfhDbgM2SV7lma8LEVUE=
Subject: [PATCH 2/4] x86: kprobe cleanup resume_execution
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>, Roland McGrath <roland@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>, prasanna@in.ibm.com,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 13:27:01 -0800
Message-Id: <1197926821.23402.29.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up and fixes bugs in resume_execution on x86-64.
Kprobes for x86-64 may cause a kernel crash if it inserted on "iret"
instruction.

"call absolute" case 0x9a is invalid on x86-64, so we don't need
treat it, leave it ifdef X86_32.

 - Add "iret"(0xcf) case.to X86_64
 - Fold jmp absolute (0xea) handling into iret/ret/lret handling

Based on patch from Masami Hiramatsu <mhiramat@redhat.com>

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/kprobes.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index 9130c01..64c702c 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -748,12 +748,13 @@ static void __kprobes resume_execution(struct kprobe *p,
 		*tos &= ~(TF_MASK | IF_MASK);
 		*tos |= kcb->kprobe_old_flags;
 		break;
-	case 0xc2:		/* ret/lret */
+	case 0xc2:		/* iret/ret/lret */
 	case 0xc3:
 	case 0xca:
 	case 0xcb:
+	case 0xcf:
+	case 0xea:		/* jmp absolute -- ip is correct */
 #ifdef CONFIG_X86_32
-	case 0xcf:		/* iret */
 		/* ip is already adjusted, no more changes required */
 		p->ainsn.boostable = 1;
 #endif
@@ -783,12 +784,6 @@ static void __kprobes resume_execution(struct kprobe *p,
 			goto no_change;
 		}
 		break;
-	case 0xea:		/* jmp absolute -- ip is correct */
-#ifdef CONFIG_X86_32
-		/* ip is already adjusted, no more changes required */
-		p->ainsn.boostable = 1;
-#endif
-		goto no_change;
 	default:
 		break;
 	}
-- 
1.5.4.rc0.1083.gf568


