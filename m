Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbZHILHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbZHILHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 07:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbZHILHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 07:07:38 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49948 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbZHILHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 07:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZTiela//203YItaF5Db9Ro88VCOW7yUjdaFktzMv/F5tBiH7Yu3fBVkJUDyPxoTJrc
         eNkBxhjs+pedmjhOuaye12H9VHhNyxocqNEUQE3TfVZWM64bvW41cebmMZBW0kYzCrRC
         wZ2OArLRS9hrcFWKhThhhg0fTthpFgjXOcOig=
Message-ID: <4A7EAED8.9090900@gmail.com>
Date: Sun, 09 Aug 2009 13:11:20 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel Mack <daniel@caiaq.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Libertas: Association request to the driver failed
References: <20090807191156.GS19257@buzzloop.caiaq.de> <20090807193610.GK7545@tuxdriver.com> <20090808123512.GZ19257@buzzloop.caiaq.de> <4A7D8AB6.9030707@gmail.com> <4A7E9596.4070901@gmail.com> <20090809102417.GH13639@buzzloop.caiaq.de>
In-Reply-To: <20090809102417.GH13639@buzzloop.caiaq.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several arrays were read before checking whether the index was within
bounds. ARRAY_SIZE() should be used to determine the size of arrays.

rates->rates has an arraysize of 1, so calling get_common_rates()
with a rates_size of MAX_RATES (14) was causing reads out of bounds.

tmp_size can increment at most to *rates_size * ARRAY_SIZE(lbs_bg_rates),
so that should be the number of elements of tmp[].

A goto can be eliminated: ret was already set upon its declaration.

---
>>>> The change came in after -rc5,
>>>> and I found 57921c31 ("libertas: Read buffer overflow") to be the
>>>> culprit. Reverting it brings my libertas device back to life. I copied
>>>> the author.
>>>>
>>>> Thanks,
>>>> Daniel
>>> Ah, I think I made an error, I think tmp is too small and should be
>>>
>>> u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates) - 1];
>> After some sleep I realized it should be:
>>
>> u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates)];
> 
> I'll test that tomorrow. Would be easier if you send in a new patch I
> can ack directly in case it works :)

This is the patch that should be applied after the revert, or do you want a
delta patch?

And does this give your libertas back?

Thanks for testing,

Roel

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index b9b3741..e9efc4c 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -1,6 +1,7 @@
 /* Copyright (C) 2006, Red Hat, Inc. */
 
 #include <linux/types.h>
+#include <linux/kernel.h>
 #include <linux/etherdevice.h>
 #include <linux/ieee80211.h>
 #include <linux/if_arp.h>
@@ -43,21 +44,21 @@ static int get_common_rates(struct lbs_private *priv,
 	u16 *rates_size)
 {
 	u8 *card_rates = lbs_bg_rates;
-	size_t num_card_rates = sizeof(lbs_bg_rates);
 	int ret = 0, i, j;
-	u8 tmp[30];
+	u8 tmp[*rates_size * ARRAY_SIZE(lbs_bg_rates)];
 	size_t tmp_size = 0;
 
 	/* For each rate in card_rates that exists in rate1, copy to tmp */
-	for (i = 0; card_rates[i] && (i < num_card_rates); i++) {
-		for (j = 0; rates[j] && (j < *rates_size); j++) {
+	for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && card_rates[i]; i++) {
+		for (j = 0; j < *rates_size && rates[j]; j++) {
 			if (rates[j] == card_rates[i])
 				tmp[tmp_size++] = card_rates[i];
 		}
 	}
 
 	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
-	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates, num_card_rates);
+	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates,
+			ARRAY_SIZE(lbs_bg_rates));
 	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
 	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
 
@@ -69,10 +70,7 @@ static int get_common_rates(struct lbs_private *priv,
 		lbs_pr_alert("Previously set fixed data rate %#x isn't "
 		       "compatible with the network.\n", priv->cur_rate);
 		ret = -1;
-		goto done;
 	}
-	ret = 0;
-
 done:
 	memset(rates, 0, *rates_size);
 	*rates_size = min_t(int, tmp_size, *rates_size);
@@ -322,7 +320,7 @@ static int lbs_associate(struct lbs_private *priv,
 	rates = (struct mrvl_ie_rates_param_set *) pos;
 	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
 	memcpy(&rates->rates, &bss->rates, MAX_RATES);
-	tmplen = MAX_RATES;
+	tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
 	if (get_common_rates(priv, rates->rates, &tmplen)) {
 		ret = -1;
 		goto done;
@@ -598,7 +596,7 @@ static int lbs_adhoc_join(struct lbs_private *priv,
 
 	/* Copy Data rates from the rates recorded in scan response */
 	memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
-	ratesize = min_t(u16, sizeof(cmd.bss.rates), MAX_RATES);
+	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), MAX_RATES);
 	memcpy(cmd.bss.rates, bss->rates, ratesize);
 	if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
 		lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.\n");
