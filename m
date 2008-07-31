Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbYGaVvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbYGaVvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755964AbYGaVve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:51:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:1230 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723AbYGaVvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:51:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Aaoi0X11v6joBJgU/9VX7WSh0s/SielFjVjORnKYItI2xw+Acyrke0ryHoUbmqLADK
         9OuLd8LVApXtREuk8ryO6N0zKnKX+1SD8Q574kuL8pvSSXDPSb9B3H0hYW9TLPTQDEhO
         hFTa+czRt54cI7ZdHEe4yKU+mISeVRTPyo5CM=
Message-ID: <489233E1.8080800@gmail.com>
Date: Thu, 31 Jul 2008 14:51:29 -0700
From: John Daiker <daikerjohn@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Peter Chubb <peterc@chubb.wattle.id.au>
CC: Peter Chubb <peterc@gelato.unsw.edu.au>, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       John Linville <linville@tuxdriver.com>
Subject: Re: Fixing rt2500pci [PATCH]
References: <87tze8vu18.wl%peterc@chubb.wattle.id.au>	<200807302105.56909.IvDoorn@gmail.com>	<200807302115.03865.IvDoorn@gmail.com>	<87vdym6fct.wl%peterc@chubb.wattle.id.au> <87wsj2246r.wl%peterc@chubb.wattle.id.au>
In-Reply-To: <87wsj2246r.wl%peterc@chubb.wattle.id.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Chubb wrote:
> In kernel version 2.6.26-rc9 my wireless LAN card worked; but in the
> released 2.6.26, my RaLink rt2500 card wouldn't associate.
>
> Git-bisect led me to this patch:
>
> 	61486e0f68d1f8966c09b734566a187d42d65c54
> 	rt2x00: Remove ieee80211_tx_control argument from write_tx_desc()
>
> I believe that there is a problem with that patch --- it
> (inadvertantly) removes an extra line of code, that used to set the
> DATABYTE_COUNT field.
>  
> This patch reinstates that line, and with it my card works again.
>
> The original version I sent still used the skbdesc->data_len which has
> been removed; this version of the patch applies on top of 2.6.27-rc1.
>  
> Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
> Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
>
>
> Index: linux-2.6-git/drivers/net/wireless/rt2x00/rt2500pci.c
> ===================================================================
> --- linux-2.6-git.orig/drivers/net/wireless/rt2x00/rt2500pci.c	2008-07-31 10:58:43.000000000 +1000
> +++ linux-2.6-git/drivers/net/wireless/rt2x00/rt2500pci.c	2008-07-31 11:40:44.000000000 +1000
> @@ -1213,20 +1213,21 @@ static void rt2500pci_write_tx_desc(stru
>  	rt2x00_set_field32(&word, TXD_W0_ACK,
>  			   test_bit(ENTRY_TXD_ACK, &txdesc->flags));
>  	rt2x00_set_field32(&word, TXD_W0_TIMESTAMP,
>  			   test_bit(ENTRY_TXD_REQ_TIMESTAMP, &txdesc->flags));
>  	rt2x00_set_field32(&word, TXD_W0_OFDM,
>  			   test_bit(ENTRY_TXD_OFDM_RATE, &txdesc->flags));
>  	rt2x00_set_field32(&word, TXD_W0_CIPHER_OWNER, 1);
>  	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
>  	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
>  			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
> +	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skb->len);
>  	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
>  	rt2x00_desc_write(txd, 0, word);
>  }
>  
>  /*
>   * TX data initialization
>   */
>  static void rt2500pci_write_beacon(struct queue_entry *entry)
>  {
>  	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
>
> --
> Dr Peter Chubb  http://www.gelato.unsw.edu.au  peterc AT gelato.unsw.edu.au
> http://www.ertos.nicta.com.au           ERTOS within National ICT Australia
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   
I can confirm that this is working on top of 
2.6.27-rc1-94ad374a0751f40d25e22e036c37f7263569d24c

Acked-by: John Daiker <daikerjohn@gmail.com>
