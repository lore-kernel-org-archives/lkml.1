Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab0B0GNE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 01:13:04 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61320 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab0B0GNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 01:13:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=AFfmocBLZeEmUhmMquGwHeenEy9VfoqygELus+k5h28QQ7jlvqNoVrFO6iHqlTbuqh
         hJGkwUAAGNHtC/MC6DZZowXWtgfMUDezmcCs7ousGEYd6CtHnT8QXd02AIZdD6wXUMSs
         nNOuNLqabfFIGObX7yxajqd9naRfHCn311dXg=
Date: Sat, 27 Feb 2010 09:12:34 +0300
From: Dan Carpenter <error27@gmail.com>
To: Daniel Drake <dsd@gentoo.org>
Cc: Ulrich Kunitz <kune@deine-taler.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
       Benoit PAPILLAULT <benoit.papillault@free.fr>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] zd1211rw: fix potential array underflow
Message-ID: <20100227061234.GA14323@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	=?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first chunk fixes a debugging assert to print a warning about array underflows.
The second chunk corrects a potential array underflow.  I also removed an assert
in the second chunk because it can no longer happen.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This was found by a static check and compile tested only.  Please review carefully.

diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
index f14deb0..ead2f2c 100644
--- a/drivers/net/wireless/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/zd1211rw/zd_mac.c
@@ -350,7 +350,7 @@ static void zd_mac_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
 	first_idx = info->status.rates[0].idx;
 	ZD_ASSERT(0<=first_idx && first_idx<ARRAY_SIZE(zd_retry_rates));
 	retries = &zd_retry_rates[first_idx];
-	ZD_ASSERT(0<=retry && retry<=retries->count);
+	ZD_ASSERT(1 <= retry && retry <= retries->count);
 
 	info->status.rates[0].idx = retries->rate[0];
 	info->status.rates[0].count = 1; // (retry > 1 ? 2 : 1);
@@ -360,7 +360,7 @@ static void zd_mac_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
 		info->status.rates[i].count = 1; // ((i==retry-1) && success ? 1:2);
 	}
 	for (; i<IEEE80211_TX_MAX_RATES && i<retry; i++) {
-		info->status.rates[i].idx = retries->rate[retry-1];
+		info->status.rates[i].idx = retries->rate[retry - 1];
 		info->status.rates[i].count = 1; // (success ? 1:2);
 	}
 	if (i<IEEE80211_TX_MAX_RATES)
@@ -424,12 +424,10 @@ void zd_mac_tx_failed(struct urb *urb)
 		first_idx = info->status.rates[0].idx;
 		ZD_ASSERT(0<=first_idx && first_idx<ARRAY_SIZE(zd_retry_rates));
 		retries = &zd_retry_rates[first_idx];
-		if (retry < 0 || retry > retries->count) {
+		if (retry <= 0 || retry > retries->count)
 			continue;
-		}
 
-		ZD_ASSERT(0<=retry && retry<=retries->count);
-		final_idx = retries->rate[retry-1];
+		final_idx = retries->rate[retry - 1];
 		final_rate = zd_rates[final_idx].hw_value;
 
 		if (final_rate != tx_status->rate) {
