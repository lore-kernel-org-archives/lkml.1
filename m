Return-Path: <linux-kernel-owner+w=401wt.eu-S1753028AbXLIRzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbXLIRzt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 12:55:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751810AbXLIRze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 12:55:34 -0500
Received: from an-out-0708.google.com ([209.85.132.249]:21053 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbXLIRzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 12:55:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=G2pu+ibrsMpdqK38gZP06xesU9ud2TQMSqtYz/Fo+VKmdKmUrKZ5EfbyGfVGiaMoxe9sio6FU+lcZ01yyeoI7w9B1EC2TmSsbLtJJD2Q6cJWa7IIgNgUF/NOR7o/5IO/sbwGhtLbLzpo1/P1GMAUM09VrOaBP/Rf0iVgR6QKX2o=
Message-ID: <40f31dec0712090955l4ffada24p302414593e440c9d@mail.gmail.com>
Date: Sun, 9 Dec 2007 19:55:29 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: 2.6.24-rc4-mm1
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, mcgrof@gmail.com, linux-wireless@vger.kernel.org,
       ath5k-devel@lists.ath5k.org,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20071207021258.GA12624@darkstar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071204211701.994dfce6.akpm@linux-foundation.org>
	 <20071207021258.GA12624@darkstar.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2007/12/7, Dave Young <hidave.darkstar@gmail.com>:
> Hi,
>
> 2.6.24-rc4-mm1 build failed at drivers/net/wireless/ath5k/base.c for some inline functions like this:
> drivers/net/wireless/ath5k/base.c:292: sorry, unimplemented: inlining failed in call to 'ath5k_extend_tsf': function body not available
>
> fix it with adjust the order of inline function body.
>
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
>
> ---
> drivers/net/wireless/ath5k/base.c |   67 ++++++++++++++++----------------------
> 1 file changed, 29 insertions(+), 38 deletions(-)
>
> diff -upr linux/drivers/net/wireless/ath5k/base.c linux.new/drivers/net/wireless/ath5k/base.c
> --- linux/drivers/net/wireless/ath5k/base.c     2007-12-07 10:01:42.000000000 +0800
> +++ linux.new/drivers/net/wireless/ath5k/base.c 2007-12-07 10:01:49.000000000 +0800
> @@ -250,8 +250,19 @@ static int         ath5k_rxbuf_setup(struct ath
>  static int     ath5k_txbuf_setup(struct ath5k_softc *sc,
>                                 struct ath5k_buf *bf,
>                                 struct ieee80211_tx_control *ctl);
> +
>  static inline void ath5k_txbuf_free(struct ath5k_softc *sc,
> -                               struct ath5k_buf *bf);
> +                               struct ath5k_buf *bf)
> +{
> +       BUG_ON(!bf);
> +       if (!bf->skb)
> +               return;
> +       pci_unmap_single(sc->pdev, bf->skbaddr, bf->skb->len,
> +                       PCI_DMA_TODEVICE);
> +       dev_kfree_skb(bf->skb);
> +       bf->skb = NULL;
> +}
> +
>  /* Queues setup */
>  static struct  ath5k_txq *ath5k_txq_setup(struct ath5k_softc *sc,
>                                 int qtype, int subtype);
> @@ -278,14 +289,29 @@ static int        ath5k_beacon_setup(struct at
>                                 struct ieee80211_tx_control *ctl);
>  static void    ath5k_beacon_send(struct ath5k_softc *sc);
>  static void    ath5k_beacon_config(struct ath5k_softc *sc);
> -static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp);
> +
> +static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
> +{
> +       u64 tsf = ath5k_hw_get_tsf64(ah);
> +
> +       if ((tsf & 0x7fff) < rstamp)
> +               tsf -= 0x8000;
> +
> +       return (tsf & ~0x7fff) | rstamp;
> +}
> +
>  /* Interrupt handling */
>  static int     ath5k_init(struct ath5k_softc *sc);
>  static int     ath5k_stop_locked(struct ath5k_softc *sc);
>  static int     ath5k_stop_hw(struct ath5k_softc *sc);
>  static irqreturn_t ath5k_intr(int irq, void *dev_id);
>  static void    ath5k_tasklet_reset(unsigned long data);
> -static inline void ath5k_update_txpow(struct ath5k_softc *sc);
> +
> +static inline void ath5k_update_txpow(struct ath5k_softc *sc)
> +{
> +       ath5k_hw_set_txpower_limit(sc->ah, 0);
> +}
> +
>  static void    ath5k_calibrate(unsigned long data);
>  /* LED functions */
>  static void    ath5k_led_off(unsigned long data);
> @@ -1341,21 +1367,6 @@ err_unmap:
>         return ret;
>  }
>
> -static inline void
> -ath5k_txbuf_free(struct ath5k_softc *sc, struct ath5k_buf *bf)
> -{
> -       BUG_ON(!bf);
> -       if (!bf->skb)
> -               return;
> -       pci_unmap_single(sc->pdev, bf->skbaddr, bf->skb->len,
> -                       PCI_DMA_TODEVICE);
> -       dev_kfree_skb(bf->skb);
> -       bf->skb = NULL;
> -}
> -
> -
> -
> -
>  /**************\
>  * Queues setup *
>  \**************/
> @@ -2046,20 +2057,6 @@ ath5k_beacon_config(struct ath5k_softc *
>  #undef TSF_TO_TU
>  }
>
> -static inline
> -u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
> -{
> -       u64 tsf = ath5k_hw_get_tsf64(ah);
> -
> -       if ((tsf & 0x7fff) < rstamp)
> -               tsf -= 0x8000;
> -
> -       return (tsf & ~0x7fff) | rstamp;
> -}
> -
> -
> -
> -
>  /********************\
>  * Interrupt handling *
>  \********************/
> @@ -2295,12 +2292,6 @@ ath5k_tasklet_reset(unsigned long data)
>         ath5k_reset(sc->hw);
>  }
>
> -static inline void
> -ath5k_update_txpow(struct ath5k_softc *sc)
> -{
> -       ath5k_hw_set_txpower_limit(sc->ah, 0);
> -}
> -
>  /*
>   * Periodically recalibrate the PHY to account
>   * for temperature/environment changes.
>

We'll change their order in the code, plz keep prototype declarations
clean. I'll submit a patch asap on this.

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
