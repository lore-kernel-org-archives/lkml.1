Return-Path: <linux-kernel-owner+w=401wt.eu-S1756292AbZDNNzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292AbZDNNzr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 09:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756294AbZDNNxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 09:53:55 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:46266 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021AbZDNNxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 09:53:49 -0400
Message-Id: <20090414135347.279922307@de.ibm.com>
References: <20090414135327.576111185@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 14 Apr 2009 15:53:31 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 04/14] stp synchronization retry timer
Content-Disposition: inline; filename=004-stp-retry.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Add a timer that retries the clock synchronization via the server time
protocol if there is a usable clock but the synchronization failed.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/time.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

Index: quilt-2.6/arch/s390/kernel/time.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/time.c
+++ quilt-2.6/arch/s390/kernel/time.c
@@ -1423,6 +1423,7 @@ static void *stp_page;
 static void stp_work_fn(struct work_struct *work);
 static DEFINE_MUTEX(stp_work_mutex);
 static DECLARE_WORK(stp_work, stp_work_fn);
+static struct timer_list stp_timer;
 
 static int __init early_parse_stp(char *p)
 {
@@ -1454,10 +1455,16 @@ static void __init stp_reset(void)
 	}
 }
 
+static void stp_timeout(unsigned long dummy)
+{
+	queue_work(time_sync_wq, &stp_work);
+}
+
 static int __init stp_init(void)
 {
 	if (!test_bit(CLOCK_SYNC_HAS_STP, &clock_sync_flags))
 		return 0;
+	setup_timer(&stp_timer, stp_timeout, 0UL);
 	time_init_wq();
 	if (!stp_online)
 		return 0;
@@ -1565,6 +1572,7 @@ static void stp_work_fn(struct work_stru
 
 	if (!stp_online) {
 		chsc_sstpc(stp_page, STP_OP_CTRL, 0x0000);
+		del_timer_sync(&stp_timer);
 		goto out_unlock;
 	}
 
@@ -1586,6 +1594,13 @@ static void stp_work_fn(struct work_stru
 	stop_machine(stp_sync_clock, &stp_sync, &cpu_online_map);
 	put_online_cpus();
 
+	if (!check_sync_clock())
+		/*
+		 * There is a usable clock but the synchonization failed.
+		 * Retry after a second.
+		 */
+		mod_timer(&stp_timer, jiffies + HZ);
+
 out_unlock:
 	mutex_unlock(&stp_work_mutex);
 }

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

