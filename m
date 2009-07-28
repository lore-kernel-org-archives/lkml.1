Return-Path: <linux-kernel-owner+w=401wt.eu-S1755881AbZG1XwH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881AbZG1XwH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:52:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755225AbZG1XwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:52:06 -0400
Received: from fias.uni-frankfurt.de ([141.2.248.1]:43032 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbZG1XwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:52:03 -0400
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
       Jan Scholz <scholz@fias.uni-frankfurt.de>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Bob Copeland <bcopeland@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Tomas Janousek <tomi@nomi.cz>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.31] mac80211: fix suspend
References: <1248797417.13742.0.camel@johannes.local>
References: <200907282315.54085.rjw@sisk.pl>
Date: Wed, 29 Jul 2009 01:51:43 +0200
In-Reply-To: <1248797417.13742.0.camel@johannes.local> (Johannes Berg's
	message of "Tue, 28 Jul 2009 18:10:17 +0200")
Message-ID: <87tz0wjrhs.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.96 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I applied the patch to v2.6.31-rc4 and suspend works just fine.

Thanks,
   Jan

Johannes Berg <johannes@sipsolutions.net> writes:

> Jan reported that his b43-based laptop hangs during suspend.
> The problem turned out to be mac80211 asking the driver to
> stop the hardware before removing interfaces, and interface
> removal caused b43 to touch the hardware (while down, which
> causes the hang).
>
> This patch fixes mac80211 to do reorder these operations to
> have them in the correct order -- first remove interfaces
> and then stop the hardware. Some more code is necessary to
> be able to do so in a race-free manner, in particular it is
> necessary to not process frames received during quiescing.
>
> Fixes http://bugzilla.kernel.org/show_bug.cgi?id=13337.
>
> Reported-by: Jan Scholz <scholz@fias.uni-frankfurt.de>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/pm.c |   24 +++++++++++++++---------
>  net/mac80211/rx.c |   12 ++++++++++++
>  2 files changed, 27 insertions(+), 9 deletions(-)
>
> --- wireless-testing.orig/net/mac80211/pm.c	2009-07-28 17:58:11.000000000 +0200
> +++ wireless-testing/net/mac80211/pm.c	2009-07-28 18:06:25.000000000 +0200
> @@ -54,15 +54,6 @@ int __ieee80211_suspend(struct ieee80211
>  
>  	rcu_read_unlock();
>  
> -	/* flush again, in case driver queued work */
> -	flush_workqueue(local->hw.workqueue);
> -
> -	/* stop hardware - this must stop RX */
> -	if (local->open_count) {
> -		ieee80211_led_radio(local, false);
> -		drv_stop(local);
> -	}
> -
>  	/* remove STAs */
>  	spin_lock_bh(&local->sta_lock);
>  	list_for_each_entry(sta, &local->sta_list, list) {
> @@ -110,7 +101,22 @@ int __ieee80211_suspend(struct ieee80211
>  		drv_remove_interface(local, &conf);
>  	}
>  
> +	/* stop hardware - this must stop RX */
> +	if (local->open_count) {
> +		ieee80211_led_radio(local, false);
> +		drv_stop(local);
> +	}
> +
> +	/*
> +	 * flush again, in case driver queued work -- it
> +	 * shouldn't be doing (or cancel everything in the
> +	 * stop callback) that but better safe than sorry.
> +	 */
> +	flush_workqueue(local->hw.workqueue);
> +
>  	local->suspended = true;
> +	/* need suspended to be visible before quiescing is false */
> +	barrier();
>  	local->quiescing = false;
>  
>  	return 0;
> --- wireless-testing.orig/net/mac80211/rx.c	2009-07-28 17:58:52.000000000 +0200
> +++ wireless-testing/net/mac80211/rx.c	2009-07-28 18:04:24.000000000 +0200
> @@ -2441,6 +2441,18 @@ void __ieee80211_rx(struct ieee80211_hw 
>  		return;
>  	}
>  
> +	/*
> +	 * If we're suspending, it is possible although not too likely
> +	 * that we'd be receiving frames after having already partially
> +	 * quiesced the stack. We can't process such frames then since
> +	 * that might, for example, cause stations to be added or other
> +	 * driver callbacks be invoked.
> +	 */
> +	if (unlikely(local->quiescing || local->suspended)) {
> +		kfree_skb(skb);
> +		return;
> +	}
> +
>  	if (status->flag & RX_FLAG_HT) {
>  		/* rate_idx is MCS index */
>  		if (WARN_ON(status->rate_idx < 0 ||
>
