Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968424Ab0B0O1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 09:27:49 -0500
Received: from 29.mail-out.ovh.net ([87.98.216.213]:49750 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S968411Ab0B0O1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 09:27:47 -0500
Message-ID: <4B892A2F.2040307@free.fr>
Date: Sat, 27 Feb 2010 15:20:31 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, Daniel Drake <dsd@gentoo.org>,
       Ulrich Kunitz <kune@deine-taler.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       =?ISO-8859-1?Q?Andr=E9_G?= =?ISO-8859-1?Q?oddard_Rosa?= 
	<andre.goddard@gmail.com>,
       Benoit PAPILLAULT <benoit.papillault@free.fr>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] zd1211rw: fix potential array underflow
References: <20100227061234.GA14323@bicker>
In-Reply-To: <20100227061234.GA14323@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3039648274423041803
X-Ovh-Remote: 88.163.232.53 (ns.popipo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter a écrit :
> The first chunk fixes a debugging assert to print a warning about array underflows.
> The second chunk corrects a potential array underflow.  I also removed an assert
> in the second chunk because it can no longer happen.
>
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---
> This was found by a static check and compile tested only.  Please review carefully.
>
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c b/drivers/net/wireless/zd1211rw/zd_mac.c
> index f14deb0..ead2f2c 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -350,7 +350,7 @@ static void zd_mac_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
>  	first_idx = info->status.rates[0].idx;
>  	ZD_ASSERT(0<=first_idx && first_idx<ARRAY_SIZE(zd_retry_rates));
>  	retries = &zd_retry_rates[first_idx];
> -	ZD_ASSERT(0<=retry && retry<=retries->count);
> +	ZD_ASSERT(1 <= retry && retry <= retries->count);
>   
Note: normal hardware always report a tx_status->retry >= 1. There are 2 
code paths to initialize retry itself : either tx_status is NULL and 
then retry=1 (so we are safe), or tx_status is not NULL and retry = 
tx_status->retry + success >=1 (so we are safe again).

However, I wonder how we should handle if it happens that the HW reports 
a tx_status->retry = 0. I think ZD_ASSERT purpose is to catch 
programming errors, not bogus hardware. Comments?
>  
>  	info->status.rates[0].idx = retries->rate[0];
>  	info->status.rates[0].count = 1; // (retry > 1 ? 2 : 1);
> @@ -360,7 +360,7 @@ static void zd_mac_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb,
>  		info->status.rates[i].count = 1; // ((i==retry-1) && success ? 1:2);
>  	}
>  	for (; i<IEEE80211_TX_MAX_RATES && i<retry; i++) {
> -		info->status.rates[i].idx = retries->rate[retry-1];
> +		info->status.rates[i].idx = retries->rate[retry - 1];
>  		info->status.rates[i].count = 1; // (success ? 1:2);
>  	}
>  	if (i<IEEE80211_TX_MAX_RATES)
> @@ -424,12 +424,10 @@ void zd_mac_tx_failed(struct urb *urb)
>  		first_idx = info->status.rates[0].idx;
>  		ZD_ASSERT(0<=first_idx && first_idx<ARRAY_SIZE(zd_retry_rates));
>  		retries = &zd_retry_rates[first_idx];
> -		if (retry < 0 || retry > retries->count) {
> +		if (retry <= 0 || retry > retries->count)
>  			continue;
> -		}
>  
> -		ZD_ASSERT(0<=retry && retry<=retries->count);
> -		final_idx = retries->rate[retry-1];
> +		final_idx = retries->rate[retry - 1];
>  		final_rate = zd_rates[final_idx].hw_value;
>  
>  		if (final_rate != tx_status->rate) {
>
>   
Acked-by: Benoit Papillault <benoit.papillault@free.fr>

Regards,
Benoit

