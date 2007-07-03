Return-Path: <linux-kernel-owner+w=401wt.eu-S1760307AbXGCPLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760307AbXGCPLW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 11:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbXGCPLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 11:11:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54663 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755305AbXGCPLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 11:11:11 -0400
Date: Tue, 3 Jul 2007 16:17:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       jeff@garzik.org
Subject: [PATCH] iomap: Sort out the broken address reporting caused by the
 iomap layer
Message-ID: <20070703161718.40ef836e@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add an iomap_name() function which translates an I/O map into a string to
print
Use it for the Libata layer

For now we use 0xXXXX for I/O and 0xXXXXXXXX for MMIO. I'm assuming that
eventually some other platforms will want to use their own iomap_name()
and we can add ARCH_HAVE_IOMAP_NAME later as such a platform needs it.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-core.c linux-2.6.22-rc6-mm1/drivers/ata/libata-core.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/libata-core.c	2007-07-02 20:50:11.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/libata-core.c	2007-07-02 21:36:20.000000000 +0100
@@ -6292,6 +6425,7 @@
 int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 {
 	int i, rc;
+	char ctlbuf[IOMAP_NAMELEN], cmdbuf[IOMAP_NAMELEN], dmabuf[IOMAP_NAMELEN];
 
 	/* host must have been started */
 	if (!(host->flags & ATA_HOST_STARTED)) {
@@ -6348,13 +6482,13 @@
 
 		/* print per-port info to dmesg */
 		if (!ata_port_is_dummy(ap))
-			ata_port_printk(ap, KERN_INFO, "%cATA max %s cmd 0x%p "
-					"ctl 0x%p bmdma 0x%p irq %d\n",
+			ata_port_printk(ap, KERN_INFO, "%cATA max %s cmd %s "
+					"ctl %s bmdma %s irq %d\n",
 					(ap->flags & ATA_FLAG_SATA) ? 'S' : 'P',
 					ata_mode_string(xfer_mask),
-					ap->ioaddr.cmd_addr,
-					ap->ioaddr.ctl_addr,
-					ap->ioaddr.bmdma_addr,
+					iomap_name(ap->ioaddr.cmd_addr, cmdbuf, sizeof(cmdbuf)),
+					iomap_name(ap->ioaddr.ctl_addr, ctlbuf, sizeof(ctlbuf)),
+					iomap_name(ap->ioaddr.bmdma_addr, dmabuf, sizeof(dmabuf)),
 					irq_line);
 		else
 			ata_port_printk(ap, KERN_INFO, "DUMMY\n");
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/include/linux/libata.h linux-2.6.22-rc6-mm1/include/linux/libata.h
--- linux.vanilla-2.6.22-rc6-mm1/include/linux/libata.h	2007-07-02 20:50:14.000000000 +0100
+++ linux-2.6.22-rc6-mm1/include/linux/libata.h	2007-07-02 21:29:18.000000000 +0100
@@ -1112,11 +1124,14 @@
 
 static inline u8 ata_wait_idle(struct ata_port *ap)
 {
+	char buf[IOMAP_NAMELEN];
 	u8 status = ata_busy_wait(ap, ATA_BUSY | ATA_DRQ, 1000);
 
-	if (status != 0xff && (status & (ATA_BUSY | ATA_DRQ)))
-		DPRINTK("ATA: abnormal status 0x%X on port 0x%p\n",
-			status, ap->ioaddr.status_addr);
+	if (status != 0xff && (status & (ATA_BUSY | ATA_DRQ))) {
+  		if (ata_msg_warn(ap))
+			printk(KERN_WARNING "ATA: abnormal status 0x%X on port %s\n",
+ 				status, iomap_name(ap->ioaddr.status_addr, buf, sizeof(buf)));
+	}
 
 	return status;
 }
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/lib/iomap.c linux-2.6.22-rc6-mm1/lib/iomap.c
--- linux.vanilla-2.6.22-rc6-mm1/lib/iomap.c	2007-07-02 20:49:03.000000000 +0100
+++ linux-2.6.22-rc6-mm1/lib/iomap.c	2007-07-02 21:30:38.000000000 +0100
@@ -268,3 +268,15 @@
 }
 EXPORT_SYMBOL(pci_iomap);
 EXPORT_SYMBOL(pci_iounmap);
+
+char *iomap_name(void __iomem *port, char *buf, size_t len)
+{
+	if (port == NULL) {
+		snprintf(buf, len, "None");
+		return buf;
+	}
+	IO_COND(port, snprintf(buf, len, "0x%04lx", port), snprintf(buf, len, "%08lx", port));
+	return buf;
+}
+
+EXPORT_SYMBOL(iomap_name);
diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/include/asm-generic/iomap.h linux-2.6.22-rc6-mm1/include/asm-generic/iomap.h
--- linux.vanilla-2.6.22-rc6-mm1/include/asm-generic/iomap.h	2007-07-02 20:47:33.000000000 +0100
+++ linux-2.6.22-rc6-mm1/include/asm-generic/iomap.h	2007-07-02 21:25:46.000000000 +0100
@@ -65,4 +65,9 @@
 extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
 extern void pci_iounmap(struct pci_dev *dev, void __iomem *);
 
+/* Convert an iomap to text for this platform */
+extern char *iomap_name(void __iomem *addr, char *buf, size_t len);
+#define IOMAP_NAMELEN	12
+
+
 #endif
