Return-Path: <linux-kernel-owner+w=401wt.eu-S936227AbZLQEF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936227AbZLQEF5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936158AbZLQEFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:05:34 -0500
Received: from kroah.org ([198.145.64.141]:55921 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935781AbZLQEF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:05:27 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:58 2009
Message-Id: <20091217035658.537655213@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [120/151] ath9k: fix tx status reporting
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Felix Fietkau <nbd@openwrt.org>

This is a backport of upstream commit: e8c6342d989e241513baeba4b05a04b6b1f3bc8b

This patch fixes a bug in ath9k's tx status check, which
caused mac80211 to consider regularly transmitted unicast frames
as un-acked.

When checking the ts_status field for errors, it needs to be masked
with ATH9K_TXERR_FILT, because this field also contains other fields
like ATH9K_TX_ACKED.

Without this patch, AP mode is pretty much unusable, as hostapd
checks the ACK status for the frames that it injects.


Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/ath/ath9k/xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2020,7 +2020,7 @@ static void ath_tx_processq(struct ath_s
 		if (bf_isaggr(bf))
 			txq->axq_aggr_depth--;
 
-		txok = (ds->ds_txstat.ts_status == 0);
+		txok = !(ds->ds_txstat.ts_status & ATH9K_TXERR_FILT);
 		txq->axq_tx_inprogress = false;
 		spin_unlock_bh(&txq->axq_lock);
 


