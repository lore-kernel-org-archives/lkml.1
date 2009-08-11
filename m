Return-Path: <linux-kernel-owner+w=401wt.eu-S1751466AbZHKLx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbZHKLx2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 07:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393AbZHKLx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 07:53:26 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:52579 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbZHKLxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 07:53:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qvuyNsfFxk9DY6/0+c6cQCZeQjcrCZpsXQT90l/d2uvJLNJwmKG6sTgON1Ar74Y21h
         Laq/GeHularFt5nSMRMBgvDx+qmeEdfonDV/zJzYIakCgoodpm7aJ7NQ6ePHqpRCKH+f
         v7AMrBkznKuUDdIEQEaRtwTVQVdNdtnOfZQ8s=
Message-ID: <4A811776.8090003@gmail.com>
Date: Tue, 11 Aug 2009 09:02:14 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Daniel Mack <daniel@caiaq.de>, libertas-dev@lists.infradead.org,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Libertas: Association request to the driver failed
References: <20090807191156.GS19257@buzzloop.caiaq.de> <20090807193610.GK7545@tuxdriver.com> <20090808123512.GZ19257@buzzloop.caiaq.de> <4A7D8AB6.9030707@gmail.com> <4A7E9596.4070901@gmail.com> <20090809102417.GH13639@buzzloop.caiaq.de> <4A7EAED8.9090900@gmail.com> <20090810175939.GH2733@tuxdriver.com>
In-Reply-To: <20090810175939.GH2733@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size of the tmp buffer was too small, causing a regression

rates->rates has an arraysize of 1, so a memcpy with
MAX_RATES (14) was already causing reads out of bounds.

In get_common_rates() the memset/memcpy can be moved upwards.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Tested-by: Daniel Mack <daniel@caiaq.de>
---
> Delta patch, please...

Here,

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index d699737..ba0164a 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -44,8 +44,8 @@ static int get_common_rates(struct lbs_private *priv,
 	u16 *rates_size)
 {
 	u8 *card_rates = lbs_bg_rates;
-	int ret = 0, i, j;
-	u8 tmp[(ARRAY_SIZE(lbs_bg_rates) - 1) * (*rates_size - 1)];
+	int i, j;
+	u8 tmp[MAX_RATES * ARRAY_SIZE(lbs_bg_rates)];
 	size_t tmp_size = 0;
 
 	/* For each rate in card_rates that exists in rate1, copy to tmp */
@@ -62,20 +62,23 @@ static int get_common_rates(struct lbs_private *priv,
 	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
 	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
 
+	memset(rates, 0, *rates_size);
+	*rates_size = min_t(u16, tmp_size, *rates_size);
+	memcpy(rates, tmp, *rates_size);
+
 	if (!priv->enablehwauto) {
 		for (i = 0; i < tmp_size; i++) {
 			if (tmp[i] == priv->cur_rate)
-				goto done;
+				break;
+		}
+		if (i == tmp_size) {
+			lbs_pr_alert("Previously set fixed data rate %#x isn't "
+					"compatible with the network.\n",
+					priv->cur_rate);
+			return -1;
 		}
-		lbs_pr_alert("Previously set fixed data rate %#x isn't "
-		       "compatible with the network.\n", priv->cur_rate);
-		ret = -1;
 	}
-done:
-	memset(rates, 0, *rates_size);
-	*rates_size = min_t(int, tmp_size, *rates_size);
-	memcpy(rates, tmp, *rates_size);
-	return ret;
+	return 0;
 }
 
 
@@ -319,8 +322,8 @@ static int lbs_associate(struct lbs_private *priv,
 
 	rates = (struct mrvl_ie_rates_param_set *) pos;
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
-	memcpy(&rates->rates, &bss->rates, MAX_RATES);
 	tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
+	memcpy(&rates->rates, &bss->rates, tmplen);
 	if (get_common_rates(priv, rates->rates, &tmplen)) {
 		ret = -1;
 		goto done;
