Return-Path: <linux-kernel-owner+w=401wt.eu-S1756348AbYE2NDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348AbYE2NDW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbYE2NBM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:01:12 -0400
Received: from mtagate2.de.ibm.com ([195.212.29.151]:30153 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924AbYE2NBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:01:09 -0400
Message-Id: <20080529125729.367911865@de.ibm.com>
References: <20080529125501.196123527@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 14:55:06 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 05/11] appldata: prevent cpu hotplug when walking cpu_online_map.
Content-Disposition: inline; filename=005-appldate-getcpu.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerald Schaefer <gerald.schaefer@de.ibm.com>

Use get_online_cpus() to prevent cpu hotplug in situations where
for_each_online_cpu() is called.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/appldata/appldata_base.c |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: quilt-2.6/arch/s390/appldata/appldata_base.c
===================================================================
--- quilt-2.6.orig/arch/s390/appldata/appldata_base.c
+++ quilt-2.6/arch/s390/appldata/appldata_base.c
@@ -130,6 +130,7 @@ static void appldata_work_fn(struct work
 
 	P_DEBUG("  -= Work Queue =-\n");
 	i = 0;
+	get_online_cpus();
 	spin_lock(&appldata_ops_lock);
 	list_for_each(lh, &appldata_ops_list) {
 		ops = list_entry(lh, struct appldata_ops, list);
@@ -140,6 +141,7 @@ static void appldata_work_fn(struct work
 		}
 	}
 	spin_unlock(&appldata_ops_lock);
+	put_online_cpus();
 }
 
 /*
@@ -266,12 +268,14 @@ appldata_timer_handler(ctl_table *ctl, i
 	len = *lenp;
 	if (copy_from_user(buf, buffer, len > sizeof(buf) ? sizeof(buf) : len))
 		return -EFAULT;
+	get_online_cpus();
 	spin_lock(&appldata_timer_lock);
 	if (buf[0] == '1')
 		__appldata_vtimer_setup(APPLDATA_ADD_TIMER);
 	else if (buf[0] == '0')
 		__appldata_vtimer_setup(APPLDATA_DEL_TIMER);
 	spin_unlock(&appldata_timer_lock);
+	put_online_cpus();
 out:
 	*lenp = len;
 	*ppos += len;
@@ -314,10 +318,12 @@ appldata_interval_handler(ctl_table *ctl
 		return -EINVAL;
 	}
 
+	get_online_cpus();
 	spin_lock(&appldata_timer_lock);
 	appldata_interval = interval;
 	__appldata_vtimer_setup(APPLDATA_MOD_TIMER);
 	spin_unlock(&appldata_timer_lock);
+	put_online_cpus();
 
 	P_INFO("Monitoring CPU interval set to %u milliseconds.\n",
 		 interval);
@@ -556,8 +562,10 @@ static int __init appldata_init(void)
 		return -ENOMEM;
 	}
 
+	get_online_cpus();
 	for_each_online_cpu(i)
 		appldata_online_cpu(i);
+	put_online_cpus();
 
 	/* Register cpu hotplug notifier */
 	register_hotcpu_notifier(&appldata_nb);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

