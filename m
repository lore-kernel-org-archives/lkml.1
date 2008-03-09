Return-Path: <linux-kernel-owner+w=401wt.eu-S1755363AbYCIVna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbYCIVna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 17:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751886AbYCIVnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 17:43:17 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:52224 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753526AbYCIVmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 17:42:53 -0400
Message-ID: <47D459DA.20207@free.fr>
Date: Sun, 09 Mar 2008 22:42:50 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080129 Iceape/1.1.8 (Debian-1.1.8-2)
MIME-Version: 1.0
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  mass storage : emulation of sat scsi_pass_thru with
 ATACB
References: <47D2CD95.9070701@free.fr> <20080308183125.GB2820@one-eyed-alien.net> <47D2F23A.4020103@free.fr> <20080308212148.GC2820@one-eyed-alien.net> <47D39E14.9050900@free.fr> <20080309184524.GF2820@one-eyed-alien.net>
In-Reply-To: <20080309184524.GF2820@one-eyed-alien.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

here an update version of the patch


I have got a cypress usb-ide bridge and I would like to tune or monitor
my disk with tools like hdparm, hddtemp or smartctl.

My controller support a way to send raw ATA command to the disk with
something call atacb (see
http://download.cypress.com.edgesuite.net/design_resources/datasheets/contents/cy7c68300c_8.pdf).

Atacb support can be added for each application, but there is some 
disadvantages :
- all application need to be patched
- A race is possible if there other accesses, because the emulation can
be split in 2 atacb scsi transactions. One for sending the command, one
for reading the register (if ck_cond is set).

I have implemented the emulation in usb-storage with a special 
proto_handler, and an unsual entry.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>

Index: linux-2.6.24.2/drivers/usb/storage/unusual_devs.h
===================================================================
--- linux-2.6.24.2.orig/drivers/usb/storage/unusual_devs.h	2008-02-29 
22:14:09.000000000 +0100
+++ linux-2.6.24.2/drivers/usb/storage/unusual_devs.h	2008-03-09 
22:10:59.000000000 +0100
@@ -1588,6 +1588,14 @@
  		US_SC_DEVICE, US_PR_DEVICE, NULL,
  		US_FL_CAPACITY_HEURISTICS),

+#ifdef CONFIG_USB_STORAGE_CYPRESS_ATACB
+UNUSUAL_DEV(  0x04b4, 0x6830, 0x0000, 0x9999,
+		"Cypress",
+		"Cypress AT2LP",
+		US_SC_CYP_ATACB, US_PR_BULK, NULL,
+		0),
+#endif
+
  /* Control/Bulk transport for all SubClass values */
  USUAL_DEV(US_SC_RBC, US_PR_CB, USB_US_TYPE_STOR),
  USUAL_DEV(US_SC_8020, US_PR_CB, USB_US_TYPE_STOR),
Index: linux-2.6.24.2/drivers/usb/storage/cypress_atacb.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.24.2/drivers/usb/storage/cypress_atacb.c	2008-03-09 
22:04:18.000000000 +0100
@@ -0,0 +1,199 @@
+/*
+ * Support for emulating SAT (ata pass through) on devices based
+ *       on the Cypress USB/ATA bridge supporting ATACB.
+ *
+ * Copyright (c) 2008 Matthieu Castet (castet.matthieu@free.fr)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
+#include <linux/ata.h>
+
+#include "usb.h"
+#include "protocol.h"
+#include "scsiglue.h"
+
+/*
+ * ATACB is a protocol used on cypress usb<->ata bridge to
+ * send raw ATA command over mass storage
+ * There is a ATACB2 protocol that support LBA48 on newer chip.
+ * More info that be found on cy7c68310_8.pdf and cy7c68300c_8.pdf
+ * datasheet from cypress.com.
+ */
+void cypress_atacb_passthrough(struct scsi_cmnd *srb, struct us_data *us)
+{
+	unsigned char save_cmnd[MAX_COMMAND_SIZE];
+
+	if (likely(srb->cmnd[0] != ATA_16 && srb->cmnd[0] != ATA_12)) {
+		usb_stor_transparent_scsi_command(srb, us);
+		return;
+	}
+
+	memcpy(save_cmnd, srb->cmnd, sizeof(save_cmnd));
+	memset(srb->cmnd, 0, sizeof(srb->cmnd));
+
+	/* check if we support the command */
+	if (save_cmnd[1] >> 5) /* MULTIPLE_COUNT */
+		goto invalid_fld;
+	/* check protocol */
+	switch((save_cmnd[1] >> 1) & 0xf) {
+		case 3:
+		case 4:
+		case 5:
+			break;
+		default:
+			goto invalid_fld;
+	}
+
+	/* first build the ATACB command */
+	srb->cmd_len = 16;
+
+ 	/* this value can change, but most(all ?) manufacturers keep the cypress
+	 * default : 0x24
+	 */
+	srb->cmnd[0] = 0x24;
+	srb->cmnd[1] = 0x24;
+	srb->cmnd[2] = 0;
+
+	srb->cmnd[3] = 0xff - 1;
+	srb->cmnd[4] = 1;
+
+	if (save_cmnd[0] == ATA_16) {
+		srb->cmnd[6] = save_cmnd[4]; /* features */
+		srb->cmnd[7] = save_cmnd[6]; /* sector count */
+		srb->cmnd[8] = save_cmnd[8]; /* lba low */
+		srb->cmnd[9] = save_cmnd[10]; /* lba med */
+		srb->cmnd[10] = save_cmnd[12]; /* lba high */
+		srb->cmnd[11] = save_cmnd[13]; /* device */
+		srb->cmnd[12] = save_cmnd[14]; /* command */
+
+		if (save_cmnd[1] & 0x01) {/* extended bit set for LBA48 */
+			/* this could be supported by atacb2 */
+			if (save_cmnd[3] || save_cmnd[5] || save_cmnd[7] || save_cmnd[9]
+					|| save_cmnd[11])
+				goto invalid_fld;
+		}
+	}
+	else { /* ATA12 */
+		srb->cmnd[6] = save_cmnd[3]; /* features */
+		srb->cmnd[7] = save_cmnd[4]; /* sector count */
+		srb->cmnd[8] = save_cmnd[5]; /* lba low */
+		srb->cmnd[9] = save_cmnd[6]; /* lba med */
+		srb->cmnd[10] = save_cmnd[7]; /* lba high */
+		srb->cmnd[11] = save_cmnd[8]; /* device */
+		srb->cmnd[12] = save_cmnd[9]; /* command */
+
+	}
+	/* Filter SET_FEATURES - XFER MODE command */
+	if ((srb->cmnd[12] == ATA_CMD_SET_FEATURES)
+			&& (srb->cmnd[6] == SETFEATURES_XFER))
+		goto invalid_fld;
+
+	if (srb->cmnd[12] == ATA_CMD_ID_ATA || srb->cmnd[12] == ATA_CMD_ID_ATAPI)
+		srb->cmnd[2] |= (1<<7);
+
+
+	usb_stor_transparent_scsi_command(srb, us);
+
+	/* if the device doesn't support ATACB
+	 * abort and register usb_stor_transparent_scsi_command
+	 * callback
+	 */
+	if (srb->result == SAM_STAT_CHECK_CONDITION &&
+			memcmp(srb->sense_buffer, usb_stor_sense_invalidCDB,
+				sizeof(usb_stor_sense_invalidCDB)) == 0) {
+		us->subclass = US_SC_SCSI;
+		us->proto_handler = usb_stor_transparent_scsi_command;
+		goto end;
+	}
+
+	/* if ck_cond flags is set, and there wasn't critical error,
+	 * build the special sense
+	 */
+	if ((srb->result != (DID_ERROR << 16) &&
+				srb->result != (DID_ABORT << 16)) &&
+			save_cmnd[2] & 0x20) {
+		struct scsi_eh_save ses;
+		unsigned char sk, asc, ascq;
+		unsigned char regs[8];
+		unsigned char *sb = srb->sense_buffer;
+		unsigned char *desc = sb + 8;
+		int tmp_result;
+
+		sk = RECOVERED_ERROR;
+		asc = 0; /* ATA PASS THROUGH INFORMATION AVAILABLE */
+		ascq = 0x1D;
+
+		/* read registers */
+		srb->cmnd[2] = 1;
+		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, 0);
+		srb->request_buffer = regs;
+		srb->request_bufflen = sizeof(regs);
+		srb->sc_data_direction = DMA_FROM_DEVICE;
+
+		usb_stor_transparent_scsi_command(srb, us);
+		tmp_result = srb->result;
+		scsi_eh_restore_cmnd(srb, &ses);
+		/* we fail to get registers, report invalid command */
+		if (tmp_result != SAM_STAT_GOOD)
+			goto invalid_fld;
+
+		/* build the sense */
+		memset(sb, 0, SCSI_SENSE_BUFFERSIZE);
+
+		/* XXX we should generate sk, asc, ascq from status and error
+		 * regs
+		 * (see 11.1 Error translation ­ ATA device error to SCSI error map)
+		 * and ata_to_sense_error from libata.
+		 */
+		sb[1] = sk;
+		sb[2] = asc;
+		sb[3] = ascq;
+
+		/* Sense data is current and format is descriptor. */
+		sb[0] = 0x72;
+		desc[0] = 0x09; /* ATA_RETURN_DESCRIPTOR */
+
+		/* set length of additional sense data */
+		sb[7] = 14;
+		desc[1] = 12;
+
+		/* Copy registers into sense buffer. */
+		desc[2] = 0x00;
+		desc[3] = regs[1];
+		desc[5] = regs[2];
+		desc[7] = regs[3];
+		desc[9] = regs[4];
+		desc[11] = regs[5];
+		desc[12] = regs[6];
+		desc[13] = regs[7];
+
+		srb->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+	}
+	goto end;
+invalid_fld:
+	srb->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
+
+	memcpy(srb->sense_buffer,
+			usb_stor_sense_invalidCDB,
+			sizeof(usb_stor_sense_invalidCDB));
+end:
+	memcpy(srb->cmnd, save_cmnd, sizeof(save_cmnd));
+	if (srb->cmnd[0] == ATA_12)
+		srb->cmd_len = 12;
+}
Index: linux-2.6.24.2/drivers/usb/storage/cypress_atacb.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.24.2/drivers/usb/storage/cypress_atacb.h	2008-03-09 
22:03:51.000000000 +0100
@@ -0,0 +1,25 @@
+/*
+ * Support for emulating SAT (ata pass through) on devices based
+ *       on the Cypress USB/ATA bridge supporting ATACB.
+ *
+ * Copyright (c) 2008 Matthieu Castet (castet.matthieu@free.fr)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _CYPRESS_ATACB_H_
+#define _CYPRESS_ATACB_H_
+extern void cypress_atacb_passthrough(struct scsi_cmnd*, struct us_data*);
+#endif
Index: linux-2.6.24.2/drivers/usb/storage/Kconfig
===================================================================
--- linux-2.6.24.2.orig/drivers/usb/storage/Kconfig	2008-03-09 
21:42:32.000000000 +0100
+++ linux-2.6.24.2/drivers/usb/storage/Kconfig	2008-03-09 
21:52:16.000000000 +0100
@@ -145,6 +145,17 @@
  	  on the resulting scsi device node returns the Karma to normal
  	  operation.

+config USB_STORAGE_CYPRESS_ATACB
+	bool "SAT emulation on Cypress USB/ATA Bridge with ATACB"
+	depends on USB_STORAGE
+	---help---
+	  Say Y here if you want to use SAT (ata pass through) on devices based
+	  on the Cypress USB/ATA bridge supporting ATACB. This will allow you
+	  to use tools to tune and monitor your drive (like hdparm or smartctl).
+
+	  If you say no here your device will still work with the standard usb
+	  mass storage class.
+
  config USB_LIBUSUAL
  	bool "The shared table of common (or usual) storage devices"
  	depends on USB
Index: linux-2.6.24.2/drivers/usb/storage/Makefile
===================================================================
--- linux-2.6.24.2.orig/drivers/usb/storage/Makefile	2008-03-09 
21:39:45.000000000 +0100
+++ linux-2.6.24.2/drivers/usb/storage/Makefile	2008-03-09 
21:55:26.000000000 +0100
@@ -21,6 +21,7 @@
  usb-storage-obj-$(CONFIG_USB_STORAGE_ALAUDA)	+= alauda.o
  usb-storage-obj-$(CONFIG_USB_STORAGE_ONETOUCH)	+= onetouch.o
  usb-storage-obj-$(CONFIG_USB_STORAGE_KARMA)	+= karma.o
+usb-storage-obj-$(CONFIG_USB_STORAGE_CYPRESS_ATACB) += cypress_atacb.o

  usb-storage-objs :=	scsiglue.o protocol.o transport.o usb.o \
  			initializers.o $(usb-storage-obj-y)
Index: linux-2.6.24.2/drivers/usb/storage/scsiglue.c
===================================================================
--- linux-2.6.24.2.orig/drivers/usb/storage/scsiglue.c	2008-03-09 
21:33:25.000000000 +0100
+++ linux-2.6.24.2/drivers/usb/storage/scsiglue.c	2008-03-09 
21:33:49.000000000 +0100
@@ -132,7 +132,7 @@
  		/* Disk-type devices use MODE SENSE(6) if the protocol
  		 * (SubClass) is Transparent SCSI, otherwise they use
  		 * MODE SENSE(10). */
-		if (us->subclass != US_SC_SCSI)
+		if (us->subclass != US_SC_SCSI && us->subclass != US_SC_CYP_ATACB)
  			sdev->use_10_for_ms = 1;

  		/* Many disks only accept MODE SENSE transfer lengths of
Index: linux-2.6.24.2/drivers/usb/storage/transport.c
===================================================================
--- linux-2.6.24.2.orig/drivers/usb/storage/transport.c	2008-03-09 
21:33:56.000000000 +0100
+++ linux-2.6.24.2/drivers/usb/storage/transport.c	2008-03-09 
21:34:14.000000000 +0100
@@ -587,7 +587,8 @@
  		scsi_eh_prep_cmnd(srb, &ses, NULL, 0, US_SENSE_SIZE);

  		/* FIXME: we must do the protocol translation here */
-		if (us->subclass == US_SC_RBC || us->subclass == US_SC_SCSI)
+		if (us->subclass == US_SC_RBC || us->subclass == US_SC_SCSI ||
+				us->subclass == US_SC_CYP_ATACB)
  			srb->cmd_len = 6;
  		else
  			srb->cmd_len = 12;
Index: linux-2.6.24.2/drivers/usb/storage/usb.c
===================================================================
--- linux-2.6.24.2.orig/drivers/usb/storage/usb.c	2008-03-09 
21:12:36.000000000 +0100
+++ linux-2.6.24.2/drivers/usb/storage/usb.c	2008-03-09 
21:53:55.000000000 +0100
@@ -101,6 +101,9 @@
  #ifdef CONFIG_USB_STORAGE_KARMA
  #include "karma.h"
  #endif
+#ifdef CONFIG_USB_STORAGE_CYPRESS_ATACB
+#include "cypress_atacb.h"
+#endif

  /* Some informational data */
  MODULE_AUTHOR("Matthew Dharm <mdharm-usb@one-eyed-alien.net>");
@@ -708,6 +711,13 @@
  		break;
  #endif

+#ifdef CONFIG_USB_STORAGE_CYPRESS_ATACB
+	case US_SC_CYP_ATACB:
+		us->protocol_name = "Transparent SCSI with Cypress ATACB";
+		us->proto_handler = cypress_atacb_passthrough;
+		break;
+#endif
+
  	default:
  		return -EIO;
  	}
Index: linux-2.6.24.2/include/linux/usb_usual.h
===================================================================
--- linux-2.6.24.2.orig/include/linux/usb_usual.h	2008-03-09 
21:15:01.000000000 +0100
+++ linux-2.6.24.2/include/linux/usb_usual.h	2008-03-09 
21:24:12.000000000 +0100
@@ -81,8 +81,9 @@
  #define US_SC_8070	0x05		/* Removable media */
  #define US_SC_SCSI	0x06		/* Transparent */
  #define US_SC_ISD200    0x07		/* ISD200 ATA */
+#define US_SC_CYP_ATACB 0x08		/* Cypress ATACB */
  #define US_SC_MIN	US_SC_RBC
-#define US_SC_MAX	US_SC_ISD200
+#define US_SC_MAX	US_SC_CYP_ATACB

  #define US_SC_DEVICE	0xff		/* Use device's value */

