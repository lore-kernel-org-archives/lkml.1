Return-Path: <linux-kernel-owner+w=401wt.eu-S1758375AbYGPQN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbYGPQN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:13:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756834AbYGPQNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:13:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:48401 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbYGPQNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:13:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EnoyV3zaZog0zLjQ/deVbtCReuPUMfYIAKgdpId3I9JLLYkV3bUYlZ90+NK9OUTEW3
         /1xZC0a12Emeqlo8w8bL5Jdamr0+0Shk/tqKnS3wcMLQAZv4XdlctK8/Yjs+SaTrq6P/
         KJsQznLkNdj96Kq7eBik2wzY3W58MzI6bSNto=
Message-ID: <40f31dec0807160913m58f8e77fy5a396e25adab7880@mail.gmail.com>
Date: Wed, 16 Jul 2008 19:13:08 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 3/5] Ath5k: flush work
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1216136661-10930-3-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
	 <1216136661-10930-3-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/15 Jiri Slaby <jirislaby@gmail.com>:
> Make sure that the irq is not in progress after stop. This means
> two things:
> - ensure the intr setting register is set by flushing posted values
> - call synchronize_irq() after that
>
> Also flush stop tx write, inform callers of the tx stop about still
> pending transfers (unsuccessful stop) and finally don't wait another
> 3ms in ath5k_rx_stop, since ath5k_hw_stop_rx_dma ensures transfer to
> be finished.
>
> Make sure all writes will be ordered in respect to locks by mmiowb().
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   13 +++++++++++--
>  drivers/net/wireless/ath5k/hw.c   |    4 ++++
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 4d9ff97..4874a6f 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -43,7 +43,9 @@
>  #include <linux/version.h>
>  #include <linux/module.h>
>  #include <linux/delay.h>
> +#include <linux/hardirq.h>
>  #include <linux/if.h>
> +#include <linux/io.h>
>  #include <linux/netdevice.h>
>  #include <linux/cache.h>
>  #include <linux/pci.h>
> @@ -1250,6 +1252,7 @@ ath5k_txbuf_setup(struct ath5k_softc *sc, struct ath5k_buf *bf)
>
>        txq->link = &ds->ds_link;
>        ath5k_hw_tx_start(ah, txq->qnum);
> +       mmiowb();
>        spin_unlock_bh(&txq->lock);
>
>        return 0;
> @@ -1584,7 +1587,6 @@ ath5k_rx_stop(struct ath5k_softc *sc)
>        ath5k_hw_stop_pcu_recv(ah);     /* disable PCU */
>        ath5k_hw_set_rx_filter(ah, 0);  /* clear recv filter */
>        ath5k_hw_stop_rx_dma(ah);       /* disable DMA engine */
> -       mdelay(3);                      /* 3ms is long enough for 1 frame */
>
>        ath5k_debug_printrxbuffs(sc, ah);
>
> @@ -2259,6 +2261,7 @@ ath5k_init(struct ath5k_softc *sc)
>
>        ret = 0;
>  done:
> +       mmiowb();
>        mutex_unlock(&sc->lock);
>        return ret;
>  }
> @@ -2291,6 +2294,7 @@ ath5k_stop_locked(struct ath5k_softc *sc)
>        if (!test_bit(ATH_STAT_INVALID, sc->status)) {
>                ath5k_led_off(sc);
>                ath5k_hw_set_intr(ah, 0);
> +               synchronize_irq(sc->pdev->irq);
>        }
>        ath5k_txq_cleanup(sc);
>        if (!test_bit(ATH_STAT_INVALID, sc->status)) {
> @@ -2340,6 +2344,7 @@ ath5k_stop_hw(struct ath5k_softc *sc)
>                }
>        }
>        ath5k_txbuf_free(sc, sc->bbuf);
> +       mmiowb();
>        mutex_unlock(&sc->lock);
>
>        del_timer_sync(&sc->calib_tim);
> @@ -2805,6 +2810,7 @@ ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>                /* XXX: assoc id is set to 0 for now, mac80211 doesn't have
>                 * a clean way of letting us retrieve this yet. */
>                ath5k_hw_set_associd(ah, ah->ah_bssid, 0);
> +               mmiowb();
>        }
>        mutex_unlock(&sc->lock);
>
> @@ -2981,6 +2987,7 @@ ath5k_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
>        }
>
>  unlock:
> +       mmiowb();
>        mutex_unlock(&sc->lock);
>        return ret;
>  }
> @@ -3054,8 +3061,10 @@ ath5k_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
>        ret = ath5k_beacon_setup(sc, sc->bbuf);
>        if (ret)
>                sc->bbuf->skb = NULL;
> -       else
> +       else {
>                ath5k_beacon_config(sc);
> +               mmiowb();
> +       }
>
>  end:
>        mutex_unlock(&sc->lock);
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index c6d12c5..7ca87a5 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -1440,6 +1440,7 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
>
>                /* Stop queue */
>                ath5k_hw_reg_write(ah, tx_queue, AR5K_CR);
> +               ath5k_hw_reg_read(ah, AR5K_CR);
>        } else {
>                /*
>                 * Schedule TX disable and wait until queue is empty
> @@ -1456,6 +1457,8 @@ int ath5k_hw_stop_tx_dma(struct ath5k_hw *ah, unsigned int queue)
>
>                /* Clear register */
>                ath5k_hw_reg_write(ah, 0, AR5K_QCU_TXD);
> +               if (pending)
> +                       return -EBUSY;
>        }
>
>        /* TODO: Check for success else return error */
> @@ -1716,6 +1719,7 @@ enum ath5k_int ath5k_hw_set_intr(struct ath5k_hw *ah, enum ath5k_int new_mask)
>
>        /* ..re-enable interrupts */
>        ath5k_hw_reg_write(ah, AR5K_IER_ENABLE, AR5K_IER);
> +       ath5k_hw_reg_read(ah, AR5K_IER);
>
>        return old_mask;
>  }
> --
> 1.5.6.2
>
>

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
