Return-Path: <linux-kernel-owner+w=401wt.eu-S932141AbYDNQjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbYDNQjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 12:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762929AbYDNQis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 12:38:48 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:28605 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762916AbYDNQip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 12:38:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SX17Fi81acrkJfkTzksxkrr+wcIEUJQp0liVnxhVMogTyoGyYeKoDq0JiVFSULbW/6FfaIIP3cm6tWhVCF8cP2kaq2u3M2kO4JdTyUymusjcZ1C7pr2IAFJI2wpxrR3KJjhhpFvHgCMXFLSQok+qquLRINGW8x2CoJCGxyFYrkU=
Subject: [PATCH 06/10] net: Use get/put_unaligned_* helpers
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-arch <linux-arch@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 09:37:55 -0700
Message-Id: <1208191075.5721.28.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/net/e100.c             |    2 +-
 drivers/net/hamachi.c          |    2 +-
 drivers/net/irda/mcs7780.c     |    2 +-
 drivers/net/irda/stir4200.c    |    2 +-
 drivers/net/tulip/de4x5.c      |   35 +++++++++++++++++------------------
 drivers/net/tulip/de4x5.h      |    2 +-
 drivers/net/tulip/tulip.h      |    7 ++-----
 drivers/net/tulip/tulip_core.c |   10 +++++-----
 drivers/net/yellowfin.c        |    2 +-
 9 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/drivers/net/e100.c b/drivers/net/e100.c
index 2d139ec..f3cba5e 100644
--- a/drivers/net/e100.c
+++ b/drivers/net/e100.c
@@ -1802,7 +1802,7 @@ static int e100_rx_alloc_skb(struct nic *nic, struct rx *rx)
 	 * it is protected by the before last buffer's el bit being set */
 	if (rx->prev->skb) {
 		struct rfd *prev_rfd = (struct rfd *)rx->prev->skb->data;
-		put_unaligned(cpu_to_le32(rx->dma_addr), &prev_rfd->link);
+		put_unaligned_le32(rx->dma_addr, &prev_rfd->link);
 	}
 
 	return 0;
diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
index b53f6b6..e5c2380 100644
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -1508,7 +1508,7 @@ static int hamachi_rx(struct net_device *dev)
 					    hmp->rx_buf_sz,
 					    PCI_DMA_FROMDEVICE);
 		buf_addr = (u8 *) hmp->rx_skbuff[entry]->data;
-		frame_status = le32_to_cpu(get_unaligned((__le32*)&(buf_addr[data_size - 12])));
+		frame_status = get_unaligned_le32(&(buf_addr[data_size - 12]));
 		if (hamachi_debug > 4)
 			printk(KERN_DEBUG "  hamachi_rx() status was %8.8x.\n",
 				frame_status);
diff --git a/drivers/net/irda/mcs7780.c b/drivers/net/irda/mcs7780.c
index 93916cf..ad92d3f 100644
--- a/drivers/net/irda/mcs7780.c
+++ b/drivers/net/irda/mcs7780.c
@@ -464,7 +464,7 @@ static void mcs_unwrap_fir(struct mcs_cb *mcs, __u8 *buf, int len)
 	}
 
 	fcs = ~(crc32_le(~0, buf, new_len));
-	if(fcs != le32_to_cpu(get_unaligned((__le32 *)(buf+new_len)))) {
+	if(fcs != get_unaligned_le32(buf + new_len)) {
 		IRDA_ERROR("crc error calc 0x%x len %d\n", fcs, new_len);
 		mcs->stats.rx_errors++;
 		mcs->stats.rx_crc_errors++;
diff --git a/drivers/net/irda/stir4200.c b/drivers/net/irda/stir4200.c
index e59c485..0519637 100644
--- a/drivers/net/irda/stir4200.c
+++ b/drivers/net/irda/stir4200.c
@@ -329,7 +329,7 @@ static void fir_eof(struct stir_cb *stir)
 	}
 
 	fcs = ~(crc32_le(~0, rx_buff->data, len));
-	if (fcs != le32_to_cpu(get_unaligned((__le32 *)(rx_buff->data+len)))) {
+	if (fcs != get_unaligned_le32(rx_buff->data + len)) {
 		pr_debug("crc error calc 0x%x len %d\n", fcs, len);
 		stir->stats.rx_errors++;
 		stir->stats.rx_crc_errors++;
diff --git a/drivers/net/tulip/de4x5.c b/drivers/net/tulip/de4x5.c
index 6c6fc32..bc30c6e 100644
--- a/drivers/net/tulip/de4x5.c
+++ b/drivers/net/tulip/de4x5.c
@@ -482,7 +482,6 @@
 static char version[] __devinitdata = "de4x5.c:V0.546 2001/02/22 davies@maniac.ultranet.com\n";
 
 #define c_char const char
-#define TWIDDLE(a) (u_short)le16_to_cpu(get_unaligned((__le16 *)(a)))
 
 /*
 ** MII Information
@@ -4405,7 +4404,7 @@ srom_infoleaf_info(struct net_device *dev)
 	}
     }
 
-    lp->infoleaf_offset = TWIDDLE(p+1);
+	lp->infoleaf_offset = get_unaligned_le16(p + 1);
 
     return 0;
 }
@@ -4476,7 +4475,7 @@ srom_exec(struct net_device *dev, u_char *p)
 
     while (count--) {
 	gep_wr(((lp->chipset==DC21140) && (lp->ibn!=5) ?
-		                                   *p++ : TWIDDLE(w++)), dev);
+		                                   *p++ : get_unaligned_le16(w++)), dev);
 	mdelay(2);                          /* 2ms per action */
     }
 
@@ -4711,10 +4710,10 @@ type1_infoblock(struct net_device *dev, u_char count, u_char *p)
 	lp->active = *p++;
 	lp->phy[lp->active].gep = (*p ? p : NULL); p += (*p + 1);
 	lp->phy[lp->active].rst = (*p ? p : NULL); p += (*p + 1);
-	lp->phy[lp->active].mc  = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].ana = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].fdx = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].ttm = TWIDDLE(p);
+	lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].ana = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].fdx = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].ttm = get_unaligned_le16(p);
 	return 0;
     } else if ((lp->media == INIT) && (lp->timeout < 0)) {
         lp->ibn = 1;
@@ -4751,16 +4750,16 @@ type2_infoblock(struct net_device *dev, u_char count, u_char *p)
 	lp->infoblock_media = (*p) & MEDIA_CODE;
 
         if ((*p++) & EXT_FIELD) {
-	    lp->cache.csr13 = TWIDDLE(p); p += 2;
-	    lp->cache.csr14 = TWIDDLE(p); p += 2;
-	    lp->cache.csr15 = TWIDDLE(p); p += 2;
+	    lp->cache.csr13 = get_unaligned_le16(p); p += 2;
+	    lp->cache.csr14 = get_unaligned_le16(p); p += 2;
+	    lp->cache.csr15 = get_unaligned_le16(p); p += 2;
 	} else {
 	    lp->cache.csr13 = CSR13;
 	    lp->cache.csr14 = CSR14;
 	    lp->cache.csr15 = CSR15;
 	}
-        lp->cache.gepc = ((s32)(TWIDDLE(p)) << 16); p += 2;
-        lp->cache.gep  = ((s32)(TWIDDLE(p)) << 16);
+        lp->cache.gepc = ((s32)(get_unaligned_le16(p)) << 16); p += 2;
+        lp->cache.gep  = ((s32)(get_unaligned_le16(p)) << 16);
 	lp->infoblock_csr6 = OMR_SIA;
 	lp->useMII = false;
 
@@ -4792,10 +4791,10 @@ type3_infoblock(struct net_device *dev, u_char count, u_char *p)
 	if (MOTO_SROM_BUG) lp->active = 0;
 	lp->phy[lp->active].gep = (*p ? p : NULL); p += (2 * (*p) + 1);
 	lp->phy[lp->active].rst = (*p ? p : NULL); p += (2 * (*p) + 1);
-	lp->phy[lp->active].mc  = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].ana = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].fdx = TWIDDLE(p); p += 2;
-	lp->phy[lp->active].ttm = TWIDDLE(p); p += 2;
+	lp->phy[lp->active].mc  = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].ana = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].fdx = get_unaligned_le16(p); p += 2;
+	lp->phy[lp->active].ttm = get_unaligned_le16(p); p += 2;
 	lp->phy[lp->active].mci = *p;
 	return 0;
     } else if ((lp->media == INIT) && (lp->timeout < 0)) {
@@ -4835,8 +4834,8 @@ type4_infoblock(struct net_device *dev, u_char count, u_char *p)
         lp->cache.csr13 = CSR13;              /* Hard coded defaults */
 	lp->cache.csr14 = CSR14;
 	lp->cache.csr15 = CSR15;
-        lp->cache.gepc = ((s32)(TWIDDLE(p)) << 16); p += 2;
-        lp->cache.gep  = ((s32)(TWIDDLE(p)) << 16); p += 2;
+        lp->cache.gepc = ((s32)(get_unaligned_le16(p)) << 16); p += 2;
+        lp->cache.gep  = ((s32)(get_unaligned_le16(p)) << 16); p += 2;
 	csr6 = *p++;
 	flags = *p++;
 
diff --git a/drivers/net/tulip/de4x5.h b/drivers/net/tulip/de4x5.h
index 9fb8d7f..f5f33b3 100644
--- a/drivers/net/tulip/de4x5.h
+++ b/drivers/net/tulip/de4x5.h
@@ -1017,4 +1017,4 @@ struct de4x5_ioctl {
 #define DE4X5_SET_OMR           0x0d /* Set the OMR Register contents */
 #define DE4X5_GET_REG           0x0e /* Get the DE4X5 Registers */
 
-#define MOTO_SROM_BUG    ((lp->active == 8) && (((le32_to_cpu(get_unaligned(((__le32 *)dev->dev_addr))))&0x00ffffff)==0x3e0008))
+#define MOTO_SROM_BUG    (lp->active == 8 && (get_unaligned_le32(dev->dev_addr) & 0x00ffffff) == 0x3e0008)
diff --git a/drivers/net/tulip/tulip.h b/drivers/net/tulip/tulip.h
index 3f69f53..78d1cfc 100644
--- a/drivers/net/tulip/tulip.h
+++ b/drivers/net/tulip/tulip.h
@@ -25,6 +25,7 @@
 #include <linux/pci.h>
 #include <asm/io.h>
 #include <asm/irq.h>
+#include <asm/unaligned.h>
 


@@ -299,11 +300,7 @@ enum t21143_csr6_bits {
 
 #define RUN_AT(x) (jiffies + (x))
 
-#if defined(__i386__)			/* AKA get_unaligned() */
-#define get_u16(ptr) (*(u16 *)(ptr))
-#else
-#define get_u16(ptr) (((u8*)(ptr))[0] + (((u8*)(ptr))[1]<<8))
-#endif
+#define get_u16(ptr) get_unaligned_le16((ptr))
 
 struct medialeaf {
 	u8 type;
diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index 82f404b..1c6d59d 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -327,8 +327,8 @@ static void tulip_up(struct net_device *dev)
 	tp->dirty_rx = tp->dirty_tx = 0;
 
 	if (tp->flags & MC_HASH_ONLY) {
-		u32 addr_low = le32_to_cpu(get_unaligned((__le32 *)dev->dev_addr));
-		u32 addr_high = le16_to_cpu(get_unaligned((__le16 *)(dev->dev_addr+4)));
+		u32 addr_low = get_unaligned_le32(dev->dev_addr);
+		u32 addr_high = get_unaligned_le16(dev->dev_addr + 4);
 		if (tp->chip_id == AX88140) {
 			iowrite32(0, ioaddr + CSR13);
 			iowrite32(addr_low,  ioaddr + CSR14);
@@ -1446,13 +1446,13 @@ static int __devinit tulip_init_one (struct pci_dev *pdev,
 			do
 				value = ioread32(ioaddr + CSR9);
 			while (value < 0  && --boguscnt > 0);
-			put_unaligned(cpu_to_le16(value), ((__le16*)dev->dev_addr) + i);
+			put_unaligned_le16(value, ((__le16 *)dev->dev_addr) + i);
 			sum += value & 0xffff;
 		}
 	} else if (chip_idx == COMET) {
 		/* No need to read the EEPROM. */
-		put_unaligned(cpu_to_le32(ioread32(ioaddr + 0xA4)), (__le32 *)dev->dev_addr);
-		put_unaligned(cpu_to_le16(ioread32(ioaddr + 0xA8)), (__le16 *)(dev->dev_addr + 4));
+		put_unaligned_le32(ioread32(ioaddr + 0xA4), dev->dev_addr);
+		put_unaligned_le16(ioread32(ioaddr + 0xA8), dev->dev_addr + 4);
 		for (i = 0; i < 6; i ++)
 			sum += dev->dev_addr[i];
 	} else {
diff --git a/drivers/net/yellowfin.c b/drivers/net/yellowfin.c
index fe6ff3e..9b53bfb 100644
--- a/drivers/net/yellowfin.c
+++ b/drivers/net/yellowfin.c
@@ -1062,7 +1062,7 @@ static int yellowfin_rx(struct net_device *dev)
 		buf_addr = rx_skb->data;
 		data_size = (le32_to_cpu(desc->dbdma_cmd) -
 			le32_to_cpu(desc->result_status)) & 0xffff;
-		frame_status = le16_to_cpu(get_unaligned((__le16*)&(buf_addr[data_size - 2])));
+		frame_status = get_unaligned_le16(&(buf_addr[data_size - 2]));
 		if (yellowfin_debug > 4)
 			printk(KERN_DEBUG "  yellowfin_rx() status was %4.4x.\n",
 				   frame_status);
-- 
1.5.5.144.g3e42


