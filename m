Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbXJaFJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbXJaFJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753246AbXJaFJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:09:12 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:48850 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbXJaFJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:09:11 -0400
Message-ID: <47280DE6.7030606@cosmosbay.com>
Date: Wed, 31 Oct 2007 06:08:54 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Paul Menage <menage@google.com>
CC: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] CFS : Use NSEC_PER_MSEC and NSEC_PER_SEC in kernel/sched.c
 and kernel/sysctl.c
Content-Type: multipart/mixed;
 boundary="------------070503040604070309090404"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Wed, 31 Oct 2007 06:09:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070503040604070309090404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

1) hardcoded 1000000000 value is used five times in places where NSEC_PER_SEC 
might be more readable.

2) A conversion from nsec to msec uses the hardcoded 1000000 value, which is a 
candidate for NSEC_PER_MSEC.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>


--------------070503040604070309090404
Content-Type: text/plain;
 name="nsec_per_msec.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nsec_per_msec.patch"

diff --git a/kernel/sched.c b/kernel/sched.c
index 3f6bd11..57c539d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -75,7 +75,7 @@
  */
 unsigned long long __attribute__((weak)) sched_clock(void)
 {
-	return (unsigned long long)jiffies * (1000000000 / HZ);
+	return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
 }
 
 /*
@@ -99,8 +99,8 @@ unsigned long long __attribute__((weak)) sched_clock(void)
 /*
  * Some helpers for converting nanosecond timing to jiffy resolution
  */
-#define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (1000000000 / HZ))
-#define JIFFIES_TO_NS(TIME)	((TIME) * (1000000000 / HZ))
+#define NS_TO_JIFFIES(TIME)	((unsigned long)(TIME) / (NSEC_PER_SEC / HZ))
+#define JIFFIES_TO_NS(TIME)	((TIME) * (NSEC_PER_SEC / HZ))
 
 #define NICE_0_LOAD		SCHED_LOAD_SCALE
 #define NICE_0_SHIFT		SCHED_LOAD_SHIFT
@@ -7228,7 +7228,7 @@ static u64 cpu_usage_read(struct cgroup *cgrp, struct cftype *cft)
 		spin_unlock_irqrestore(&cpu_rq(i)->lock, flags);
 	}
 	/* Convert from ns to ms */
-	do_div(res, 1000000);
+	do_div(res, NSEC_PER_MSEC);
 
 	return res;
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3b4efbe..6547f9a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -226,9 +226,9 @@ static struct ctl_table root_table[] = {
 
 #ifdef CONFIG_SCHED_DEBUG
 static unsigned long min_sched_granularity_ns = 100000;		/* 100 usecs */
-static unsigned long max_sched_granularity_ns = 1000000000;	/* 1 second */
+static unsigned long max_sched_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 static unsigned long min_wakeup_granularity_ns;			/* 0 usecs */
-static unsigned long max_wakeup_granularity_ns = 1000000000;	/* 1 second */
+static unsigned long max_wakeup_granularity_ns = NSEC_PER_SEC;	/* 1 second */
 #endif
 
 static struct ctl_table kern_table[] = {

--------------070503040604070309090404--
