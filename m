Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYK0Ked@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYK0Ked (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:34:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYK0KcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:32:25 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:47696 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbYK0KcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:32:19 -0500
Message-Id: <20081127103129.055639526@de.ibm.com>
References: <20081127103020.528516828@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 27 Nov 2008 11:30:25 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 05/60] serialize stp/etr work
Content-Disposition: inline; filename=104-stp-etr-work.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

The work function dispatched with schedule_work() can be run twice
on different cpus because run_workqueue clears the WORK_STRUCT_PENDING
bit and then executes the function. Another cpu can call schedule_work()
again and run the work function a second time before the first call
is completed. This patch serialized the etr and stp work function with
a mutex.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/kernel/time.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

Index: quilt-2.6/arch/s390/kernel/time.c
===================================================================
--- quilt-2.6.orig/arch/s390/kernel/time.c
+++ quilt-2.6/arch/s390/kernel/time.c
@@ -467,6 +467,7 @@ static struct timer_list etr_timer;
 
 static void etr_timeout(unsigned long dummy);
 static void etr_work_fn(struct work_struct *work);
+static DEFINE_MUTEX(etr_work_mutex);
 static DECLARE_WORK(etr_work, etr_work_fn);
 
 /*
@@ -976,6 +977,9 @@ static void etr_work_fn(struct work_stru
 	struct etr_aib aib;
 	int sync_port;
 
+	/* prevent multiple execution. */
+	mutex_lock(&etr_work_mutex);
+
 	/* Create working copy of etr_eacr. */
 	eacr = etr_eacr;
 
@@ -991,7 +995,7 @@ static void etr_work_fn(struct work_stru
 		del_timer_sync(&etr_timer);
 		etr_update_eacr(eacr);
 		clear_bit(CLOCK_SYNC_ETR, &clock_sync_flags);
-		return;
+		goto out_unlock;
 	}
 
 	/* Store aib to get the current ETR status word. */
@@ -1078,7 +1082,7 @@ static void etr_work_fn(struct work_stru
 	    eacr.es || sync_port < 0) {
 		etr_update_eacr(eacr);
 		etr_set_tolec_timeout(now);
-		return;
+		goto out_unlock;
 	}
 
 	/*
@@ -1106,6 +1110,8 @@ static void etr_work_fn(struct work_stru
 		etr_set_sync_timeout();
 	} else
 		etr_set_tolec_timeout(now);
+out_unlock:
+	mutex_unlock(&etr_work_mutex);
 }
 
 /*
@@ -1394,6 +1400,7 @@ static struct stp_sstpi stp_info;
 static void *stp_page;
 
 static void stp_work_fn(struct work_struct *work);
+static DEFINE_MUTEX(stp_work_mutex);
 static DECLARE_WORK(stp_work, stp_work_fn);
 
 static int __init early_parse_stp(char *p)
@@ -1542,24 +1549,30 @@ static void stp_work_fn(struct work_stru
 	struct clock_sync_data stp_sync;
 	int rc;
 
+	/* prevent multiple execution. */
+	mutex_lock(&stp_work_mutex);
+
 	if (!stp_online) {
 		chsc_sstpc(stp_page, STP_OP_CTRL, 0x0000);
-		return;
+		goto out_unlock;
 	}
 
 	rc = chsc_sstpc(stp_page, STP_OP_CTRL, 0xb0e0);
 	if (rc)
-		return;
+		goto out_unlock;
 
 	rc = chsc_sstpi(stp_page, &stp_info, sizeof(struct stp_sstpi));
 	if (rc || stp_info.c == 0)
-		return;
+		goto out_unlock;
 
 	memset(&stp_sync, 0, sizeof(stp_sync));
 	get_online_cpus();
 	atomic_set(&stp_sync.cpus, num_online_cpus() - 1);
 	stop_machine(stp_sync_clock, &stp_sync, &cpu_online_map);
 	put_online_cpus();
+
+out_unlock:
+	mutex_unlock(&stp_work_mutex);
 }
 
 /*

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

