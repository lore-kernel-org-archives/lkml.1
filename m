Return-Path: <linux-kernel-owner+w=401wt.eu-S932650Ab0AFTHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab0AFTHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:07:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932626Ab0AFTHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:07:50 -0500
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:59720 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932622Ab0AFTHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:07:50 -0500
Message-ID: <4B44DF84.80206@gmail.com>
Date: Wed, 06 Jan 2010 20:07:48 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091210 Lightning/1.0pre Shredder/3.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] NET: wireless, fix memory leak
References: <1262795743-15009-1-git-send-email-jslaby@suse.cz> <1262795743-15009-2-git-send-email-jslaby@suse.cz>
In-Reply-To: <1262795743-15009-2-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2010 19:07:49.0132 (UTC) FILETIME=[89B254C0:01CA8F03]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/10 17:35, Jiri Slaby wrote:
> Stanse found a memory leak in cfg80211_wext_siwscan. creq is not
> freed/assigned on all paths. Fix that.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> ---
>  net/wireless/scan.c |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 9c50c85..3003d13 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -685,7 +685,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
>  	/* No channels found? */
>  	if (!i) {
>  		err = -EINVAL;
> -		goto out;
> +		goto out_free;
>  	}
>  
>  	/* Set real number of channels specified in creq->channels[] */
> @@ -696,7 +696,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
>  		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
>  			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN) {
>  				err = -EINVAL;
> -				goto out;
> +				goto out_free;
>  			}
>  			memcpy(creq->ssids[0].ssid, wreq->essid, wreq->essid_len);
>  			creq->ssids[0].ssid_len = wreq->essid_len;
> @@ -717,6 +717,9 @@ int cfg80211_wext_siwscan(struct net_device *dev,
>   out:
>  	cfg80211_unlock_rdev(rdev);
>  	return err;
> +out_free:
> +	kfree(creq);
> +	goto out;
>  }
>  EXPORT_SYMBOL_GPL(cfg80211_wext_siwscan);
>  

This last part looks a bit strange. Why don't you put out_free label before out label,
and let it continue after the kfree, instead of jumping back to the out label.

---
Gertjan.

