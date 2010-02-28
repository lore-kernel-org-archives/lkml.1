Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031791Ab0B1K7A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 05:59:00 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:51694 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031778Ab0B1K65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 05:58:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Y9CklYimSKWODuPG2v/InYbEolkCtD05ydirrDqkBLHK+BJq0l4A5DcazBNpdI8BX5
         /hRSmPb+3YrwOs9XUBPolEYCjd/PHBeIMrAsAhdHFo9XxHTm6U2IBBb8lphV6rDTFKcY
         JeuLPWKW9Wp9Kmdr9/AT/lWao42YeG5i4cVDQ=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org
Subject: [PATCH] alpha: use __ratelimit
Date: Sun, 28 Feb 2010 19:58:13 +0900
Message-Id: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open-coded rate limiting logic with __ratelimit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/traps.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 6ee7655..b14f015 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kallsyms.h>
+#include <linux/ratelimit.h>
 
 #include <asm/gentrap.h>
 #include <asm/uaccess.h>
@@ -771,8 +772,7 @@ asmlinkage void
 do_entUnaUser(void __user * va, unsigned long opcode,
 	      unsigned long reg, struct pt_regs *regs)
 {
-	static int cnt = 0;
-	static unsigned long last_time;
+	static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 5);
 
 	unsigned long tmp1, tmp2, tmp3, tmp4;
 	unsigned long fake_reg, *reg_addr = &fake_reg;
@@ -783,15 +783,11 @@ do_entUnaUser(void __user * va, unsigned long opcode,
 	   with the unaliged access.  */
 
 	if (!test_thread_flag (TIF_UAC_NOPRINT)) {
-		if (cnt >= 5 && time_after(jiffies, last_time + 5 * HZ)) {
-			cnt = 0;
-		}
-		if (++cnt < 5) {
+		if (__ratelimit(&ratelimit)) {
 			printk("%s(%d): unaligned trap at %016lx: %p %lx %ld\n",
 			       current->comm, task_pid_nr(current),
 			       regs->pc - 4, va, opcode, reg);
 		}
-		last_time = jiffies;
 	}
 	if (test_thread_flag (TIF_UAC_SIGBUS))
 		goto give_sigbus;
-- 
1.6.0.6

