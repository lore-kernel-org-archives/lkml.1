Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbYDBQps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbYDBQps (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 12:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbYDBQpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 12:45:41 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:32838 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995AbYDBQpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 12:45:40 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: bzolnier@gmail.com, akpm@osdl.org
Subject: [PATCH 1/2] ide: switch /proc/ide/ali to seq_file interface
Date: Wed, 2 Apr 2008 20:44:49 +0400
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804022044.49434.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/2] ide: switch /proc/ide/ali to seq_file interface

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
---

 drivers/ide/pci/alim15x3.c |   66 
++++++++++++++++++++++++++-------------------
 1 file changed, 39 insertions(+), 27 deletions(-)

--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -52,6 +52,7 @@ static struct pci_dev *isa_dev;
 #if defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
 #include <linux/stat.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 static u8 ali_proc = 0;
 
@@ -96,11 +97,11 @@ static char *channel_status[8] = {
  *	anything else that will help with debugging
  */
  
-static int ali_get_info (char *buffer, char **addr, off_t offset, int count)
+static int proc_ide_ali_show(struct seq_file *m, void *v)
 {
 	unsigned long bibma;
 	u8 reg53h, reg5xh, reg5yh, reg5xh1, reg5yh1, c0, c1, rev, tmp;
-	char *q, *p = buffer;
+	char *q;
 
 	/* fetch rev. */
 	pci_read_config_byte(bmide_dev, 0x08, &rev);
@@ -120,52 +121,50 @@ static int ali_get_info (char *buffer, char **addr, 
off_t offset, int count)
 	c0 = inb(bibma + 0x02);
 	c1 = inb(bibma + 0x0a);
 
-	p += sprintf(p,
-		"\n                                Ali M15x3 Chipset.\n");
-	p += sprintf(p,
-		"                                ------------------\n");
+	seq_puts(m, "\n                                Ali M15x3 Chipset.\n");
+	seq_puts(m, "                                ------------------\n");
 	pci_read_config_byte(bmide_dev, 0x78, &reg53h);
-	p += sprintf(p, "PCI Clock: %d.\n", reg53h);
+	seq_printf(m, "PCI Clock: %d.\n", reg53h);
 
 	pci_read_config_byte(bmide_dev, 0x53, &reg53h);
-	p += sprintf(p,
+	seq_printf(m,
 		"CD_ROM FIFO:%s, CD_ROM DMA:%s\n",
 		(reg53h & 0x02) ? "Yes" : "No ",
 		(reg53h & 0x01) ? "Yes" : "No " );
 	pci_read_config_byte(bmide_dev, 0x74, &reg53h);
-	p += sprintf(p,
+	seq_printf(m,
 		"FIFO Status: contains %d Words, runs%s%s\n\n",
 		(reg53h & 0x3f),
 		(reg53h & 0x40) ? " OVERWR" : "",
 		(reg53h & 0x80) ? " OVERRD." : "." );
 
-	p += sprintf(p,
+	seq_puts(m,
 		"-------------------primary channel"
 		"-------------------secondary channel"
 		"---------\n\n");
 
 	pci_read_config_byte(bmide_dev, 0x09, &reg53h);
-	p += sprintf(p,
+	seq_printf(m,
 		"channel status:       %s"
 		"                               %s\n",
 		(reg53h & 0x20) ? "On " : "Off",
 		(reg53h & 0x10) ? "On " : "Off" );
 
-	p += sprintf(p,
+	seq_printf(m,
 		"both channels togth:  %s"
 		"                               %s\n",
 		(c0&0x80) ? "No " : "Yes",
 		(c1&0x80) ? "No " : "Yes" );
 
 	pci_read_config_byte(bmide_dev, 0x76, &reg53h);
-	p += sprintf(p,
+	seq_printf(m,
 		"Channel state:        %s                    %s\n",
 		channel_status[reg53h & 0x07],
 		channel_status[(reg53h & 0x70) >> 4] );
 
 	pci_read_config_byte(bmide_dev, 0x58, &reg5xh);
 	pci_read_config_byte(bmide_dev, 0x5c, &reg5yh);
-	p += sprintf(p,
+	seq_printf(m,
 		"Add. Setup Timing:    %dT"
 		"                                %dT\n",
 		(reg5xh & 0x07) ? (reg5xh & 0x07) : 8,
@@ -173,7 +172,7 @@ static int ali_get_info (char *buffer, char **addr, off_t 
offset, int count)
 
 	pci_read_config_byte(bmide_dev, 0x59, &reg5xh);
 	pci_read_config_byte(bmide_dev, 0x5d, &reg5yh);
-	p += sprintf(p,
+	seq_printf(m,
 		"Command Act. Count:   %dT"
 		"                                %dT\n"
 		"Command Rec. Count:   %dT"
@@ -183,10 +182,10 @@ static int ali_get_info (char *buffer, char **addr, 
off_t offset, int count)
 		(reg5xh & 0x0f) ? (reg5xh & 0x0f) : 16,
 		(reg5yh & 0x0f) ? (reg5yh & 0x0f) : 16 );
 
-	p += sprintf(p,
+	seq_puts(m,
 		"----------------drive0-----------drive1"
 		"------------drive0-----------drive1------\n\n");
-	p += sprintf(p,
+	seq_printf(m,
 		"DMA enabled:      %s              %s"
 		"               %s              %s\n",
 		(c0&0x20) ? "Yes" : "No ",
@@ -201,9 +200,9 @@ static int ali_get_info (char *buffer, char **addr, off_t 
offset, int count)
 	if (rev < 0xc1) {
 		if ((rev == 0x20) &&
 		    (pci_read_config_byte(bmide_dev, 0x4f, &tmp), (tmp &= 0x20))) {
-			p += sprintf(p, q, 8, 8, 8, 8);
+			seq_printf(m, q, 8, 8, 8, 8);
 		} else {
-			p += sprintf(p, q,
+			seq_printf(m, q,
 				(reg5xh & 0x03) + 12,
 				((reg5xh & 0x30)>>4) + 12,
 				(reg5yh & 0x03) + 12,
@@ -214,11 +213,11 @@ static int ali_get_info (char *buffer, char **addr, 
off_t offset, int count)
 		int t2 = (tmp = ((reg5xh & 0x30)>>4)) ? (tmp << 3) : 4;
 		int t3 = (tmp = (reg5yh & 0x03)) ? (tmp << 3) : 4;
 		int t4 = (tmp = ((reg5yh & 0x30)>>4)) ? (tmp << 3) : 4;
-		p += sprintf(p, q, t1, t2, t3, t4);
+		seq_printf(m, q, t1, t2, t3, t4);
 	}
 
 #if 0
-	p += sprintf(p, 
+	seq_printf(m, 
 		"FIFO threshold:   %2d Words         %2d Words"
 		"          %2d Words         %2d Words\n",
 		(reg5xh & 0x03) + 12,
@@ -227,7 +226,7 @@ static int ali_get_info (char *buffer, char **addr, off_t 
offset, int count)
 		((reg5yh & 0x30)>>4) + 12 );
 #endif
 
-	p += sprintf(p,
+	seq_printf(m,
 		"FIFO mode:        %s         %s          %s         %s\n",
 		fifo[((reg5xh & 0x0c) >> 2)],
 		fifo[((reg5xh & 0xc0) >> 6)],
@@ -239,7 +238,7 @@ static int ali_get_info (char *buffer, char **addr, off_t 
offset, int count)
 	pci_read_config_byte(bmide_dev, 0x5e, &reg5yh);
 	pci_read_config_byte(bmide_dev, 0x5f, &reg5yh1);
 
-	p += sprintf(p,/*
+	seq_printf(m,/*
 		"------------------drive0-----------drive1"
 		"------------drive0-----------drive1------\n")*/
 		"Dt RW act. Cnt    %2dT              %2dT"
@@ -255,13 +254,13 @@ static int ali_get_info (char *buffer, char **addr, 
off_t offset, int count)
 		(reg5yh & 0x0f) ? (reg5yh & 0x0f) : 16,
 		(reg5yh1 & 0x0f) ? (reg5yh1 & 0x0f) : 16 );
 
-	p += sprintf(p,
+	seq_puts(m,
 		"-----------------------------------UDMA Timings"
 		"--------------------------------\n\n");
 
 	pci_read_config_byte(bmide_dev, 0x56, &reg5xh);
 	pci_read_config_byte(bmide_dev, 0x57, &reg5yh);
-	p += sprintf(p,
+	seq_printf(m,
 		"UDMA:             %s               %s"
 		"                %s               %s\n"
 		"UDMA timings:     %s             %s"
@@ -275,8 +274,21 @@ static int ali_get_info (char *buffer, char **addr, off_t 
offset, int count)
 		udmaT[reg5yh & 0x07],
 		udmaT[(reg5yh & 0x70) >> 4] );
 
-	return p-buffer; /* => must be less than 4k! */
+	return 0;
+}
+
+static int proc_ide_ali_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, proc_ide_ali_show, NULL);
 }
+
+static const struct file_operations ide_ali_proc_fops = {
+	.owner		= THIS_MODULE,
+	.open		= proc_ide_ali_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
 #endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
 
 /**
@@ -469,7 +481,7 @@ static unsigned int __devinit init_chipset_ali15x3 (struct 
pci_dev *dev, const c
 	if (!ali_proc) {
 		ali_proc = 1;
 		bmide_dev = dev;
-		ide_pci_create_host_proc("ali", ali_get_info);
+		proc_create("ide/ali", 0, NULL, &ide_ali_proc_fops);
 	}
 #endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
 
