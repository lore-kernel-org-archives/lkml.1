Return-Path: <linux-kernel-owner+w=401wt.eu-S1760935AbYENA4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760935AbYENA4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 20:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757350AbYENA4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 20:56:05 -0400
Received: from fmailhost05.isp.att.net ([204.127.217.105]:49251 "EHLO
	fmailhost01.isp.att.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755299AbYENA4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 20:56:03 -0400
X-Originating-IP: [70.152.106.110]
From: Jay Cliburn <jacliburn@bellsouth.net>
To: jeff@garzik.org
Cc: adobriyan@gmail.com, csnook@redhat.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH] atl1: fix 4G memory corruption bug
Date: Tue, 13 May 2008 19:50:58 -0500
Message-Id: <1210726258-3053-1-git-send-email-jacliburn@bellsouth.net>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

When using 4+ GB RAM and SWIOTLB is active, the driver corrupts
memory by writing an skb after the relevant DMA page has been
unmapped.  Although this doesn't happen when *not* using bounce
buffers, clearing the pointer to the DMA page after unmapping
it fixes the problem.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
---
 drivers/net/atlx/atl1.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
index 0afe522..e67b154 100644
--- a/drivers/net/atlx/atl1.c
+++ b/drivers/net/atlx/atl1.c
@@ -2027,6 +2027,7 @@ rrd_ok:
 		/* Good Receive */
 		pci_unmap_page(adapter->pdev, buffer_info->dma,
 			       buffer_info->length, PCI_DMA_FROMDEVICE);
+		buffer_info->dma = 0;
 		skb = buffer_info->skb;
 		length = le16_to_cpu(rrd->xsz.xsum_sz.pkt_size);
 
-- 
1.5.4.1

