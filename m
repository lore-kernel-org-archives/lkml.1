Return-Path: <linux-kernel-owner+w=401wt.eu-S2992722AbXCBXRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992722AbXCBXRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 18:17:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992726AbXCBXRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 18:17:46 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:36567 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992722AbXCBXRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 18:17:45 -0500
Message-ID: <45E8B068.70500@cosmosbay.com>
Date: Sat, 03 Mar 2007 00:16:56 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] : Optimizes timespec_trunc() 
References: <20070301101249.GA29351@skynet.ie>	<20070301160915.6da876c5.akpm@linux-foundation.org>	<45E842F6.5010105@redhat.com>	<20070302085838.bcf9099e.akpm@linux-foundation.org>	<Pine.LNX.4.64.0703020919350.16719@schroedinger.engr.sgi.com>	<20070302093501.34c6ef2a.akpm@linux-foundation.org>	<45E8624E.2080001@redhat.com>	<20070302100619.cec06d6a.akpm@linux-foundation.org>	<Pine.LNX.4.64.0703021012170.17676@schroedinger.engr.sgi.com>	<45E86BA0.50508@redhat.com>	<20070302211207.GJ10643@holomorphy.com>	<45E894D7.2040309@redhat.com>	<20070302135243.ada51084.akpm@linux-foundation.org>	<45E89F1E.8020803@redhat.com> <20070302142256.0127f5ac.akpm@linux-foundation.org>
In-Reply-To: <20070302142256.0127f5ac.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------000305090706060607090706"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 03 Mar 2007 00:17:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000305090706060607090706
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

The first thing done by timespec_trunc() is :

  if (gran <= jiffies_to_usecs(1) * 1000)

This should really be a test against a constant known at compile time.

Alas, it isnt. jiffies_to_usec() was unilined so C compiler emits a function 
call and a multiply to compute : a CONSTANT.

mov    $0x1,%edi
mov    %rbx,0xffffffffffffffe8(%rbp)
mov    %r12,0xfffffffffffffff0(%rbp)
mov    %edx,%ebx
mov    %rsi,0xffffffffffffffc8(%rbp)
mov    %rsi,%r12
callq  ffffffff80232010 <jiffies_to_usecs>
imul   $0x3e8,%eax,%eax
cmp    %ebx,%eax

This patch reorders kernel/time.c a bit so that jiffies_to_usecs() is defined 
before timespec_trunc() so that compiler now generates :

cmp    $0x3d0900,%edx  (HZ=250 on my machine)

This gives a better code (timespec_trunc() becoming a leaf function), and 
shorter kernel size as well.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--------------000305090706060607090706
Content-Type: text/plain;
 name="time.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="time.patch"

diff --git a/kernel/time.c b/kernel/time.c
index c6c80ea..a0cf037 100644
--- a/kernel/time.c
+++ b/kernel/time.c
@@ -247,6 +247,36 @@ struct timespec current_fs_time(struct s
 }
 EXPORT_SYMBOL(current_fs_time);
 
+/*
+ * Convert jiffies to milliseconds and back.
+ *
+ * Avoid unnecessary multiplications/divisions in the
+ * two most common HZ cases:
+ */
+unsigned int inline jiffies_to_msecs(const unsigned long j)
+{
+#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
+	return (MSEC_PER_SEC / HZ) * j;
+#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
+	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
+#else
+	return (j * MSEC_PER_SEC) / HZ;
+#endif
+}
+EXPORT_SYMBOL(jiffies_to_msecs);
+
+unsigned int inline jiffies_to_usecs(const unsigned long j)
+{
+#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
+	return (USEC_PER_SEC / HZ) * j;
+#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
+	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
+#else
+	return (j * USEC_PER_SEC) / HZ;
+#endif
+}
+EXPORT_SYMBOL(jiffies_to_usecs);
+
 /**
  * timespec_trunc - Truncate timespec to a granularity
  * @t: Timespec
@@ -471,36 +501,6 @@ struct timeval ns_to_timeval(const s64 n
 }
 
 /*
- * Convert jiffies to milliseconds and back.
- *
- * Avoid unnecessary multiplications/divisions in the
- * two most common HZ cases:
- */
-unsigned int jiffies_to_msecs(const unsigned long j)
-{
-#if HZ <= MSEC_PER_SEC && !(MSEC_PER_SEC % HZ)
-	return (MSEC_PER_SEC / HZ) * j;
-#elif HZ > MSEC_PER_SEC && !(HZ % MSEC_PER_SEC)
-	return (j + (HZ / MSEC_PER_SEC) - 1)/(HZ / MSEC_PER_SEC);
-#else
-	return (j * MSEC_PER_SEC) / HZ;
-#endif
-}
-EXPORT_SYMBOL(jiffies_to_msecs);
-
-unsigned int jiffies_to_usecs(const unsigned long j)
-{
-#if HZ <= USEC_PER_SEC && !(USEC_PER_SEC % HZ)
-	return (USEC_PER_SEC / HZ) * j;
-#elif HZ > USEC_PER_SEC && !(HZ % USEC_PER_SEC)
-	return (j + (HZ / USEC_PER_SEC) - 1)/(HZ / USEC_PER_SEC);
-#else
-	return (j * USEC_PER_SEC) / HZ;
-#endif
-}
-EXPORT_SYMBOL(jiffies_to_usecs);
-
-/*
  * When we convert to jiffies then we interpret incoming values
  * the following way:
  *

--------------000305090706060607090706--
