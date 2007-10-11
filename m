Return-Path: <linux-kernel-owner+w=401wt.eu-S1757673AbXJKMgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757673AbXJKMgA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753148AbXJKMfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:35:53 -0400
Received: from toplitzer.net ([83.151.30.110]:43262 "EHLO toplitzer.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbXJKMfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:35:52 -0400
X-Greylist: delayed 1574 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2007 08:35:51 EDT
From: Helmut Toplizer <bgrpt@toplitzer.net>
To: poison <rc.poison@gmail.com>
Subject: Re: linux-2.6.23 - acting funny
Date: Thu, 11 Oct 2007 14:09:13 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_pJhDHf05Y/d5MsE"
Message-Id: <200710111409.13854.bgrpt@toplitzer.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_pJhDHf05Y/d5MsE
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi!

I had similar behavior in the kernel releases since I can think of.
(You may find some reports about at
http://marc.info/?a=113508574400006&r=1&w=2)

Maybe your problem is similar.

Here's what have been found out:
Plugin of ehci devices causes some strange DMA thing
which causes delays because of the CPU HLT instruction.
(DMA are handled with delays on HLT)

Possible fixes:
1) Kernel parameter: idle=poll
    Disables HLT and causes heat up and noise from the cpu

2) Don't insert EHCI-USB devices

3) Patch: attached, try out at your own risk.
    you need to add a kernel-boot parameter "disableviahlt"
   (You've got a via-chipset, right?)

Please report back to me if 1/2 works or to linux-ide if the patch works. 
Thanks

Helmut

--Boundary-00=_pJhDHf05Y/d5MsE
Content-Type: text/x-diff;
  charset="us-ascii";
  name="02_hlt_dma_patch.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="02_hlt_dma_patch.diff"

--- kernel/drivers/ide/ide-dma.c	2006-08-20 11:31:53.000000000 +0200
+++ kernel/drivers/ide/ide-dma.c	2006-08-20 11:40:43.000000000 +0200
@@ -89,6 +89,57 @@
 #include <asm/io.h>
 #include <asm/irq.h>
 
+
+/* Some VIA boards show strange slowdown when HLT is eanbled  */
+/* So we disable the HLT during a IDE-DMA transfer.           */
+/* You need to pass disableviahlt at boottime to enable this  */
+/* workaround.                                                */
+#if defined(HAVE_DISABLE_HLT)
+
+static DEFINE_SPINLOCK(ide_hlt_lock);
+static int hlt_disabled;
+static int disableviahlt;
+static void ide_disable_hlt(void)
+{
+	unsigned long flags;
+	
+	spin_lock_irqsave(&ide_hlt_lock, flags);
+	if(disableviahlt) {
+		hlt_disabled++ ;
+		disable_hlt();
+	}
+	spin_unlock_irqrestore(&ide_hlt_lock, flags);
+}
+
+static void ide_enable_hlt(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&ide_hlt_lock, flags);
+	if(hlt_disabled && disableviahlt){
+		hlt_disabled--;
+		enable_hlt();
+	}
+	spin_unlock_irqrestore(&ide_hlt_lock, flags);
+}
+
+static int __init disable_via_hlt(char *str)
+{
+    printk(KERN_WARNING "DISABLE VIA HLT  activated\n");
+    disableviahlt = 1;
+    return 1;
+}
+
+__setup("disableviahlt", disable_via_hlt);
+
+
+#else  /* HAVE_DISABLE_HLT */
+inline static void ide_disable_hlt(void)
+{}
+inline static void ide_enable_hlt(void)
+{}
+#endif /* HAVE_DISABLE_HLT */
+
 static const struct drive_list_entry drive_whitelist [] = {
 
 	{ "Micropolis 2112A"	,       "ALL"		},
@@ -301,6 +352,7 @@
 	if (count) {
 		if (!is_trm290)
 			*--table |= cpu_to_le32(0x80000000);
+		ide_disable_hlt();
 		return count;
 	}
 	printk(KERN_ERR "%s: empty DMA table?\n", drive->name);
@@ -332,6 +384,7 @@
 	int nents = HWIF(drive)->sg_nents;
 
 	pci_unmap_sg(dev, sg, nents, HWIF(drive)->sg_dma_direction);
+	ide_enable_hlt();
 }
 
 EXPORT_SYMBOL_GPL(ide_destroy_dmatable);

--Boundary-00=_pJhDHf05Y/d5MsE--
