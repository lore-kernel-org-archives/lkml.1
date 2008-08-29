Return-Path: <linux-kernel-owner+w=401wt.eu-S1751964AbYH2PVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751964AbYH2PVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:21:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYH2PVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:21:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:42537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYH2PVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:21:06 -0400
Date: Fri, 29 Aug 2008 08:08:09 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
Subject: [PATCH 4/5] select: make select() use schedule_hrtimeout()
Message-ID: <20080829080809.0e42a323@infradead.org>
In-Reply-To: <20080829080549.6906b744@infradead.org>
References: <20080829080549.6906b744@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Arjan van de Ven <arjan@linux.intel.com>
Date: Thu, 28 Aug 2008 13:45:38 -0700
Subject: [PATCH] select: make select() use schedule_hrtimeout()

now that we have schedule_hrtimeout(), make select() use it.
But only for short delays; really long delays are assumed to not
need the highres level of accuracy but rather want the regular
timer behavior for now.

This is only done for delays shorter than 1 second; currently
the assumption is that longer delays have no desire to get the
higher accuracy.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/select.c |   41 +++++++++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 3ce5943..62b9767 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -24,6 +24,7 @@
 #include <linux/fdtable.h>
 #include <linux/fs.h>
 #include <linux/rcupdate.h>
+#include <linux/hrtimer.h>
 
 #include <asm/uaccess.h>
 
@@ -187,6 +188,7 @@ int do_select(int n, fd_set_bits *fds, s64 *timeout, struct timespec *end_time)
 	struct poll_wqueues table;
 	poll_table *wait;
 	int retval, i;
+	int use_hr = 0;
 
 	rcu_read_lock();
 	retval = max_select_fd(n, fds);
@@ -196,6 +198,10 @@ int do_select(int n, fd_set_bits *fds, s64 *timeout, struct timespec *end_time)
 		return retval;
 	n = retval;
 
+	/* Use hrtimers only for short timeouts for now */
+	if (*timeout < HZ && end_time->tv_sec != 0)
+		use_hr = 1;
+
 	poll_initwait(&table);
 	wait = &table.pt;
 	if (!*timeout)
@@ -266,20 +272,31 @@ int do_select(int n, fd_set_bits *fds, s64 *timeout, struct timespec *end_time)
 			break;
 		}
 
-		if (*timeout < 0) {
-			/* Wait indefinitely */
-			__timeout = MAX_SCHEDULE_TIMEOUT;
-		} else if (unlikely(*timeout >= (s64)MAX_SCHEDULE_TIMEOUT - 1)) {
-			/* Wait for longer than MAX_SCHEDULE_TIMEOUT. Do it in a loop */
-			__timeout = MAX_SCHEDULE_TIMEOUT - 1;
-			*timeout -= __timeout;
+		if (use_hr) {
+			struct timespec now;
+			ktime_t expire;
+			schedule_hrtimeout(end_time, HRTIMER_MODE_ABS);
+			getnstimeofday(&now);
+			expire = ktime_sub(timespec_to_ktime(*end_time), timespec_to_ktime(now));
+			if (ktime_to_ns(expire) <= 0)
+				break;
+
 		} else {
-			__timeout = *timeout;
-			*timeout = 0;
+			if (*timeout < 0) {
+				/* Wait indefinitely */
+				__timeout = MAX_SCHEDULE_TIMEOUT;
+			} else if (unlikely(*timeout >= (s64)MAX_SCHEDULE_TIMEOUT - 1)) {
+				/* Wait for longer than MAX_SCHEDULE_TIMEOUT. Do it in a loop */
+				__timeout = MAX_SCHEDULE_TIMEOUT - 1;
+				*timeout -= __timeout;
+			} else {
+				__timeout = *timeout;
+				*timeout = 0;
+			}
+			__timeout = schedule_timeout(__timeout);
+			if (*timeout >= 0)
+				*timeout += __timeout;
 		}
-		__timeout = schedule_timeout(__timeout);
-		if (*timeout >= 0)
-			*timeout += __timeout;
 	}
 	__set_current_state(TASK_RUNNING);
 
-- 
1.5.5.1

