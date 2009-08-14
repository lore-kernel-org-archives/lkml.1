Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZHNOPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZHNOPN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 10:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbZHNOPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 10:15:12 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55196 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772AbZHNOPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 10:15:10 -0400
Date: Fri, 14 Aug 2009 10:12:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: pull request: wireless-2.6 2009-08-14
Message-ID: <20090814141224.GH2650@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

A couple more squeakers for 2.6.31...one avoids a panic related to
802.11n, the other avoids some memory corruption with rt2x00 devices.

Please let me know if there are problems!

John

---

Individual patches are available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 839d1624b9dcf31fdc02e47359043bb7bd71d6ca:
  Francois Romieu (1):
        8139cp: balance dma_map_single vs dma_unmap_single pair

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Luis R. Rodriguez (1):
      mac80211: fix panic when splicing unprepared TIDs

Pavel Roskin (1):
      rt2x00: fix memory corruption in rf cache, add a sanity check

 drivers/net/wireless/rt2x00/rt2x00.h |    6 ++++--
 net/mac80211/agg-tx.c                |    8 ++++++++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index a498dde..49c9e2c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -849,13 +849,15 @@ struct rt2x00_dev {
 static inline void rt2x00_rf_read(struct rt2x00_dev *rt2x00dev,
 				  const unsigned int word, u32 *data)
 {
-	*data = rt2x00dev->rf[word];
+	BUG_ON(word < 1 || word > rt2x00dev->ops->rf_size / sizeof(u32));
+	*data = rt2x00dev->rf[word - 1];
 }
 
 static inline void rt2x00_rf_write(struct rt2x00_dev *rt2x00dev,
 				   const unsigned int word, u32 data)
 {
-	rt2x00dev->rf[word] = data;
+	BUG_ON(word < 1 || word > rt2x00dev->ops->rf_size / sizeof(u32));
+	rt2x00dev->rf[word - 1] = data;
 }
 
 /*
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 9e5762a..a24e598 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -381,6 +381,14 @@ static void ieee80211_agg_splice_packets(struct ieee80211_local *local,
 		&local->hw, queue,
 		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
 
+	if (!(sta->ampdu_mlme.tid_state_tx[tid] & HT_ADDBA_REQUESTED_MSK))
+		return;
+
+	if (WARN(!sta->ampdu_mlme.tid_tx[tid],
+		 "TID %d gone but expected when splicing aggregates from"
+		 "the pending queue\n", tid))
+		return;
+
 	if (!skb_queue_empty(&sta->ampdu_mlme.tid_tx[tid]->pending)) {
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 		/* mark queue as pending, it is stopped already */
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
