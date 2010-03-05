Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0CECiE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 21:38:04 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59873 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487Ab0CECiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 21:38:00 -0500
From: John Stultz <johnstul@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Paul Mackerras <paulus@samba.org>,
       Anton Blanchard <anton@samba.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/2] powerpc: Cleanup xtime usage
Date: Thu,  4 Mar 2010 18:37:54 -0800
Message-Id: <1267756674-30430-2-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1267756674-30430-1-git-send-email-johnstul@us.ibm.com>
References: <1267756674-30430-1-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes powerpc's direct xtime usage, allowing for further
generic timeekeping cleanups

Compiled but otherwise untested.

Cc: Paul Mackerras <paulus@samba.org>
Cc: Anton Blanchard <anton@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>

Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/powerpc/kernel/time.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index 9a06ff9..9487ff0 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -828,9 +828,9 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	/* XXX this assumes clock->shift == 22 */
 	/* 4611686018 ~= 2^(20+64-22) / 1e9 */
 	new_tb_to_xs = (u64) mult * 4611686018ULL;
-	new_stamp_xsec = (u64) xtime.tv_nsec * XSEC_PER_SEC;
+	new_stamp_xsec = (u64) wall_time->tv_nsec * XSEC_PER_SEC;
 	do_div(new_stamp_xsec, 1000000000);
-	new_stamp_xsec += (u64) xtime.tv_sec * XSEC_PER_SEC;
+	new_stamp_xsec += (u64) wall_time->tv_sec * XSEC_PER_SEC;
 
 	/*
 	 * tb_update_count is used to allow the userspace gettimeofday code
@@ -848,7 +848,7 @@ void update_vsyscall(struct timespec *wall_time, struct clocksource *clock,
 	vdso_data->tb_to_xs = new_tb_to_xs;
 	vdso_data->wtom_clock_sec = wall_to_monotonic.tv_sec;
 	vdso_data->wtom_clock_nsec = wall_to_monotonic.tv_nsec;
-	vdso_data->stamp_xtime = xtime;
+	vdso_data->stamp_xtime = *wall_time;
 	smp_wmb();
 	++(vdso_data->tb_update_count);
 }
@@ -1057,7 +1057,7 @@ void __init time_init(void)
 	vdso_data->tb_orig_stamp = tb_last_jiffy;
 	vdso_data->tb_update_count = 0;
 	vdso_data->tb_ticks_per_sec = tb_ticks_per_sec;
-	vdso_data->stamp_xsec = (u64) xtime.tv_sec * XSEC_PER_SEC;
+	vdso_data->stamp_xsec = (u64) get_seconds() * XSEC_PER_SEC;
 	vdso_data->tb_to_xs = tb_to_xs;
 
 	write_sequnlock_irqrestore(&xtime_lock, flags);
-- 
1.6.0.4

