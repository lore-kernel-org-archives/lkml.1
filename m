Return-Path: <linux-kernel-owner+w=401wt.eu-S1754851AbYFBEdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbYFBEdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 00:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYFBEdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 00:33:09 -0400
Received: from c60.cesmail.net ([216.154.195.49]:29742 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038AbYFBEdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 00:33:06 -0400
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet
	transmit
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
       "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
       Michael Buesch <mb@bu3sch.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20080602000841.qjrd66s3esgscko0-cebfxv@fcnzpbc.arg@webmail.spamcop.net>
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
	 <200805311841.46740.mb@bu3sch.de> <1212252636.2766.10.camel@rd>
	 <200805311954.46639.mb@bu3sch.de> <1212265322.7672.2.camel@johannes.berg>
	 <20080602000841.qjrd66s3esgscko0-cebfxv@fcnzpbc.arg@webmail.spamcop.net>
Content-Type: text/plain
Date: Mon, 02 Jun 2008 00:33:04 -0400
Message-Id: <1212381184.2894.3.camel@rd>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-02 at 00:08 -0400, Pavel Roskin wrote:

> wep_encrypt_skb() in wep.c would not return TX_CONTINUE.  But most  
> importantly, there is a suspicious change in wep_encrypt_skb() - the  
> key is set in the other branch of the condition.
> 
> I'll try to restore the original logic in wep.c.  I'll post a patch if  
> it works.

That was it!  Here's the patch (I'll submit it to John tomorrow if nobody objects).


mac80211: fix hardware WEP support

Setting hardware WEP key was accidentally moved to a wrong place in
57ccbb1cbe3f8e10a500ff8b9fb26dc1a542fe99.  Move it back.  This fixes
kernel panic in b43 if WEP is used.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 net/mac80211/wep.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index c9fd129..e7b6344 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -335,10 +335,10 @@ static int wep_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	info->control.icv_len = WEP_ICV_LEN;
 
 	if (!(tx->key->flags & KEY_FLAG_UPLOADED_TO_HARDWARE)) {
-		info->control.hw_key = &tx->key->conf;
 		if (ieee80211_wep_encrypt(tx->local, skb, tx->key))
 			return -1;
 	} else {
+		info->control.hw_key = &tx->key->conf;
 		if (tx->key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_IV) {
 			if (!ieee80211_wep_add_iv(tx->local, skb, tx->key))
 				return -1;


-- 
Regards,
Pavel Roskin
