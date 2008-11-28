Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYK1CIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYK1CIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 21:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753228AbYK1CIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 21:08:13 -0500
Received: from mail.windriver.com ([147.11.1.11]:41612 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225AbYK1CIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 21:08:12 -0500
From: Liming Wang <liming.wang@windriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Liming Wang <liming.wang@windriver.com>
Subject: [PATCH 1/1] softirq: remove useless function __local_bh_enable
Date: Fri, 28 Nov 2008 09:52:40 +0800
Message-Id: <1227837160-3280-1-git-send-email-liming.wang@windriver.com>
X-Mailer: git-send-email 1.6.0.3
X-OriginalArrivalTime: 28 Nov 2008 02:07:54.0459 (UTC) FILETIME=[1FF142B0:01C950FE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__local_bh_enable has been replaced with _local_bh_enable.
As comments says "it always nests inside local_bh_enable() sections"
has not been valid now. Also there is no reason to use __local_bh_enable
anywhere, so we can remove this useless function.

Signed-off-by: Liming Wang <liming.wang@windriver.com>
---
 include/linux/bottom_half.h |    1 -
 kernel/softirq.c            |   14 --------------
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/include/linux/bottom_half.h b/include/linux/bottom_half.h
index 777dbf6..27b1bcf 100644
--- a/include/linux/bottom_half.h
+++ b/include/linux/bottom_half.h
@@ -2,7 +2,6 @@
 #define _LINUX_BH_H
 
 extern void local_bh_disable(void);
-extern void __local_bh_enable(void);
 extern void _local_bh_enable(void);
 extern void local_bh_enable(void);
 extern void local_bh_enable_ip(unsigned long ip);
diff --git a/kernel/softirq.c b/kernel/softirq.c
index e7c69a7..8d9934b 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -102,20 +102,6 @@ void local_bh_disable(void)
 
 EXPORT_SYMBOL(local_bh_disable);
 
-void __local_bh_enable(void)
-{
-	WARN_ON_ONCE(in_irq());
-
-	/*
-	 * softirqs should never be enabled by __local_bh_enable(),
-	 * it always nests inside local_bh_enable() sections:
-	 */
-	WARN_ON_ONCE(softirq_count() == SOFTIRQ_OFFSET);
-
-	sub_preempt_count(SOFTIRQ_OFFSET);
-}
-EXPORT_SYMBOL_GPL(__local_bh_enable);
-
 /*
  * Special-case - softirqs can safely be enabled in
  * cond_resched_softirq(), or by __do_softirq(),
-- 
1.6.0.3

