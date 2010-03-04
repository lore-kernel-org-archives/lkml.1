Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0CDD6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:58:10 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47484 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917Ab0CDD5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:57:46 -0500
From: John Stultz <johnstul@us.ibm.com>
To: "	lkml" <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Tony Luck <tony.luck@intel.com>,
       Fenghua Yu <fenghua.yu@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 07/14] ia64: Convert ia64 to use read/update_persistent_clock
Date: Wed,  3 Mar 2010 19:57:22 -0800
Message-Id: <1267675049-12337-8-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-2-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-5-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the ia64  architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers would be appreciated.

Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/ia64/kernel/time.c |   12 +++++-------
 1 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/kernel/time.c b/arch/ia64/kernel/time.c
index 47a1927..653b3c4 100644
--- a/arch/ia64/kernel/time.c
+++ b/arch/ia64/kernel/time.c
@@ -430,18 +430,16 @@ static int __init rtc_init(void)
 }
 module_init(rtc_init);
 
+void read_persistent_clock(struct timespec *ts)
+{
+	efi_gettimeofday(ts);
+}
+
 void __init
 time_init (void)
 {
 	register_percpu_irq(IA64_TIMER_VECTOR, &timer_irqaction);
-	efi_gettimeofday(&xtime);
 	ia64_init_itm();
-
-	/*
-	 * Initialize wall_to_monotonic such that adding it to xtime will yield zero, the
-	 * tv_nsec field must be normalized (i.e., 0 <= nsec < NSEC_PER_SEC).
-	 */
-	set_normalized_timespec(&wall_to_monotonic, -xtime.tv_sec, -xtime.tv_nsec);
 }
 
 /*
-- 
1.6.0.4

