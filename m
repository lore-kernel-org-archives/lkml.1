Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYJMD5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYJMD5j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 23:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754417AbYJMD5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 23:57:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45288
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbYJMD53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 23:57:29 -0400
Date: Sun, 12 Oct 2008 20:57:06 -0700 (PDT)
Message-Id: <20081012.205706.66825182.davem@davemloft.net>
To: manfred@colorfullife.com
CC: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH]: sparc64: Add missing notify_cpu_starting() call.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Manfred please be much more careful next time.

You broke the sparc32 build (missing linux/cpu.h includes), and
you skipped over sparc64 entirely.

I checked in a fix for the sparc32 build failure and the following
sparc64 patch to my sparc-2.6 tree to fix this stuff.

And I'll push this off to Linus shortly.

sparc64: Add missing notify_cpu_starting() call.

Commit e545a6140b698b2494daf0b32107bdcc5e901390 ("kernel/cpu.c: create
a CPU_STARTING cpu_chain notifier") added a notify_cpu_starting()
notifier event, and hit every arch except sparc64.

Fix that missed case.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc64/kernel/smp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/sparc64/kernel/smp.c b/arch/sparc64/kernel/smp.c
index 2be166c..e562711 100644
--- a/arch/sparc64/kernel/smp.c
+++ b/arch/sparc64/kernel/smp.c
@@ -21,6 +21,7 @@
 #include <linux/jiffies.h>
 #include <linux/profile.h>
 #include <linux/lmb.h>
+#include <linux/cpu.h>
 
 #include <asm/head.h>
 #include <asm/ptrace.h>
@@ -115,6 +116,9 @@ void __cpuinit smp_callin(void)
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
 
+	/* inform the notifiers about the new cpu */
+	notify_cpu_starting(cpuid);
+
 	while (!cpu_isset(cpuid, smp_commenced_mask))
 		rmb();
 
-- 
1.5.6.5

