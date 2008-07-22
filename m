Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbYGVXSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbYGVXSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754223AbYGVXRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:17:33 -0400
Received: from mx1.suse.de ([195.135.220.2]:52677 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754137AbYGVXRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:17:32 -0400
Date: Tue, 22 Jul 2008 16:14:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org, John Linville <linville@tuxdriver.com>,
       bcm43xx-dev@lists.berlios.de, Michael Buesch <mb@bu3sch.de>
Subject: [patch 02/47] b43: Do not return TX_BUSY from op_tx
Message-ID: <20080722231410.GC8282@suse.de>
References: <20080722230208.148102983@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-do-not-return-tx_busy-from-op_tx.patch"
In-Reply-To: <20080722231342.GA8282@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Michael Buesch <mb@bu3sch.de>

Never return TX_BUSY from op_tx. It doesn't make sense to return
TX_BUSY, if we can not transmit the packet.
Drop the packet and return TX_OK.
This will fix the resume hang.

Upstream commit is
66193a7cef2239bfd1b9b96e304770facf7a49c7

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/b43/main.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2607,7 +2607,7 @@ static int b43_op_tx(struct ieee80211_hw
 	int err;
 
 	if (unlikely(!dev))
-		return NETDEV_TX_BUSY;
+		goto drop_packet;
 
 	/* Transmissions on seperate queues can run concurrently. */
 	read_lock_irqsave(&wl->tx_lock, flags);
@@ -2619,7 +2619,12 @@ static int b43_op_tx(struct ieee80211_hw
 	read_unlock_irqrestore(&wl->tx_lock, flags);
 
 	if (unlikely(err))
-		return NETDEV_TX_BUSY;
+		goto drop_packet;
+	return NETDEV_TX_OK;
+
+drop_packet:
+	/* We can not transmit this packet. Drop it. */
+	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
 

-- 
