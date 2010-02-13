Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab0BMTss (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:48:48 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:47287 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0BMTsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:48:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=YcE4lNYEwTrsaqJwJO40ibyUpNDatOmUA5y7++CTAHNa0JvaQuBtjEREBBvFdUhDeo
         BfrnoiGPBoFIX7cvC39utIiBPB2npp68gGH+1JGZBUo3U3cGPGdJ7+ZQIn15xx0mCnVf
         yce11J/07ri8ssj8yELQuyZusDEHfgIBM22RA=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 06/10] ARM: ftrace: add Thumb-2 support
Date: Sun, 14 Feb 2010 01:18:34 +0530
Message-Id: <1266090518-31120-7-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266090518-31120-1-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the mcount routines to build and run on a kernel built with the
Thumb-2 instruction set.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/entry-common.S |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 42eb166..cd2a574 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -156,7 +156,8 @@ ENTRY(__gnu_mcount_nc)
 	stmdb	sp!, {r0-r3, lr}
 	ldr	r0, =ftrace_trace_function
 	ldr	r2, [r0]
-	adr	r0, ftrace_stub
+ THUMB(	orr	r2, r2, #1		)
+	adr	r0, BSYM(ftrace_stub)
 	cmp	r0, r2
 	bne	gnu_trace
 	ldmia	sp!, {r0-r3, ip, lr}
@@ -166,8 +167,9 @@ gnu_trace:
 	ldr	r1, [sp, #20]			@ lr of instrumented routine
 	mov	r0, lr
 	sub	r0, r0, #MCOUNT_INSN_SIZE
-	mov	lr, pc
-	mov	pc, r2
+ ARM(	mov	lr, pc			)
+ ARM(	mov	pc, r2			)
+ THUMB(	blx	r2			)
 	ldmia	sp!, {r0-r3, ip, lr}
 	mov	pc, ip
 ENDPROC(__gnu_mcount_nc)
-- 
1.6.6

