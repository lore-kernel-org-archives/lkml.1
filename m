Return-Path: <linux-kernel-owner+w=401wt.eu-S1751560AbYKNDsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560AbYKNDsv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 22:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751882AbYKNDsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 22:48:30 -0500
Received: from mail.deathmatch.net ([70.167.247.36]:3515 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595AbYKNDs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 22:48:29 -0500
Date: Thu, 13 Nov 2008 22:47:30 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Message-ID: <20081114034730.GA9482@hash.localnet>
References: <491506DB.1070000@gmail.com> <b6c5339f0811100851t1fd9a180pfe24312081885467@mail.gmail.com> <4918A8C5.3050607@gmail.com> <40f31dec0811101412n1a4faf86sf4b1f37bb41caef9@mail.gmail.com> <491B17B3.204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <491B17B3.204@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 07:51:47PM +0200, Maxim Levitsky wrote:
> >>Why it doesn't accept new mac?, can this be fixed?
> 
> Any update on mac changer status?

As a first stab, can you try this patch?  This sets the address on
add_interface and clears it on remove_interface, instead of only doing
it at probe time.  I only compile-tested it.

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 5ef8cc4..6c56893 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2765,6 +2765,7 @@ static int ath5k_add_interface(struct ieee80211_hw *hw,
 	/* Set to a reasonable value. Note that this will
 	 * be set to mac80211's value at ath5k_config(). */
 	sc->bintval = 1000;
+	ath5k_hw_set_lladdr(sc->ah, conf->mac_addr);
 
 	ret = 0;
 end:
@@ -2777,11 +2778,13 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
 			struct ieee80211_if_init_conf *conf)
 {
 	struct ath5k_softc *sc = hw->priv;
+	u8 mac[ETH_ALEN] = {};
 
 	mutex_lock(&sc->lock);
 	if (sc->vif != conf->vif)
 		goto end;
 
+	ath5k_hw_set_lladdr(sc->ah, mac);
 	sc->vif = NULL;
 end:
 	mutex_unlock(&sc->lock);

-- 
Bob Copeland %% www.bobcopeland.com

