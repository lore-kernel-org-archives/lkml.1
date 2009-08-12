Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbZHLOrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbZHLOrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 10:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbZHLOrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 10:47:18 -0400
Received: from ppsw-6.csi.cam.ac.uk ([131.111.8.136]:60198 "EHLO
	ppsw-6.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZHLOrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 10:47:17 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4A8281AD.1010807@cam.ac.uk>
Date: Wed, 12 Aug 2009 08:47:41 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Michael Buesch <mb@bu3sch.de>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       Daniel Mack <daniel@caiaq.de>
Subject: Re: Libertas: Association request to the driver failed
References: <20090807191156.GS19257@buzzloop.caiaq.de>	<20090809102417.GH13639@buzzloop.caiaq.de>	<4A7EAED8.9090900@gmail.com> <200908091310.56919.mb@bu3sch.de>	<20090809191359.GG4805@lenovo> <4A7FF84C.7070708@gmail.com>
In-Reply-To: <4A7FF84C.7070708@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All, 

After applying this patch I've been receiving 0x12 response from
an access point (association failed: not all rates supported)
to association requests.

See below for queries on what is happening,
> Several arrays were read before checking whether the index was within
> bounds. ARRAY_SIZE() should be used to determine the size of arrays.
> 
> rates->rates has an arraysize of 1, so calling get_common_rates()
> with a rates_size of MAX_RATES (14) was causing reads out of bounds.
> 
> tmp_size can increment at most to MAX_RATES * ARRAY_SIZE(lbs_bg_rates),
> so that should be the number of elements of tmp[].
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> 
>> | Is it a good idea to use dynamic stack arrays in the kernel?
>> | What about kmalloc for dynamic allocations?
>> | 
>> | -- 
>> | Greetings, Michael.
>>
>> I saw one pattern in trace code (not sure if it's
>> still there) but personally don't like dynamic
>> stack arrays (though at moment the max value
>> being passed into routine is known maybe just
>> use MAX_RATES instead of (*rates_size)?). Hmm?
> 
> Good point.
> 
>> 	-- Cyrill
> 
> Thanks,
> 
> I think there was another problem in lbs_associate(),
> the memcpy already affected rates->rates.
> 
> Also in get_common_rates() I think we can safely move the
> memset/memcpy, originally after label done, upwards.
> 
> The patch below, if correct, is to be applied after the revert
> 
> Roel
> 
> diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
> index b9b3741..ba0164a 100644
> --- a/drivers/net/wireless/libertas/assoc.c
> +++ b/drivers/net/wireless/libertas/assoc.c
> @@ -1,6 +1,7 @@
>  /* Copyright (C) 2006, Red Hat, Inc. */
>  
>  #include <linux/types.h>
> +#include <linux/kernel.h>
>  #include <linux/etherdevice.h>
>  #include <linux/ieee80211.h>
>  #include <linux/if_arp.h>
> @@ -43,41 +44,41 @@ static int get_common_rates(struct lbs_private *priv,
>  	u16 *rates_size)
>  {
>  	u8 *card_rates = lbs_bg_rates;
> -	size_t num_card_rates = sizeof(lbs_bg_rates);
> -	int ret = 0, i, j;
> -	u8 tmp[30];
> +	int i, j;
> +	u8 tmp[MAX_RATES * ARRAY_SIZE(lbs_bg_rates)];
>  	size_t tmp_size = 0;
>  
>  	/* For each rate in card_rates that exists in rate1, copy to tmp */
> -	for (i = 0; card_rates[i] && (i < num_card_rates); i++) {
> -		for (j = 0; rates[j] && (j < *rates_size); j++) {
> +	for (i = 0; i < ARRAY_SIZE(lbs_bg_rates) && card_rates[i]; i++) {
> +		for (j = 0; j < *rates_size && rates[j]; j++) {
>  			if (rates[j] == card_rates[i])
>  				tmp[tmp_size++] = card_rates[i];
>  		}
>  	}
>  
>  	lbs_deb_hex(LBS_DEB_JOIN, "AP rates    ", rates, *rates_size);
> -	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates, num_card_rates);
> +	lbs_deb_hex(LBS_DEB_JOIN, "card rates  ", card_rates,
> +			ARRAY_SIZE(lbs_bg_rates));
>  	lbs_deb_hex(LBS_DEB_JOIN, "common rates", tmp, tmp_size);
>  	lbs_deb_join("TX data rate 0x%02x\n", priv->cur_rate);
>  
> +	memset(rates, 0, *rates_size);
> +	*rates_size = min_t(u16, tmp_size, *rates_size);
> +	memcpy(rates, tmp, *rates_size);
> +
>  	if (!priv->enablehwauto) {
>  		for (i = 0; i < tmp_size; i++) {
>  			if (tmp[i] == priv->cur_rate)
> -				goto done;
> +				break;
> +		}
> +		if (i == tmp_size) {
> +			lbs_pr_alert("Previously set fixed data rate %#x isn't "
> +					"compatible with the network.\n",
> +					priv->cur_rate);
> +			return -1;
>  		}
> -		lbs_pr_alert("Previously set fixed data rate %#x isn't "
> -		       "compatible with the network.\n", priv->cur_rate);
> -		ret = -1;
> -		goto done;
>  	}
> -	ret = 0;
> -
> -done:
> -	memset(rates, 0, *rates_size);
> -	*rates_size = min_t(int, tmp_size, *rates_size);
> -	memcpy(rates, tmp, *rates_size);
> -	return ret;
> +	return 0;
>  }
>  
>  
> @@ -321,8 +322,8 @@ static int lbs_associate(struct lbs_private *priv,
>  
>  	rates = (struct mrvl_ie_rates_param_set *) pos;
>  	rates->header.type = cpu_to_le16(TLV_TYPE_RATES);
> -	memcpy(&rates->rates, &bss->rates, MAX_RATES);
> -	tmplen = MAX_RATES;
> +	tmplen = min_t(u16, ARRAY_SIZE(rates->rates), MAX_RATES);
Isn't this always going to be 1? Switching back to original version
allows association to work for me.

As is, it only allows one rate to be tested as ARRAY_SIZE(rates->rates)
is always 1 as it stands.  

If this is the desired behaviour please explain why?
I'll admit I'm not really sure what should be happening, I've merely
been bisecting looking for what was causing a regression for me.

> +	memcpy(&rates->rates, &bss->rates, tmplen);
>  	if (get_common_rates(priv, rates->rates, &tmplen)) {
>  		ret = -1;
>  		goto done;
> @@ -598,7 +599,7 @@ static int lbs_adhoc_join(struct lbs_private *priv,
>  
>  	/* Copy Data rates from the rates recorded in scan response */
>  	memset(cmd.bss.rates, 0, sizeof(cmd.bss.rates));
> -	ratesize = min_t(u16, sizeof(cmd.bss.rates), MAX_RATES);
> +	ratesize = min_t(u16, ARRAY_SIZE(cmd.bss.rates), MAX_RATES);
>  	memcpy(cmd.bss.rates, bss->rates, ratesize);
>  	if (get_common_rates(priv, cmd.bss.rates, &ratesize)) {
>  		lbs_deb_join("ADHOC_JOIN: get_common_rates returned error.\n");
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev
> 

