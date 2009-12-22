Return-Path: <linux-kernel-owner+w=401wt.eu-S1754329AbZLVTaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329AbZLVTaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 14:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752747AbZLVTaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 14:30:14 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46009 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbZLVTaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 14:30:13 -0500
Date: Tue, 22 Dec 2009 14:30:10 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: mac80211 suspend corner case (was: Asus eeepc 1008HA suspend
	issue and mac80211 suspend corner) case
Message-ID: <20091222193010.GB30201@bombadil.infradead.org>
References: <20091222022355.GA32508@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091222022355.GA32508@bombadil.infradead.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting a 3rd thread based on my original post to focus on the
corner case of the driver start() op failing.

Johannes, any preferences how to handle this? The patch below avoids
the Interrupt being turned off but its not enough given that we still
could be associated according to userspace. If the hardware is
unresponsive maybe it is best to just let the IRQ go disabled, not
sure, but its likely not what happens in all cases.

Trimming out the irrelevant parts below.

On Mon, Dec 21, 2009 at 09:23:55PM -0500, Luis R. Rodriguez wrote:
> I'm testing ath9k on an Asus eeepc 1008HA on a 2.6.32.2 kernel
> and ran into a suspend corner case issue which we do not handle
> yet. From what I've debugged so far it appears to me ath9k is
> doing everything it should to suspend. mac80211 drivers don't
> really do much on suspend except listen to mac80211. In the
> suspend case the mac80211 first stops TX, flushes out all packets,
> tears down aggregation, removes peers (if STA this would be your
> AP), removes all interfaces and finally call the mac80211 driver
> stop() callback for the driver. The driver is expected to have
> completed the stop() successfully, it shall not fail. It should
> be noted we never disassociate from the AP, this is left to
> userspace to figure out if it wants to do this prior to suspend.
> Network manger does this, for example. If you run the supplicant
> manually though and if your AP does not kick you off you could
> end up suspending and resumeing and still have a valid auth/assoc
> to the AP.
> 
> Upon resume mac80211 first calls the mac80211 start() driver callback,
> then re-add the interfaces, then the peers (your AP), etc. The corner
> case I just ran into was that the mac80211 driver start() callback
> *can* fail if your bus is screwy. You would likely see other sorts
> of errors when this sort of thing happens but I'm not and when we
> try to start() on ath9k we fail as the harware is completely
> unresponsive. What ends up happening then currently is the driver
> will enable interrupts and obviously though since we cannot even
> reset the hardware these interrupts will have gone unhandled and
> the interrupt gets disabled by the kernel. I reproduced this on
> vanilla 2.6.32.2 but I only did get full ath9k debug logs when
> testing against 2.6.31 with 2.6.32.2 wireless bits. That log can
> be found here:
> 
> http://bombadil.infradead.org/~mcgrof/logs/2.6.31-with-2.6.32-wireless/irq-disabled.txt
> 
> This can be fixed by something like the following:
> 
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index e6c08da..63d42fa 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1031,7 +1031,14 @@ int ieee80211_reconfig(struct ieee80211_local *local)
>  
>  	/* restart hardware */
>  	if (local->open_count) {
> +		/*
> +		 * Upon resume hardware can sometimes be goofy due to
> +		 * various platform issues, so restarting the device may
> +		 * at times not work immediately. Propagate the error.
> +		 */
>  		res = drv_start(local);
> +		if (res)
> +			return res;
>  
>  		ieee80211_led_radio(local, true);
>  	}
> 
> But this isn't enough. And since we cannot exactly talk to hardware
> we can't try to send a deassoc as harware would be unresponsive. I
> also don't see us handling such cases before either on cfg80211 or
> mac80211, so curious what we should do. Doing the above is not enough
> since userspace will still believe it will be associated if it left
> the device in an associated state. If you end up killing userspace
> and restarting you'll end up with crawling into cfg80211/mac80211
> warnings due to the unexpected state we left things in. This is
> currently busted on 2.6.32.2 and I don't see an obvious fix, hoping
> others might.
