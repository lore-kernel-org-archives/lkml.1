Return-Path: <linux-kernel-owner+w=401wt.eu-S1756427AbZKFJga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427AbZKFJga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 04:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755447AbZKFJg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 04:36:29 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40489 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330AbZKFJg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 04:36:28 -0500
From: "Dasgupta, Romit" <romit@ti.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Date: Fri, 6 Nov 2009 15:06:02 +0530
Subject: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel threads 
Thread-Topic: [PATCH 1/1] PM: Thaws refrigerated and to be exited kernel
 threads 
Thread-Index: AcpexI3YkX8ksHLLSeSQhVt8kYH8Tw==
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301DE31F934@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kicks out a frozen thread from the refrigerator when an active thread has
invoked kthread_stop on the frozen thread.

Signed-off-by: Romit Dasgupta <romit@ti.com>
---

diff --git a/kernel/freezer.c b/kernel/freezer.c
index bd1d42b..c28dbe8 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/syscalls.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 
 /*
  * freezing is complete, mark current process as frozen
@@ -49,7 +50,7 @@ void refrigerator(void)
 
 	for (;;) {
 		set_current_state(TASK_UNINTERRUPTIBLE);
-		if (!frozen(current))
+		if (!frozen(current) || (!current->mm && kthread_should_stop()))
 			break;
 		schedule();
 	}
