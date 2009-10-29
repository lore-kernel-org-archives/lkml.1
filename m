Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbZJ2Jjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbZJ2Jjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 05:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751766AbZJ2Jjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 05:39:54 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:34151 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbZJ2Jjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 05:39:53 -0400
X-Greylist: delayed 1773 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Oct 2009 05:39:51 EDT
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rodolfo Giometti <giometti@linux.it>
Date: Thu, 29 Oct 2009 10:09:09 +0100
Message-Id: <1256807349-20540-1-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.0.4
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] pps: events reporting fix up.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PPS events must be recorded according to PPS's mode settings.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Tested-by: William S. Brasher <billb958@door.net>
Tested-by: Reg Clemens <clemens@dwf.com>
---
 drivers/pps/kapi.c |   20 +++++++++++++++-----
 1 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 35a0b19..2d414e2 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -271,6 +271,7 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 {
 	struct pps_device *pps;
 	unsigned long flags;
+	int captured = 0;
 
 	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
 		printk(KERN_ERR "pps: unknown event (%x) for source %d\n",
@@ -293,7 +294,8 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 
 	/* Check the event */
 	pps->current_mode = pps->params.mode;
-	if (event & PPS_CAPTUREASSERT) {
+	if ((event & PPS_CAPTUREASSERT) &
+			(pps->params.mode & PPS_CAPTUREASSERT)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETASSERT)
 			pps_add_offset(ts, &pps->params.assert_off_tu);
@@ -303,8 +305,11 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 		pps->assert_sequence++;
 		pr_debug("capture assert seq #%u for source %d\n",
 			pps->assert_sequence, source);
+
+		captured = ~0;
 	}
-	if (event & PPS_CAPTURECLEAR) {
+	if ((event & PPS_CAPTURECLEAR) &
+			(pps->params.mode & PPS_CAPTURECLEAR)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETCLEAR)
 			pps_add_offset(ts, &pps->params.clear_off_tu);
@@ -314,12 +319,17 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 		pps->clear_sequence++;
 		pr_debug("capture clear seq #%u for source %d\n",
 			pps->clear_sequence, source);
+
+		captured = ~0;
 	}
 
-	pps->go = ~0;
-	wake_up_interruptible(&pps->queue);
+	/* Wake up iif captured somthing */
+	if (captured) {
+		pps->go = ~0;
+		wake_up_interruptible(&pps->queue);
 
-	kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
+		kill_fasync(&pps->async_queue, SIGIO, POLL_IN);
+	}
 
 	spin_unlock_irqrestore(&pps->lock, flags);
 
-- 
1.6.0.4

