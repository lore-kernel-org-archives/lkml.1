Return-Path: <linux-kernel-owner+w=401wt.eu-S1756390AbZCGANe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390AbZCGANe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 19:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754234AbZCGANZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 19:13:25 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:60048 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260AbZCGANZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 19:13:25 -0500
From: Timur Tabi <timur@freescale.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] add function spin_event_timeout()
Date: Fri,  6 Mar 2009 18:13:21 -0600
Message-Id: <1236384801-10305-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function spin_event_timeout() takes a condition and timeout value
(in jiffies) as parameters.  It spins until either the condition is true
or the timeout expires.  It returns non-zero if the condition is true,
zero otherwise.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 include/linux/delay.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/include/linux/delay.h b/include/linux/delay.h
index fd832c6..00ac466 100644
--- a/include/linux/delay.h
+++ b/include/linux/delay.h
@@ -51,4 +51,25 @@ static inline void ssleep(unsigned int seconds)
 	msleep(seconds * 1000);
 }
 
+/**
+ * spin_event_timeout - spin until a condition gets true or a timeout elapses
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process spins until the @condition evaluates to true or the @timeout
+ * elapses.
+ *
+ * The function returns non-zero if the @condition evaluated to true, or
+ * zero if the @timeout elapsed.  If both occurs (e.g. the loop was
+ * pre-empted and the @condition became true in the meantime, but when the
+ * loop resumed the @timeout had already elapsed), then non-zero will be
+ * returned.
+ */
+#define spin_event_timeout(condition, timeout)		\
+({							\
+	long __timeout = jiffies + (timeout);		\
+	while (!(condition) && (jiffies < __timeout));	\
+	(condition);					\
+})
+
 #endif /* defined(_LINUX_DELAY_H) */
-- 
1.6.1.3

