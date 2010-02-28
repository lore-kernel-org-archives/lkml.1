Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031828Ab0B1K7S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 05:59:18 -0500
Received: from mail-iw0-f182.google.com ([209.85.223.182]:51694 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031811Ab0B1K7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 05:59:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JAWwC79ufe2vtna6LVO7lGJJm2O0GnaXYGl6ZPlhXYgIbqpQN8spJ6NJBQ87pcBIKZ
         VCVkNZ/dB958l/bzR9rEwWoFRwuH7clJzzTamoVMUMmZvag1+n/bD3NKnjmawaUvUAwi
         QbOaHPjxdtjl47+5o3/TuTTxQm/i7/SSyfYmU=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH] sparc: use __ratelimit
Date: Sun, 28 Feb 2010 19:58:17 +0900
Message-Id: <1267354697-6456-5-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
References: <1267354697-6456-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace open-coded rate limiting logic with __ratelimit().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
---
 arch/sparc/kernel/unaligned_64.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/sparc/kernel/unaligned_64.c b/arch/sparc/kernel/unaligned_64.c
index 378ca82..f03641f 100644
--- a/arch/sparc/kernel/unaligned_64.c
+++ b/arch/sparc/kernel/unaligned_64.c
@@ -21,6 +21,7 @@
 #include <linux/smp.h>
 #include <linux/bitops.h>
 #include <linux/perf_event.h>
+#include <linux/ratelimit.h>
 #include <asm/fpumacro.h>
 
 enum direction {
@@ -274,13 +275,9 @@ static void kernel_mna_trap_fault(int fixup_tstate_asi)
 
 static void log_unaligned(struct pt_regs *regs)
 {
-	static unsigned long count, last_time;
+	static DEFINE_RATELIMIT_STATE(ratelimit, 5 * HZ, 5);
 
-	if (time_after(jiffies, last_time + 5 * HZ))
-		count = 0;
-	if (count < 5) {
-		last_time = jiffies;
-		count++;
+	if (__ratelimit(&ratelimit)) {
 		printk("Kernel unaligned access at TPC[%lx] %pS\n",
 		       regs->tpc, (void *) regs->tpc);
 	}
-- 
1.6.0.6

