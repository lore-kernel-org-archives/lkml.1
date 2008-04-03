Return-Path: <linux-kernel-owner+w=401wt.eu-S1760741AbYDCGEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760741AbYDCGEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 02:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbYDCGEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 02:04:14 -0400
Received: from smtp3-g19.free.fr ([212.27.42.29]:50806 "EHLO smtp3-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755876AbYDCGEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 02:04:12 -0400
Message-ID: <47F47324.80108@free.fr>
Date: Thu, 03 Apr 2008 08:03:16 +0200
From: Xavier <x.guimard@free.fr>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Proposed patch for IDE missing commands
Content-Type: multipart/mixed;
 boundary="------------050204090804010707040006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050204090804010707040006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi all,

I'm working for the french Gendarmerie Nationale and we've decided to 
publish our patch for the kernel that provides some missing IDE commands 
to access to protected areas (HPA and DCO).

Best regards,
Xavier


--------------050204090804010707040006
Content-Type: text/plain;
 name="patch-linux-2.6.24-ide"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-linux-2.6.24-ide"

diff -aburN linux-2.6.24/drivers/ide/ide-disk.c linux-2.6.24-ide/drivers/ide/ide-disk.c
--- linux-2.6.24/drivers/ide/ide-disk.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24-ide/drivers/ide/ide-disk.c	2008-03-25 18:30:02.000000000 +0100
@@ -331,6 +331,7 @@
 	}
 	return addr;
 }
+EXPORT_SYMBOL(idedisk_read_native_max_address);
 
 static unsigned long long idedisk_read_native_max_address_ext(ide_drive_t *drive)
 {
@@ -361,6 +362,8 @@
 	return addr;
 }
 
+EXPORT_SYMBOL(idedisk_read_native_max_address_ext);
+
 /*
  * Sets maximum virtual LBA address of the drive.
  * Returns new maximum virtual LBA address (> 0) or 0 on failure.
@@ -392,6 +395,7 @@
 	}
 	return addr_set;
 }
+EXPORT_SYMBOL(idedisk_set_max_address);
 
 static unsigned long long idedisk_set_max_address_ext(ide_drive_t *drive, unsigned long long addr_req)
 {
@@ -428,6 +432,7 @@
 	}
 	return addr_set;
 }
+EXPORT_SYMBOL(idedisk_set_max_address_ext);
 
 static unsigned long long sectors_to_MB(unsigned long long n)
 {
@@ -465,6 +470,125 @@
 	{ NULL,		NULL }
 };
 
+static unsigned long long idedisk_read_lba_hpa(ide_drive_t *drive)
+{
+	unsigned long long lba_hpa;
+	
+	if (idedisk_supports_lba48(drive->id)) 
+	{
+		/* drive speaks 48-bit LBA */
+		lba_hpa = drive->id->lba_capacity_2-1;
+		printk(KERN_INFO "drive speaks 48-bit LBA.(%llu)\n",lba_hpa);
+	} 
+	else if ((drive->id->capability & 2) && lba_capacity_is_ok(drive->id)) 
+	{
+		/* drive speaks 28-bit LBA */
+		lba_hpa = drive->id->lba_capacity-1;
+		printk(KERN_INFO "drive speaks 24-bit LBA.(%llu)\n",lba_hpa);
+	} 
+	else 
+	{
+		/* drive speaks boring old 28-bit CHS */
+		lba_hpa = (drive->cyl * drive->head * drive->sect)-1;
+		printk(KERN_INFO "drive speaks 24-bit CHS.(%llu)\n",lba_hpa);
+	}
+	return lba_hpa;
+}
+
+static unsigned long long idedisk_read_lba_dco(ide_drive_t *drive)
+{
+	unsigned long long lba_dco;
+	int lba48 = idedisk_supports_lba48(drive->id);
+
+	if (lba48)
+	{
+		lba_dco = idedisk_read_native_max_address_ext(drive)-1;
+		printk(KERN_INFO "read native max address 48-bit LBA.(%llu)\n",lba_dco);
+	}
+	else
+	{
+		lba_dco = idedisk_read_native_max_address(drive)-1;
+		printk(KERN_INFO "read native max address 24-bit LBA.(%llu)\n",lba_dco);
+	}
+	return lba_dco;
+}
+
+static int idedisk_get_dco(ide_drive_t *drive, u8 *buf)
+{
+	ide_task_t args;
+
+	memset(&args, 0, sizeof(ide_task_t));
+	args.tfRegister[IDE_FEATURE_OFFSET]	= 0xC2;
+	args.tfRegister[IDE_NSECTOR_OFFSET]	= 0x01;
+	args.tfRegister[IDE_LCYL_OFFSET]	= 0x00;
+	args.tfRegister[IDE_HCYL_OFFSET]	= 0x00;
+	args.tfRegister[IDE_COMMAND_OFFSET]	= 0xB1;
+	args.command_type			= IDE_DRIVE_TASK_IN;
+	args.data_phase				= TASKFILE_IN;
+	args.handler				= &task_in_intr;
+	return ide_raw_taskfile(drive, &args, buf);
+}
+
+static inline int idedisk_supports_dco(const struct hd_driveid *id)
+{
+	return (id->command_set_2 & 0x0800);
+}
+
+static unsigned long long idedisk_read_lba_max(ide_drive_t *drive)
+{
+
+	unsigned long long lba_max=0;
+	int s_dco = idedisk_supports_dco(drive->id);
+//	unsigned short int tmp;
+//	unsigned short int tmpa;
+//	char txt[2];
+	unsigned char qtmp[8];
+	char *ptr;
+	char *buf=NULL;
+	
+	if (s_dco)
+	{
+		printk(KERN_INFO "DCO supported\n");
+		buf = kzalloc(512, GFP_KERNEL);
+		if (!buf)
+			return (unsigned long long)-1;
+		
+		if (!idedisk_get_dco(drive, buf)) 
+		{
+			ptr=buf+6;
+			qtmp[0]=(*ptr);
+			ptr++;
+			qtmp[1]=(*ptr);
+			ptr++;
+			qtmp[2]=(*ptr);
+			ptr++;
+			qtmp[3]=*(ptr);
+			ptr++;
+			qtmp[4]=(*ptr);
+			ptr++;
+			qtmp[5]=(*ptr);
+			ptr++;
+			qtmp[6]=(*ptr);
+			ptr++;
+			qtmp[7]=(*ptr);
+			lba_max+=(unsigned long long)(*((unsigned long long *)(&qtmp)));
+			printk(KERN_INFO "LBA MAX via DCO (%llu)\n",lba_max);
+		}
+		else
+		{
+			lba_max = 0;
+			printk(KERN_INFO "Error : LBA MAX via DCO (%llu)\n",lba_max);
+		}
+		kfree(buf);
+	}
+	else
+	{
+		lba_max = drive->id->lba_capacity_2;
+		printk(KERN_INFO "DCO not supported, LBA MAX.(%llu)\n",lba_max);
+	}
+	return lba_max;	
+}
+
 static void idedisk_check_hpa(ide_drive_t *drive)
 {
 	unsigned long long capacity, set_max;
@@ -495,7 +619,7 @@
 			 capacity, sectors_to_MB(capacity),
 			 set_max, sectors_to_MB(set_max));
 
-	if (lba48)
+/*	if (lba48)
 		set_max = idedisk_set_max_address_ext(drive, set_max);
 	else
 		set_max = idedisk_set_max_address(drive, set_max);
@@ -503,9 +627,11 @@
 		drive->capacity64 = set_max;
 		printk(KERN_INFO "%s: Host Protected Area disabled.\n",
 				 drive->name);
-	}
+	}*/
 }
 
+
+
 /*
  * Compute drive->capacity, the full capacity of the drive
  * Called with drive->id != NULL.
@@ -527,20 +653,24 @@
 	 * If this drive supports the Host Protected Area feature set,
 	 * then we may need to change our opinion about the drive's capacity.
 	 */
-	int hpa = idedisk_supports_hpa(id);
+	
+	drive->lba_hpa = idedisk_read_lba_hpa(drive);
+	drive->lba_dco = idedisk_read_lba_dco(drive);
+	drive->lba_max = idedisk_read_lba_max(drive);
+//	int hpa = idedisk_supports_hpa(id);
 
 	if (idedisk_supports_lba48(id)) {
 		/* drive speaks 48-bit LBA */
 		drive->select.b.lba = 1;
 		drive->capacity64 = id->lba_capacity_2;
-		if (hpa)
-			idedisk_check_hpa(drive);
+/*		if (hpa)
+			idedisk_check_hpa(drive);*/
 	} else if ((id->capability & 2) && lba_capacity_is_ok(id)) {
 		/* drive speaks 28-bit LBA */
 		drive->select.b.lba = 1;
 		drive->capacity64 = id->lba_capacity;
-		if (hpa)
-			idedisk_check_hpa(drive);
+/*		if (hpa)
+			idedisk_check_hpa(drive);*/
 	} else {
 		/* drive speaks boring old 28-bit CHS */
 		drive->capacity64 = drive->cyl * drive->head * drive->sect;
@@ -584,6 +714,8 @@
 	return ide_raw_taskfile(drive, &args, buf);
 }
 
+
+
 static int proc_idedisk_read_cache
 	(char *page, char **start, off_t off, int count, int *eof, void *data)
 {
@@ -646,12 +778,49 @@
 	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
 }
 
+static int proc_idedisk_read_lba_hpa
+		(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	ide_drive_t*drive = (ide_drive_t *)data;
+	int len;
+	
+	len = sprintf(page,"%llu\n", idedisk_read_lba_hpa(drive));
+	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+}
+
+
+static int proc_idedisk_read_lba_dco
+		(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	ide_drive_t*drive = (ide_drive_t *)data;
+	int len;
+
+	len = sprintf(page,"%llu\n", idedisk_read_lba_dco(drive));
+	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+}
+
+
+
+
+static int proc_idedisk_read_lba_max
+		(char *page, char **start, off_t off, int count, int *eof, void *data)
+{
+	ide_drive_t*drive = (ide_drive_t *)data;
+	int		len = 0;
+
+	len = sprintf(page,"%llu\n", idedisk_read_lba_max(drive));
+	PROC_IDE_READ_RETURN(page,start,off,count,eof,len);
+}
+
 static ide_proc_entry_t idedisk_proc[] = {
 	{ "cache",		S_IFREG|S_IRUGO,	proc_idedisk_read_cache,		NULL },
 	{ "capacity",		S_IFREG|S_IRUGO,	proc_idedisk_read_capacity,		NULL },
 	{ "geometry",		S_IFREG|S_IRUGO,	proc_ide_read_geometry,			NULL },
 	{ "smart_values",	S_IFREG|S_IRUSR,	proc_idedisk_read_smart_values,		NULL },
 	{ "smart_thresholds",	S_IFREG|S_IRUSR,	proc_idedisk_read_smart_thresholds,	NULL },
+	{ "lba_hpa",	S_IFREG|S_IRUGO,	proc_idedisk_read_lba_hpa,	NULL },
+	{ "lba_dco",	S_IFREG|S_IRUGO,	proc_idedisk_read_lba_dco,	NULL },
+	{ "lba_max",	S_IFREG|S_IRUGO,	proc_idedisk_read_lba_max,	NULL },
 	{ NULL, 0, NULL, NULL }
 };
 #endif	/* CONFIG_IDE_PROC_FS */
@@ -831,7 +1000,7 @@
 	ide_add_setting(drive,	"bios_cyl",	SETTING_RW,	TYPE_INT,	0,	65535,			1,	1,	&drive->bios_cyl,	NULL);
 	ide_add_setting(drive,	"bios_head",	SETTING_RW,	TYPE_BYTE,	0,	255,			1,	1,	&drive->bios_head,	NULL);
 	ide_add_setting(drive,	"bios_sect",	SETTING_RW,	TYPE_BYTE,	0,	63,			1,	1,	&drive->bios_sect,	NULL);
-	ide_add_setting(drive,	"address",	SETTING_RW,	TYPE_BYTE,	0,	2,			1,	1,	&drive->addressing,	set_lba_addressing);
+	ide_add_setting(drive,	"address",	SETTING_RW,	TYPE_INTA,	0,	2,			1,	1,	&drive->addressing,	set_lba_addressing);
 	ide_add_setting(drive,	"bswap",	SETTING_READ,	TYPE_BYTE,	0,	1,			1,	1,	&drive->bswap,		NULL);
 	ide_add_setting(drive,	"multcount",	SETTING_RW,	TYPE_BYTE,	0,	id->max_multsect,	1,	1,	&drive->mult_count,	set_multcount);
 	ide_add_setting(drive,	"nowerr",	SETTING_RW,	TYPE_BYTE,	0,	1,			1,	1,	&drive->nowerr,		set_nowerr);
@@ -928,8 +1097,8 @@
 			}
 		}
 	}
-	printk(KERN_INFO "%s: %llu sectors (%llu MB)",
-			 drive->name, capacity, sectors_to_MB(capacity));
+	printk(KERN_INFO "%s: %llu sectors (%llu MB), (HPA: %llu, DCO: %llu, MAX: %llu)",
+			 drive->name, capacity, sectors_to_MB(capacity),drive->lba_hpa,drive->lba_dco,drive->lba_max);
 
 	/* Only print cache size when it was specified */
 	if (id->buf_size)
diff -aburN linux-2.6.24/drivers/ide/ide-proc.c linux-2.6.24-ide/drivers/ide/ide-proc.c
--- linux-2.6.24/drivers/ide/ide-proc.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24-ide/drivers/ide/ide-proc.c	2008-03-25 18:58:35.000000000 +0100
@@ -37,6 +37,8 @@
 #include <linux/ide.h>
 #include <linux/seq_file.h>
 
+#include <linux/types.h>
+
 #include <asm/io.h>
 
 static struct proc_dir_entry *proc_ide_root;
@@ -152,7 +154,7 @@
  *	remove.
  */
 
-static int __ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set, int auto_remove)
+static int __ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type, int min, u64 max, int mul_factor, int div_factor, void *data, ide_procset_t *set, int auto_remove)
 {
 	ide_settings_t **p = (ide_settings_t **) &drive->settings, *setting = NULL;
 
@@ -185,7 +187,7 @@
 	return -1;
 }
 
-int ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type, int min, int max, int mul_factor, int div_factor, void *data, ide_procset_t *set)
+int ide_add_setting(ide_drive_t *drive, const char *name, int rw, int data_type, int min, u64 max, int mul_factor, int div_factor, void *data, ide_procset_t *set)
 {
 	return __ide_add_setting(drive, name, rw, data_type, min, max, mul_factor, div_factor, data, set, 1);
 }
@@ -276,22 +278,26 @@
  *	be told apart
  */
 
-static int ide_read_setting(ide_drive_t *drive, ide_settings_t *setting)
+static u64 ide_read_setting(ide_drive_t *drive, ide_settings_t *setting)
 {
-	int		val = -EINVAL;
+	u64		val = -EINVAL;
 	unsigned long	flags;
 
 	if ((setting->rw & SETTING_READ)) {
 		spin_lock_irqsave(&ide_lock, flags);
 		switch(setting->data_type) {
 			case TYPE_BYTE:
-				val = *((u8 *) setting->data);
+				val = (u64)(*((u8 *) setting->data));
 				break;
 			case TYPE_SHORT:
-				val = *((u16 *) setting->data);
+				val = (u64)(*((u16 *) setting->data));
 				break;
 			case TYPE_INT:
-				val = *((u32 *) setting->data);
+			case TYPE_INTA:
+				val = (u64)(*((u32 *) setting->data));
+				break;
+			case TYPE_LONG:
+				val = *((u64 *) setting->data);
 				break;
 		}
 		spin_unlock_irqrestore(&ide_lock, flags);
@@ -319,6 +325,9 @@
 
 static int ide_write_setting(ide_drive_t *drive, ide_settings_t *setting, int val)
 {
+	int i;
+	u32 *p;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 	if (setting->set)
@@ -339,6 +348,11 @@
 		case TYPE_INT:
 			*((u32 *) setting->data) = val;
 			break;
+		case TYPE_INTA:
+			p = (u32 *) setting->data;
+			for (i = 0; i < 1 << PARTN_BITS; i++, p++)
+				*p = val;
+			break;
 	}
 	spin_unlock_irq(&ide_lock);
 	return 0;
@@ -384,6 +398,9 @@
 	__ide_add_setting(drive,	"init_speed",		SETTING_RW,					TYPE_BYTE,	0,	70,				1,		1,		&drive->init_speed,		NULL,		0);
 	__ide_add_setting(drive,	"current_speed",	SETTING_RW,					TYPE_BYTE,	0,	70,				1,		1,		&drive->current_speed,		set_xfer_rate,	0);
 	__ide_add_setting(drive,	"number",		SETTING_RW,					TYPE_BYTE,	0,	3,				1,		1,		&drive->dn,			NULL,		0);
+	__ide_add_setting(drive,	"get_lba_max",		SETTING_READ,					TYPE_LONG, 0,	(u64)-1,			1,		1,		&drive->lba_max,		NULL,		0);
+	__ide_add_setting(drive,	"get_lba_dco",		SETTING_READ,					TYPE_LONG,	0,	(u64)-1,			1,		1,		&drive->lba_dco,		NULL,		0);
+	__ide_add_setting(drive,	"get_lba_hpa",		SETTING_READ,					TYPE_LONG,	0,	(u64)-1,			1,		1,		&drive->lba_hpa,		NULL,		0);
 }
 
 static void proc_ide_settings_warn(void)
@@ -404,8 +421,8 @@
 	ide_drive_t	*drive = (ide_drive_t *) data;
 	ide_settings_t	*setting = (ide_settings_t *) drive->settings;
 	char		*out = page;
-	int		len, rc, mul_factor, div_factor;
-
+	int		len, mul_factor, div_factor;
+	u64 rc;
 	proc_ide_settings_warn();
 
 	mutex_lock(&ide_setting_mtx);
@@ -416,10 +433,10 @@
 		div_factor = setting->div_factor;
 		out += sprintf(out, "%-24s", setting->name);
 		if ((rc = ide_read_setting(drive, setting)) >= 0)
-			out += sprintf(out, "%-16d", rc * mul_factor / div_factor);
+			out += sprintf(out, "%llu",(u64)(rc * (u64)(mul_factor / div_factor)));
 		else
 			out += sprintf(out, "%-16s", "write-only");
-		out += sprintf(out, "%-16d%-16d", (setting->min * mul_factor + div_factor - 1) / div_factor, setting->max * mul_factor / div_factor);
+		out += sprintf(out, "%-16d%llu", (setting->min * mul_factor + div_factor - 1) / div_factor, (u64)(setting->max * (u64)(mul_factor / div_factor)));
 		if (setting->rw & SETTING_READ)
 			out += sprintf(out, "r");
 		if (setting->rw & SETTING_WRITE)
diff -aburN linux-2.6.24/drivers/ide/ide-taskfile.c linux-2.6.24-ide/drivers/ide/ide-taskfile.c
--- linux-2.6.24/drivers/ide/ide-taskfile.c	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24-ide/drivers/ide/ide-taskfile.c	2008-03-25 12:33:35.000000000 +0100
@@ -528,7 +528,7 @@
 	u8 io_32bit		= drive->io_32bit;
 	char __user *buf = (char __user *)arg;
 
-//	printk("IDE Taskfile ...\n");
+//	printk(KERN_ERR "IDE Taskfile ...\n");
 
 	req_task = kzalloc(tasksize, GFP_KERNEL);
 	if (req_task == NULL) return -ENOMEM;
@@ -620,6 +620,7 @@
 			err = ide_diag_taskfile(drive, &args, taskin, inbuf);
 			break;
 		case TASKFILE_NO_DATA:
+			printk(KERN_INFO "Debut Taskfile no data") ;
 			args.handler = &task_no_data_intr;
 			err = ide_diag_taskfile(drive, &args, 0, NULL);
 			break;
@@ -835,7 +836,6 @@
 	 */
 	hwif->OUTB(taskfile->device_head | drive->select.all, IDE_SELECT_REG);
 	switch(task->data_phase) {
-
    	        case TASKFILE_OUT_DMAQ:
 		case TASKFILE_OUT_DMA:
 		case TASKFILE_IN_DMAQ:
diff -aburN linux-2.6.24/include/linux/hdreg.h linux-2.6.24-ide/include/linux/hdreg.h
--- linux-2.6.24/include/linux/hdreg.h	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24-ide/include/linux/hdreg.h	2008-03-25 19:30:40.000000000 +0100
@@ -399,6 +399,9 @@
 #define HDIO_GET_WCACHE		0x030e	/* get write cache mode on|off */
 #define HDIO_GET_ACOUSTIC	0x030f	/* get acoustic value */
 #define	HDIO_GET_ADDRESS	0x0310	/* */
+#define	HDIO_GET_LBA_HPA	0x0315	/* get lba hpa*/
+#define	HDIO_GET_LBA_DCO	0x0316	/* get lba dco*/
+#define	HDIO_GET_LBA_MAX	0x0317	/* get lba max*/
 
 #define HDIO_GET_BUSSTATE	0x031a	/* get the bus state of the hwif */
 #define HDIO_TRISTATE_HWIF	0x031b	/* execute a channel tristate */
diff -aburN linux-2.6.24/include/linux/ide.h linux-2.6.24-ide/include/linux/ide.h
--- linux-2.6.24/include/linux/ide.h	2008-01-24 23:58:37.000000000 +0100
+++ linux-2.6.24-ide/include/linux/ide.h	2008-03-25 19:28:10.000000000 +0100
@@ -636,6 +636,12 @@
 	struct list_head list;
 	struct device	gendev;
 	struct completion gendev_rel_comp;	/* to deal with device release() */
+	int f_lba_max;
+	u64 lba_max;
+	int f_lba_dco;
+	u64 lba_dco;
+	int f_lba_hpa;
+	u64 lba_hpa;
 } ide_drive_t;
 
 #define to_ide_device(dev)container_of(dev, ide_drive_t, gendev)
@@ -864,8 +870,10 @@
  */
 
 #define TYPE_INT	0
-#define TYPE_BYTE	1
-#define TYPE_SHORT	2
+#define TYPE_INTA	1
+#define TYPE_BYTE	2
+#define TYPE_SHORT	3
+#define TYPE_LONG	4
 
 #define SETTING_READ	(1 << 0)
 #define SETTING_WRITE	(1 << 1)

--------------050204090804010707040006--
