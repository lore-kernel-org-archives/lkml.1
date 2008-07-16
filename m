Return-Path: <linux-kernel-owner+w=401wt.eu-S1758006AbYGPQNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006AbYGPQNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:13:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbYGPQNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:13:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:45155 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056AbYGPQNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:13:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=UHcorOeZ/b7Vo+KWHO3P33ic0fsVCul0WJyrZvG8gPiqGQZbc1N4rdc6n9ILlHUNn9
         XTZhIGX89I4VL/NY4qUuU9ZKROys7+mQcFcr34z26qCjmqmxnJkUnKOkkfYavCQjs8lO
         N8hLi4GItPKvCkwrPL+QmC1YoOnSdqNDJgWuY=
Message-ID: <40f31dec0807160913m3f79cd5cw19d91f9aa513b505@mail.gmail.com>
Date: Wed, 16 Jul 2008 19:13:36 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: [PATCH 4/5] Ath5k: fix dma operation
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, davem@redhat.com, rth@cygnus.com,
       jakub@redhat.com, "Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1216136683-10955-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
	 <1216136683-10955-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/15 Jiri Slaby <jirislaby@gmail.com>:
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

Acked-by: Nick Kossifidis <mickflemm@gmail.com>

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
