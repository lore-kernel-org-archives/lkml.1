Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbZG1CIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbZG1CIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 22:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZG1CIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 22:08:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53312 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbZG1CIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 22:08:18 -0400
Date: Tue, 28 Jul 2009 11:59:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Reinette Chatre <reinette.chatre@intel.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20090728115915.7544ad44.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Today's linux-next merge of the net tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-tx.c between commit
3995bd9332a51b626237d6671cfeb7235e6c1305 ("iwlwifi: fix TX queue race")
from the wireless-current tree and commit
45af81956e990440fe78d6d41f847664cb620609 ("iwlwifi: make software queue
assignment more efficient") from the net tree.

Just overlapping context.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-tx.c
index 2e89040,0912987..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@@ -744,21 -749,16 +747,19 @@@ int iwl_tx_skb(struct iwl_priv *priv, s
  		hdr->seq_ctrl |= cpu_to_le16(seq_number);
  		seq_number += 0x10;
  		/* aggregation is on for this <sta,tid> */
- 		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
+ 		if (info->flags & IEEE80211_TX_CTL_AMPDU)
  			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
  	}
  
  	txq = &priv->txq[txq_id];
+ 	swq_id = txq->swq_id;
  	q = &txq->q;
- 	txq->swq_id = swq_id;
  
 -	spin_lock_irqsave(&priv->lock, flags);
 +	if (unlikely(iwl_queue_space(q) < q->high_mark))
 +		goto drop_unlock;
 +
 +	if (ieee80211_is_data_qos(fc))
 +		priv->stations[sta_id].tid[tid].tfds_in_queue++;
  
  	/* Set up driver data for this TFD */
  	memset(&(txq->txb[q->write_ptr]), 0, sizeof(struct iwl_tx_info));
