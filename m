Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031824Ab0B1K7u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 05:59:50 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:51694 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031793Ab0B1K7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 05:59:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=WlRPYbIT1Iqqp43oSMQQ/ebRuzzoOWJheFBEUoHxcCgcK818NlPTr9wm4CS9JG1vbb
         KvcUs0TIs931iLzvoNuPULxZpA7tMP5SI+1pvoZeAZut2iN/9ReNsZxY162VE4+6vM73
         NkjqIcD38h0V0iFsAUROIqa/U+C3BHLsI8XdU=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Helge Deller <deller@gmx.de>,
       "James E.J. Bottomley" <jejb@parisc-linux.org>,
       linux-parisc@vger.kernel.org
Subject: [PATCH] parisc: use __ratelimit
Date: Sun, 28 Feb 2010 19:58:15 +0900
Message-Id: <1267354697-6456-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
References: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open-coded rate limiting logic with __ratelimit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/kernel/unaligned.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/parisc/kernel/unaligned.c b/arch/parisc/kernel/unaligned.c
index e6f4b7a..92d977b 100644
--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -25,6 +25,7 @@
 #include <linux/module.h>
 #include <linux/sched.h>
 #include <linux/signal.h>
+#include <linux/ratelimit.h>
 #include <asm/uaccess.h>
 
 /* #define DEBUG_UNALIGNED 1 */
@@ -446,8 +447,7 @@ static int emulate_std(struct pt_regs *regs, int frreg, int flop)
 
 void handle_unaligned(struct pt_regs *regs)
 {
-	static unsigned long unaligned_count = 0;
-	static unsigned long last_time = 0;
+	static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 5);
 	unsigned long newbase = R1(regs->iir)?regs->gr[R1(regs->iir)]:0;
 	int modify = 0;
 	int ret = ERR_NOTHANDLED;
@@ -460,14 +460,8 @@ void handle_unaligned(struct pt_regs *regs)
 			goto force_sigbus;
 		}
 
-		if (unaligned_count > 5 &&
-				time_after(jiffies, last_time + 5 * HZ)) {
-			unaligned_count = 0;
-			last_time = jiffies;
-		}
-
-		if (!(current->thread.flags & PARISC_UAC_NOPRINT) 
-		    && ++unaligned_count < 5) {
+		if (!(current->thread.flags & PARISC_UAC_NOPRINT) &&
+			__ratelimit(&ratelimit)) {
 			char buf[256];
 			sprintf(buf, "%s(%d): unaligned access to 0x" RFMT " at ip=0x" RFMT "\n",
 				current->comm, task_pid_nr(current), regs->ior, regs->iaoq[0]);
-- 
1.6.0.6

