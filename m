Return-Path: <linux-kernel-owner+w=401wt.eu-S932463AbZHJRrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbZHJRrk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932359AbZHJRrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:47:39 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:44105 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbZHJRri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:47:38 -0400
Date: Mon, 10 Aug 2009 19:47:35 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Libertas: Association request to the driver failed
Message-ID: <20090810174735.GD19257@buzzloop.caiaq.de>
References: <20090807191156.GS19257@buzzloop.caiaq.de> <20090809102417.GH13639@buzzloop.caiaq.de> <4A7EAED8.9090900@gmail.com> <200908091310.56919.mb@bu3sch.de> <20090809191359.GG4805@lenovo> <4A7FF84C.7070708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7FF84C.7070708@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 12:37:00PM +0200, Roel Kluin wrote:
> I think there was another problem in lbs_associate(),
> the memcpy already affected rates->rates.
> 
> Also in get_common_rates() I think we can safely move the
> memset/memcpy, originally after label done, upwards.
> 
> The patch below, if correct, is to be applied after the revert

I tested that and the driver still works fine for me. Thanks :)

Feel free to add my Tested-by: if you like.

Daniel


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
