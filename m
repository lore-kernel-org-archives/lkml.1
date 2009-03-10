Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZCJPbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZCJPbR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZCJPbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:31:01 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:38782 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbZCJPbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:31:00 -0400
From: Timur Tabi <timur@freescale.com>
To: linux-kernel@vger.kernel.org, rdreier@cisco.com, jirislaby@gmail.com,
       peterz@infradead.org, will.newton@gmail.com, hancockrwd@gmail.com,
       jeremy@goop.org
Subject: [PATCH v4] introduce macro spin_event_timeout()
Date: Tue, 10 Mar 2009 10:30:04 -0500
Message-Id: <1236699004-1863-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro spin_event_timeout() takes a condition and timeout value
(in microseconds) as parameters.  It spins until either the condition is true
or the timeout expires.  It returns zero if the timeout expires first, non-zero
otherwise.

This primary purpose of this macro is to poll on a hardware register until a
status bit changes.  The timeout ensures that the loop still terminates if the
bit doesn't change as expected.  This macro makes it easier for driver
developers to perform this kind of operation properly.

Signed-off-by: Timur Tabi <timur@freescale.com>
---

v4: removed cpu_relax (redundant), changed timeout to unsigned long

v3: eliminated secondary evaluation of condition, replaced jiffies with udelay

v2: added cpu_relax and time_before

 include/linux/delay.h |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index fd832c6..4af6df6 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -51,4 +51,31 @@ static inline void ssleep(unsigned int seconds)
 	msleep(seconds * 1000);
 }
 
+/**
+ * spin_event_timeout - spin until a condition gets true or a timeout elapses
+ * @condition: a C expression to evalate
+ * @timeout: timeout, in microseconds
+ *
+ * The process spins until the @condition evaluates to true (non-zero) or
+ * the @timeout elapses.
+ *
+ * This primary purpose of this macro is to poll on a hardware register
+ * until a status bit changes.  The timeout ensures that the loop still
+ * terminates if the bit never changes.
+ *
+ * The return value is the number of microseconds left in the timeout, so if
+ * the return value is non-zero, then it means the condition is true.
+ *
+ * Short-circuit evaluation in the while-loop ensures that if the condition
+ * becomes true exactly when the timeout expires, non-zero will still be
+ * returned.
+ */
+#define spin_event_timeout(condition, timeout)				\
+({									\
+	unsigned long __timeout = timeout;				\
+	while (!(condition) && --__timeout)				\
+		udelay(1);						\
+	__timeout;							\
+})
+
 #endif /* defined(_LINUX_DELAY_H) */
-- 
1.6.1.3

