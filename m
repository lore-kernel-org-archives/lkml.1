Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYAMUWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYAMUWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 15:22:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753403AbYAMUWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 15:22:07 -0500
Received: from smtp109.plus.mail.re1.yahoo.com ([69.147.102.72]:45586 "HELO
	smtp109.plus.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753380AbYAMUWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 15:22:04 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References;
  b=jkkB7vJNA5lfdZ693NWRzSylzaJb05YQANK3I28vsIMioBvzTwl+EZ5Y5z+P1Ul5e5MXMR1lawoPuPyZ8X57SuDPlkM86MdobDisPvs06T2WgbDQy15PooCk/mMwuq4h+EzYeeWDyaK4Yi1ZeFix2C9WEfmmrk462kwx583UyvQ=  ;
X-YMail-OSG: pgTPA5YVM1liYB8h8FXaHkPsqmlKO9VvMgAkXMAIhAGzMDrh_8BcdZ4yGC44Ad_SbOQtaEex.A--
X-Yahoo-Newman-Property: ymail-3
From: Borislav Petkov <bbpetkov@yahoo.de>
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
Subject: [PATCH 1/12] ide-floppy: remove struct idefloppy_mode_parameter_header
Date: Sun, 13 Jan 2008 21:18:14 +0100
Message-Id: <1200255505-31418-2-git-send-email-bbpetkov@yahoo.de>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
---
 drivers/ide/ide-floppy.c |   26 +++-----------------------
 1 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 2b9885f..7648684 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -365,24 +365,6 @@ typedef struct {
 #define	IDEFLOPPY_CAPABILITIES_PAGE	0x1b
 #define IDEFLOPPY_FLEXIBLE_DISK_PAGE	0x05
 
-/*
- *	Mode Parameter Header for the MODE SENSE packet command
- */
-typedef struct {
-	u16		mode_data_length;	/* Length of the following data transfer */
-	u8		medium_type;		/* Medium Type */
-#if defined(__LITTLE_ENDIAN_BITFIELD)
-	unsigned	reserved3	:7;
-	unsigned	wp		:1;	/* Write protect */
-#elif defined(__BIG_ENDIAN_BITFIELD)
-	unsigned	wp		:1;	/* Write protect */
-	unsigned	reserved3	:7;
-#else
-#error "Bitfield endianness not defined! Check your byteorder.h"
-#endif
-	u8		reserved[4];
-} idefloppy_mode_parameter_header_t;
-
 static DEFINE_MUTEX(idefloppy_ref_mutex);
 
 #define to_ide_floppy(obj) container_of(obj, struct ide_floppy_obj, kref)
@@ -1029,7 +1011,7 @@ static void idefloppy_create_format_unit_cmd (idefloppy_pc_t *pc, int b, int l,
  */
 static void idefloppy_create_mode_sense_cmd (idefloppy_pc_t *pc, u8 page_code, u8 type)
 {
-	u16 length = sizeof(idefloppy_mode_parameter_header_t);
+	u16 length = 8; /* sizeof(Mode Parameter Header) = 8 Bytes */
 	
 	idefloppy_init_pc(pc);
 	pc->c[0] = GPCMD_MODE_SENSE_10;
@@ -1195,7 +1177,6 @@ static int idefloppy_get_flexible_disk_page (ide_drive_t *drive)
 {
 	idefloppy_floppy_t *floppy = drive->driver_data;
 	idefloppy_pc_t pc;
-	idefloppy_mode_parameter_header_t *header;
 	idefloppy_flexible_disk_page_t *page;
 	int capacity, lba_capacity;
 
@@ -1205,10 +1186,9 @@ static int idefloppy_get_flexible_disk_page (ide_drive_t *drive)
 			"page parameters\n");
 		return 1;
 	}
-	header = (idefloppy_mode_parameter_header_t *) pc.buffer;
-	floppy->wp = header->wp;
+	floppy->wp = !!(pc.buffer[3] & 0x80);
 	set_disk_ro(floppy->disk, floppy->wp);
-	page = (idefloppy_flexible_disk_page_t *) (header + 1);
+	page = (idefloppy_flexible_disk_page_t *) &pc.buffer[8];
 
 	page->transfer_rate = be16_to_cpu(page->transfer_rate);
 	page->sector_size = be16_to_cpu(page->sector_size);
-- 
1.5.3.7

