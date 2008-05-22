Return-Path: <linux-kernel-owner+w=401wt.eu-S1761023AbYEVVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbYEVVEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758352AbYEVVEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:04:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:27252 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757662AbYEVVEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=jxzTJnWt+h4H1kM5aT6VFkgytecIRrTUwr334Qidv5/IhvLjBpOGh+dIIiiuavO37IGJhxwoDUYL41yvgHF1VxkloD3h/mfLjtCudDElxaKtFRdW6gGheYmkJ3fCTGFD3V917ZDQ4UJwuMmLTtDj2suHPOWQpPjiIUcgXzjw65o=
Date: Fri, 23 May 2008 02:00:25 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: jeff@garzik.org
Cc: csnook@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jay Cliburn <jacliburn@bellsouth.net>, stable@kernel.org
Subject: [PATCH RESEND] atl1: fix 4G memory corruption bug
Message-ID: <20080522220025.GA566@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

When using 4+ GB RAM and SWIOTLB is active, the driver corrupts
memory by writing an skb after the relevant DMA page has been
unmapped.  Although this doesn't happen when *not* using bounce
buffers, clearing the pointer to the DMA page after unmapping
it fixes the problem.

http://marc.info/?t=120861317000005&r=2&w=2


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---

 drivers/net/atlx/atl1.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2027,6 +2027,7 @@ rrd_ok:
 		/* Good Receive */
 		pci_unmap_page(adapter->pdev, buffer_info->dma,
 			       buffer_info->length, PCI_DMA_FROMDEVICE);
+		buffer_info->dma = 0;
 		skb = buffer_info->skb;
 		length = le16_to_cpu(rrd->xsz.xsum_sz.pkt_size);
 

