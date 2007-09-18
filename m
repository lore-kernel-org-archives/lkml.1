Return-Path: <linux-kernel-owner+w=401wt.eu-S1758538AbXIRT2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758538AbXIRT2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbXIRT2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:28:01 -0400
Received: from smtp102.plus.mail.re1.yahoo.com ([69.147.102.65]:43975 "HELO
	smtp102.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753747AbXIRT2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:28:00 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:User-Agent;
  b=bcicb63sMD4YVJ9QEY433od3MJy3YMoVYyo2zXi8yjzdIKuaq/dGN9t7rppz0xt2VFF1x34Q+Wd9tJDjXWJuXVQ0zUjqsGGFTZ1fUieKnWtKk/XnCNBVsTI0cYMwgGapNObMTgS0D3HghzMJAk1opi2rSdBDl4vr9jfVeugvfi4=  ;
X-YMail-OSG: N8OyRSEVM1k.o0UJ3Mo77xqhuEAUSE3AjZRtmRrV.SobIPNwXCveT_ET5noXsIIDUPkC37.Lzw--
Date: Tue, 18 Sep 2007 21:27:07 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Muli Ben-Yehuda <muli@il.ibm.com>,
       Satyam Sharma <satyam@infradead.org>, amitkale@netxen.com,
       achim_leubner@adaptec.com
Subject: [PATCH 1/1] unify DMA_..BIT_MASK definitions: v3
Message-ID: <20070918192707.GA22933@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches remove redundant DMA_..BIT_MASK definitions across two
drivers. The computation of the majority of the bitmasks is done by the
compiler. The initial split of the patch touching each a different file got
removed due to possible git bisect breakage.

Andrew, can you please apply this patch for it touches drivers maintained by
different people and there might be responsibility issues, imho.

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>

 drivers/net/netxen/netxen_nic_main.c |    3 ---
 drivers/scsi/gdth.c                  |    5 -----
 include/linux/dma-mapping.h          |   23 +++++++++++++----------
 3 files changed, 13 insertions(+), 18 deletions(-)

--
Index: b/include/linux/dma-mapping.h
===================================================================
--- a/include/linux/dma-mapping.h	2007-09-18 21:12:30.000000000 +0200
+++ b/include/linux/dma-mapping.h	2007-09-18 21:13:17.000000000 +0200
@@ -13,16 +13,19 @@
 	DMA_NONE = 3,
 };
 
-#define DMA_64BIT_MASK	0xffffffffffffffffULL
-#define DMA_48BIT_MASK	0x0000ffffffffffffULL
-#define DMA_40BIT_MASK	0x000000ffffffffffULL
-#define DMA_39BIT_MASK	0x0000007fffffffffULL
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_31BIT_MASK	0x000000007fffffffULL
-#define DMA_30BIT_MASK	0x000000003fffffffULL
-#define DMA_29BIT_MASK	0x000000001fffffffULL
-#define DMA_28BIT_MASK	0x000000000fffffffULL
-#define DMA_24BIT_MASK	0x0000000000ffffffULL
+#define DMA_BIT_MASK(n)	((1ULL<<(n))-1)
+
+#define DMA_64BIT_MASK	~0ULL
+#define DMA_48BIT_MASK	DMA_BIT_MASK(48)
+#define DMA_40BIT_MASK	DMA_BIT_MASK(40)
+#define DMA_39BIT_MASK	DMA_BIT_MASK(39)
+#define DMA_35BIT_MASK	DMA_BIT_MASK(35)
+#define DMA_32BIT_MASK	DMA_BIT_MASK(32)
+#define DMA_31BIT_MASK	DMA_BIT_MASK(31)
+#define DMA_30BIT_MASK	DMA_BIT_MASK(30)
+#define DMA_29BIT_MASK	DMA_BIT_MASK(29)
+#define DMA_28BIT_MASK	DMA_BIT_MASK(28)
+#define DMA_24BIT_MASK	DMA_BIT_MASK(24)
 
 static inline int valid_dma_direction(int dma_direction)
 {
Index: b/drivers/net/netxen/netxen_nic_main.c
===================================================================
--- a/drivers/net/netxen/netxen_nic_main.c	2007-09-18 21:13:06.000000000 +0200
+++ b/drivers/net/netxen/netxen_nic_main.c	2007-09-18 21:13:46.000000000 +0200
@@ -54,9 +54,6 @@
 #define NETXEN_ADAPTER_UP_MAGIC 777
 #define NETXEN_NIC_PEG_TUNE 0
 
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_35BIT_MASK	0x00000007ffffffffULL
-
 /* Local functions to NetXen NIC driver */
 static int __devinit netxen_nic_probe(struct pci_dev *pdev,
 				      const struct pci_device_id *ent);
Index: b/drivers/scsi/gdth.c
===================================================================
--- a/drivers/scsi/gdth.c	2007-09-18 21:12:43.000000000 +0200
+++ b/drivers/scsi/gdth.c	2007-09-18 21:14:06.000000000 +0200
@@ -392,12 +392,7 @@
 #include <linux/proc_fs.h>
 #include <linux/time.h>
 #include <linux/timer.h>
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,6)
 #include <linux/dma-mapping.h>
-#else
-#define DMA_32BIT_MASK	0x00000000ffffffffULL
-#define DMA_64BIT_MASK	0xffffffffffffffffULL
-#endif
 
 #ifdef GDTH_RTC
 #include <linux/mc146818rtc.h>

-- 
Regards/Gruﬂ,
    Boris.
