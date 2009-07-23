Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbZGWRQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbZGWRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 13:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbZGWRQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 13:16:56 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:38432 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbZGWRQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 13:16:55 -0400
Message-ID: <4A689B01.3010007@gmail.com>
Date: Thu, 23 Jul 2009 19:16:49 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: Kalpesh Rathod <kalpeshrathod@gmail.com>
CC: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [query] skb alignment in tx path of driver
References: <cee4bbc90907230955s558123dpe021fa1e7b384068@mail.gmail.com>
In-Reply-To: <cee4bbc90907230955s558123dpe021fa1e7b384068@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 23 Jul 2009 19:16:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kalpesh Rathod a écrit :
> Hi,
> 
> I am writing n/w device driver for sdio wifi card. I am testing it on
> embedded platform.
> DMA controller on the platform is able to xfer data to sdio only if
> source data buf address is 4 byte aligned.
> 
> The firmware on the card understands 802.3 frames with snap headers.
> So, I convert it to the required format in my driver.
> 4 byte additional header is also attached to this frame and sent over sdio.
> This all conversion effectively adds 12 byes to the frame received in
> hard_xmit method.
> 
> Problem is, frame received in hard_xmit method is 2 byte aligned.
> (skb->data is 2 byte aligned). As a result,
> after addition of 12 bytes header, skb->data remains 2 byte aligned
> instead of 4 byte aligned. And DMA controller refuses
> to transfer it.
> 
> So, how can I request IP stack so that frame received in hard_xmit is
> on 4 byte aligned boundry?

You cannot.

Search for skb_copy_and_csum_dev() use in drivers.

drivers/net/via-rhine.c is a good example of a driver dealing with same
alignment requirement.

        if ((rp->quirks & rqRhineI) &&
            (((unsigned long)skb->data & 3) || skb_shinfo(skb)->nr_frags != 0 || skb->ip_summed == CHECKSUM_PARTIAL)) {
                /* Must use alignment buffer. */
                if (skb->len > PKT_BUF_SZ) {
                        /* packet too long, drop it */
                        dev_kfree_skb(skb);
                        rp->tx_skbuff[entry] = NULL;
                        dev->stats.tx_dropped++;
                        return NETDEV_TX_OK;
                }

                /* Padding is not copied and so must be redone. */
                skb_copy_and_csum_dev(skb, rp->tx_buf[entry]);
                if (skb->len < ETH_ZLEN)
                        memset(rp->tx_buf[entry] + skb->len, 0,
                               ETH_ZLEN - skb->len);
                rp->tx_skbuff_dma[entry] = 0;
                rp->tx_ring[entry].addr = cpu_to_le32(rp->tx_bufs_dma +
                                                      (rp->tx_buf[entry] -
                                                       rp->tx_bufs));
        } else {
                rp->tx_skbuff_dma[entry] =
                        pci_map_single(rp->pdev, skb->data, skb->len,
                                       PCI_DMA_TODEVICE);
                rp->tx_ring[entry].addr = cpu_to_le32(rp->tx_skbuff_dma[entry]);
        }


