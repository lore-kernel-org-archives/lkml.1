Return-Path: <linux-kernel-owner+w=401wt.eu-S1758851AbYCUSFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758851AbYCUSFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbYCUSFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:05:09 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:42391 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301AbYCUSFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:05:07 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ISAPNP: fix limits of logical device register set
Date: Fri, 21 Mar 2008 12:08:37 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Jaroslav Kysela <perex@perex.cz>, Adam Belay <ambx1@neo.rr.com>,
       Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803211208.39124.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I think we should consider this for 2.6.25.  I know it's late in
the cycle but it is low-risk.  Without this patch, we can read and
write off the end of the ISAPNP hardware register set with unknown
consequences.  This was also broken in 2.6.24, and I haven't heard
any reports, but if 2.6.25 ends up being more widely-used, ISAPNP
users might start tripping over it.]


PNP_MAX_MEM and PNP_MAX_PORT are mainly used to size tables of PNP
device resources.  In 2.6.24, we increased their values to accomodate
ACPI devices that have many resources:

                 2.6.23    2.6.24
                 ------    ------
  PNP_MAX_MEM       4         12
  PNP_MAX_PORT      8         40

However, ISAPNP also used these constants as the size of parts of the
logical device register set.  This register set is fixed by hardware,
so increasing the constants meant that we were reading and writing
unintended parts of the register set.

This patch changes ISAPNP to use the correct register set sizes (the
same values we used prior to 2.6.24).

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/drivers/pnp/isapnp/core.c
===================================================================
--- work7.orig/drivers/pnp/isapnp/core.c	2008-03-21 11:45:41.000000000 -0600
+++ work7/drivers/pnp/isapnp/core.c	2008-03-21 11:52:12.000000000 -0600
@@ -88,6 +88,15 @@
 #define _LTAG_MEM32RANGE	0x85
 #define _LTAG_FIXEDMEM32RANGE	0x86
 
+/*
+ * Sizes of ISAPNP logical device configuration register sets.
+ * See PNP-ISA-v1.0a.pdf, Appendix A.
+ */
+#define ISAPNP_MAX_MEM		4
+#define ISAPNP_MAX_PORT		8
+#define ISAPNP_MAX_IRQ		2
+#define ISAPNP_MAX_DMA		2
+
 static unsigned char isapnp_checksum_value;
 static DEFINE_MUTEX(isapnp_cfg_mutex);
 static int isapnp_csn_count;
@@ -945,14 +954,14 @@
 
 	dev->active = isapnp_read_byte(ISAPNP_CFG_ACTIVATE);
 	if (dev->active) {
-		for (tmp = 0; tmp < PNP_MAX_PORT; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_PORT; tmp++) {
 			ret = isapnp_read_word(ISAPNP_CFG_PORT + (tmp << 1));
 			if (!ret)
 				continue;
 			res->port_resource[tmp].start = ret;
 			res->port_resource[tmp].flags = IORESOURCE_IO;
 		}
-		for (tmp = 0; tmp < PNP_MAX_MEM; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_MEM; tmp++) {
 			ret =
 			    isapnp_read_word(ISAPNP_CFG_MEM + (tmp << 3)) << 8;
 			if (!ret)
@@ -960,7 +969,7 @@
 			res->mem_resource[tmp].start = ret;
 			res->mem_resource[tmp].flags = IORESOURCE_MEM;
 		}
-		for (tmp = 0; tmp < PNP_MAX_IRQ; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_IRQ; tmp++) {
 			ret =
 			    (isapnp_read_word(ISAPNP_CFG_IRQ + (tmp << 1)) >>
 			     8);
@@ -970,7 +979,7 @@
 			    res->irq_resource[tmp].end = ret;
 			res->irq_resource[tmp].flags = IORESOURCE_IRQ;
 		}
-		for (tmp = 0; tmp < PNP_MAX_DMA; tmp++) {
+		for (tmp = 0; tmp < ISAPNP_MAX_DMA; tmp++) {
 			ret = isapnp_read_byte(ISAPNP_CFG_DMA + tmp);
 			if (ret == 4)
 				continue;
@@ -1002,14 +1011,14 @@
 	isapnp_cfg_begin(dev->card->number, dev->number);
 	dev->active = 1;
 	for (tmp = 0;
-	     tmp < PNP_MAX_PORT
+	     tmp < ISAPNP_MAX_PORT
 	     && (res->port_resource[tmp].
 		 flags & (IORESOURCE_IO | IORESOURCE_UNSET)) == IORESOURCE_IO;
 	     tmp++)
 		isapnp_write_word(ISAPNP_CFG_PORT + (tmp << 1),
 				  res->port_resource[tmp].start);
 	for (tmp = 0;
-	     tmp < PNP_MAX_IRQ
+	     tmp < ISAPNP_MAX_IRQ
 	     && (res->irq_resource[tmp].
 		 flags & (IORESOURCE_IRQ | IORESOURCE_UNSET)) == IORESOURCE_IRQ;
 	     tmp++) {
@@ -1019,14 +1028,14 @@
 		isapnp_write_byte(ISAPNP_CFG_IRQ + (tmp << 1), irq);
 	}
 	for (tmp = 0;
-	     tmp < PNP_MAX_DMA
+	     tmp < ISAPNP_MAX_DMA
 	     && (res->dma_resource[tmp].
 		 flags & (IORESOURCE_DMA | IORESOURCE_UNSET)) == IORESOURCE_DMA;
 	     tmp++)
 		isapnp_write_byte(ISAPNP_CFG_DMA + tmp,
 				  res->dma_resource[tmp].start);
 	for (tmp = 0;
-	     tmp < PNP_MAX_MEM
+	     tmp < ISAPNP_MAX_MEM
 	     && (res->mem_resource[tmp].
 		 flags & (IORESOURCE_MEM | IORESOURCE_UNSET)) == IORESOURCE_MEM;
 	     tmp++)
