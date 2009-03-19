Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbZCSQ2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbZCSQ2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZCSQ1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:27:50 -0400
Received: from dgate20.fujitsu-siemens.com ([80.70.172.51]:42341 "EHLO
	dgate20.fujitsu-siemens.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756575AbZCSQ1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:27:48 -0400
DomainKey-Signature: s=s768; d=fujitsu-siemens.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Received:Message-ID:Date:From:Organization:
   User-Agent:MIME-Version:To:Subject:X-Enigmail-Version:
   Content-Type;
  b=qOkN7jvKVIwPTU/R6QLtcTw+Zgn6A2l+rOUJ9bg7U20+6mBCKp3564dd
   pYhQwHQSGOeElR6d1vv3wAUPcnOBTWwM9wW8ZYjU9cLueEn6rIoeAM9ZL
   vnAp4B7+y+tun2q;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.38,389,1233529200"; 
   d="diff'?scan'208";a="56946914"
X-IronPort-AV: E=Sophos;i="4.38,389,1233529200"; 
   d="diff'?scan'208";a="49903646"
Message-ID: <49C27281.4040207@fujitsu-siemens.com>
Date: Thu, 19 Mar 2009 17:27:45 +0100
From: Martin Wilck <martin.wilck@fujitsu-siemens.com>
Organization: Fujitsu Siemens Computers
User-Agent: Thunderbird 2.0.0.15pre (X11/20080508)
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Corey Minyard <minyard@acm.org>,
       openipmi-developer@lists.sourceforge.net
Subject: [PATCH] limit CPU time spent in kipmid
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------070702070202030304020601"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070702070202030304020601
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hello Corey, hi everyone,

here is a patch that limits the CPU time spent in kipmid. I know that it 
was previously stated that current kipmid "works as designed" (e.g. 
http://lists.us.dell.com/pipermail/linux-poweredge/2008-October/037636.html), 
yet users are irritated by the high amount of CPU time kipmid may use up 
on current servers with many sensors, even though it is "nice" CPU time. 
Moreover, kipmid busy-waiting for the KCS interface to become ready also 
prevents CPUs from sleeping.

The attached patch was developed and tested on an enterprise 
distribution kernel where it caused the CPU load of kipmid to drop to 
essentially 0 while still delivering reliable IPMI communication.

I am looking forward for comments.
Martin

-- 
Martin Wilck
PRIMERGY System Software Engineer
FSC IP ESP DEV 6

Fujitsu Siemens Computers GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn
Germany

Tel:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			mailto:martin.wilck@fujitsu-siemens.com
Internet:		http://www.fujitsu-siemens.com
Company Details:	http://www.fujitsu-siemens.com/imprint.html

--------------070702070202030304020601
Content-Type: text/x-patch;
 name="ipmi_si_max_busy-2.6.29-rc8.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipmi_si_max_busy-2.6.29-rc8.diff"

While the current kipmid implementation is optimal in the sense that kipmid obtains
data as quickly as possible without stealing CPU time from other processes
(by running on low prio and calling schedule() in each loop iteration), it
may spend a lot of CPU time polling for data e.g. on the KCS interface. The
busy loop also prevents CPUs from entering sleep states when no KCS data is
available.

This patch adds a module parameter "kipmid_max_busy" that specifies how many
microseconds kipmid should busy-loop before going to sleep. It affects only the
SI_SM_CALL_WITH_DELAY case, where a delay is acceptible. My experiments have shown
that SI_SM_CALL_WITH_DELAY catches about 99% of smi_event_handler calls. The
new parameter defaults to 0 (previous behavior - busy-loop forever).

With this patch, at least on Fujitsu Siemens hardware, the kipmid CPU time can be
reduced to negligible values without noticeably affecting the performance of the
IPMI interface. Recommended values for kipmid_max_busy on this hardware are in the
100us range (50-500us).

Signed-off-by: Martin Wilck <martin.wilck@fujitsu-siemens.com>
--- linux-2.6.29-rc8/drivers/char/ipmi/ipmi_si_intf.c.orig	2009-03-13 03:39:28.000000000 +0100
+++ linux-2.6.29-rc8/drivers/char/ipmi/ipmi_si_intf.c	2009-03-19 13:24:10.009829167 +0100
@@ -298,6 +298,7 @@ static int force_kipmid[SI_MAX_PARMS];
 static int num_force_kipmid;
 
 static int unload_when_empty = 1;
+static unsigned int kipmid_max_busy;
 
 static int try_smi_init(struct smi_info *smi);
 static void cleanup_one_si(struct smi_info *to_clean);
@@ -927,20 +928,53 @@ static void set_run_to_completion(void *
 	}
 }
 
+
+
+static int ipmi_thread_must_sleep(enum si_sm_result smi_result, int *busy,
+				  struct timespec *busy_time)
+{
+	if (kipmid_max_busy == 0)
+		return 0;
+
+	if (smi_result != SI_SM_CALL_WITH_DELAY) {
+		*busy = 0;
+		return 0;
+	}
+
+	if (*busy == 0) {
+		*busy = 1;
+		getnstimeofday(busy_time);
+		timespec_add_ns(busy_time, kipmid_max_busy*NSEC_PER_USEC);
+	} else {
+		struct timespec now;
+		getnstimeofday(&now);
+		if (unlikely(timespec_compare(&now, busy_time))) {
+			*busy = 0;
+			return 1;
+		}
+	}
+	return 0;
+}
+
 static int ipmi_thread(void *data)
 {
 	struct smi_info *smi_info = data;
 	unsigned long flags;
 	enum si_sm_result smi_result;
+	struct timespec busy_time;
+	int busy = 0;
 
 	set_user_nice(current, 19);
 	while (!kthread_should_stop()) {
+		int must_sleep;
 		spin_lock_irqsave(&(smi_info->si_lock), flags);
 		smi_result = smi_event_handler(smi_info, 0);
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
+		must_sleep = ipmi_thread_must_sleep(smi_result,
+						    &busy, &busy_time);
 		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
 			; /* do nothing */
-		else if (smi_result == SI_SM_CALL_WITH_DELAY)
+		else if (smi_result == SI_SM_CALL_WITH_DELAY && !must_sleep)
 			schedule();
 		else
 			schedule_timeout_interruptible(1);
@@ -1213,6 +1247,11 @@ module_param(unload_when_empty, int, 0);
 MODULE_PARM_DESC(unload_when_empty, "Unload the module if no interfaces are"
 		 " specified or found, default is 1.  Setting to 0"
 		 " is useful for hot add of devices using hotmod.");
+module_param(kipmid_max_busy, uint, 0);
+MODULE_PARM_DESC(kipmid_max_busy,
+		 "Max time (in microseconds) to busy-wait for IPMI data before"
+		 " sleeping. 0 (default) means to wait forever. Set to 100-500"
+		 " if kipmid is using up a lot of CPU time.");
 
 
 static void std_irq_cleanup(struct smi_info *info)

--------------070702070202030304020601--
