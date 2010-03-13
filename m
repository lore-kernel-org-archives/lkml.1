Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935089Ab0CMAWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 19:22:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:46657 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935091Ab0CMAV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:21:27 -0500
Date: Sat, 13 Mar 2010 00:20:40 GMT
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com, tony.luck@intel.com, akpm@linux-foundation.org,
       fenghua.yu@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tony.luck@intel.com, akpm@linux-foundation.org,
       fenghua.yu@intel.com, tglx@linutronix.de
In-Reply-To: <1267675049-12337-8-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-8-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] ia64: Convert ia64 to use read/update_persistent_clock
Message-ID: <tip-6ffdc5774a9ef80e58db398a8307d5b2db2644ce@git.kernel.org>
Git-Commit-ID: 6ffdc5774a9ef80e58db398a8307d5b2db2644ce
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 13 Mar 2010 00:20:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ffdc5774a9ef80e58db398a8307d5b2db2644ce
Gitweb:     http://git.kernel.org/tip/6ffdc5774a9ef80e58db398a8307d5b2db2644ce
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Wed, 3 Mar 2010 19:57:22 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sat, 13 Mar 2010 01:14:11 +0100

ia64: Convert ia64 to use read/update_persistent_clock

This patch converts the ia64 architecture to use the generic
read_persistent_clock and update_persistent_clock interfaces, reducing
the amount of arch specific code we have to maintain, and allowing for
further cleanups in the future.

I have not built or tested this patch, so help from arch maintainers
would be appreciated.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <1267675049-12337-8-git-send-email-johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
