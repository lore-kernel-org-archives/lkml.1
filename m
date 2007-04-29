Return-Path: <linux-kernel-owner+w=401wt.eu-S1161361AbXD2VGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161361AbXD2VGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161383AbXD2VGu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:06:50 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48228 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161361AbXD2VGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:06:11 -0400
Message-id: <2351127086724526083@wsc.cz>
In-reply-to: <1726067771982725064@wsc.cz>
Subject: [PATCH 19/21] Char: cyclades, dynamic ports
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 29 Apr 2007 23:06:08 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, dynamic ports

and save thus approx. 160k of .bss

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit c1eb9b97d07f0ac45e3c6173b4e5b822a2a5dca2
tree ca449397fca08a7bb4bb6a28f273f8c00eade922
parent 0d1d9602e00c115e03e04ee01f3ecc92adbbf504
author Jiri Slaby <jirislaby@gmail.com> Sun, 29 Apr 2007 14:51:11 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 29 Apr 2007 14:51:11 +0200

 drivers/char/cyclades.c  |  142 ++++++++++++++++++++++------------------------
 include/linux/cyclades.h |    1 
 2 files changed, 70 insertions(+), 73 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index f23d481..3eabd26 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -722,11 +722,6 @@ module_param_array(irq, int, NULL, 0);
 */
 static struct cyclades_card cy_card[NR_CARDS];
 
-/* This is the per-channel data structure containing pointers, flags
- and variables for the port. This driver supports a maximum of NR_PORTS.
-*/
-static struct cyclades_port cy_port[NR_PORTS];
-
 static int cy_next_channel;	/* next minor available */
 
 /*
@@ -855,13 +850,6 @@ static inline int serial_paranoia_check(struct cyclades_port *info,
 		return 1;
 	}
 
-	if ((long)info < (long)(&cy_port[0]) ||
-			(long)(&cy_port[NR_PORTS]) < (long)info) {
-		printk(KERN_WARNING "cyc Warning: cyclades_port out of range "
-				"for (%s) in %s\n", name, routine);
-		return 1;
-	}
-
 	if (info->magic != CYCLADES_MAGIC) {
 		printk(KERN_WARNING "cyc Warning: bad magic number for serial "
 				"struct (%s) in %s\n", name, routine);
@@ -1025,7 +1013,7 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 	struct cyclades_port *info;
 	struct tty_struct *tty;
 	int char_count;
-	int i, j, len, mdm_change, mdm_status, outch;
+	int j, len, mdm_change, mdm_status, outch;
 	int save_xir, channel, save_car;
 	char data;
 
@@ -1037,8 +1025,7 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 		spin_lock(&cinfo->card_lock);
 		save_xir = (u_char) readb(base_addr + (CyRIR << index));
 		channel = (u_short) (save_xir & CyIRChannel);
-		i = channel + chip * 4 + cinfo->first_line;
-		info = &cy_port[i];
+		info = &cinfo->ports[channel + chip * 4];
 		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
@@ -1202,18 +1189,17 @@ static void cyy_intr_chip(struct cyclades_card *cinfo, int chip,
 		spin_lock(&cinfo->card_lock);
 		save_xir = (u_char) readb(base_addr + (CyTIR << index));
 		channel = (u_short) (save_xir & CyIRChannel);
-		i = channel + chip * 4 + cinfo->first_line;
 		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
 		/* validate the port# (as configured and open) */
-		if ((i < 0) || (NR_PORTS <= i)) {
+		if (channel + chip * 4 >= cinfo->nports) {
 			cy_writeb(base_addr + (CySRER << index),
 				  readb(base_addr + (CySRER << index)) &
 				  ~CyTxRdy);
 			goto txend;
 		}
-		info = &cy_port[i];
+		info = &cinfo->ports[channel + chip * 4];
 		if (info->tty == NULL) {
 			cy_writeb(base_addr + (CySRER << index),
 				  readb(base_addr + (CySRER << index)) &
@@ -1325,7 +1311,7 @@ txend:
 		spin_lock(&cinfo->card_lock);
 		save_xir = (u_char) readb(base_addr + (CyMIR << index));
 		channel = (u_short) (save_xir & CyIRChannel);
-		info = &cy_port[channel + chip * 4 + cinfo->first_line];
+		info = &cinfo->ports[channel + chip * 4];
 		save_car = readb(base_addr + (CyCAR << index));
 		cy_writeb(base_addr + (CyCAR << index), save_xir);
 
@@ -1726,7 +1712,7 @@ static void cyz_handle_cmd(struct cyclades_card *cinfo)
 	while (cyz_fetch_msg(cinfo, &channel, &cmd, &param) == 1) {
 		special_count = 0;
 		delta_count = 0;
-		info = &cy_port[channel + cinfo->first_line];
+		info = &cinfo->ports[channel];
 		if ((tty = info->tty) == NULL)
 			continue;
 
@@ -1896,7 +1882,7 @@ static void cyz_poll(unsigned long arg)
 		cyz_handle_cmd(cinfo);
 
 		for (port = 0; port < cinfo->nports; port++) {
-			info = &cy_port[port + cinfo->first_line];
+			info = &cinfo->ports[port];
 			tty = info->tty;
 			ch_ctrl = &(zfw_ctrl->ch_ctrl[port]);
 			buf_ctrl = &(zfw_ctrl->buf_ctrl[port]);
@@ -2468,13 +2454,20 @@ block_til_ready(struct tty_struct *tty, struct file *filp,
 static int cy_open(struct tty_struct *tty, struct file *filp)
 {
 	struct cyclades_port *info;
+	unsigned int i;
 	int retval, line;
 
 	line = tty->index;
 	if ((line < 0) || (NR_PORTS <= line)) {
 		return -ENODEV;
 	}
-	info = &cy_port[line];
+	for (i = 0; i < NR_CARDS; i++)
+		if (line < cy_card[i].first_line + cy_card[i].nports &&
+				line >= cy_card[i].first_line)
+			break;
+	if (i >= NR_CARDS)
+		return -ENODEV;
+	info = &cy_card[i].ports[line - cy_card[i].first_line];
 	if (info->line < 0) {
 		return -ENODEV;
 	}
@@ -4437,7 +4430,7 @@ static void cy_hangup(struct tty_struct *tty)
  * ---------------------------------------------------------------------
  */
 
-static void __devinit cy_init_card(struct cyclades_card *cinfo)
+static int __devinit cy_init_card(struct cyclades_card *cinfo)
 {
 	struct cyclades_port *info;
 	u32 mailbox;
@@ -4459,10 +4452,15 @@ static void __devinit cy_init_card(struct cyclades_card *cinfo)
 		nports = cinfo->nports = CyPORTS_PER_CHIP * cinfo->num_chips;
 	}
 
+	cinfo->ports = kzalloc(sizeof(*cinfo->ports) * nports, GFP_KERNEL);
+	if (cinfo->ports == NULL) {
+		printk(KERN_ERR "Cyclades: cannot allocate ports\n");
+		return -ENOMEM;
+	}
+
 	for (port = cinfo->first_line; port < cinfo->first_line + nports;
 			port++) {
-		info = &cy_port[port];
-		memset(info, 0, sizeof(*info));
+		info = &cinfo->ports[port - cinfo->first_line];
 		info->magic = CYCLADES_MAGIC;
 		info->card = cinfo;
 		info->line = port;
@@ -4525,6 +4523,7 @@ static void __devinit cy_init_card(struct cyclades_card *cinfo)
 #endif
 	}
 #endif
+	return 0;
 }
 
 /* initialize chips on Cyclom-Y card -- return number of valid
@@ -5094,13 +5093,11 @@ static void __devexit cy_pci_remove(struct pci_dev *pdev)
 	pci_release_regions(pdev);
 
 	cinfo->base_addr = NULL;
-	for (i = cinfo->first_line; i < cinfo->first_line + cinfo->nports; i++){
-		cy_port[i].line = -1;
-		cy_port[i].magic = -1;
-	}
 	for (i = cinfo->first_line; i < cinfo->first_line +
 			cinfo->nports; i++)
 		tty_unregister_device(cy_serial_driver, i);
+	cinfo->nports = 0;
+	kfree(cinfo->ports);
 }
 
 static struct pci_driver cy_pci_driver = {
@@ -5116,7 +5113,7 @@ cyclades_get_proc_info(char *buf, char **start, off_t offset, int length,
 		int *eof, void *data)
 {
 	struct cyclades_port *info;
-	int i;
+	unsigned int i, j;
 	int len = 0;
 	off_t begin = 0;
 	off_t pos = 0;
@@ -5130,33 +5127,34 @@ cyclades_get_proc_info(char *buf, char **start, off_t offset, int length,
 	len += size;
 
 	/* Output one line for each known port */
-	for (i = 0; i < NR_PORTS && cy_port[i].line >= 0; i++) {
-		info = &cy_port[i];
-
-		if (info->count)
-			size = sprintf(buf + len, "%3d %8lu %10lu %8lu %10lu "
-				"%8lu %9lu %6ld\n", info->line,
-				(cur_jifs - info->idle_stats.in_use) / HZ,
-				info->idle_stats.xmit_bytes,
-				(cur_jifs - info->idle_stats.xmit_idle) / HZ,
-				info->idle_stats.recv_bytes,
-				(cur_jifs - info->idle_stats.recv_idle) / HZ,
-				info->idle_stats.overruns,
-				(long)info->tty->ldisc.num);
-		else
-			size = sprintf(buf + len, "%3d %8lu %10lu %8lu %10lu "
-				"%8lu %9lu %6ld\n",
-				info->line, 0L, 0L, 0L, 0L, 0L, 0L, 0L);
-		len += size;
-		pos = begin + len;
-
-		if (pos < offset) {
-			len = 0;
-			begin = pos;
+	for (i = 0; i < NR_CARDS; i++)
+		for (j = 0; j < cy_card[i].nports; j++) {
+			info = &cy_card[i].ports[j];
+
+			if (info->count)
+				size = sprintf(buf + len, "%3d %8lu %10lu %8lu "
+					"%10lu %8lu %9lu %6ld\n", info->line,
+					(cur_jifs - info->idle_stats.in_use) /
+					HZ, info->idle_stats.xmit_bytes,
+					(cur_jifs - info->idle_stats.xmit_idle)/
+					HZ, info->idle_stats.recv_bytes,
+					(cur_jifs - info->idle_stats.recv_idle)/
+					HZ, info->idle_stats.overruns,
+					(long)info->tty->ldisc.num);
+			else
+				size = sprintf(buf + len, "%3d %8lu %10lu %8lu "
+					"%10lu %8lu %9lu %6ld\n",
+					info->line, 0L, 0L, 0L, 0L, 0L, 0L, 0L);
+			len += size;
+			pos = begin + len;
+
+			if (pos < offset) {
+				len = 0;
+				begin = pos;
+			}
+			if (pos > offset + length)
+				goto done;
 		}
-		if (pos > offset + length)
-			goto done;
-	}
 	*eof = 1;
 done:
 	*start = buf + (offset - begin);	/* Start of wanted data */
@@ -5211,7 +5209,7 @@ static const struct tty_operations cy_ops = {
 
 static int __init cy_init(void)
 {
-	unsigned int i, nboards;
+	unsigned int nboards;
 	int retval = -ENOMEM;
 
 	cy_serial_driver = alloc_tty_driver(NR_PORTS);
@@ -5242,11 +5240,6 @@ static int __init cy_init(void)
 		goto err_frtty;
 	}
 
-	for (i = 0; i < NR_PORTS; i++) {
-		cy_port[i].line = -1;
-		cy_port[i].magic = -1;
-	}
-
 	/* the code below is responsible to find the boards. Each different
 	   type of board has its own detection routine. If a board is found,
 	   the next cy_card structure available is set by the detection
@@ -5275,6 +5268,7 @@ err:
 
 static void __exit cy_cleanup_module(void)
 {
+	struct cyclades_card *card;
 	int i, e1;
 
 #ifndef CONFIG_CYZ_INTR
@@ -5290,22 +5284,24 @@ static void __exit cy_cleanup_module(void)
 #endif
 
 	for (i = 0; i < NR_CARDS; i++) {
-		if (cy_card[i].base_addr) {
+		card = &cy_card[i];
+		if (card->base_addr) {
 			/* clear interrupt */
-			cy_writeb(cy_card[i].base_addr + Cy_ClrIntr, 0);
-			iounmap(cy_card[i].base_addr);
-			if (cy_card[i].ctl_addr)
-				iounmap(cy_card[i].ctl_addr);
-			if (cy_card[i].irq
+			cy_writeb(card->base_addr + Cy_ClrIntr, 0);
+			iounmap(card->base_addr);
+			if (card->ctl_addr)
+				iounmap(card->ctl_addr);
+			if (card->irq
 #ifndef CONFIG_CYZ_INTR
-				&& !IS_CYC_Z(cy_card[i])
+				&& !IS_CYC_Z(*card)
 #endif /* CONFIG_CYZ_INTR */
 				)
-				free_irq(cy_card[i].irq, &cy_card[i]);
-			for (e1 = cy_card[i].first_line;
-					e1 < cy_card[i].first_line +
-					cy_card[i].nports; e1++)
+				free_irq(card->irq, card);
+			for (e1 = card->first_line;
+					e1 < card->first_line +
+					card->nports; e1++)
 				tty_unregister_device(cy_serial_driver, e1);
+			kfree(card->ports);
 		}
 	}
 
diff --git a/include/linux/cyclades.h b/include/linux/cyclades.h
index 07791f0..72aa00c 100644
--- a/include/linux/cyclades.h
+++ b/include/linux/cyclades.h
@@ -518,6 +518,7 @@ struct cyclades_card {
     int bus_index;	/* address shift - 0 for ISA, 1 for PCI */
     int	intr_enabled;	/* FW Interrupt flag - 0 disabled, 1 enabled */
     spinlock_t card_lock;
+    struct cyclades_port *ports;
 };
 
 /***************************************
