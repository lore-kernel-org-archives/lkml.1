Return-Path: <linux-kernel-owner+w=401wt.eu-S1751946AbZLRAR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbZLRAR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:17:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZLRARZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:17:25 -0500
Received: from mga09.intel.com ([134.134.136.24]:34059 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbZLRARY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:17:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,415,1257148800"; 
   d="scan'208";a="477219363"
From: "Smith, GeoffX" <geoffx.smith@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 17 Dec 2009 16:17:15 -0800
Subject: [PATCH] prctl: return timerslack through pointer
Thread-Topic: [PATCH] prctl: return timerslack through pointer
Thread-Index: Acp/d3QE6Iz9s5c3S5uq4VZygLlEQw==
Message-ID: <354B2877CF17F44BB3FA44EB4DB0E5470C91CE12F3@orsmsx510.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the semantics of prctl() option PR_GET_TIMERSLACK
to pass the return value through *arg2.

With this change, the option now follows the same conventions as the
other "get" options added since 2.6.0, and also brings it into
conformance with the advice in chapter 16 of Documentation/CodingStyle.

In addition, it effectively doubles the range of time slack to 4.29
seconds (on a 32-bit architecture).

The timer slack feature was only added in Sep 2009 (new in 2.6.32.1), 
so there are not any production applications to break.  I have also 
repaired some unmatched signed/unsigned mismatches in timer slack
calculations.



diff --git a/kernel/sys.c b/kernel/sys.c
index 20ccfb5..e01da12 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1531,7 +1531,8 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 			error = perf_event_task_enable();
 			break;
 		case PR_GET_TIMERSLACK:
-			error = current->timer_slack_ns;
+			error = put_user(current->timer_slack_ns, 
+				(unsigned long __user *)arg2);
 			break;
 		case PR_SET_TIMERSLACK:
 			if (arg2 <= 0)
diff --git a/fs/select.c b/fs/select.c
index fd38ce2..5122364 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -44,10 +44,10 @@
 
 #define MAX_SLACK	(100 * NSEC_PER_MSEC)
 
-static long __estimate_accuracy(struct timespec *tv)
+static unsigned long __estimate_accuracy(struct timespec *tv)
 {
-	long slack;
-	int divfactor = 1000;
+	unsigned long slack;
+	unsigned int divfactor = 1000;
 
 	if (tv->tv_sec < 0)
 		return 0;
@@ -67,7 +67,7 @@ static long __estimate_accuracy(struct timespec *tv)
 	return slack;
 }
 
-static long estimate_accuracy(struct timespec *tv)
+static unsigned long estimate_accuracy(struct timespec *tv)
 {
 	unsigned long ret;
 	struct timespec now;


