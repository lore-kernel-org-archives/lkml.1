Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbZLWV20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbZLWV20 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:28:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbZLWV2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:28:21 -0500
Received: from mail.windriver.com ([147.11.1.11]:45041 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214AbZLWVU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:28 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 08/37] kgdb,sh: update superh kgdb exception handling
Date: Wed, 23 Dec 2009 15:19:21 -0600
Message-Id: <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:07.0270 (UTC) FILETIME=[B3699060:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement kgdb_arch_pc() which adjusts the pc if it needs to be
adjusted after a software breakpoint trap.

Implement kgdb_arch_set_pc() which is a new required function in the
kgdb debug core.

When processing a single step return zero in the error exception field
so that the debug core can distinguish between a single step trap and
a breakpoint trap generically.

CC: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/sh/kernel/kgdb.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/sh/kernel/kgdb.c b/arch/sh/kernel/kgdb.c
index 3e532d0..1ec03c9 100644
--- a/arch/sh/kernel/kgdb.c
+++ b/arch/sh/kernel/kgdb.c
@@ -237,6 +237,18 @@ int kgdb_arch_handle_exception(int e_vector, int signo, int err_code,
 	return -1;
 }
 
+unsigned long kgdb_arch_pc(int exception, struct pt_regs *regs)
+{
+	if (exception == 60)
+		return instruction_pointer(regs) - 2;
+	return instruction_pointer(regs);
+}
+
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->pc = ip;
+}
+
 /*
  * The primary entry points for the kgdb debug trap table entries.
  */
@@ -247,7 +259,7 @@ BUILD_TRAP_HANDLER(singlestep)
 
 	local_irq_save(flags);
 	regs->pc -= instruction_size(__raw_readw(regs->pc - 4));
-	kgdb_handle_exception(vec >> 2, SIGTRAP, 0, regs);
+	kgdb_handle_exception(0, SIGTRAP, 0, regs);
 	local_irq_restore(flags);
 }
 
-- 
1.6.4.rc1

