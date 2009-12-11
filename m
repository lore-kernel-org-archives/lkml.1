Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZLKM46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZLKM46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:56:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbZLKM4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:56:52 -0500
Received: from hera.kernel.org ([140.211.167.34]:48511 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbZLKM4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:56:52 -0500
Date: Fri, 11 Dec 2009 12:54:33 GMT
From: tip-bot for Jamie Iles <jamie.iles@picochip.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peterz@infradead.org, jamie.iles@picochip.com, mikpe@it.uu.se,
       linux@arm.linux.org.uk, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peterz@infradead.org, jamie.iles@picochip.com, mikpe@it.uu.se,
       linux@arm.linux.org.uk, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1260534009-5394-1-git-send-email-jamie.iles@picochip.com>
References: <1260534009-5394-1-git-send-email-jamie.iles@picochip.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Allow building for ARM
Message-ID: <tip-58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f@git.kernel.org>
Git-Commit-ID: 58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f
Gitweb:     http://git.kernel.org/tip/58e9f94138c1d9c47f6a63632ca7a78fc6dcc15f
Author:     Jamie Iles <jamie.iles@picochip.com>
AuthorDate: Fri, 11 Dec 2009 12:20:09 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 11 Dec 2009 13:50:21 +0100

perf tools: Allow building for ARM

Add definitions of rmb() and cpu_relax() and include the ARM
unistd.h header. The __kuser_memory_barrier helper in the helper
page is used to provide the correct memory barrier depending on
the CPU type.

[ The rmb() will work on v6 and v7, segfault on v5. Dynamic
  detection to add v5 support will be added later. ]

Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>
LKML-Reference: <1260534009-5394-1-git-send-email-jamie.iles@picochip.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/perf.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 454d5d5..75f941b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -59,6 +59,18 @@
 #define cpu_relax()	asm volatile ("hint @pause" ::: "memory")
 #endif
 
+#ifdef __arm__
+#include "../../arch/arm/include/asm/unistd.h"
+/*
+ * Use the __kuser_memory_barrier helper in the CPU helper page. See
+ * arch/arm/kernel/entry-armv.S in the kernel source for details.
+ */
+#define rmb()		asm volatile("mov r0, #0xffff0fff; mov lr, pc;" \
+				     "sub pc, r0, #95" ::: "r0", "lr", "cc", \
+				     "memory")
+#define cpu_relax()	asm volatile("":::"memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
