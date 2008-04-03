Return-Path: <linux-kernel-owner+w=401wt.eu-S1758128AbYDCNtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758128AbYDCNtw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 09:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbYDCNto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 09:49:44 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:9167 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbYDCNtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 09:49:43 -0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: devel@openvz.org
Subject: [PATCH 1/2] ide: remove /proc/ide/ali
Date: Thu, 3 Apr 2008 17:49:23 +0400
User-Agent: KMail/1.9.9
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
References: <200804022044.49434.adobriyan@sw.ru> <200804022120.28339.bzolnier@gmail.com>
In-Reply-To: <200804022120.28339.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804031749.24095.adobriyan@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008 23:20:28 Bartlomiej Zolnierkiewicz wrote:
> Could you please re-do patch #1/2 to remove /proc/ide/ali instead?
> 
> [ like we did for all other /proc/ide/<host_driver> files ]

Oh, even better!


[PATCH 1/2] ide: remove /proc/ide/ali

Bart says: "can be done from user-space and is not especially interesting
even when debugging problems (raw PCI config space dump is far more useful)."

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
---

 drivers/ide/pci/alim15x3.c |  240 ---------------------------------------------
 1 file changed, 240 deletions(-)

--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -38,8 +38,6 @@
 
 #include <asm/io.h>
 
-#define DISPLAY_ALI_TIMINGS
-
 /*
  *	ALi devices are not plug in. Otherwise these static values would
  *	need to go. They ought to go away anyway
@@ -49,236 +47,6 @@ static u8 m5229_revision;
 static u8 chip_is_1543c_e;
 static struct pci_dev *isa_dev;
 
-#if defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
-#include <linux/stat.h>
-#include <linux/proc_fs.h>
-
-static u8 ali_proc = 0;
-
-static struct pci_dev *bmide_dev;
-
-static char *fifo[4] = {
-	"FIFO Off",
-	"FIFO On ",
-	"DMA mode",
-	"PIO mode" };
-
-static char *udmaT[8] = {
-	"1.5T",
-	"  2T",
-	"2.5T",
-	"  3T",
-	"3.5T",
-	"  4T",
-	"  6T",
-	"  8T"
-};
-
-static char *channel_status[8] = {
-	"OK            ",
-	"busy          ",
-	"DRQ           ",
-	"DRQ busy      ",
-	"error         ",
-	"error busy    ",
-	"error DRQ     ",
-	"error DRQ busy"
-};
-
-/**
- *	ali_get_info		-	generate proc file for ALi IDE
- *	@buffer: buffer to fill
- *	@addr: address of user start in buffer
- *	@offset: offset into 'file'
- *	@count: buffer count
- *
- *	Walks the Ali devices and outputs summary data on the tuning and
- *	anything else that will help with debugging
- */
- 
-static int ali_get_info (char *buffer, char **addr, off_t offset, int count)
-{
-	unsigned long bibma;
-	u8 reg53h, reg5xh, reg5yh, reg5xh1, reg5yh1, c0, c1, rev, tmp;
-	char *q, *p = buffer;
-
-	/* fetch rev. */
-	pci_read_config_byte(bmide_dev, 0x08, &rev);
-	if (rev >= 0xc1)	/* M1543C or newer */
-		udmaT[7] = " ???";
-	else
-		fifo[3]  = "   ???  ";
-
-	/* first fetch bibma: */
-	
-	bibma = pci_resource_start(bmide_dev, 4);
-
-	/*
-	 * at that point bibma+0x2 et bibma+0xa are byte
-	 * registers to investigate:
-	 */
-	c0 = inb(bibma + 0x02);
-	c1 = inb(bibma + 0x0a);
-
-	p += sprintf(p,
-		"\n                                Ali M15x3 Chipset.\n");
-	p += sprintf(p,
-		"                                ------------------\n");
-	pci_read_config_byte(bmide_dev, 0x78, &reg53h);
-	p += sprintf(p, "PCI Clock: %d.\n", reg53h);
-
-	pci_read_config_byte(bmide_dev, 0x53, &reg53h);
-	p += sprintf(p,
-		"CD_ROM FIFO:%s, CD_ROM DMA:%s\n",
-		(reg53h & 0x02) ? "Yes" : "No ",
-		(reg53h & 0x01) ? "Yes" : "No " );
-	pci_read_config_byte(bmide_dev, 0x74, &reg53h);
-	p += sprintf(p,
-		"FIFO Status: contains %d Words, runs%s%s\n\n",
-		(reg53h & 0x3f),
-		(reg53h & 0x40) ? " OVERWR" : "",
-		(reg53h & 0x80) ? " OVERRD." : "." );
-
-	p += sprintf(p,
-		"-------------------primary channel"
-		"-------------------secondary channel"
-		"---------\n\n");
-
-	pci_read_config_byte(bmide_dev, 0x09, &reg53h);
-	p += sprintf(p,
-		"channel status:       %s"
-		"                               %s\n",
-		(reg53h & 0x20) ? "On " : "Off",
-		(reg53h & 0x10) ? "On " : "Off" );
-
-	p += sprintf(p,
-		"both channels togth:  %s"
-		"                               %s\n",
-		(c0&0x80) ? "No " : "Yes",
-		(c1&0x80) ? "No " : "Yes" );
-
-	pci_read_config_byte(bmide_dev, 0x76, &reg53h);
-	p += sprintf(p,
-		"Channel state:        %s                    %s\n",
-		channel_status[reg53h & 0x07],
-		channel_status[(reg53h & 0x70) >> 4] );
-
-	pci_read_config_byte(bmide_dev, 0x58, &reg5xh);
-	pci_read_config_byte(bmide_dev, 0x5c, &reg5yh);
-	p += sprintf(p,
-		"Add. Setup Timing:    %dT"
-		"                                %dT\n",
-		(reg5xh & 0x07) ? (reg5xh & 0x07) : 8,
-		(reg5yh & 0x07) ? (reg5yh & 0x07) : 8 );
-
-	pci_read_config_byte(bmide_dev, 0x59, &reg5xh);
-	pci_read_config_byte(bmide_dev, 0x5d, &reg5yh);
-	p += sprintf(p,
-		"Command Act. Count:   %dT"
-		"                                %dT\n"
-		"Command Rec. Count:   %dT"
-		"                               %dT\n\n",
-		(reg5xh & 0x70) ? ((reg5xh & 0x70) >> 4) : 8,
-		(reg5yh & 0x70) ? ((reg5yh & 0x70) >> 4) : 8, 
-		(reg5xh & 0x0f) ? (reg5xh & 0x0f) : 16,
-		(reg5yh & 0x0f) ? (reg5yh & 0x0f) : 16 );
-
-	p += sprintf(p,
-		"----------------drive0-----------drive1"
-		"------------drive0-----------drive1------\n\n");
-	p += sprintf(p,
-		"DMA enabled:      %s              %s"
-		"               %s              %s\n",
-		(c0&0x20) ? "Yes" : "No ",
-		(c0&0x40) ? "Yes" : "No ",
-		(c1&0x20) ? "Yes" : "No ",
-		(c1&0x40) ? "Yes" : "No " );
-
-	pci_read_config_byte(bmide_dev, 0x54, &reg5xh);
-	pci_read_config_byte(bmide_dev, 0x55, &reg5yh);
-	q = "FIFO threshold:   %2d Words         %2d Words"
-		"          %2d Words         %2d Words\n";
-	if (rev < 0xc1) {
-		if ((rev == 0x20) &&
-		    (pci_read_config_byte(bmide_dev, 0x4f, &tmp), (tmp &= 0x20))) {
-			p += sprintf(p, q, 8, 8, 8, 8);
-		} else {
-			p += sprintf(p, q,
-				(reg5xh & 0x03) + 12,
-				((reg5xh & 0x30)>>4) + 12,
-				(reg5yh & 0x03) + 12,
-				((reg5yh & 0x30)>>4) + 12 );
-		}
-	} else {
-		int t1 = (tmp = (reg5xh & 0x03)) ? (tmp << 3) : 4;
-		int t2 = (tmp = ((reg5xh & 0x30)>>4)) ? (tmp << 3) : 4;
-		int t3 = (tmp = (reg5yh & 0x03)) ? (tmp << 3) : 4;
-		int t4 = (tmp = ((reg5yh & 0x30)>>4)) ? (tmp << 3) : 4;
-		p += sprintf(p, q, t1, t2, t3, t4);
-	}
-
-#if 0
-	p += sprintf(p, 
-		"FIFO threshold:   %2d Words         %2d Words"
-		"          %2d Words         %2d Words\n",
-		(reg5xh & 0x03) + 12,
-		((reg5xh & 0x30)>>4) + 12,
-		(reg5yh & 0x03) + 12,
-		((reg5yh & 0x30)>>4) + 12 );
-#endif
-
-	p += sprintf(p,
-		"FIFO mode:        %s         %s          %s         %s\n",
-		fifo[((reg5xh & 0x0c) >> 2)],
-		fifo[((reg5xh & 0xc0) >> 6)],
-		fifo[((reg5yh & 0x0c) >> 2)],
-		fifo[((reg5yh & 0xc0) >> 6)] );
-
-	pci_read_config_byte(bmide_dev, 0x5a, &reg5xh);
-	pci_read_config_byte(bmide_dev, 0x5b, &reg5xh1);
-	pci_read_config_byte(bmide_dev, 0x5e, &reg5yh);
-	pci_read_config_byte(bmide_dev, 0x5f, &reg5yh1);
-
-	p += sprintf(p,/*
-		"------------------drive0-----------drive1"
-		"------------drive0-----------drive1------\n")*/
-		"Dt RW act. Cnt    %2dT              %2dT"
-		"               %2dT              %2dT\n"
-		"Dt RW rec. Cnt    %2dT              %2dT"
-		"               %2dT              %2dT\n\n",
-		(reg5xh & 0x70) ? ((reg5xh & 0x70) >> 4) : 8,
-		(reg5xh1 & 0x70) ? ((reg5xh1 & 0x70) >> 4) : 8,
-		(reg5yh & 0x70) ? ((reg5yh & 0x70) >> 4) : 8,
-		(reg5yh1 & 0x70) ? ((reg5yh1 & 0x70) >> 4) : 8,
-		(reg5xh & 0x0f) ? (reg5xh & 0x0f) : 16,
-		(reg5xh1 & 0x0f) ? (reg5xh1 & 0x0f) : 16,
-		(reg5yh & 0x0f) ? (reg5yh & 0x0f) : 16,
-		(reg5yh1 & 0x0f) ? (reg5yh1 & 0x0f) : 16 );
-
-	p += sprintf(p,
-		"-----------------------------------UDMA Timings"
-		"--------------------------------\n\n");
-
-	pci_read_config_byte(bmide_dev, 0x56, &reg5xh);
-	pci_read_config_byte(bmide_dev, 0x57, &reg5yh);
-	p += sprintf(p,
-		"UDMA:             %s               %s"
-		"                %s               %s\n"
-		"UDMA timings:     %s             %s"
-		"              %s             %s\n\n",
-		(reg5xh & 0x08) ? "OK" : "No",
-		(reg5xh & 0x80) ? "OK" : "No",
-		(reg5yh & 0x08) ? "OK" : "No",
-		(reg5yh & 0x80) ? "OK" : "No",
-		udmaT[(reg5xh & 0x07)],
-		udmaT[(reg5xh & 0x70) >> 4],
-		udmaT[reg5yh & 0x07],
-		udmaT[(reg5yh & 0x70) >> 4] );
-
-	return p-buffer; /* => must be less than 4k! */
-}
-#endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
-
 /**
  *	ali_set_pio_mode	-	set host controller for PIO mode
  *	@drive: drive
@@ -465,14 +233,6 @@ static unsigned int __devinit init_chipset_ali15x3 (struct pci_dev *dev, const c
 
 	isa_dev = pci_get_device(PCI_VENDOR_ID_AL, PCI_DEVICE_ID_AL_M1533, NULL);
 
-#if defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS)
-	if (!ali_proc) {
-		ali_proc = 1;
-		bmide_dev = dev;
-		ide_pci_create_host_proc("ali", ali_get_info);
-	}
-#endif  /* defined(DISPLAY_ALI_TIMINGS) && defined(CONFIG_IDE_PROC_FS) */
-
 	local_irq_save(flags);
 
 	if (m5229_revision < 0xC2) {
