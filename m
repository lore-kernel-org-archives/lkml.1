Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbZLKMTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbZLKMTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750939AbZLKMTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:19:09 -0500
Received: from mail2.picochip.com ([82.111.145.34]:45608 "EHLO
	thurne.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750877AbZLKMTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:19:08 -0500
From: Jamie Iles <jamie.iles@picochip.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie.iles@picochip.com>,
       Russell King <linux@arm.linux.org.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       Mikael Pettersson <mikpe@it.uu.se>
Subject: [PATCH] perf tools: allow building for ARM (patch v2)
Date: Fri, 11 Dec 2009 12:20:09 +0000
Message-Id: <1260534009-5394-1-git-send-email-jamie.iles@picochip.com>
X-Mailer: git-send-email 1.6.5.4
In-Reply-To: <1260523260-15694-2-git-send-email-jamie.iles@picochip.com>
References: <1260523260-15694-2-git-send-email-jamie.iles@picochip.com>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (thurne.picochip.com [172.17.0.105]); Fri, 11 Dec 2009 12:18:59 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add definitions of rmb() and cpu_relax() and include the ARM unistd.h
header. The __kuser_memory_barrier helper in the helper page is used to
provide the correct memory barrier depending on the CPU type.

Signed-off-by: Jamie Iles <jamie.iles@picochip.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>
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
-- 
1.6.5.4

