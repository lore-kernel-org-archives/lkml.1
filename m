Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZJMRDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZJMRDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 13:03:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760339AbZJMRDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 13:03:20 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:62231 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbZJMRDT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 13:03:19 -0400
Date: Tue, 13 Oct 2009 10:01:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       David Vrabel <david.vrabel@csr.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       lud <linux-usb@vger.kernel.org>
Subject: [PATCH] whci: fix type and format warnings
Message-Id: <20091013100128.0f06d67c.randy.dunlap@oracle.com>
In-Reply-To: <20091013162312.8b93998b.sfr@canb.auug.org.au>
References: <20091013162312.8b93998b.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4AD4B28E.00AC:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix format and type warnings in whci driver:

drivers/usb/host/whci/qset.c:440: warning: comparison of distinct pointer types lacks a cast
drivers/usb/host/whci/qset.c:442: warning: format '%d' expects type 'int', but argument 6 has type 'size_t'
drivers/usb/host/whci/qset.c:488: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
drivers/usb/host/whci/qset.c:509: warning: format '%08x' expects type 'unsigned int', but argument 5 has type 'dma_addr_t'
drivers/usb/host/whci/qset.c:568: warning: comparison of distinct pointer types lacks a cast
drivers/usb/host/whci/qset.c:571: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'
drivers/usb/host/whci/qset.c:590: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
drivers/usb/host/whci/qset.c:590: warning: format '%d' expects type 'int', but argument 6 has type 'long int'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/usb/host/whci/qset.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- linux-next-20091012.orig/drivers/usb/host/whci/qset.c
+++ linux-next-20091012/drivers/usb/host/whci/qset.c
@@ -437,9 +437,9 @@ static int qset_add_urb_sg(struct whc *w
 		}
 
 		dma_addr = sg_dma_address(sg);
-		dma_remaining = min(sg_dma_len(sg), remaining);
+		dma_remaining = min_t(size_t, sg_dma_len(sg), remaining);
 
-		dev_dbg(&whc->umc->dev, "adding sg[%d] %08x %d\n", i, (unsigned)dma_addr,
+		dev_dbg(&whc->umc->dev, "adding sg[%d] %08x %zu\n", i, (unsigned)dma_addr,
 			dma_remaining);
 
 		while (dma_remaining) {
@@ -485,7 +485,7 @@ static int qset_add_urb_sg(struct whc *w
 				dma_len = ep - dma_addr;
 			}
 
-			dev_dbg(&whc->umc->dev, "adding %d\n", dma_len);
+			dev_dbg(&whc->umc->dev, "adding %zu\n", dma_len);
 
 			std->len += dma_len;
 			std->ntds_remaining = -1; /* filled in later */
@@ -506,7 +506,8 @@ static int qset_add_urb_sg(struct whc *w
 			}
 
 			for (;p < std->num_pointers; p++, entry++) {
-				dev_dbg(&whc->umc->dev, "e[%d] %08x\n", p, dma_addr);
+				dev_dbg(&whc->umc->dev, "e[%d] %08llx\n", p,
+					(unsigned long long)dma_addr);
 				std->pl_virt[p].buf_ptr = cpu_to_le64(dma_addr);
 				dma_addr = (dma_addr + WHCI_PAGE_SIZE) & ~(WHCI_PAGE_SIZE-1);
 			}
@@ -565,10 +566,10 @@ static int qset_add_urb_sg_linearize(str
 			break;
 		}
 
-		sg_remaining = min(remaining, sg->length);
+		sg_remaining = min_t(size_t, remaining, sg->length);
 		orig = sg_virt(sg);
 
-		dev_dbg(&whc->umc->dev, "adding sg[%d] %d\n", i, sg_remaining);
+		dev_dbg(&whc->umc->dev, "adding sg[%d] %zu\n", i, sg_remaining);
 
 		while (sg_remaining) {
 			if (!std || std->len == max_std_len) {
@@ -587,7 +588,7 @@ static int qset_add_urb_sg_linearize(str
 
 			len = min(sg_remaining, max_std_len - std->len);
 
-			dev_dbg(&whc->umc->dev, "added %d from sg[%d] @ offset %d\n",
+			dev_dbg(&whc->umc->dev, "added %zu from sg[%d] @ offset %td\n",
 				len, i, orig - sg_virt(sg));
 
 			if (is_out)
