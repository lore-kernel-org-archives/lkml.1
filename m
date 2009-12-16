Return-Path: <linux-kernel-owner+w=401wt.eu-S935499AbZLPVYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935499AbZLPVYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 16:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbZLPVYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 16:24:00 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:38023 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932229AbZLPVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 16:23:59 -0500
Date: Wed, 16 Dec 2009 15:23:54 -0600
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Martin Wilck <martin.wilck@ts.fujitsu.com>,
       Jean Delvare <jdelvare@suse.de>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH] IPMI: Add parameter to limit CPU usage in kipmid
Message-id: <20091216212354.GA13097@minyard.local>
Reply-to: minyard@acm.org
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Wilck <martin.wilck@ts.fujitsu.com>

In some cases kipmid can use a lot of CPU.  This adds a way to tune
the CPU used by kipmid to help in those cases.  By setting
kipmid_max_busy_us to a value between 100 and 500, it is possible to
bring down kipmid CPU load to practically 0 without loosing too much
ipmi throughput performance.  Not setting the value, or setting the
value to zero, operation is unaffected.

Signed-off-by: Martin Wilck <martin.wilck@ts.fujitsu.com>
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Corey Minyard <cminyard@mvista.com>

--- linux-2.6.29.4/drivers/char/ipmi/ipmi_si_intf.c	2009-05-19 01:52:34.000000000 +0200
+++ linux-2.6.29-rc8/drivers/char/ipmi/ipmi_si_intf.c	2009-06-04 15:30:34.855398091 +0200
@@ -297,6 +297,9 @@
 static int force_kipmid[SI_MAX_PARMS];
 static int num_force_kipmid;
 
+static unsigned int kipmid_max_busy_us[SI_MAX_PARMS];
+static int num_max_busy_us;
+
 static int unload_when_empty = 1;
 
 static int try_smi_init(struct smi_info *smi);
@@ -927,23 +930,56 @@
 	}
 }
 
+#define ipmi_si_set_not_busy(timespec) \
+	do { (timespec)->tv_nsec = -1; } while (0)
+#define ipmi_si_is_busy(timespec) ((timespec)->tv_nsec != -1)
+
+static int ipmi_thread_busy_wait(enum si_sm_result smi_result,
+				 const struct smi_info *smi_info,
+				 struct timespec *busy_until)
+{
+	unsigned int max_busy_us = 0;
+
+	if (smi_info->intf_num < num_max_busy_us)
+		max_busy_us = kipmid_max_busy_us[smi_info->intf_num];
+	if (max_busy_us == 0 || smi_result != SI_SM_CALL_WITH_DELAY)
+		ipmi_si_set_not_busy(busy_until);
+	else if (!ipmi_si_is_busy(busy_until)) {
+		getnstimeofday(busy_until);
+		timespec_add_ns(busy_until, max_busy_us*NSEC_PER_USEC);
+	} else {
+		struct timespec now;
+		getnstimeofday(&now);
+		if (unlikely(timespec_compare(&now, busy_until) > 0)) {
+			ipmi_si_set_not_busy(busy_until);
+			return 0;
+		}
+	}
+	return 1;
+}
+
 static int ipmi_thread(void *data)
 {
 	struct smi_info *smi_info = data;
 	unsigned long flags;
 	enum si_sm_result smi_result;
+	struct timespec busy_until;
 
+	ipmi_si_set_not_busy(&busy_until);
 	set_user_nice(current, 19);
 	while (!kthread_should_stop()) {
+		int busy_wait;
 		spin_lock_irqsave(&(smi_info->si_lock), flags);
 		smi_result = smi_event_handler(smi_info, 0);
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
+		busy_wait = ipmi_thread_busy_wait(smi_result, smi_info,
+						  &busy_until);
 		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
 			; /* do nothing */
-		else if (smi_result == SI_SM_CALL_WITH_DELAY)
+		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
 			schedule();
 		else
-			schedule_timeout_interruptible(1);
+			schedule_timeout_interruptible(0);
 	}
 	return 0;
 }
@@ -1213,6 +1249,11 @@
 MODULE_PARM_DESC(unload_when_empty, "Unload the module if no interfaces are"
 		 " specified or found, default is 1.  Setting to 0"
 		 " is useful for hot add of devices using hotmod.");
+module_param_array(kipmid_max_busy_us, uint, &num_max_busy_us, 0644);
+MODULE_PARM_DESC(kipmid_max_busy_us,
+		 "Max time (in microseconds) to busy-wait for IPMI data before"
+		 " sleeping. 0 (default) means to wait forever. Set to 100-500"
+		 " if kipmid is using up a lot of CPU time.");
 
 
 static void std_irq_cleanup(struct smi_info *info)
