Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYAZP4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYAZP4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 10:56:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbYAZPyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 10:54:21 -0500
Received: from 206-47-31-89.wifiinternet.cz ([89.31.47.206]:1177 "EHLO
	monstr.monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754748AbYAZPyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 10:54:13 -0500
From: monstr@monstr.eu
To: monstr@monstr.eu
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au
Subject: [PATCH 24/52] [microblaze] time support
Date: Thu, 24 Jan 2008 16:02:59 +0100
Message-Id: <3bcb9581bc512fdd0a124ac8322af9e2a8adc975.1201107832.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.4.rc4.14.g6fc74
In-Reply-To: <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
References: <1201187014-3979-1-git-send-email-monstr@monstr.eu>
 <dbff6b883dbcb108db53e5093994c473946e1240.1201107832.git.monstr@monstr.eu>
 <ac0947adfe718fcb4c0dc5f6f7ab64f8155541fb.1201107832.git.monstr@monstr.eu>
 <873c2bf1f67696aa11014886470f6ba46f04e8d2.1201107832.git.monstr@monstr.eu>
 <516d173b1789ea533431e8f5ad05751c6a353c88.1201107832.git.monstr@monstr.eu>
 <068508828aac6298b4cc65b0cd7b2737a61c466c.1201107832.git.monstr@monstr.eu>
 <010fc233f82a8f7a591c9f8315ae03f9951139aa.1201107832.git.monstr@monstr.eu>
 <68faaf69ea03196d4a56a263707355e7e7eb5c6a.1201107832.git.monstr@monstr.eu>
 <4b7d90fc1b9bcb3c0b1b308c6460390f7bdf3824.1201107832.git.monstr@monstr.eu>
 <eb28582e845efb4f2f26054630895f26fa69866e.1201107832.git.monstr@monstr.eu>
 <64e6e541db30cc4f1ee5cd85da4bdea6024f75b8.1201107832.git.monstr@monstr.eu>
 <90badb264d0e4ec49fdaa76842a5e5f259681299.1201107832.git.monstr@monstr.eu>
 <a013a2b7044186c64d55cdafc8c9b29bc73a7fc5.1201107832.git.monstr@monstr.eu>
 <60642f04ebcf9f76da50a1d40191755f258edcc5.1201107832.git.monstr@monstr.eu>
 <240998be1af3774635995fd19248f8b3a9e8a702.1201107832.git.monstr@monstr.eu>
In-Reply-To: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>


Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/time.c  |   90 ++++++++++++++++++++++++++++++++++++++++
 include/asm-microblaze/delay.h |   28 ++++++++++++
 include/asm-microblaze/timex.h |   21 +++++++++
 3 files changed, 139 insertions(+), 0 deletions(-)
 create mode 100644 arch/microblaze/kernel/time.c
 create mode 100644 include/asm-microblaze/delay.h
 create mode 100644 include/asm-microblaze/timex.h

diff --git a/arch/microblaze/kernel/time.c b/arch/microblaze/kernel/time.c
new file mode 100644
index 0000000..d5ebdff
--- /dev/null
+++ b/arch/microblaze/kernel/time.c
@@ -0,0 +1,90 @@
+/*
+ * arch/microblaze/kernel/time.c
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/param.h>
+#include <linux/jiffies.h>
+#include <linux/time.h>
+#include <linux/hrtimer.h>
+#include <asm/bug.h>
+#include <asm/setup.h>
+
+void time_init(void)
+{
+	system_timer_init();
+}
+
+int do_settimeofday(struct timespec *tv)
+{
+	if ((unsigned long)tv->tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
+
+	write_seqlock_irq(&xtime_lock);
+
+	/* This is revolting. We need to set the xtime.tv_nsec
+	 * correctly. However, the value in this location is
+	 * is value at the last tick.
+	 * Discover what correction gettimeofday
+	 * would have done, and then undo it!
+	 */
+#if 0
+	tv->tv_nsec -= mach_gettimeoffset() * 1000;
+#endif
+
+	while (tv->tv_nsec < 0) {
+		tv->tv_nsec += NSEC_PER_SEC;
+		tv->tv_sec--;
+	}
+
+	xtime.tv_sec = tv->tv_sec;
+	xtime.tv_nsec = tv->tv_nsec;
+
+	time_adjust = 0;
+	time_status |= STA_UNSYNC;
+	time_maxerror = NTP_PHASE_LIMIT;
+	time_esterror = NTP_PHASE_LIMIT;
+
+	write_sequnlock_irq(&xtime_lock);
+	clock_was_set();
+	return 0;
+}
+EXPORT_SYMBOL(do_settimeofday);
+
+/*
+ * This version of gettimeofday has near microsecond resolution.
+ */
+void do_gettimeofday(struct timeval *tv)
+{
+	unsigned long seq;
+	unsigned long usec, sec;
+	/* unsigned long max_ntp_tick = tick_usec - tickadj; */
+
+	do {
+		seq = read_seqbegin(&xtime_lock);
+		usec = do_gettimeoffset();
+		sec = xtime.tv_sec;
+		usec += (xtime.tv_nsec / 1000);
+	} while (read_seqretry(&xtime_lock, seq));
+
+	while (usec >= 1000000) {
+		usec -= 1000000;
+		sec++;
+	}
+
+	tv->tv_sec = sec;
+	tv->tv_usec = usec;
+}
+EXPORT_SYMBOL(do_gettimeofday);
+
+unsigned long long sched_clock(void)
+{
+	return (unsigned long long)jiffies * (1000000000 / HZ);
+}
diff --git a/include/asm-microblaze/delay.h b/include/asm-microblaze/delay.h
new file mode 100644
index 0000000..1eaa74c
--- /dev/null
+++ b/include/asm-microblaze/delay.h
@@ -0,0 +1,28 @@
+/*
+ * include/asm-microblaze/delay.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ */
+
+#ifndef _ASM_DELAY_H
+#define _ASM_DELAY_H
+
+extern inline void __delay(unsigned long loops)
+{
+	asm volatile ("# __delay		\n\t"		\
+			"1: addi	%0, %0, -1 \t\n"	\
+			"bneid	%0, 1b		\t\n"		\
+			"nop			\t\n"
+			: "=r" (loops)
+			: "0" (loops));
+}
+
+static inline void udelay(unsigned long usec)
+{
+}
+
+#endif /* _ASM_DELAY_H */
diff --git a/include/asm-microblaze/timex.h b/include/asm-microblaze/timex.h
new file mode 100644
index 0000000..17d2f11
--- /dev/null
+++ b/include/asm-microblaze/timex.h
@@ -0,0 +1,21 @@
+/*
+ * include/asm-microblaze/timex.h
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2006 Atmark Techno, Inc.
+ * FIXME -- need review
+ */
+
+#ifndef _ASM_TIMEX_H
+#define _ASM_TIMEX_H
+
+#define CLOCK_TICK_RATE 1000 /* Timer input freq. */
+
+typedef unsigned long cycles_t;
+
+#define get_cycles()	(0)
+
+#endif /* _ASM_TIMEX_H */
-- 
1.5.4.rc4.14.g6fc74

