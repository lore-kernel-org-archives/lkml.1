Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbXCGPgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbXCGPgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 10:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbXCGPgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 10:36:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55581 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751967AbXCGPgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 10:36:04 -0500
Date: Wed, 7 Mar 2007 16:40:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: [PATCH] prism54usb: Fix hail of warnings on 64bit platforms
Message-ID: <20070307164020.16944e32@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If you want to cast a pointer to a small value then start by turning it
into an unsigned long so the compiler knows what is going on.

Personally I find the whole approach used by this driver for types of
registers (which are really USB register numbers) utterly perverse...

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.21-rc2-mm2/drivers/net/wireless/mac80211/p54/prism54usb.c linux-2.6.21-rc2-mm2/drivers/net/wireless/mac80211/p54/prism54usb.c
--- linux.vanilla-2.6.21-rc2-mm2/drivers/net/wireless/mac80211/p54/prism54usb.c	2007-03-06 23:09:47.000000000 +0000
+++ linux-2.6.21-rc2-mm2/drivers/net/wireless/mac80211/p54/prism54usb.c	2007-03-06 19:15:52.000000000 +0000
@@ -533,7 +533,7 @@
 #define P54U_WRITE(type, addr, data) \
 	do {\
 		err = p54u_write(priv, buf, type,\
-				 cpu_to_le32((u32)addr), data);\
+				 cpu_to_le32((u32)(unsigned long)addr), data);\
 		if (err) \
 			goto fail;\
 	} while (0)
@@ -541,7 +541,7 @@
 #define P54U_READ(type, addr) \
 	do {\
 		err = p54u_read(priv, buf, type,\
-				cpu_to_le32((u32)addr), &reg);\
+				cpu_to_le32((u32)(unsigned long)addr), &reg);\
 		if (err)\
 			goto fail;\
 	} while (0)
@@ -648,16 +648,16 @@
 			   cpu_to_le32(0xc0000f00));
 
 		P54U_WRITE(NET2280_DEV_U32,
-			   0x0020 | (u32)&devreg->direct_mem_win, 0);
+			   0x0020 | (unsigned long)&devreg->direct_mem_win, 0);
 		P54U_WRITE(NET2280_DEV_U32,
-			   0x0020 | (u32)&devreg->direct_mem_win,
+			   0x0020 | (unsigned long)&devreg->direct_mem_win,
 			   cpu_to_le32(1));
 
 		P54U_WRITE(NET2280_DEV_U32,
-			   0x0024 | (u32)&devreg->direct_mem_win,
+			   0x0024 | (unsigned long)&devreg->direct_mem_win,
 			   cpu_to_le32(block_len));
 		P54U_WRITE(NET2280_DEV_U32,
-			   0x0028 | (u32)&devreg->direct_mem_win,
+			   0x0028 | (unsigned long)&devreg->direct_mem_win,
 			   cpu_to_le32(offset));
 
 		P54U_WRITE(NET2280_DEV_U32, &devreg->dma_addr,
@@ -670,7 +670,7 @@
 		mdelay(10);
 
 		P54U_READ(NET2280_DEV_U32,
-			  0x002C | (u32)&devreg->direct_mem_win);
+			  0x002C | (unsigned long)&devreg->direct_mem_win);
 		if (!(reg & cpu_to_le32(ISL38XX_DMA_STATUS_DONE)) ||
 		    !(reg & cpu_to_le32(ISL38XX_DMA_STATUS_READY))) {
 			printk(KERN_ERR "prism54usb: firmware DMA transfer "
