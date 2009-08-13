Return-Path: <linux-kernel-owner+w=401wt.eu-S1755239AbZHMRaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbZHMRaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 13:30:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbZHMRaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 13:30:10 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45248 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755173AbZHMRaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 13:30:09 -0400
Date: Thu, 13 Aug 2009 13:28:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Zhu Yi <yi.zhu@intel.com>,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] mmotm0812 - something in linux-next killed
	iwl-3945.c
Message-ID: <20090813172819.GD2647@tuxdriver.com>
References: <19728.1250182794@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19728.1250182794@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 12:59:54PM -0400, Valdis.Kletnieks@vt.edu wrote:
> Build bombs out:
> 
>   CC      drivers/net/wireless/iwlwifi/iwl-3945.o
> drivers/net/wireless/iwlwifi/iwl-3945.c: In function 'iwl3945_pass_packet_to_mac80211':
> drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: 'hdr' undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: (Each undeclared identifier is reported only once
> drivers/net/wireless/iwlwifi/iwl-3945.c:580: error: for each function it appears in.)
> make[1]: *** [drivers/net/wireless/iwlwifi/iwl-3945.o] Error 1
> 
> due to this in linux-next.patch:
> 
> index 46288e7..ae7f163 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> (skipping)
> @@ -577,7 +577,10 @@ static void iwl3945_pass_packet_to_mac80211(struct iwl_priv
>  *priv,
>         if (ieee80211_is_data(hdr->frame_control))
>                 priv->rxtxpackets += len;
>  #endif
> -       ieee80211_rx_irqsafe(priv->hw, rxb->skb, stats);
> +       iwl_update_stats(priv, false, hdr->frame_control, len);
> +
> +       memcpy(IEEE80211_SKB_RXCB(rxb->skb), stats, sizeof(*stats));
> +       ieee80211_rx_irqsafe(priv->hw, rxb->skb);
>         rxb->skb = NULL;
> 
> Sorry, don't have a linux-next git tree, so no 'git blame' for what did it.
> Hopefully somebody recognizes their handiwork... ;)

I think this is the LEDS-related build failure, which already has a patch.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
