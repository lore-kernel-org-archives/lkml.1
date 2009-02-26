Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbZBZUx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbZBZUx3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:53:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbZBZUxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:53:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:58032 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068AbZBZUxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:53:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YsHEkOOP4hBw1vaRTazbH4E63i21onPlMcFSA3hGEFisIdA8aUI/xk74i1n5ZDd/XK
         AqHgXsT6xH+chtfRwWQIX0IeR8iSJ4revYB9GDDTVHAb9PPQ3xcNEB9b7IaPf7zyZ72k
         y9GZUx/GNWjzyS59XnzyW+ONooEhmiPa0Xw3U=
Message-ID: <49A70134.4070700@gmail.com>
Date: Thu, 26 Feb 2009 21:53:08 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090218 SUSE/3.0b2-1.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Sitsofe Wheeler <sitsofe@yahoo.com>, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [TIP] BUG kmalloc-4096: Poison overwritten (ath5k_rx_skb_alloc)
References: <20090222170201.GA27360@silver.sucs.org> <49A1CA01.9030501@gmail.com> <49A1DDD2.7040706@gmail.com> <20090223152724.M82409@bobcopeland.com> <49A321BA.2040500@gmail.com> <49A326A4.8090103@gmail.com> <40f31dec0902231508l512af5b7w68cfcc0bdf3cfa87@mail.gmail.com> <20090224135817.GB6019@hash.localnet> <49A46AD4.3060007@gmail.com> <20090225140139.GA18694@silver.sucs.org> <20090226010625.GA10577@hash.localnet>
In-Reply-To: <20090226010625.GA10577@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.2.2009 02:06, Bob Copeland wrote:
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1140,12 +1140,14 @@ ath5k_rxbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
>   	struct ath5k_hw *ah = sc->ah;
>   	struct sk_buff *skb = bf->skb;
>   	struct ath5k_desc *ds;
> +	dma_addr_t dma_addr;
>
>   	if (!skb) {
> -		skb = ath5k_rx_skb_alloc(sc,&bf->skbaddr);
> +		skb = ath5k_rx_skb_alloc(sc,&dma_addr);
>   		if (!skb)
>   			return -ENOMEM;
>   		bf->skb = skb;
> +		bf->skbaddr = dma_addr;

Hmm, rather than the caller, ath5k_rx_skb_alloc is wrong here in my 
eyes. It shouldn't touch the second parameter unless it knows it won't 
fail anymore.
