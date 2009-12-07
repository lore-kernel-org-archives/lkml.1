Return-Path: <linux-kernel-owner+w=401wt.eu-S934525AbZLGAaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934525AbZLGAaZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:30:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758425AbZLGANA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:13:00 -0500
Received: from kroah.org ([198.145.64.141]:34294 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758370AbZLGAMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:12:50 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:45 2009
Message-Id: <20091207000645.293589784@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:00:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Rodolfo Giometti <giometti@linux.it>
Subject: [031/119] pps: events reporting fix up
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=pps-events-reporting-fix-up.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Rodolfo Giometti <giometti@linux.it>

commit 276b282e904f690dc930f9bc946110651f297669 upstream.

PPS events must be recorded according to PPS's mode settings.

If a process asks for (i.e.) capture-assert events only, when the PPS
client calls the pps_event() function to save the current PPS event, we
should verify the event type and then discard unwanted ones.

Also, without this patch userland processes waiting for a specific PPS
event (assert or clear but not both) may be awakened at wrong time.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
Tested-by: William S. Brasher <billb958@door.net>
Tested-by: Reg Clemens <clemens@dwf.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pps/kapi.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -271,6 +271,7 @@ void pps_event(int source, struct pps_kt
 {
 	struct pps_device *pps;
 	unsigned long flags;
+	int captured = 0;
 
 	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) == 0) {
 		printk(KERN_ERR "pps: unknown event (%x) for source %d\n",
@@ -293,7 +294,8 @@ void pps_event(int source, struct pps_kt
 
 	/* Check the event */
 	pps->current_mode = pps->params.mode;
-	if (event & PPS_CAPTUREASSERT) {
+	if ((event & PPS_CAPTUREASSERT) &
+			(pps->params.mode & PPS_CAPTUREASSERT)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETASSERT)
 			pps_add_offset(ts, &pps->params.assert_off_tu);
@@ -303,8 +305,11 @@ void pps_event(int source, struct pps_kt
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
@@ -314,12 +319,17 @@ void pps_event(int source, struct pps_kt
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
 


