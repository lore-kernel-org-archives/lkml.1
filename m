Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbZBDSwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbZBDSwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:52:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759335AbZBDStE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:04 -0500
Received: from kroah.org ([198.145.64.141]:34264 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760220AbZBDStB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:01 -0500
Date: Wed, 4 Feb 2009 10:45:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Breno Leitao <leitao@linux.vnet.ibm.com>,
       Jesse Brandeburg <jesse.brandeburg@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 02/41] ixgb: fix bug when freeing resources
Message-ID: <20090204184552.GC25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ixgb-fix-bug-when-freeing-resources.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Brandeburg, Jesse <jesse.brandeburg@intel.com>

commit 23e55a32ca1ffdbe7a492ef99f0e0ac48e504a13 upstream.

It was pointed out by Breno Leitao <leitao@linux.vnet.ibm.com> that
ixgb would crash on PPC when an IOMMU was in use, if change_mtu was
called.

It appears to be a pretty simple issue in the driver that wasn't discovered
because most systems don't run with an IOMMU.  The driver needs to only unmap
buffers that are mapped (duh).

CC: Breno Leitao <leitao@linux.vnet.ibm.com>

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ixgb/ixgb_main.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ixgb/ixgb_main.c
+++ b/drivers/net/ixgb/ixgb_main.c
@@ -977,15 +977,17 @@ ixgb_clean_rx_ring(struct ixgb_adapter *
 
 	for (i = 0; i < rx_ring->count; i++) {
 		buffer_info = &rx_ring->buffer_info[i];
-		if (buffer_info->skb) {
-
+		if (buffer_info->dma) {
 			pci_unmap_single(pdev,
 					 buffer_info->dma,
 					 buffer_info->length,
 					 PCI_DMA_FROMDEVICE);
+			buffer_info->dma = 0;
+			buffer_info->length = 0;
+		}
 
+		if (buffer_info->skb) {
 			dev_kfree_skb(buffer_info->skb);
-
 			buffer_info->skb = NULL;
 		}
 	}

