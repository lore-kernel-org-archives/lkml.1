Return-Path: <linux-kernel-owner+w=401wt.eu-S1753464AbYG3Sou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbYG3Sou (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:44:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYG3Sol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:44:41 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:11883 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYG3Sok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :message-id:from;
        b=lagT5uJBCGqev/FZLXz44zGnw/2EF1HqSwtGco87CjPXbLS2GHGfL2DMtUnT7E25VG
         7GNCRhu229PSZ8aGQuL86C9+ohsrZmkJSdb41ulgDlH1kDo61+PyuNlJQiVoLJhtlAuq
         DuhNM1zYc0gZayv2cSjY+Hj990Mi9LNj17xcA=
To: Peter Chubb <peterc@gelato.unsw.edu.au>
Subject: Re: Fixing rt2500pci
Date: Wed, 30 Jul 2008 21:05:56 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       John Linville <linville@tuxdriver.com>
References: <87tze8vu18.wl%peterc@chubb.wattle.id.au>
In-Reply-To: <87tze8vu18.wl%peterc@chubb.wattle.id.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302105.56909.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008, Peter Chubb wrote:
> 
> In kernel version 2.6.26-rc9 my wireless LAN card worked; but in the
> released 2.6.26, my RaLink rt2500 card wouldn't associate.
> 
> Git-bisect led me to this patch:
> 
> 	61486e0f68d1f8966c09b734566a187d42d65c54
> 	rt2x00: Remove ieee80211_tx_control argument from write_tx_desc()
> 
> I believe that there are two problems with that patch.  Setting the Tx
> Length has been removed inadvertently, and one of the conditions for
> when to set ifs to IFS_SIFS has also been removed.
> 
> This patch fixes those things, and with it my card works again.
> 
> Signed-off-by: Peter Chubb <peterc@gelato.unsw.edu.au>
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
> index 1724ce9..4ba2165 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -1198,6 +1198,7 @@ static void rt2500pci_write_tx_desc(struct rt2x00_dev *rt2x00dev,
>  	rt2x00_set_field32(&word, TXD_W0_IFS, txdesc->ifs);
>  	rt2x00_set_field32(&word, TXD_W0_RETRY_MODE,
>  			   test_bit(ENTRY_TXD_RETRY_MODE, &txdesc->flags));
> +	rt2x00_set_field32(&word, TXD_W0_DATABYTE_COUNT, skbdesc->data_len);
>  	rt2x00_set_field32(&word, TXD_W0_CIPHER_ALG, CIPHER_NONE);
>  	rt2x00_desc_write(txd, 0, word);
>  }

How could that have disappeared? good catch.
The above change is:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

But:

> diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
> index e1368f7..a11d6ff 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
> @@ -691,7 +691,8 @@ void rt2x00lib_write_tx_desc(struct rt2x00_dev *rt2x00dev,
>  	 * Set ifs to IFS_SIFS when the this is not the first fragment,
>  	 * or this fragment came after RTS/CTS.
>  	 */
> -	if (test_bit(ENTRY_TXD_RTS_FRAME, &txdesc.flags)) {
> +	if ((seq_ctrl & IEEE80211_SCTL_FRAG)  ||
> +		test_bit(ENTRY_TXD_RTS_FRAME, &txdesc.flags)) {
>  		txdesc.ifs = IFS_SIFS;
>  	} else if (control->flags & IEEE80211_TXCTL_FIRST_FRAGMENT) {
>  		__set_bit(ENTRY_TXD_FIRST_FRAGMENT, &txdesc.flags);

The above does not correspond with legacy driver, so I am hesitant in accepting this change.
Unless you are _absolutely_ sure this change does fix the issue, and the databate count
initialization is not sufficient on its own. If that is not the case, please resend the patch with the
rt2x00dev.c change ommitted and my ack added. (Please add John Linville to the CC list as well,
so it can be merged faster :) )

Ivo
