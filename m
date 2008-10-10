Return-Path: <linux-kernel-owner+w=401wt.eu-S1754967AbYJJCTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbYJJCTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 22:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbYJJCTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 22:19:33 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:63760 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999AbYJJCTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 22:19:32 -0400
Date: Thu, 9 Oct 2008 22:19:08 -0400 (EDT)
From: Anders Kaseorg <andersk@MIT.EDU>
To: Ingo Molnar <mingo@elte.hu>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: Make ftrace_test_p6nop disassembler-friendly
Message-ID: <alpine.DEB.2.00.0810092209460.21569@vinegar-pot.mit.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4c3dc21b136f8cb4b72afee16c3ba7e961656c0b in tip introduced the
5-byte NOP ftrace_test_p6nop:
  jmp . + 5
  .byte 0x00, 0x00, 0x00
This is not friendly to disassemblers because an odd number of 0x00s
ends in the middle of an instruction boundary.  This changes the 0x00s
to 1-byte NOPs (0x90).

Signed-off-by: Anders Kaseorg <andersk@mit.edu>

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 222507e..d073d98 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -132,7 +132,9 @@ int __init ftrace_dyn_arch_init(void *data)
 		".section .text, \"ax\"\n"
 		"ftrace_test_jmp:"
 		"jmp ftrace_test_p6nop\n"
-		".byte 0x00,0x00,0x00\n"  /* 2 byte jmp + 3 bytes */
+		"nop\n"
+		"nop\n"
+		"nop\n"  /* 2 byte jmp + 3 bytes */
 		"ftrace_test_p6nop:"
 		P6_NOP5
 		"jmp 1f\n"
@@ -161,7 +163,7 @@ int __init ftrace_dyn_arch_init(void *data)
 		ftrace_nop = (unsigned long *)ftrace_test_nop5;
 		break;
 	case 2:
-		pr_info("ftrace: converting mcount calls to jmp 1f\n");
+		pr_info("ftrace: converting mcount calls to jmp . + 5\n");
 		ftrace_nop = (unsigned long *)ftrace_test_jmp;
 		break;
 	}
