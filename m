Return-Path: <linux-kernel-owner+w=401wt.eu-S932730AbYFGBPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730AbYFGBPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbYFGBJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:09:14 -0400
Received: from sous-sol.org ([216.99.217.87]:42417 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760247AbYFGBJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:09:06 -0400
Message-Id: <20080607010629.479706743@sous-sol.org>
References: <20080607010215.358296706@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 06 Jun 2008 18:02:55 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jay Cliburn <jacliburn@bellsouth.net>,
       Alexey Dobriyan <adobriyan@gmail.com>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 40/50] atl1: fix 4G memory corruption bug
Content-Disposition: inline; filename=atl1-fix-4g-memory-corruption-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

upstream commit: aefdbf1a3b832a580a50cf3d1dcbb717be7cbdbe

When using 4+ GB RAM and SWIOTLB is active, the driver corrupts
memory by writing an skb after the relevant DMA page has been
unmapped.  Although this doesn't happen when *not* using bounce
buffers, clearing the pointer to the DMA page after unmapping
it fixes the problem.

http://marc.info/?t=120861317000005&r=2&w=2

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
[jacliburn@bellsouth.net: backport to 2.6.25.4]
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/atl1/atl1_main.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/atl1/atl1_main.c
+++ b/drivers/net/atl1/atl1_main.c
@@ -1334,6 +1334,7 @@ rrd_ok:
 		/* Good Receive */
 		pci_unmap_page(adapter->pdev, buffer_info->dma,
 			       buffer_info->length, PCI_DMA_FROMDEVICE);
+		buffer_info->dma = 0;
 		skb = buffer_info->skb;
 		length = le16_to_cpu(rrd->xsz.xsum_sz.pkt_size);
 

-- 
