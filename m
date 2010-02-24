Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab0BXM25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 07:28:57 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:38504 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab0BXM2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 07:28:52 -0500
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: linuxpps@ml.enneenne.com, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
       stas@lvk.cs.msu.su, Rodolfo Giometti <giometti@enneenne.com>,
       john stultz <johnstul@us.ibm.com>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Reg Clemens <clemens@dwf.com>
Subject: [PATCHv2 2/6] pps: unify timestamp gathering
Date: Wed, 24 Feb 2010 15:28:13 +0300
Message-Id: <c44b39b1a3744ef3e93d5b55324d539f5688a6de.1267008049.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
References: <cover.1267008049.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a helper function to gather timestamps. This way clients don't have
to duplicate it.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 drivers/pps/kapi.c         |   15 +++++++++------
 include/linux/pps_kernel.h |   23 ++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 2d414e2..b87f699 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -267,7 +267,7 @@ EXPORT_SYMBOL(pps_unregister_source);
  *	pps->info.echo(source, event, data);
  */
 
-void pps_event(int source, struct pps_ktime *ts, int event, void *data)
+void pps_event(int source, struct pps_event_time *ts, int event, void *data)
 {
 	struct pps_device *pps;
 	unsigned long flags;
@@ -284,7 +284,8 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 		return;
 
 	pr_debug("PPS event on source %d at %llu.%06u\n",
-			pps->id, (unsigned long long) ts->sec, ts->nsec);
+			pps->id, (unsigned long long) ts->ts_real.sec,
+			ts->ts_real.nsec);
 
 	spin_lock_irqsave(&pps->lock, flags);
 
@@ -298,10 +299,11 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 			(pps->params.mode & PPS_CAPTUREASSERT)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETASSERT)
-			pps_add_offset(ts, &pps->params.assert_off_tu);
+			pps_add_offset(&ts->ts_real,
+					&pps->params.assert_off_tu);
 
 		/* Save the time stamp */
-		pps->assert_tu = *ts;
+		pps->assert_tu = ts->ts_real;
 		pps->assert_sequence++;
 		pr_debug("capture assert seq #%u for source %d\n",
 			pps->assert_sequence, source);
@@ -312,10 +314,11 @@ void pps_event(int source, struct pps_ktime *ts, int event, void *data)
 			(pps->params.mode & PPS_CAPTURECLEAR)) {
 		/* We have to add an offset? */
 		if (pps->params.mode & PPS_OFFSETCLEAR)
-			pps_add_offset(ts, &pps->params.clear_off_tu);
+			pps_add_offset(&ts->ts_real,
+					&pps->params.clear_off_tu);
 
 		/* Save the time stamp */
-		pps->clear_tu = *ts;
+		pps->clear_tu = ts->ts_real;
 		pps->clear_sequence++;
 		pr_debug("capture clear seq #%u for source %d\n",
 			pps->clear_sequence, source);
diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index e0a193f..a2804c1 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -40,6 +40,10 @@ struct pps_source_info {
 	struct device *dev;
 };
 
+struct pps_event_time {
+	struct pps_ktime ts_real;
+};
+
 /* The main struct */
 struct pps_device {
 	struct pps_source_info info;		/* PSS source info */
@@ -86,4 +90,21 @@ extern int pps_register_source(struct pps_source_info *info,
 extern void pps_unregister_source(int source);
 extern int pps_register_cdev(struct pps_device *pps);
 extern void pps_unregister_cdev(struct pps_device *pps);
-extern void pps_event(int source, struct pps_ktime *ts, int event, void *data);
+extern void pps_event(int source, struct pps_event_time *ts, int event,
+		void *data);
+
+static inline void timespec_to_pps_ktime(struct pps_ktime *kt,
+		struct timespec ts)
+{
+	kt->sec = ts.tv_sec;
+	kt->nsec = ts.tv_nsec;
+}
+
+static inline void pps_get_ts(struct pps_event_time *ts)
+{
+	struct timespec ts_real;
+
+	getnstimeofday(&ts_real);
+	timespec_to_pps_ktime(&ts->ts_real, ts_real);
+}
+
-- 
1.6.6.1

