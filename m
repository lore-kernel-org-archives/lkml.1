Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXAWWMb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXAWWMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:12:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932955AbXAWWMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:12:25 -0500
Received: from www.osadl.org ([213.239.205.134]:35799 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932939AbXAWWAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:45 -0500
Message-Id: <20070123211203.414475000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 05/46] 
Content-Disposition: inline;
	filename=gtod-fix-multiple-conversion-bugs-in-msecs_to_jiffies.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Fix multiple conversion bugs in msecs_to_jiffies().

The main problem is that this condition:

	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))

overflows if HZ is smaller than 1000!

This change is user-visible: for HZ=250 SUS-compliant poll()-timeout
value of -20 is mistakenly converted to 'immediate timeout'.

(The new dyntick code also triggered this, that's how we noticed.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/time.c |   43 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

Index: linux-2.6.20-rc4-mm1-bo/kernel/time.c
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/kernel/time.c
+++ linux-2.6.20-rc4-mm1-bo/kernel/time.c
@@ -500,15 +500,56 @@ unsigned int jiffies_to_usecs(const unsi
 }
 EXPORT_SYMBOL(jiffies_to_usecs);
 
+/*
+ * When we convert to jiffies then we interpret incoming values
+ * the following way:
+ *
+ * - negative values mean 'infinite timeout' (MAX_JIFFY_OFFSET)
+ *
+ * - 'too large' values [that would result in larger than
+ *   MAX_JIFFY_OFFSET values] mean 'infinite timeout' too.
+ *
+ * - all other values are converted to jiffies by either multiplying
+ *   the input value by a factor or dividing it with a factor
+ *
+ * We must also be careful about 32-bit overflows.
+ */
 unsigned long msecs_to_jiffies(const unsigned int m)
 {
-	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+	/*
+	 * Negative value, means infinite timeout:
+	 */
+	if ((int)m < 0)
 		return MAX_JIFFY_OFFSET;
+
 #if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
+	/*
+	 * HZ is equal to or smaller than 1000, and 1000 is a nice
+	 * round multiple of HZ, divide with the factor between them,
+	 * but round upwards:
+	 */
 	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);
 #elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
+	/*
+	 * HZ is larger than 1000, and HZ is a nice round multiple of
+	 * 1000 - simply multiply with the factor between them.
+	 *
+	 * But first make sure the multiplication result cannot
+	 * overflow:
+	 */
+	if (m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+		return MAX_JIFFY_OFFSET;
+
 	return m * (HZ / MSEC_PER_SEC);
 #else
+	/*
+	 * Generic case - multiply, round and divide. But first
+	 * check that if we are doing a net multiplication, that
+	 * we wouldnt overflow:
+	 */
+	if (HZ > MSEC_PER_SEC && m > jiffies_to_msecs(MAX_JIFFY_OFFSET))
+		return MAX_JIFFY_OFFSET;
+
 	return (m * HZ + MSEC_PER_SEC - 1) / MSEC_PER_SEC;
 #endif
 }

--

