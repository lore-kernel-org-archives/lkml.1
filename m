Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956Ab0ASWpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab0ASWpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 17:45:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755833Ab0ASWpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 17:45:17 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:55172 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab0ASWpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 17:45:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MQ/K06su+5dKZbiv4p15r7PPaOu6KBraeP2sZ0PC5OkPGwPSDZ+KtTkmlUZf4Tv0kr
         lBOHpWSjZ6hqoDUbyhF3NXS/a1Iy48gLfOgYn0cnDooCzORj5SrzvoKFNmmFdS9v7t/O
         V3trcpo0iaB17OW3nRVGzHN3F0xtruIYcc1B4=
Date: Tue, 19 Jan 2010 23:45:08 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100119224508.GA3473@del.dom.local>
References: <20100118212516.GE3157@del.dom.local>
 <4B54D50C.90608@majjas.com>
 <20100118220814.GG3157@del.dom.local>
 <20100118221747.GH3157@del.dom.local>
 <4B54E4EF.8080602@majjas.com>
 <4B554730.6090000@majjas.com>
 <20100119104739.GA9088@ff.dom.local>
 <4B55D40F.5080509@majjas.com>
 <20100119195933.GA3060@del.dom.local>
 <4B5610A9.7030902@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5610A9.7030902@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 19, 2010 at 03:06:01PM -0500, Michael Breuer wrote:
> On 1/19/2010 2:59 PM, Jarek Poplawski wrote:
> >On Tue, Jan 19, 2010 at 10:47:27AM -0500, Michael Breuer wrote:
> >...
> >>Still get the warning... but now 60 bytes.
> >>Jan 19 10:43:50 mail kernel: ------------[ cut here ]------------
> >>Jan 19 10:43:50 mail kernel: WARNING: at lib/dma-debug.c:902
> >Thanks for trying this.
> >Jarek P.
> NP. Let me know what else I can do to help with this one. Note that
> it seems innocuous. I'll continue with the older set and no dmar for
> now and see if I get another crash.

Maybe one more idea to try (not compiled).

Jarek P.
---

 drivers/net/sky2.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 7650f73..cdebdd3 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -2252,12 +2252,14 @@ static struct sk_buff *receive_copy(struct sky2_port *sky2,
 	skb = netdev_alloc_skb_ip_align(sky2->netdev, length);
 	if (likely(skb)) {
 		pci_dma_sync_single_for_cpu(sky2->hw->pdev, re->data_addr,
-					    length, PCI_DMA_FROMDEVICE);
+					    pci_unmap_len(re, data_size),
+					    PCI_DMA_FROMDEVICE);
 		skb_copy_from_linear_data(re->skb, skb->data, length);
 		skb->ip_summed = re->skb->ip_summed;
 		skb->csum = re->skb->csum;
 		pci_dma_sync_single_for_device(sky2->hw->pdev, re->data_addr,
-					       length, PCI_DMA_FROMDEVICE);
+					       pci_unmap_len(re, data_size),
+					       PCI_DMA_FROMDEVICE);
 		re->skb->ip_summed = CHECKSUM_NONE;
 		skb_put(skb, length);
 	}
