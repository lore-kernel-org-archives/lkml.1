Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0BTS3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 13:29:19 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:57629 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab0BTS3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 13:29:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Dr6UdNRfAVsR8RxE5ViGUtsIV2JO1mmokOdZbDO4Oc7whtWZNNrTiXFY6mrOiAAPIr
         uN0Juk0oh0IbCARUFSSsYy7qZDh8RFmJzthv/HbhzKsHbZMfR+V5/1rDpH/x2EpIHMHm
         +xnzd62bYRdqMsRrtq6kWuYAFtML5BScvjpP8=
Message-ID: <4B8029FA.2000404@gmail.com>
Date: Sat, 20 Feb 2010 12:29:14 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Subject: NETIF_F_HIGHDMA misuse in networking drivers?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was just part of a discussion in another thread talking about 64-bit DMA 
support issues where NETIF_F_HIGHDMA came up. I was originally under the 
impression that this flag indicated the device supported 64-bit DMA 
addressing. However, from looking at the code that checks for it (and, 
well, the actual comment for the flag) it really means "can access 
highmem" which has nothing to do with 64-bit at all. And if there's no 
highmem (like on x86_64) it has no effect at all.

 From looking at some drivers, however, it seems a lot of others had 
similar confusion, as they are doing things like setting NETIF_F_HIGHDMA 
conditionally on whether setting 64-bit DMA mask succeeds:

drivers/net/8139cp.c:

         if (pci_using_dac)
                 dev->features |= NETIF_F_HIGHDMA;

drivers/net/jme.c:

         if (jme->dev->features & NETIF_F_HIGHDMA)
                 rxdesc->desc1.flags = RXFLAG_64BIT;

drivers/net/forcedeth.c:

                 if (dma_64bit) {
                         if (pci_set_dma_mask(pci_dev, DMA_BIT_MASK(39)))
                                 dev_printk(KERN_INFO, &pci_dev->dev,
                                         "64-bit DMA failed, using 
32-bit addressing\n");
                         else
                                 dev->features |= NETIF_F_HIGHDMA;

(the last one is extra funny because it keeps saying 64-bit when it's 
really only 39-bit..)

The net result is that a lot of drivers aren't setting the HIGHDMA flag 
where they should, and thus on architectures where highmem exists, 
resulting in a bunch of unnecessary copying.

Assuming my interpretation is correct, I could try and fix up some of 
this mess.. any comments?
