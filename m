Return-Path: <linux-kernel-owner+w=401wt.eu-S932733AbYBBJMO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932733AbYBBJMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:12:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932578AbYBBJH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:07:58 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:49580 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbYBBJHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:07:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=oibAvSQDMyDemIakVvtYjhDMq49k2Kgpa54EhqDFpQxrNny8SSykBAygGzMsQEzNQ3zk67gcazShEQM2V4B81rHK5u3LsTV1pPmsvdOhbsNfqBGGJFOooLpi7no5i2w4QFIM+bPKljevhkAcVQVC6IeVqpS6m+X97QOAbbELuNA=
Message-ID: <47A432DA.6080307@gmail.com>
Date: Sat, 02 Feb 2008 14:37:38 +0530
From: Abhishek Sagar <sagar.abhishek@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ktime: Allow ktime_t comparison using ktime_compare
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a timespec style comparison function. Allows two ktime types to be compared
without having to convert to timespec/timeval. Useful for modules doing ktime
based math, especially the ones using ktime_get heavily.

Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
---

diff --git a/include/linux/ktime.h b/include/linux/ktime.h
index a6ddec1..7f9d321 100644
--- a/include/linux/ktime.h
+++ b/include/linux/ktime.h
@@ -95,6 +95,23 @@ static inline ktime_t ktime_set(const long secs, const unsigned long nsecs)
 #define ktime_add(lhs, rhs) \
 		({ (ktime_t){ .tv64 = (lhs).tv64 + (rhs).tv64 }; })
 
+/**
+ * ktime_compare - Compares two ktime_t variables
+ *
+ * Return val:
+ * lhs < rhs:  < 0
+ * lhs == rhs: 0
+ * lhs > rhs:  > 0
+ */
+static inline int ktime_compare(const ktime_t lhs, const ktime_t rhs)
+{
+	if (lhs.tv64 < rhs.tv64)
+		return -1;
+	if (lhs.tv64 > rhs.tv64)
+		return 1;
+	return 0;
+}
+
 /*
  * Add a ktime_t variable and a scalar nanosecond value.
  * res = kt + nsval:
@@ -198,6 +215,23 @@ static inline ktime_t ktime_add(const ktime_t add1, const ktime_t add2)
 }
 
 /**
+ * ktime_compare - Compares two ktime_t variables
+ *
+ * Return val:
+ * lhs < rhs:  < 0
+ * lhs == rhs: 0
+ * lhs > rhs:  > 0
+ */
+static inline int ktime_compare(const ktime_t lhs, const ktime_t rhs)
+{
+	if (lhs.tv.sec < rhs.tv.sec)
+		return -1;
+	if (lhs.tv.sec > rhs.tv.sec)
+		return 1;
+	return lhs.tv.nsec - rhs.tv.nsec;
+}
+
+/**
  * ktime_add_ns - Add a scalar nanoseconds value to a ktime_t variable
  * @kt:		addend
  * @nsec:	the scalar nsec value to add
