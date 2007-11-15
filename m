Return-Path: <linux-kernel-owner+w=401wt.eu-S932598AbXKOGuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932598AbXKOGuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758685AbXKOGnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:43:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57691 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762718AbXKOGnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:43:11 -0500
Date: Wed, 14 Nov 2007 22:41:19 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Wu <flamingice@sourmilk.net>, linux-wireless@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 15/16] rtl8187: Fix more frag bit checking, rts duration
	calc
Message-ID: <20071115064119.GP18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="rtl8187-fix-more-frag-bit-checking-rts-duration-calc.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Wu <flamingice@sourmilk.net>

patch 98798f4875b7149db4eb7d0a126fc6dcd9637821 in mainline.

The wrong pointer is passed to ieee80211_get_morefrag. Fix this.

While we're at it, reorder things so they look better and the rts duration
calculation is done with the right length.

Thanks to Christoph Hellwig for finding the ieee80211_get_morefrag issue.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtl8187_dev.c |   31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl8187_dev.c
@@ -78,7 +78,8 @@ static int rtl8187_tx(struct ieee80211_h
 	struct rtl8187_tx_hdr *hdr;
 	struct rtl8187_tx_info *info;
 	struct urb *urb;
-	u32 tmp;
+	__le16 rts_dur = 0;
+	u32 flags;
 
 	urb = usb_alloc_urb(0, GFP_ATOMIC);
 	if (!urb) {
@@ -86,24 +87,24 @@ static int rtl8187_tx(struct ieee80211_h
 		return 0;
 	}
 
-	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
-	tmp = skb->len - sizeof(*hdr);
-	tmp |= RTL8187_TX_FLAG_NO_ENCRYPT;
-	tmp |= control->rts_cts_rate << 19;
-	tmp |= control->tx_rate << 24;
-	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb))
-		tmp |= RTL8187_TX_FLAG_MORE_FRAG;
+	flags = skb->len;
+	flags |= RTL8187_TX_FLAG_NO_ENCRYPT;
+	flags |= control->rts_cts_rate << 19;
+	flags |= control->tx_rate << 24;
+	if (ieee80211_get_morefrag((struct ieee80211_hdr *)skb->data))
+		flags |= RTL8187_TX_FLAG_MORE_FRAG;
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
-		tmp |= RTL8187_TX_FLAG_RTS;
-		hdr->rts_duration =
-			ieee80211_rts_duration(dev, skb->len, control);
+		flags |= RTL8187_TX_FLAG_RTS;
+		rts_dur = ieee80211_rts_duration(dev, skb->len, control);
 	}
 	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
-		tmp |= RTL8187_TX_FLAG_CTS;
-	hdr->flags = cpu_to_le32(tmp);
+		flags |= RTL8187_TX_FLAG_CTS;
+
+	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
+	hdr->flags = cpu_to_le32(flags);
 	hdr->len = 0;
-	tmp = control->retry_limit << 8;
-	hdr->retry = cpu_to_le32(tmp);
+	hdr->rts_duration = rts_dur;
+	hdr->retry = cpu_to_le32(control->retry_limit << 8);
 
 	info = (struct rtl8187_tx_info *)skb->cb;
 	info->control = kmemdup(control, sizeof(*control), GFP_ATOMIC);

-- 
