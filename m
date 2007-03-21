Return-Path: <linux-kernel-owner+w=401wt.eu-S964826AbXCUUYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964826AbXCUUYG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:24:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964871AbXCUUYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:24:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:15742 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964826AbXCUUYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:24:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,309,1170662400"; 
   d="scan'208"; a="200303186:sNHT18723936"
Date: Wed, 21 Mar 2007 13:23:40 -0700
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
       tglx@linutronix.de
Subject: [PATCH 2/2] Export deferrable timer through workqueue and use it in ondemand governor
Message-ID: <20070321202339.GB29367@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Add a new deferrable delayed work init. This can be used to schedule work
that are 'unimportant' when CPU is idle and can be called later, when CPU
eventually comes out of idle.

Use this init in cpufreq ondemand governor.
 
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

Index: new/drivers/cpufreq/cpufreq_ondemand.c
===================================================================
--- new.orig/drivers/cpufreq/cpufreq_ondemand.c	2007-03-21 09:16:52.000000000 -0800
+++ new/drivers/cpufreq/cpufreq_ondemand.c	2007-03-21 09:18:08.000000000 -0800
@@ -470,7 +470,7 @@
 	dbs_info->enable = 1;
 	ondemand_powersave_bias_init();
 	dbs_info->sample_type = DBS_NORMAL_SAMPLE;
-	INIT_DELAYED_WORK(&dbs_info->work, do_dbs_timer);
+	INIT_DELAYED_WORK_DEF(&dbs_info->work, do_dbs_timer);
 	queue_delayed_work_on(dbs_info->cpu, kondemand_wq, &dbs_info->work,
 	                      delay);
 }
Index: new/include/linux/workqueue.h
===================================================================
--- new.orig/include/linux/workqueue.h	2007-03-21 09:16:52.000000000 -0800
+++ new/include/linux/workqueue.h	2007-03-21 09:18:08.000000000 -0800
@@ -115,6 +115,12 @@
 		init_timer(&(_work)->timer);			\
 	} while (0)
 
+#define INIT_DELAYED_WORK_DEF(_work, _func)			\
+	do {							\
+		INIT_WORK(&(_work)->work, (_func));		\
+		init_timer_deferrable(&(_work)->timer);		\
+	} while (0)
+
 #define INIT_DELAYED_WORK_NAR(_work, _func)			\
 	do {							\
 		INIT_WORK_NAR(&(_work)->work, (_func));		\
