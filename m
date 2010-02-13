Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757976Ab0BMTsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 14:48:22 -0500
Received: from mail-yw0-f179.google.com ([209.85.211.179]:46150 "EHLO
	mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab0BMTsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 14:48:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=iAphpaTMUGEb9VB5kXrc/OAwSDueOdu5PMB/zY95ZcLCCHHVHLXHjF7UMxUhoPQ72Y
         M3uc/Yv/jtxTdumQ/EPqhToI9t3fce5wsWtHjMwOh+KqrD3fTUrmXEfeFQosN/foBX1R
         BptF+wbDnSW9UpS2CzaWPsUT409Rj69U5oYEM=
From: Rabin Vincent <rabin@rab.in>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH 02/10] ARM: ftrace: document mcount formats
Date: Sun, 14 Feb 2010 01:18:30 +0530
Message-Id: <1266090518-31120-3-git-send-email-rabin@rab.in>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1266090518-31120-1-git-send-email-rabin@rab.in>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a comment describing the mcount variants and how the callsites look
like.

Signed-off-by: Rabin Vincent <rabin@rab.in>
---
 arch/arm/kernel/entry-common.S |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 0b042bd..d412d7c 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -92,6 +92,38 @@ ENDPROC(ret_from_fork)
 #define CALL(x) .long x
 
 #ifdef CONFIG_FUNCTION_TRACER
+/*
+ * When compiling with -pg, gcc inserts a call to the mcount routine at the
+ * start of every function.  In mcount, apart from the function's address (in
+ * lr), we need to get hold of the function's caller's address.
+ *
+ * Older GCCs (pre-4.4) inserted a call to a routine called mcount like this:
+ *
+ *	bl	mcount
+ *
+ * These versions have the limitation that in order for the mcount routine to
+ * be able to determine the function's caller's address, an APCS-style frame
+ * pointer (which is set up with something like the code below) is required.
+ *
+ *	mov     ip, sp
+ *	push    {fp, ip, lr, pc}
+ *	sub     fp, ip, #4
+ *
+ * With EABI, these frame pointers are not available unless -mapcs-frame is
+ * specified, and if building as Thumb-2, not even then.
+ *
+ * Newer GCCs (4.4+) solve this problem by introducing a new version of mcount,
+ * with call sites like:
+ *
+ *	push	{lr}
+ *	bl	__gnu_mcount_nc
+ *
+ * With these compilers, frame pointers are not necessary.
+ *
+ * With both the mcount types, we need to restore the original lr before
+ * returning.  In the __gnu_mcount_nc, version we're allowed to clobber ip.
+ * No other registers should be clobbered.
+ */
 #ifdef CONFIG_DYNAMIC_FTRACE
 ENTRY(mcount)
 	stmdb	sp!, {r0-r3, lr}
-- 
1.6.6

