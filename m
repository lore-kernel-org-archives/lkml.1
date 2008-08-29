Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbYH2PWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbYH2PWR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 11:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbYH2PVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 11:21:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:42541 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbYH2PVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 11:21:08 -0400
Date: Fri, 29 Aug 2008 08:08:43 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, tglx@tglx.de,
       torvalds@linux-foundation.org
Subject: [PATCH 5/5] select: make poll() use schedule_hrtimeout() as well
Message-ID: <20080829080843.6c8b46e2@infradead.org>
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
Date: Thu, 28 Aug 2008 13:46:47 -0700
Subject: [PATCH] select: make poll() use schedule_hrtimeout() as well

similar to the select() patch, use schedule_hrtimeout() in the
poll() codepath.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 fs/select.c |   46 ++++++++++++++++++++++++++++++----------------
 1 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 62b9767..e881b97 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -631,6 +631,10 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 {
 	int count = 0;
 	poll_table* pt = &wait->pt;
+	int use_hr = 0;
+
+	if (*timeout < HZ && *timeout > 0)
+		use_hr = 1;
 
 	/* Optimise the no-wait case */
 	if (!(*timeout))
@@ -673,24 +677,34 @@ static int do_poll(unsigned int nfds,  struct poll_list *list,
 		if (count || !*timeout)
 			break;
 
-		if (*timeout < 0) {
-			/* Wait indefinitely */
-			__timeout = MAX_SCHEDULE_TIMEOUT;
-		} else if (unlikely(*timeout >= (s64)MAX_SCHEDULE_TIMEOUT-1)) {
-			/*
-			 * Wait for longer than MAX_SCHEDULE_TIMEOUT. Do it in
-			 * a loop
-			 */
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
 		} else {
-			__timeout = *timeout;
-			*timeout = 0;
-		}
+			if (*timeout < 0) {
+				/* Wait indefinitely */
+				__timeout = MAX_SCHEDULE_TIMEOUT;
+			} else if (unlikely(*timeout >= (s64)MAX_SCHEDULE_TIMEOUT-1)) {
+				/*
+				 * Wait for longer than MAX_SCHEDULE_TIMEOUT. Do it in
+				 * a loop
+				 */
+				__timeout = MAX_SCHEDULE_TIMEOUT - 1;
+				*timeout -= __timeout;
+			} else {
+				__timeout = *timeout;
+				*timeout = 0;
+			}
 
-		__timeout = schedule_timeout(__timeout);
-		if (*timeout >= 0)
-			*timeout += __timeout;
+			__timeout = schedule_timeout(__timeout);
+			if (*timeout >= 0)
+				*timeout += __timeout;
+		}
 	}
 	__set_current_state(TASK_RUNNING);
 	return count;
-- 
1.5.5.1

