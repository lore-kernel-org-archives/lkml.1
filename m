Return-Path: <linux-kernel-owner+w=401wt.eu-S1753840AbZK0I7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbZK0I7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 03:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbZK0I7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 03:59:13 -0500
Received: from www84.your-server.de ([213.133.104.84]:53544 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbZK0I7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 03:59:12 -0500
Subject: [PATCH] fix PPC floating point debug
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 27 Nov 2009 09:59:00 +0100
Message-ID: <1259312340.9648.6.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PPC architecture is unable to debug applications using hardware
floating point, because it would not save the floating point registers.

After returning from the debugger, the contents of register was
modified. This patch fix this bug.

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 traps.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- linux-2.6.32-rc5/arch/powerpc/kernel/traps.c.orig	2009-11-27 09:47:37.989943124 +0100
+++ linux-2.6.32-rc5/arch/powerpc/kernel/traps.c	2009-11-27 09:47:41.088330825 +0100
@@ -559,6 +559,8 @@ void instruction_breakpoint_exception(st
 		return;
 	if (debugger_iabr_match(regs))
 		return;
+	if (regs->msr & MSR_FP)
+		giveup_fpu(current);
 	_exception(SIGTRAP, regs, TRAP_BRKPT, regs->nip);
 }
 
@@ -577,6 +579,8 @@ void __kprobes single_step_exception(str
 	if (debugger_sstep(regs))
 		return;
 
+	if (regs->msr & MSR_FP)
+		giveup_fpu(current);
 	_exception(SIGTRAP, regs, TRAP_TRACE, regs->nip);
 }
 
@@ -834,6 +838,8 @@ void __kprobes program_check_exception(s
 			regs->nip += 4;
 			return;
 		}
+		if (regs->msr & MSR_FP)
+			giveup_fpu(current);
 		_exception(SIGTRAP, regs, TRAP_BRKPT, regs->nip);
 		return;
 	}


