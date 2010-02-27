Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936269Ab0B0Vhn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 16:37:43 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:24544 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933964Ab0B0Vhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 16:37:41 -0500
X-Greylist: delayed 4998 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Feb 2010 16:37:40 EST
Message-ID: <4B895602.6010801@bfs.de>
Date: Sat, 27 Feb 2010 18:27:30 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
CC: Dan Carpenter <error27@gmail.com>, Daniel Drake <dsd@gentoo.org>,
       Ulrich Kunitz <kune@deine-taler.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       =?ISO-8859-1?Q?Andr=E9_G?= =?ISO-8859-1?Q?oddard_Rosa?= 
	<andre.goddard@gmail.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] zd1211rw: fix potential array underflow
References: <20100227061234.GA14323@bicker> <4B892A2F.2040307@free.fr>
In-Reply-To: <4B892A2F.2040307@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Benoit PAPILLAULT schrieb:
> Dan Carpenter a écrit :
>> The first chunk fixes a debugging assert to print a warning about
>> array underflows.
>> The second chunk corrects a potential array underflow.  I also removed
>> an assert
>> in the second chunk because it can no longer happen.
>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>> ---
>> This was found by a static check and compile tested only.  Please
>> review carefully.
>>
>> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
>> b/drivers/net/wireless/zd1211rw/zd_mac.c
>> index f14deb0..ead2f2c 100644
>> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
>> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
>> @@ -350,7 +350,7 @@ static void zd_mac_tx_status(struct ieee80211_hw
>> *hw, struct sk_buff *skb,
>>      first_idx = info->status.rates[0].idx;
>>      ZD_ASSERT(0<=first_idx && first_idx<ARRAY_SIZE(zd_retry_rates));
>>      retries = &zd_retry_rates[first_idx];
>> -    ZD_ASSERT(0<=retry && retry<=retries->count);
>> +    ZD_ASSERT(1 <= retry && retry <= retries->count);
>>   
> Note: normal hardware always report a tx_status->retry >= 1. There are 2
> code paths to initialize retry itself : either tx_status is NULL and
> then retry=1 (so we are safe), or tx_status is not NULL and retry =
> tx_status->retry + success >=1 (so we are safe again).
> 
> However, I wonder how we should handle if it happens that the HW reports
> a tx_status->retry = 0. I think ZD_ASSERT purpose is to catch
> programming errors, not bogus hardware. Comments?


Simply assume the worst, so far i see the patch does not
add more code nor should it change normal behavier.
This will help to make the code more robust.

just my 2 cents,
 walter



>>  
>>      info->status.rates[0].idx = retries->rate[0];
>>      info->status.rates[0].count = 1; // (retry > 1 ? 2 : 1);
>> @@ -360,7 +360,7 @@ static void zd_mac_tx_status(struct ieee80211_hw
>> *hw, struct sk_buff *skb,
>>          info->status.rates[i].count = 1; // ((i==retry-1) && success
>> ? 1:2);
>>      }
>>      for (; i<IEEE80211_TX_MAX_RATES && i<retry; i++) {
>> -        info->status.rates[i].idx = retries->rate[retry-1];
>> +        info->status.rates[i].idx = retries->rate[retry - 1];
>>          info->status.rates[i].count = 1; // (success ? 1:2);
>>      }
>>      if (i<IEEE80211_TX_MAX_RATES)
>> @@ -424,12 +424,10 @@ void zd_mac_tx_failed(struct urb *urb)
>>          first_idx = info->status.rates[0].idx;
>>          ZD_ASSERT(0<=first_idx && first_idx<ARRAY_SIZE(zd_retry_rates));
>>          retries = &zd_retry_rates[first_idx];
>> -        if (retry < 0 || retry > retries->count) {
>> +        if (retry <= 0 || retry > retries->count)
>>              continue;
>> -        }
>>  
>> -        ZD_ASSERT(0<=retry && retry<=retries->count);
>> -        final_idx = retries->rate[retry-1];
>> +        final_idx = retries->rate[retry - 1];
>>          final_rate = zd_rates[final_idx].hw_value;
>>  
>>          if (final_rate != tx_status->rate) {
>>
>>   
> Acked-by: Benoit Papillault <benoit.papillault@free.fr>
> 
> Regards,
> Benoit
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe
> kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
