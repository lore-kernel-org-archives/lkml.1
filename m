Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbYHGSBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbYHGSBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 14:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYHGSBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 14:01:15 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:33418 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbYHGSBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 14:01:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gV/yuJiCXEswj7YIfN2tSYfr06esfn9flFBJBraUvuQ1iZmiHayizRuwITlLHz25ka
         KJL+3anBlTk9jZ9gS1oxb8b3Y+thOEx+Uin6PI10fXUVwm4mRslxcSbYtSNBfxVu34E0
         lXnrTMCWjF27vAt4P/7tGn5ECm3ms2Ar2eKVA=
Message-ID: <40f31dec0808071101j2e63614at44d4f9fc4bb1694e@mail.gmail.com>
Date: Thu, 7 Aug 2008 21:01:11 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Michael Karcher" <kernel@mkarcher.dialup.fu-berlin.de>
Subject: Re: [PATCH] ath5k: Don't fiddle with MSI on suspend/resume.
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com, mcgrof@gmail.com
In-Reply-To: <1218130441.18466.150.camel@hermes2.karcher.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218130441.18466.150.camel@hermes2.karcher.local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/8/7 Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>:
> Commit 256b152b005e319f985f50f2a910a75ba0def74f has removed msi support,
> but overlooked the suspend/resume code. This patch completes msi removal.
>
> I don't consider this patch copyrightable, and thus put it into the
> public domain. The result is of course a base.c file dual-licensed under
> 3-clause-BSD and GPL.
>
> Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
>
> ---
>  drivers/net/wireless/ath5k/base.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index ebf19bc..d092a23 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -589,7 +589,6 @@ ath5k_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>        ath5k_stop_hw(sc);
>
>        free_irq(pdev->irq, sc);
> -       pci_disable_msi(pdev);
>        pci_save_state(pdev);
>        pci_disable_device(pdev);
>        pci_set_power_state(pdev, PCI_D3hot);
> @@ -618,12 +617,10 @@ ath5k_pci_resume(struct pci_dev *pdev)
>         */
>        pci_write_config_byte(pdev, 0x41, 0);
>
> -       pci_enable_msi(pdev);
> -
>        err = request_irq(pdev->irq, ath5k_intr, IRQF_SHARED, "ath", sc);
>        if (err) {
>                ATH5K_ERR(sc, "request_irq failed\n");
> -               goto err_msi;
> +               goto err_no_irq;
>        }
>
>        err = ath5k_init(sc);
> @@ -644,8 +641,7 @@ ath5k_pci_resume(struct pci_dev *pdev)
>        return 0;
>  err_irq:
>        free_irq(pdev->irq, sc);
> -err_msi:
> -       pci_disable_msi(pdev);
> +err_no_irq:
>        pci_disable_device(pdev);
>        return err;
>  }
> --
> 1.5.5.4
>
>

> Don't sync
> - coherent mapping (descriptors)
> - before unmap, it's useless
> - (wrongly anyway -- for_cpu) beacon skb, it's just mapped,
>  so by the device yet
>
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/base.c |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index 4874a6f..713ee99 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -1705,10 +1705,6 @@ ath5k_tasklet_rx(unsigned long data)
>                skb = bf->skb;
>                ds = bf->desc;
>
> -               /* TODO only one segment */
> -               pci_dma_sync_single_for_cpu(sc->pdev, sc->desc_daddr,
> -                               sc->desc_len, PCI_DMA_FROMDEVICE);
> -
>                /*
>                 * last buffer must not be freed to ensure proper hardware
>                 * function. When the hardware finishes also a packet next to
> @@ -1772,8 +1768,6 @@ ath5k_tasklet_rx(unsigned long data)
>                                goto next;
>                }
>  accept:
> -               pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr,
> -                               rs.rs_datalen, PCI_DMA_FROMDEVICE);
>                pci_unmap_single(sc->pdev, bf->skbaddr, sc->rxbufsize,
>                                PCI_DMA_FROMDEVICE);
>                bf->skb = NULL;
> @@ -1861,9 +1855,6 @@ ath5k_tx_processq(struct ath5k_softc *sc, struct ath5k_txq *txq)
>        list_for_each_entry_safe(bf, bf0, &txq->q, list) {
>                ds = bf->desc;
>
> -               /* TODO only one segment */
> -               pci_dma_sync_single_for_cpu(sc->pdev, sc->desc_daddr,
> -                               sc->desc_len, PCI_DMA_FROMDEVICE);
>                ret = sc->ah->ah_proc_tx_desc(sc->ah, ds, &ts);
>                if (unlikely(ret == -EINPROGRESS))
>                        break;
> @@ -2036,8 +2027,6 @@ ath5k_beacon_send(struct ath5k_softc *sc)
>                ATH5K_WARN(sc, "beacon queue %u didn't stop?\n", sc->bhalq);
>                /* NB: hw still stops DMA, so proceed */
>        }
> -       pci_dma_sync_single_for_cpu(sc->pdev, bf->skbaddr, bf->skb->len,
> -                       PCI_DMA_TODEVICE);
>
>        ath5k_hw_put_tx_buf(ah, sc->bhalq, bf->daddr);
>        ath5k_hw_tx_start(ah, sc->bhalq);
> --
> 1.5.6.2
>
>

Thanks ;-)

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
