Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZHTNpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZHTNpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754633AbZHTNpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:45:30 -0400
Received: from khc.piap.pl ([195.187.100.11]:56677 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754632AbZHTNp0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:45:26 -0400
To: Walt Holman <walt@holmansrus.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Strange network timeouts w/ 2.6.30.5
References: <985009134.71250769263099.JavaMail.root@mail.holmansrus.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 20 Aug 2009 15:45:21 +0200
In-Reply-To: <985009134.71250769263099.JavaMail.root@mail.holmansrus.com> (Walt Holman's message of "Thu\, 20 Aug 2009 06\:54\:23 -0500 \(CDT\)")
Message-ID: <m3skfmk39q.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Walt Holman <walt@holmansrus.com> writes:

> dmesg is attached. This box does have >2GB Ram (6GB total).  The dmesg
> will show e100 init'd 3 times since the first is the stock modprobe,
> 2nd was forced with use_io and the 3rd modprobe was after reverting
> the patch.

You most probably can't test without swiotlb (RAM has to be limited to
2 GB or so), can you? That would (dis)prove my theory. Alternatively (or
better), a test on IOMMU-equipped system would do.

Since swiotlb is x86-only thing (though other 64-bit archs may have
something similar), I think the correct work around is to enable the
"for_device" handoff on !X86.

Something like maybe:

Signed-off-by: Krzysztof Ha³asa <khc@pm.waw.pl>

diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 014dfb6..b610088 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1762,9 +1762,12 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 
 			if (ioread8(&nic->csr->scb.status) & rus_no_res)
 				nic->ru_running = RU_SUSPENDED;
+#ifndef CONFIG_X86
+		/* FIXME interferes with swiotlb. */
 		pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
 					       sizeof(struct rfd),
 					       PCI_DMA_BIDIRECTIONAL);
+#endif
 		return -ENODATA;
 	}
 
-- 
Krzysztof Halasa
