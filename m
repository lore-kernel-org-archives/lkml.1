Return-Path: <linux-kernel-owner+w=401wt.eu-S1758421AbXLTLPd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421AbXLTLPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 06:15:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbXLTLPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 06:15:25 -0500
Received: from wombat.diezmil.com ([209.190.27.106]:44554 "EHLO
	wombat.diezmil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbXLTLPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 06:15:24 -0500
Date: Thu, 20 Dec 2007 06:15:23 -0500
Message-ID: <20591791.1198149323148.JavaMail.root@wombat.diezmil.com>
From: shyam_iyer@dell.com
Reply-To: shyam_iyer@dell.com
To: linux-kernel@vger.kernel.org
Subject: RE: [PATCH] sata_nv: fix ADMA ATAPI issues with memory over 4GB (v3)
In-Reply-To: <46A00B48CC54E4468EF6911F877AC4CAE2AB34@blrx3m10.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
>@@ -1153,6 +1164,15 @@
> 	pp->notifier_clear_block = pp->gen_block +
> 	       NV_ADMA_NOTIFIER_CLEAR + (4 * ap->port_no);
> 
>+	/* Now that the legacy PRD and padding buffer are allocated we can
>+	   safely raise the DMA mask to allocate the CPB/APRD table.
>+	   These are allowed to fail since we store the value that ends up
>+	   being used to set as the bounce limit in slave_config later if
>+	   needed. */
>+	pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
>+	pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
>+	pp->adma_dma_mask = *dev->dma_mask;
>+
> 	mem = dmam_alloc_coherent(dev, NV_ADMA_PORT_PRIV_DMA_SZ,
>				  &mem_dma, GFP_KERNEL);


This causes my DMA memory to always be above 4GB no matter how much I delay the setting of the 64bit DMA mask. I find that if I set the DMA mask as 32bit and not increase it to 64 bit at all then all my I/O to the DVD rom are fine. 

Jeff Garzik wrote:
>I would consider setting the consistent DMA mask to 32-bit, and setting 
>the overall mask to 64-bit.

>Seems like that would solve the problem?

I agree and I have tested that it is working.

-Shyam Iyer

--
This message was sent on behalf of shyam_iyer@dell.com at openSubscriber.com
http://www.opensubscriber.com/message/linux-kernel@vger.kernel.org/8218887.html
