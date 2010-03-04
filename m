Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0CDD6u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 22:58:50 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46741 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab0CDD6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 22:58:04 -0500
From: John Stultz <johnstul@us.ibm.com>
To: "	lkml" <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 14/14] arm: Convert arm to use read_persistent_clock
Date: Wed,  3 Mar 2010 19:57:29 -0800
Message-Id: <1267675049-12337-15-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1267675049-12337-14-git-send-email-johnstul@us.ibm.com>
References: <1267675049-12337-1-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-2-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-3-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-4-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-5-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-6-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-7-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-8-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-9-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-10-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-11-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-12-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-13-git-send-email-johnstul@us.ibm.com>
 <1267675049-12337-14-git-send-email-johnstul@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts the arm architecture to use the generic read_persistent_clock and update_persistent_clock interfaces, reducing the amount of arch specific code we have to maintain, and allowing for further cleanups in the future.

Also removes a direct xtime access, replacing it with current_kernel_time()

I have not built or tested this patch, so help from arch maintainers would be appreciated.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 arch/arm/Kconfig       |    3 +++
 arch/arm/kernel/time.c |    7 +++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 3b18128..b70929d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -43,6 +43,9 @@ config GENERIC_GPIO
 config GENERIC_TIME
 	bool
 
+config GENERIC_CMOS_UPDATE
+        def_bool y
+
 config GENERIC_CLOCKEVENTS
 	bool
 
diff --git a/arch/arm/kernel/time.c b/arch/arm/kernel/time.c
index 2875380..eebe8f5 100644
--- a/arch/arm/kernel/time.c
+++ b/arch/arm/kernel/time.c
@@ -79,6 +79,13 @@ static unsigned long dummy_gettimeoffset(void)
 }
 #endif
 
+int update_persistent_clock(struct timespec now)
+{
+	if (set_rtc == NULL)
+		return -1;
+	return set_rtc(now);
+}
+
 #ifdef CONFIG_LEDS_TIMER
 static inline void do_leds(void)
 {
-- 
1.6.0.4

