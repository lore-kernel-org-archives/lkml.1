Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0CCLtJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:49:09 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:39173 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab0CCLtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:49:04 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Iles <jamie.iles@picochip.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] ARM: perf: modify kuser rmb() call to compile for Thumb-2
Date: Wed,  3 Mar 2010 11:47:58 +0000
Message-Id: <1267616878-2154-1-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 03 Mar 2010 11:48:43.0789 (UTC) FILETIME=[79C803D0:01CABAC7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Thumb-2 instruction set does not provide an encoding
for sub pc, r0, #95 as present in the rmb() definition used
by perf. This results in compilation failure when using a
compiler targetting an instruction set other than ARM.

This patch redefines rmb() for ARM by casting the address
of the kuser helper to a function pointer, therefore getting
the compiler to take care of making the call.

Patch taken against tip/master.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jamie Iles <jamie.iles@picochip.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/perf.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 75f941b..6fb379b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -65,9 +65,7 @@
  * Use the __kuser_memory_barrier helper in the CPU helper page. See
  * arch/arm/kernel/entry-armv.S in the kernel source for details.
  */
-#define rmb()		asm volatile("mov r0, #0xffff0fff; mov lr, pc;" \
-				     "sub pc, r0, #95" ::: "r0", "lr", "cc", \
-				     "memory")
+#define rmb()		((void(*)(void))0xffff0fa0)()
 #define cpu_relax()	asm volatile("":::"memory")
 #endif
 
-- 
1.6.3.3

