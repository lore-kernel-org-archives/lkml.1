Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130AbYGXTlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbYGXTlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 15:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYGXTkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 15:40:53 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:54783 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbYGXTkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 15:40:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=Aua1TPM+JDH4/m9KwYrlCUkqDCgySJY+jWgkcUWapVUJ15XJ06yTfOwkgRhJGCFW/F
         ethTSl+YVVJY1GvnnubfZ6j7L2C2Z5oP0w09blYeIh5dyXVZcy8xxB96r9/dKrtBgDHc
         PF15CGTmKQ9Nwzuj2lUWmHPR7ZQP6Rb8ZWUjU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/4] move HDIO_* ioctls support from <linux/hdreg.h> to <linux/hdio_ioctls.h>
Date: Thu, 24 Jul 2008 21:35:02 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807242135.02363.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
* against previous ATA_ID_*, ATA_CMD_* and ATA_* patchsets
* yes, this one also lacks proper description aka patch #0/0
  but it is the last one so it is not worth doing it now ;)

 include/linux/Kbuild        |    1 
 include/linux/hdio_ioctls.h |  213 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/hdreg.h       |  211 -------------------------------------------
 3 files changed, 215 insertions(+), 210 deletions(-)

Index: b/include/linux/Kbuild
===================================================================
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -210,6 +210,7 @@ unifdef-y += fs.h
 unifdef-y += gameport.h
 unifdef-y += generic_serial.h
 unifdef-y += hayesesp.h
+unifdef-y += hdio_ioctls.h
 unifdef-y += hdlcdrv.h
 unifdef-y += hdlc.h
 unifdef-y += hdreg.h
Index: b/include/linux/hdio_ioctls.h
===================================================================
--- /dev/null
+++ b/include/linux/hdio_ioctls.h
@@ -0,0 +1,213 @@
+#ifndef __LINUX_HDIO_IOCTLS_H
+#define __LINUX_HDIO_IOCTLS_H
+
+#include <linux/types.h>
+
+/*
+ * Command Header sizes for IOCTL commands
+ */
+
+#define HDIO_DRIVE_CMD_HDR_SIZE		(4 * sizeof(__u8))
+#define HDIO_DRIVE_HOB_HDR_SIZE		(8 * sizeof(__u8))
+#define HDIO_DRIVE_TASK_HDR_SIZE	(8 * sizeof(__u8))
+
+#define IDE_DRIVE_TASK_NO_DATA		0
+#ifndef __KERNEL__
+#define IDE_DRIVE_TASK_INVALID		-1
+#define IDE_DRIVE_TASK_SET_XFER		1
+#define IDE_DRIVE_TASK_IN		2
+#define IDE_DRIVE_TASK_OUT		3
+#endif
+#define IDE_DRIVE_TASK_RAW_WRITE	4
+
+/*
+ * Define standard taskfile in/out register
+ */
+#define IDE_TASKFILE_STD_IN_FLAGS	0xFE
+#define IDE_HOB_STD_IN_FLAGS		0x3C
+#ifndef __KERNEL__
+#define IDE_TASKFILE_STD_OUT_FLAGS	0xFE
+#define IDE_HOB_STD_OUT_FLAGS		0x3C
+
+typedef unsigned char task_ioreg_t;
+typedef unsigned long sata_ioreg_t;
+#endif
+
+typedef union ide_reg_valid_s {
+	unsigned all				: 16;
+	struct {
+		unsigned data			: 1;
+		unsigned error_feature		: 1;
+		unsigned sector			: 1;
+		unsigned nsector		: 1;
+		unsigned lcyl			: 1;
+		unsigned hcyl			: 1;
+		unsigned select			: 1;
+		unsigned status_command		: 1;
+
+		unsigned data_hob		: 1;
+		unsigned error_feature_hob	: 1;
+		unsigned sector_hob		: 1;
+		unsigned nsector_hob		: 1;
+		unsigned lcyl_hob		: 1;
+		unsigned hcyl_hob		: 1;
+		unsigned select_hob		: 1;
+		unsigned control_hob		: 1;
+	} b;
+} ide_reg_valid_t;
+
+typedef struct ide_task_request_s {
+	__u8		io_ports[8];
+	__u8		hob_ports[8]; /* bytes 6 and 7 are unused */
+	ide_reg_valid_t	out_flags;
+	ide_reg_valid_t	in_flags;
+	int		data_phase;
+	int		req_cmd;
+	unsigned long	out_size;
+	unsigned long	in_size;
+} ide_task_request_t;
+
+typedef struct ide_ioctl_request_s {
+	ide_task_request_t	*task_request;
+	unsigned char		*out_buffer;
+	unsigned char		*in_buffer;
+} ide_ioctl_request_t;
+
+struct hd_drive_cmd_hdr {
+	__u8 command;
+	__u8 sector_number;
+	__u8 feature;
+	__u8 sector_count;
+};
+
+#ifndef __KERNEL__
+typedef struct hd_drive_task_hdr {
+	__u8 data;
+	__u8 feature;
+	__u8 sector_count;
+	__u8 sector_number;
+	__u8 low_cylinder;
+	__u8 high_cylinder;
+	__u8 device_head;
+	__u8 command;
+} task_struct_t;
+
+typedef struct hd_drive_hob_hdr {
+	__u8 data;
+	__u8 feature;
+	__u8 sector_count;
+	__u8 sector_number;
+	__u8 low_cylinder;
+	__u8 high_cylinder;
+	__u8 device_head;
+	__u8 control;
+} hob_struct_t;
+#endif
+
+#define TASKFILE_NO_DATA		0x0000
+
+#define TASKFILE_IN			0x0001
+#define TASKFILE_MULTI_IN		0x0002
+
+#define TASKFILE_OUT			0x0004
+#define TASKFILE_MULTI_OUT		0x0008
+#define TASKFILE_IN_OUT			0x0010
+
+#define TASKFILE_IN_DMA			0x0020
+#define TASKFILE_OUT_DMA		0x0040
+#define TASKFILE_IN_DMAQ		0x0080
+#define TASKFILE_OUT_DMAQ		0x0100
+
+#ifndef __KERNEL__
+#define TASKFILE_P_IN			0x0200
+#define TASKFILE_P_OUT			0x0400
+#define TASKFILE_P_IN_DMA		0x0800
+#define TASKFILE_P_OUT_DMA		0x1000
+#define TASKFILE_P_IN_DMAQ		0x2000
+#define TASKFILE_P_OUT_DMAQ		0x4000
+#define TASKFILE_48			0x8000
+#define TASKFILE_INVALID		0x7fff
+#endif
+
+struct hd_geometry {
+      unsigned char heads;
+      unsigned char sectors;
+      unsigned short cylinders;
+      unsigned long start;
+};
+
+/* hd/ide ctl's that pass (arg) ptrs to user space are numbered 0x030n/0x031n */
+#define HDIO_GETGEO		0x0301	/* get device geometry */
+#define HDIO_GET_UNMASKINTR	0x0302	/* get current unmask setting */
+#define HDIO_GET_MULTCOUNT	0x0304	/* get current IDE blockmode setting */
+#define HDIO_GET_QDMA		0x0305	/* get use-qdma flag */
+
+#define HDIO_SET_XFER		0x0306  /* set transfer rate via proc */
+
+#define HDIO_OBSOLETE_IDENTITY	0x0307	/* OBSOLETE, DO NOT USE: returns 142 bytes */
+#define HDIO_GET_KEEPSETTINGS	0x0308	/* get keep-settings-on-reset flag */
+#define HDIO_GET_32BIT		0x0309	/* get current io_32bit setting */
+#define HDIO_GET_NOWERR		0x030a	/* get ignore-write-error flag */
+#define HDIO_GET_DMA		0x030b	/* get use-dma flag */
+#define HDIO_GET_NICE		0x030c	/* get nice flags */
+#define HDIO_GET_IDENTITY	0x030d	/* get IDE identification info */
+#define HDIO_GET_WCACHE		0x030e	/* get write cache mode on|off */
+#define HDIO_GET_ACOUSTIC	0x030f	/* get acoustic value */
+#define	HDIO_GET_ADDRESS	0x0310	/* */
+
+#define HDIO_GET_BUSSTATE	0x031a	/* get the bus state of the hwif */
+#define HDIO_TRISTATE_HWIF	0x031b	/* execute a channel tristate */
+#define HDIO_DRIVE_RESET	0x031c	/* execute a device reset */
+#define HDIO_DRIVE_TASKFILE	0x031d	/* execute raw taskfile */
+#define HDIO_DRIVE_TASK		0x031e	/* execute task and special drive command */
+#define HDIO_DRIVE_CMD		0x031f	/* execute a special drive command */
+#define HDIO_DRIVE_CMD_AEB	HDIO_DRIVE_TASK
+
+/* hd/ide ctl's that pass (arg) non-ptr values are numbered 0x032n/0x033n */
+#define HDIO_SET_MULTCOUNT	0x0321	/* change IDE blockmode */
+#define HDIO_SET_UNMASKINTR	0x0322	/* permit other irqs during I/O */
+#define HDIO_SET_KEEPSETTINGS	0x0323	/* keep ioctl settings on reset */
+#define HDIO_SET_32BIT		0x0324	/* change io_32bit flags */
+#define HDIO_SET_NOWERR		0x0325	/* change ignore-write-error flag */
+#define HDIO_SET_DMA		0x0326	/* change use-dma flag */
+#define HDIO_SET_PIO_MODE	0x0327	/* reconfig interface to new speed */
+#ifndef __KERNEL__
+#define HDIO_SCAN_HWIF		0x0328	/* register and (re)scan interface */
+#define HDIO_UNREGISTER_HWIF	0x032a  /* unregister interface */
+#endif
+#define HDIO_SET_NICE		0x0329	/* set nice flags */
+#define HDIO_SET_WCACHE		0x032b	/* change write cache enable-disable */
+#define HDIO_SET_ACOUSTIC	0x032c	/* change acoustic behavior */
+#define HDIO_SET_BUSSTATE	0x032d	/* set the bus state of the hwif */
+#define HDIO_SET_QDMA		0x032e	/* change use-qdma flag */
+#define HDIO_SET_ADDRESS	0x032f	/* change lba addressing modes */
+
+/* bus states */
+enum {
+	BUSSTATE_OFF = 0,
+	BUSSTATE_ON,
+	BUSSTATE_TRISTATE
+};
+
+/* hd/ide ctl's that pass (arg) ptrs to user space are numbered 0x033n/0x033n */
+/* 0x330 is reserved - used to be HDIO_GETGEO_BIG */
+/* 0x331 is reserved - used to be HDIO_GETGEO_BIG_RAW */
+/* 0x338 is reserved - used to be HDIO_SET_IDE_SCSI */
+/* 0x339 is reserved - used to be HDIO_SET_SCSI_IDE */
+
+#define __NEW_HD_DRIVE_ID
+
+/*
+ * IDE "nice" flags. These are used on a per drive basis to determine
+ * when to be nice and give more bandwidth to the other devices which
+ * share the same IDE bus.
+ */
+#define IDE_NICE_DSC_OVERLAP	(0)	/* per the DSC overlap protocol */
+#define IDE_NICE_ATAPI_OVERLAP	(1)	/* not supported yet */
+#define IDE_NICE_1		(3)	/* when probably won't affect us much */
+#ifndef __KERNEL__
+#define IDE_NICE_0		(2)	/* when sure that it won't affect us */
+#define IDE_NICE_2		(4)	/* when we know it's on our expense */
+#endif
+
+#endif	/* __LINUX_HDIO_IOCTLS_H */
Index: b/include/linux/hdreg.h
===================================================================
--- a/include/linux/hdreg.h
+++ b/include/linux/hdreg.h
@@ -5,133 +5,7 @@
 #include <linux/ata.h>
 #endif /* __KERNEL__ */
 
-#include <linux/types.h>
-
-/*
- * Command Header sizes for IOCTL commands
- */
-
-#define HDIO_DRIVE_CMD_HDR_SIZE		(4 * sizeof(__u8))
-#define HDIO_DRIVE_HOB_HDR_SIZE		(8 * sizeof(__u8))
-#define HDIO_DRIVE_TASK_HDR_SIZE	(8 * sizeof(__u8))
-
-#define IDE_DRIVE_TASK_NO_DATA		0
-#ifndef __KERNEL__
-#define IDE_DRIVE_TASK_INVALID		-1
-#define IDE_DRIVE_TASK_SET_XFER		1
-#define IDE_DRIVE_TASK_IN		2
-#define IDE_DRIVE_TASK_OUT		3
-#endif
-#define IDE_DRIVE_TASK_RAW_WRITE	4
-
-/*
- * Define standard taskfile in/out register
- */
-#define IDE_TASKFILE_STD_IN_FLAGS	0xFE
-#define IDE_HOB_STD_IN_FLAGS		0x3C
-#ifndef __KERNEL__
-#define IDE_TASKFILE_STD_OUT_FLAGS	0xFE
-#define IDE_HOB_STD_OUT_FLAGS		0x3C
-
-typedef unsigned char task_ioreg_t;
-typedef unsigned long sata_ioreg_t;
-#endif
-
-typedef union ide_reg_valid_s {
-	unsigned all				: 16;
-	struct {
-		unsigned data			: 1;
-		unsigned error_feature		: 1;
-		unsigned sector			: 1;
-		unsigned nsector		: 1;
-		unsigned lcyl			: 1;
-		unsigned hcyl			: 1;
-		unsigned select			: 1;
-		unsigned status_command		: 1;
-
-		unsigned data_hob		: 1;
-		unsigned error_feature_hob	: 1;
-		unsigned sector_hob		: 1;
-		unsigned nsector_hob		: 1;
-		unsigned lcyl_hob		: 1;
-		unsigned hcyl_hob		: 1;
-		unsigned select_hob		: 1;
-		unsigned control_hob		: 1;
-	} b;
-} ide_reg_valid_t;
-
-typedef struct ide_task_request_s {
-	__u8		io_ports[8];
-	__u8		hob_ports[8]; /* bytes 6 and 7 are unused */
-	ide_reg_valid_t	out_flags;
-	ide_reg_valid_t	in_flags;
-	int		data_phase;
-	int		req_cmd;
-	unsigned long	out_size;
-	unsigned long	in_size;
-} ide_task_request_t;
-
-typedef struct ide_ioctl_request_s {
-	ide_task_request_t	*task_request;
-	unsigned char		*out_buffer;
-	unsigned char		*in_buffer;
-} ide_ioctl_request_t;
-
-struct hd_drive_cmd_hdr {
-	__u8 command;
-	__u8 sector_number;
-	__u8 feature;
-	__u8 sector_count;
-};
-
-#ifndef __KERNEL__
-typedef struct hd_drive_task_hdr {
-	__u8 data;
-	__u8 feature;
-	__u8 sector_count;
-	__u8 sector_number;
-	__u8 low_cylinder;
-	__u8 high_cylinder;
-	__u8 device_head;
-	__u8 command;
-} task_struct_t;
-
-typedef struct hd_drive_hob_hdr {
-	__u8 data;
-	__u8 feature;
-	__u8 sector_count;
-	__u8 sector_number;
-	__u8 low_cylinder;
-	__u8 high_cylinder;
-	__u8 device_head;
-	__u8 control;
-} hob_struct_t;
-#endif
-
-#define TASKFILE_NO_DATA		0x0000
-
-#define TASKFILE_IN			0x0001
-#define TASKFILE_MULTI_IN		0x0002
-
-#define TASKFILE_OUT			0x0004
-#define TASKFILE_MULTI_OUT		0x0008
-#define TASKFILE_IN_OUT			0x0010
-
-#define TASKFILE_IN_DMA			0x0020
-#define TASKFILE_OUT_DMA		0x0040
-#define TASKFILE_IN_DMAQ		0x0080
-#define TASKFILE_OUT_DMAQ		0x0100
-
-#ifndef __KERNEL__
-#define TASKFILE_P_IN			0x0200
-#define TASKFILE_P_OUT			0x0400
-#define TASKFILE_P_IN_DMA		0x0800
-#define TASKFILE_P_OUT_DMA		0x1000
-#define TASKFILE_P_IN_DMAQ		0x2000
-#define TASKFILE_P_OUT_DMAQ		0x4000
-#define TASKFILE_48			0x8000
-#define TASKFILE_INVALID		0x7fff
-#endif
+#include <linux/hdio_ioctls.h>
 
 #ifndef __KERNEL__
 /* ATA/ATAPI Commands pre T13 Spec */
@@ -322,77 +196,7 @@ typedef struct hd_drive_hob_hdr {
 #define SECURITY_ERASE_UNIT		0xBD
 #define SECURITY_FREEZE_LOCK		0xBE
 #define SECURITY_DISABLE_PASSWORD	0xBF
-#endif /* __KERNEL__ */
-
-struct hd_geometry {
-      unsigned char heads;
-      unsigned char sectors;
-      unsigned short cylinders;
-      unsigned long start;
-};
-
-/* hd/ide ctl's that pass (arg) ptrs to user space are numbered 0x030n/0x031n */
-#define HDIO_GETGEO		0x0301	/* get device geometry */
-#define HDIO_GET_UNMASKINTR	0x0302	/* get current unmask setting */
-#define HDIO_GET_MULTCOUNT	0x0304	/* get current IDE blockmode setting */
-#define HDIO_GET_QDMA		0x0305	/* get use-qdma flag */
-
-#define HDIO_SET_XFER		0x0306  /* set transfer rate via proc */
-
-#define HDIO_OBSOLETE_IDENTITY	0x0307	/* OBSOLETE, DO NOT USE: returns 142 bytes */
-#define HDIO_GET_KEEPSETTINGS	0x0308	/* get keep-settings-on-reset flag */
-#define HDIO_GET_32BIT		0x0309	/* get current io_32bit setting */
-#define HDIO_GET_NOWERR		0x030a	/* get ignore-write-error flag */
-#define HDIO_GET_DMA		0x030b	/* get use-dma flag */
-#define HDIO_GET_NICE		0x030c	/* get nice flags */
-#define HDIO_GET_IDENTITY	0x030d	/* get IDE identification info */
-#define HDIO_GET_WCACHE		0x030e	/* get write cache mode on|off */
-#define HDIO_GET_ACOUSTIC	0x030f	/* get acoustic value */
-#define	HDIO_GET_ADDRESS	0x0310	/* */
-
-#define HDIO_GET_BUSSTATE	0x031a	/* get the bus state of the hwif */
-#define HDIO_TRISTATE_HWIF	0x031b	/* execute a channel tristate */
-#define HDIO_DRIVE_RESET	0x031c	/* execute a device reset */
-#define HDIO_DRIVE_TASKFILE	0x031d	/* execute raw taskfile */
-#define HDIO_DRIVE_TASK		0x031e	/* execute task and special drive command */
-#define HDIO_DRIVE_CMD		0x031f	/* execute a special drive command */
-#define HDIO_DRIVE_CMD_AEB	HDIO_DRIVE_TASK
-
-/* hd/ide ctl's that pass (arg) non-ptr values are numbered 0x032n/0x033n */
-#define HDIO_SET_MULTCOUNT	0x0321	/* change IDE blockmode */
-#define HDIO_SET_UNMASKINTR	0x0322	/* permit other irqs during I/O */
-#define HDIO_SET_KEEPSETTINGS	0x0323	/* keep ioctl settings on reset */
-#define HDIO_SET_32BIT		0x0324	/* change io_32bit flags */
-#define HDIO_SET_NOWERR		0x0325	/* change ignore-write-error flag */
-#define HDIO_SET_DMA		0x0326	/* change use-dma flag */
-#define HDIO_SET_PIO_MODE	0x0327	/* reconfig interface to new speed */
-#ifndef __KERNEL__
-#define HDIO_SCAN_HWIF		0x0328	/* register and (re)scan interface */
-#define HDIO_UNREGISTER_HWIF	0x032a  /* unregister interface */
-#endif
-#define HDIO_SET_NICE		0x0329	/* set nice flags */
-#define HDIO_SET_WCACHE		0x032b	/* change write cache enable-disable */
-#define HDIO_SET_ACOUSTIC	0x032c	/* change acoustic behavior */
-#define HDIO_SET_BUSSTATE	0x032d	/* set the bus state of the hwif */
-#define HDIO_SET_QDMA		0x032e	/* change use-qdma flag */
-#define HDIO_SET_ADDRESS	0x032f	/* change lba addressing modes */
-
-/* bus states */
-enum {
-	BUSSTATE_OFF = 0,
-	BUSSTATE_ON,
-	BUSSTATE_TRISTATE
-};
-
-/* hd/ide ctl's that pass (arg) ptrs to user space are numbered 0x033n/0x033n */
-/* 0x330 is reserved - used to be HDIO_GETGEO_BIG */
-/* 0x331 is reserved - used to be HDIO_GETGEO_BIG_RAW */
-/* 0x338 is reserved - used to be HDIO_SET_IDE_SCSI */
-/* 0x339 is reserved - used to be HDIO_SET_SCSI_IDE */
 
-#define __NEW_HD_DRIVE_ID
-
-#ifndef __KERNEL__
 /*
  * Structure returned by HDIO_GET_IDENTITY, as per ANSI NCITS ATA6 rev.1b spec.
  *
@@ -647,17 +451,4 @@ struct hd_driveid {
 };
 #endif /* __KERNEL__ */
 
-/*
- * IDE "nice" flags. These are used on a per drive basis to determine
- * when to be nice and give more bandwidth to the other devices which
- * share the same IDE bus.
- */
-#define IDE_NICE_DSC_OVERLAP	(0)	/* per the DSC overlap protocol */
-#define IDE_NICE_ATAPI_OVERLAP	(1)	/* not supported yet */
-#define IDE_NICE_1		(3)	/* when probably won't affect us much */
-#ifndef __KERNEL__
-#define IDE_NICE_0		(2)	/* when sure that it won't affect us */
-#define IDE_NICE_2		(4)	/* when we know it's on our expense */
-#endif
-
 #endif	/* _LINUX_HDREG_H */
