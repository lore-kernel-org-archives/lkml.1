Return-Path: <linux-kernel-owner+w=401wt.eu-S2993253AbXDSMEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993253AbXDSMEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 08:04:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993255AbXDSMEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 08:04:00 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40315 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993253AbXDSMD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 08:03:59 -0400
Date: Thu, 19 Apr 2007 17:32:34 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       vatsa@in.ibm.com, paulmck@us.ibm.com, pavel@ucw.cz
Subject: [RFC PATCH 1/2] Fix PF_NOFREEZE and freezeable race
Message-ID: <20070419120234.GA17069@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20070419120131.GB13435@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419120131.GB13435@in.ibm.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the race pointed out by Oleg Nesterov.

* Freezer marks a thread as freezeable. 
* The thread now marks itself PF_NOFREEZE causing it to
  freeze on calling try_to_freeze(). Thus the task is frozen, even though
  it doesn't want to.
* Subsequent thaw_processes() will also fail to thaw the task since it is 
  marked PF_NOFREEZE.

Avoid this problem by checking the current task's PF_NOFREEZE status in the 
refrigerator before marking current as frozen.

Signed-off-by: Gautham R Shenoy <ego@in.ibm.com>
---
 kernel/power/process.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-2.6.21-rc6/kernel/power/process.c
===================================================================
--- linux-2.6.21-rc6.orig/kernel/power/process.c
+++ linux-2.6.21-rc6/kernel/power/process.c
@@ -41,6 +41,15 @@ void refrigerator(void)
 
 	task_lock(current);
 	if (freezing(current)) {
+		/* check if we had marked ourself PF_NOFREEZE
+		 * *after* the freezer did the freezeable() check
+		 * on us.
+		 */
+		if (current->flags & PF_NOFREEZE) {
+			clear_tsk_thread_flag(current, TIF_FREEZE);
+			task_unlock(current);
+			return;
+		}
 		frozen_process(current);
 		task_unlock(current);
 	} else {
-- 
Gautham R Shenoy
Linux Technology Center
IBM India.
"Freedom comes with a price tag of responsibility, which is still a bargain,
because Freedom is priceless!"
