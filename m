Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYJFXaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYJFXaL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757186AbYJFXW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:22:57 -0400
Received: from mx1.suse.de ([195.135.220.2]:41041 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181AbYJFXW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:22:56 -0400
Date: Mon, 6 Oct 2008 16:17:53 -0700
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Santwona Behera <santwona.behera@sun.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 24/28] niu: panic on reset
Message-ID: <20081006231753.GY20567@suse.de>
References: <20081006225949.357365087@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0002-niu-panic-on-reset.patch"
In-Reply-To: <20081006231639.GA20567@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Santwona Behera <santwona.behera@sun.com>

[ Upstream commit cff502a38394fd33693f6233e03fca363dfa956d ]

The reset_task function in the niu driver does not reset the tx and rx
buffers properly. This leads to panic on reset. This patch is a
modified implementation of the previously posted fix.

Signed-off-by: Santwona Behera <santwona.behera@sun.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/niu.c |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 56 insertions(+)

--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -5230,6 +5230,56 @@ static void niu_netif_start(struct niu *
 	niu_enable_interrupts(np, 1);
 }
 
+static void niu_reset_buffers(struct niu *np)
+{
+	int i, j, k, err;
+
+	if (np->rx_rings) {
+		for (i = 0; i < np->num_rx_rings; i++) {
+			struct rx_ring_info *rp = &np->rx_rings[i];
+
+			for (j = 0, k = 0; j < MAX_RBR_RING_SIZE; j++) {
+				struct page *page;
+
+				page = rp->rxhash[j];
+				while (page) {
+					struct page *next =
+						(struct page *) page->mapping;
+					u64 base = page->index;
+					base = base >> RBR_DESCR_ADDR_SHIFT;
+					rp->rbr[k++] = cpu_to_le32(base);
+					page = next;
+				}
+			}
+			for (; k < MAX_RBR_RING_SIZE; k++) {
+				err = niu_rbr_add_page(np, rp, GFP_ATOMIC, k);
+				if (unlikely(err))
+					break;
+			}
+
+			rp->rbr_index = rp->rbr_table_size - 1;
+			rp->rcr_index = 0;
+			rp->rbr_pending = 0;
+			rp->rbr_refill_pending = 0;
+		}
+	}
+	if (np->tx_rings) {
+		for (i = 0; i < np->num_tx_rings; i++) {
+			struct tx_ring_info *rp = &np->tx_rings[i];
+
+			for (j = 0; j < MAX_TX_RING_SIZE; j++) {
+				if (rp->tx_buffs[j].skb)
+					(void) release_tx_packet(np, rp, j);
+			}
+
+			rp->pending = MAX_TX_RING_SIZE;
+			rp->prod = 0;
+			rp->cons = 0;
+			rp->wrap_bit = 0;
+		}
+	}
+}
+
 static void niu_reset_task(struct work_struct *work)
 {
 	struct niu *np = container_of(work, struct niu, reset_task);
@@ -5252,6 +5302,12 @@ static void niu_reset_task(struct work_s
 
 	niu_stop_hw(np);
 
+	spin_unlock_irqrestore(&np->lock, flags);
+
+	niu_reset_buffers(np);
+
+	spin_lock_irqsave(&np->lock, flags);
+
 	err = niu_init_hw(np);
 	if (!err) {
 		np->timer.expires = jiffies + HZ;

-- 
