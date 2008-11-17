Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbYKQHdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbYKQHdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbYKQHVi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:21:38 -0500
Received: from kroah.org ([198.145.64.141]:38593 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755384AbYKQHV0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:21:26 -0500
Date: Sun, 16 Nov 2008 23:16:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       Lalit Chandivade <lalit.chandivade@qlogic.com>,
       Andrew Vasquez <andrew.vasquez@qlogic.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 31/46] SCSI: qla2xxx: Correct Atmel flash-part handling.
Message-ID: <20081117071612.GF29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi-qla2xxx-correct-atmel-flash-part-handling.patch"
In-Reply-To: <20081117071333.GA29522@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lalit Chandivade <lalit.chandivade@qlogic.com>

commit 821b3996001508e872582dcafc7575021f122728 upstream.

Use correct block size (4K) for erase command 0x20 for Atmel
Flash. Use dword addresses for determining sector boundary.

Signed-off-by: Lalit Chandivade <lalit.chandivade@qlogic.com>
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/qla2xxx/qla_def.h |    1 -
 drivers/scsi/qla2xxx/qla_sup.c |   19 +++++++------------
 2 files changed, 7 insertions(+), 13 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2546,7 +2546,6 @@ typedef struct scsi_qla_host {
 	uint8_t		fcode_revision[16];
 	uint32_t	fw_revision[4];
 
-	uint16_t	fdt_odd_index;
 	uint32_t	fdt_wrt_disable;
 	uint32_t	fdt_erase_cmd;
 	uint32_t	fdt_block_size;
--- a/drivers/scsi/qla2xxx/qla_sup.c
+++ b/drivers/scsi/qla2xxx/qla_sup.c
@@ -546,6 +546,7 @@ qla24xx_get_flash_manufacturer(scsi_qla_
 void
 qla2xxx_get_flash_info(scsi_qla_host_t *ha)
 {
+#define FLASH_BLK_SIZE_4K	0x1000
 #define FLASH_BLK_SIZE_32K	0x8000
 #define FLASH_BLK_SIZE_64K	0x10000
 	uint16_t cnt, chksum;
@@ -577,7 +578,6 @@ qla2xxx_get_flash_info(scsi_qla_host_t *
 		goto no_flash_data;
 	}
 
-	ha->fdt_odd_index = le16_to_cpu(fdt->man_id) == 0x1f;
 	ha->fdt_wrt_disable = fdt->wrt_disable_bits;
 	ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0300 | fdt->erase_cmd);
 	ha->fdt_block_size = le32_to_cpu(fdt->block_size);
@@ -590,10 +590,10 @@ qla2xxx_get_flash_info(scsi_qla_host_t *
 	}
 
 	DEBUG2(qla_printk(KERN_DEBUG, ha, "Flash[FDT]: (0x%x/0x%x) erase=0x%x "
-	    "pro=%x upro=%x idx=%d wrtd=0x%x blk=0x%x.\n",
+	    "pro=%x upro=%x wrtd=0x%x blk=0x%x.\n",
 	    le16_to_cpu(fdt->man_id), le16_to_cpu(fdt->id), ha->fdt_erase_cmd,
 	    ha->fdt_protect_sec_cmd, ha->fdt_unprotect_sec_cmd,
-	    ha->fdt_odd_index, ha->fdt_wrt_disable, ha->fdt_block_size));
+	    ha->fdt_wrt_disable, ha->fdt_block_size));
 	return;
 
 no_flash_data:
@@ -614,8 +614,7 @@ no_flash_data:
 		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
 		break;
 	case 0x1f: /* Atmel 26DF081A. */
-		ha->fdt_odd_index = 1;
-		ha->fdt_block_size = FLASH_BLK_SIZE_64K;
+		ha->fdt_block_size = FLASH_BLK_SIZE_4K;
 		ha->fdt_erase_cmd = flash_conf_to_access_addr(0x0320);
 		ha->fdt_unprotect_sec_cmd = flash_conf_to_access_addr(0x0339);
 		ha->fdt_protect_sec_cmd = flash_conf_to_access_addr(0x0336);
@@ -710,13 +709,9 @@ qla24xx_write_flash_data(scsi_qla_host_t
 	qla24xx_unprotect_flash(ha);
 
 	for (liter = 0; liter < dwords; liter++, faddr++, dwptr++) {
-		if (ha->fdt_odd_index) {
-			findex = faddr << 2;
-			fdata = findex & sec_mask;
-		} else {
-			findex = faddr;
-			fdata = (findex & sec_mask) << 2;
-		}
+
+		findex = faddr;
+		fdata = (findex & sec_mask) << 2;
 
 		/* Are we at the beginning of a sector? */
 		if ((findex & rest_addr) == 0) {

-- 
