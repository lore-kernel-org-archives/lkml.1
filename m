Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbZGNFoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbZGNFoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 01:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752967AbZGNFoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 01:44:22 -0400
Received: from smtp.nokia.com ([192.100.105.134]:59741 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZGNFoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 01:44:21 -0400
Message-ID: <4A5C1B22.3040701@nokia.com>
Date: Tue, 14 Jul 2009 08:44:02 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: ext Jiri Slaby <jirislaby@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: wl12xx, fix lock imbalance
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1247520266-32007-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 05:44:08.0182 (UTC) FILETIME=[1B114960:01CA0446]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Jiri Slaby wrote:
> Add omitted mutex_unlock to one of wl12xx_op_start fail paths (when
> wl12xx_chip_wakeup fails).
>   

Cool, very nice catch.  We actually just fixed this bug in our wl1271 
code (which I will hopefully send upstream this week), but we hadn't 
fixed it in the wl1251-specific code yet.

> Not sure if the device should be powered off?
>   

You should.  If the chip cannot be booted, why should it remain powered 
on? In some rare cases, the chip might fail to initialize, but can 
recover if powered off and on again, so turning it off at this point is 
the right thing to do.

> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> ---
>   
>  drivers/net/wireless/wl12xx/main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
> index 603d611..d241e4a 100644
> --- a/drivers/net/wireless/wl12xx/main.c
> +++ b/drivers/net/wireless/wl12xx/main.c
>   
> @@ -336,7 +336,7 @@ static int wl12xx_op_start(struct ieee80211_hw *hw)
>  
>  	ret = wl12xx_chip_wakeup(wl);
>  	if (ret < 0)
> -		return ret;
> +		goto unlock;
>   

Here you can just "goto out;" so that the chip is powered off before we 
return.

>  
>  	ret = wl->chip.op_boot(wl);
>  	if (ret < 0)
> @@ -357,7 +357,7 @@ static int wl12xx_op_start(struct ieee80211_hw *hw)
>  out:
>  	if (ret < 0)
>  		wl12xx_power_off(wl);
> -
> +unlock:
>  	mutex_unlock(&wl->mutex);
>  
>  	return ret;
>   

Thanks a lot for your patch!

-- 
Cheers,
Luca.

