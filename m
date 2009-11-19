Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZKSVmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZKSVmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753790AbZKSVmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:42:08 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:56980 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbZKSVmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:42:07 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202h10c0jzzz2dh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4B05BBAE.2050005@am.sony.com>
Date: Thu, 19 Nov 2009 13:42:06 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: peterz@infradead.org, mingo@redhat.com
CC: tom.leiming@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] LOCKSTAT: patch test - Fix min, max times in /proc/lock_stats
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2009 21:42:04.0598 (UTC) FILETIME=[228E5D60:01CA6961]
X-SEL-encryption-scan: scanned
X-Reverse-DNS: mail8.fw-sd.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix min, max times in /proc/lock_stats

(1) When collecting lock hold and wait times, if the current minimum time is
    zero, it will be replaced by the next time.

(2) When aggregating minimum and maximum lock hold and wait times accross cpus,
    the values are added, instead of selecting the minimum and maximum.


Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

---
 kernel/lockdep.c |   11 	9 +	2 -	0 !
 1 files changed, 9 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -168,7 +168,7 @@ static void lock_time_inc(struct lock_ti
 	if (time > lt->max)
 		lt->max = time;
 
-	if (time < lt->min || !lt->min)
+	if (time < lt->min || !lt->nr)
 		lt->min = time;
 
 	lt->total += time;
@@ -177,8 +177,15 @@ static void lock_time_inc(struct lock_ti
 
 static inline void lock_time_add(struct lock_time *src, struct lock_time *dst)
 {
-	dst->min += src->min;
-	dst->max += src->max;
+	if (!src->nr)
+		return;
+
+	if (src->max > dst->max)
+		dst->max = src->max;
+
+	if (src->min < dst->min || !dst->nr)
+		dst->min = src->min;
+
 	dst->total += src->total;
 	dst->nr += src->nr;
 }

