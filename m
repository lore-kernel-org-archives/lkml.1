Return-Path: <linux-kernel-owner+w=401wt.eu-S1763025AbYESN0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763025AbYESN0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 09:26:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbYESNSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 09:18:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45874 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759833AbYESNSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 09:18:48 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 18/57] iTCO: unlocked_ioctl, coding style and cleanup
To: akpm@osdl.org, linux-kernel@vger.kernel.org, wim@iguana.be
Date: Mon, 19 May 2008 14:06:25 +0100
Message-ID: <20080519130625.31722.68489.stgit@core>
In-Reply-To: <20080519124659.31722.51847.stgit@core>
References: <20080519124659.31722.51847.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>


---

 drivers/watchdog/iTCO_vendor.h         |   15 ++
 drivers/watchdog/iTCO_vendor_support.c |   53 +++---
 drivers/watchdog/iTCO_wdt.c            |  294 ++++++++++++++++----------------
 3 files changed, 188 insertions(+), 174 deletions(-)
 create mode 100644 drivers/watchdog/iTCO_vendor.h


diff --git a/drivers/watchdog/iTCO_vendor.h b/drivers/watchdog/iTCO_vendor.h
new file mode 100644
index 0000000..9e27e64
--- /dev/null
+++ b/drivers/watchdog/iTCO_vendor.h
@@ -0,0 +1,15 @@
+/* iTCO Vendor Specific Support hooks */
+#ifdef CONFIG_ITCO_VENDOR_SUPPORT
+extern void iTCO_vendor_pre_start(unsigned long, unsigned int);
+extern void iTCO_vendor_pre_stop(unsigned long);
+extern void iTCO_vendor_pre_keepalive(unsigned long, unsigned int);
+extern void iTCO_vendor_pre_set_heartbeat(unsigned int);
+extern int iTCO_vendor_check_noreboot_on(void);
+#else
+#define iTCO_vendor_pre_start(acpibase, heartbeat)	{}
+#define iTCO_vendor_pre_stop(acpibase)			{}
+#define iTCO_vendor_pre_keepalive(acpibase, heartbeat)	{}
+#define iTCO_vendor_pre_set_heartbeat(heartbeat)	{}
+#define iTCO_vendor_check_noreboot_on()			1
+				/* 1=check noreboot; 0=don't check */
+#endif
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index cafc465..09e9534 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -32,7 +32,9 @@
 #include <linux/init.h>			/* For __init/__exit/... */
 #include <linux/ioport.h>		/* For io-port access */
 
-#include <asm/io.h>			/* For inb/outb/... */
+#include <linux/io.h>			/* For inb/outb/... */
+
+#include "iTCO_vendor.h"
 
 /* iTCO defines */
 #define	SMI_EN		acpibase + 0x30	/* SMI Control and Enable Register */
@@ -40,10 +42,12 @@
 #define	TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register		*/
 
 /* List of vendor support modes */
-#define SUPERMICRO_OLD_BOARD	1	/* SuperMicro Pentium 3 Era 370SSE+-OEM1/P3TSSE */
-#define SUPERMICRO_NEW_BOARD	2	/* SuperMicro Pentium 4 / Xeon 4 / EMT64T Era Systems */
+/* SuperMicro Pentium 3 Era 370SSE+-OEM1/P3TSSE */
+#define SUPERMICRO_OLD_BOARD	1
+/* SuperMicro Pentium 4 / Xeon 4 / EMT64T Era Systems */
+#define SUPERMICRO_NEW_BOARD	2
 
-static int vendorsupport = 0;
+static int vendorsupport;
 module_param(vendorsupport, int, 0);
 MODULE_PARM_DESC(vendorsupport, "iTCO vendor specific support mode, default=0 (none), 1=SuperMicro Pent3, 2=SuperMicro Pent4+");
 
@@ -143,34 +147,35 @@ static void supermicro_old_pre_keepalive(unsigned long acpibase)
  */
 
 /* I/O Port's */
-#define SM_REGINDEX	0x2e		/* SuperMicro ICH4+ Register Index */
-#define SM_DATAIO	0x2f		/* SuperMicro ICH4+ Register Data I/O */
+#define SM_REGINDEX	0x2e	/* SuperMicro ICH4+ Register Index */
+#define SM_DATAIO	0x2f	/* SuperMicro ICH4+ Register Data I/O */
 
 /* Control Register's */
-#define SM_CTLPAGESW	0x07		/* SuperMicro ICH4+ Control Page Switch */
-#define SM_CTLPAGE		0x08	/* SuperMicro ICH4+ Control Page Num */
+#define SM_CTLPAGESW	0x07	/* SuperMicro ICH4+ Control Page Switch */
+#define SM_CTLPAGE	0x08	/* SuperMicro ICH4+ Control Page Num */
 
-#define SM_WATCHENABLE	0x30		/* Watchdog enable: Bit 0: 0=off, 1=on */
+#define SM_WATCHENABLE	0x30	/* Watchdog enable: Bit 0: 0=off, 1=on */
 
-#define SM_WATCHPAGE	0x87		/* Watchdog unlock control page */
+#define SM_WATCHPAGE	0x87	/* Watchdog unlock control page */
 
-#define SM_ENDWATCH	0xAA		/* Watchdog lock control page */
+#define SM_ENDWATCH	0xAA	/* Watchdog lock control page */
 
-#define SM_COUNTMODE	0xf5		/* Watchdog count mode select */
-					/* (Bit 3: 0 = seconds, 1 = minutes */
+#define SM_COUNTMODE	0xf5	/* Watchdog count mode select */
+				/* (Bit 3: 0 = seconds, 1 = minutes */
 
-#define SM_WATCHTIMER	0xf6		/* 8-bits, Watchdog timer counter (RW) */
+#define SM_WATCHTIMER	0xf6	/* 8-bits, Watchdog timer counter (RW) */
 
-#define SM_RESETCONTROL	0xf7		/* Watchdog reset control */
-					/* Bit 6: timer is reset by kbd interrupt */
-					/* Bit 7: timer is reset by mouse interrupt */
+#define SM_RESETCONTROL	0xf7	/* Watchdog reset control */
+				/* Bit 6: timer is reset by kbd interrupt */
+				/* Bit 7: timer is reset by mouse interrupt */
 
 static void supermicro_new_unlock_watchdog(void)
 {
-	outb(SM_WATCHPAGE, SM_REGINDEX);	/* Write 0x87 to port 0x2e twice */
+	/* Write 0x87 to port 0x2e twice */
 	outb(SM_WATCHPAGE, SM_REGINDEX);
-
-	outb(SM_CTLPAGESW, SM_REGINDEX);	/* Switch to watchdog control page */
+	outb(SM_WATCHPAGE, SM_REGINDEX);
+	/* Switch to watchdog control page */
+	outb(SM_CTLPAGESW, SM_REGINDEX);
 	outb(SM_CTLPAGE, SM_DATAIO);
 }
 
@@ -192,7 +197,7 @@ static void supermicro_new_pre_start(unsigned int heartbeat)
 	outb(val, SM_DATAIO);
 
 	/* Write heartbeat interval to WDOG */
-	outb (SM_WATCHTIMER, SM_REGINDEX);
+	outb(SM_WATCHTIMER, SM_REGINDEX);
 	outb((heartbeat & 255), SM_DATAIO);
 
 	/* Make sure keyboard/mouse interrupts don't interfere */
@@ -277,7 +282,7 @@ EXPORT_SYMBOL(iTCO_vendor_pre_set_heartbeat);
 
 int iTCO_vendor_check_noreboot_on(void)
 {
-	switch(vendorsupport) {
+	switch (vendorsupport) {
 	case SUPERMICRO_OLD_BOARD:
 		return 0;
 	default:
@@ -288,13 +293,13 @@ EXPORT_SYMBOL(iTCO_vendor_check_noreboot_on);
 
 static int __init iTCO_vendor_init_module(void)
 {
-	printk (KERN_INFO PFX "vendor-support=%d\n", vendorsupport);
+	printk(KERN_INFO PFX "vendor-support=%d\n", vendorsupport);
 	return 0;
 }
 
 static void __exit iTCO_vendor_exit_module(void)
 {
-	printk (KERN_INFO PFX "Module Unloaded\n");
+	printk(KERN_INFO PFX "Module Unloaded\n");
 }
 
 module_init(iTCO_vendor_init_module);
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index a0e6809..6bcfbea 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -65,7 +65,8 @@
 #include <linux/types.h>		/* For standard types (like size_t) */
 #include <linux/errno.h>		/* For the -ENODEV/... values */
 #include <linux/kernel.h>		/* For printk/panic/... */
-#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR) */
+#include <linux/miscdevice.h>		/* For MODULE_ALIAS_MISCDEV
+							(WATCHDOG_MINOR) */
 #include <linux/watchdog.h>		/* For the watchdog specific items */
 #include <linux/init.h>			/* For __init/__exit/... */
 #include <linux/fs.h>			/* For file operations */
@@ -73,9 +74,10 @@
 #include <linux/pci.h>			/* For pci functions */
 #include <linux/ioport.h>		/* For io-port access */
 #include <linux/spinlock.h>		/* For spin_lock/spin_unlock/... */
+#include <linux/uaccess.h>		/* For copy_to_user/put_user/... */
+#include <linux/io.h>			/* For inb/outb/... */
 
-#include <asm/uaccess.h>		/* For copy_to_user/put_user/... */
-#include <asm/io.h>			/* For inb/outb/... */
+#include "iTCO_vendor.h"
 
 /* TCO related info */
 enum iTCO_chipsets {
@@ -137,7 +139,7 @@ static struct {
 	{"ICH9R", 2},
 	{"ICH9DH", 2},
 	{"631xESB/632xESB", 2},
-	{NULL,0}
+	{NULL, 0}
 };
 
 #define ITCO_PCI_DEVICE(dev, data) 	\
@@ -156,31 +158,31 @@ static struct {
  * functions that probably will be registered by other drivers.
  */
 static struct pci_device_id iTCO_wdt_pci_tbl[] = {
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AA_0,	TCO_ICH    )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AB_0,	TCO_ICH0   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_0,	TCO_ICH2   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_10,	TCO_ICH2M  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_0,	TCO_ICH3   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_12,	TCO_ICH3M  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_0,	TCO_ICH4   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_12,	TCO_ICH4M  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801E_0,		TCO_CICH   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801EB_0,	TCO_ICH5   )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AA_0,	TCO_ICH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801AB_0,	TCO_ICH0)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_0,	TCO_ICH2)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801BA_10,	TCO_ICH2M)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_0,	TCO_ICH3)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801CA_12,	TCO_ICH3M)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_0,	TCO_ICH4)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801DB_12,	TCO_ICH4M)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801E_0,		TCO_CICH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_82801EB_0,	TCO_ICH5)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB_1,		TCO_6300ESB)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_0,		TCO_ICH6   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_1,		TCO_ICH6M  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_2,		TCO_ICH6W  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0,		TCO_ICH7   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M  )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_0,		TCO_ICH6)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_1,		TCO_ICH6M)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH6_2,		TCO_ICH6W)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_0,		TCO_ICH7)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_1,		TCO_ICH7M)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH7_31,		TCO_ICH7MDH)},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8   )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1,		TCO_ICH8ME )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4,		TCO_ICH8M  )},
-	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9   )},
-	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R  )},
-	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_0,		TCO_ICH8)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_1,		TCO_ICH8ME)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_2,		TCO_ICH8DH)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_3,		TCO_ICH8DO)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH8_4,		TCO_ICH8M)},
+	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9)},
+	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R)},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH)},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0,		TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2671,				TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2672,				TCO_631XESB)},
@@ -199,13 +201,15 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x267f,				TCO_631XESB)},
 	{ 0, },			/* End of list */
 };
-MODULE_DEVICE_TABLE (pci, iTCO_wdt_pci_tbl);
+MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
 
 /* Address definitions for the TCO */
-#define	TCOBASE		iTCO_wdt_private.ACPIBASE + 0x60	/* TCO base address                */
-#define	SMI_EN		iTCO_wdt_private.ACPIBASE + 0x30	/* SMI Control and Enable Register */
+/* TCO base address */
+#define	TCOBASE		iTCO_wdt_private.ACPIBASE + 0x60
+/* SMI Control and Enable Register */
+#define	SMI_EN		iTCO_wdt_private.ACPIBASE + 0x30
 
-#define TCO_RLD		TCOBASE + 0x00	/* TCO Timer Reload and Current Value */
+#define TCO_RLD		TCOBASE + 0x00	/* TCO Timer Reload and Curr. Value */
 #define TCOv1_TMR	TCOBASE + 0x01	/* TCOv1 Timer Initial Value	*/
 #define	TCO_DAT_IN	TCOBASE + 0x02	/* TCO Data In Register		*/
 #define	TCO_DAT_OUT	TCOBASE + 0x03	/* TCO Data Out Register	*/
@@ -218,15 +222,21 @@ MODULE_DEVICE_TABLE (pci, iTCO_wdt_pci_tbl);
 /* internal variables */
 static unsigned long is_active;
 static char expect_release;
-static struct {				/* this is private data for the iTCO_wdt device */
-	unsigned int iTCO_version;	/* TCO version/generation */
-	unsigned long ACPIBASE;		/* The cards ACPIBASE address (TCOBASE = ACPIBASE+0x60) */
-	unsigned long __iomem *gcs;	/* NO_REBOOT flag is Memory-Mapped GCS register bit 5 (TCO version 2) */
-	spinlock_t io_lock;		/* the lock for io operations */
-	struct pci_dev *pdev;		/* the PCI-device */
+static struct {		/* this is private data for the iTCO_wdt device */
+	/* TCO version/generation */
+	unsigned int iTCO_version;
+	/* The cards ACPIBASE address (TCOBASE = ACPIBASE+0x60) */
+	unsigned long ACPIBASE;
+	/* NO_REBOOT flag is Memory-Mapped GCS register bit 5 (TCO version 2)*/
+	unsigned long __iomem *gcs;
+	/* the lock for io operations */
+	spinlock_t io_lock;
+	/* the PCI-device */
+	struct pci_dev *pdev;
 } iTCO_wdt_private;
 
-static struct platform_device *iTCO_wdt_platform_device;	/* the watchdog platform device */
+/* the watchdog platform device */
+static struct platform_device *iTCO_wdt_platform_device;
 
 /* module parameters */
 #define WATCHDOG_HEARTBEAT 30	/* 30 sec default heartbeat */
@@ -236,22 +246,9 @@ MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. (2<heartbeat<39 (TCO
 
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
-MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
-
-/* iTCO Vendor Specific Support hooks */
-#ifdef CONFIG_ITCO_VENDOR_SUPPORT
-extern void iTCO_vendor_pre_start(unsigned long, unsigned int);
-extern void iTCO_vendor_pre_stop(unsigned long);
-extern void iTCO_vendor_pre_keepalive(unsigned long, unsigned int);
-extern void iTCO_vendor_pre_set_heartbeat(unsigned int);
-extern int iTCO_vendor_check_noreboot_on(void);
-#else
-#define iTCO_vendor_pre_start(acpibase, heartbeat)	{}
-#define iTCO_vendor_pre_stop(acpibase)			{}
-#define iTCO_vendor_pre_keepalive(acpibase,heartbeat)	{}
-#define iTCO_vendor_pre_set_heartbeat(heartbeat)	{}
-#define iTCO_vendor_check_noreboot_on()			1	/* 1=check noreboot; 0=don't check */
-#endif
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+				__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
 
 /*
  * Some TCO specific functions
@@ -365,11 +362,10 @@ static int iTCO_wdt_keepalive(void)
 	iTCO_vendor_pre_keepalive(iTCO_wdt_private.ACPIBASE, heartbeat);
 
 	/* Reload the timer by writing to the TCO Timer Counter register */
-	if (iTCO_wdt_private.iTCO_version == 2) {
+	if (iTCO_wdt_private.iTCO_version == 2)
 		outw(0x01, TCO_RLD);
-	} else if (iTCO_wdt_private.iTCO_version == 1) {
+	else if (iTCO_wdt_private.iTCO_version == 1)
 		outb(0x01, TCO_RLD);
-	}
 
 	spin_unlock(&iTCO_wdt_private.io_lock);
 	return 0;
@@ -421,7 +417,7 @@ static int iTCO_wdt_set_heartbeat(int t)
 	return 0;
 }
 
-static int iTCO_wdt_get_timeleft (int *time_left)
+static int iTCO_wdt_get_timeleft(int *time_left)
 {
 	unsigned int val16;
 	unsigned char val8;
@@ -450,7 +446,7 @@ static int iTCO_wdt_get_timeleft (int *time_left)
  *	/dev/watchdog handling
  */
 
-static int iTCO_wdt_open (struct inode *inode, struct file *file)
+static int iTCO_wdt_open(struct inode *inode, struct file *file)
 {
 	/* /dev/watchdog can only be opened once */
 	if (test_and_set_bit(0, &is_active))
@@ -464,7 +460,7 @@ static int iTCO_wdt_open (struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
-static int iTCO_wdt_release (struct inode *inode, struct file *file)
+static int iTCO_wdt_release(struct inode *inode, struct file *file)
 {
 	/*
 	 *      Shut off the timer.
@@ -472,7 +468,8 @@ static int iTCO_wdt_release (struct inode *inode, struct file *file)
 	if (expect_release == 42) {
 		iTCO_wdt_stop();
 	} else {
-		printk(KERN_CRIT PFX "Unexpected close, not stopping watchdog!\n");
+		printk(KERN_CRIT PFX
+			"Unexpected close, not stopping watchdog!\n");
 		iTCO_wdt_keepalive();
 	}
 	clear_bit(0, &is_active);
@@ -480,19 +477,20 @@ static int iTCO_wdt_release (struct inode *inode, struct file *file)
 	return 0;
 }
 
-static ssize_t iTCO_wdt_write (struct file *file, const char __user *data,
-			      size_t len, loff_t * ppos)
+static ssize_t iTCO_wdt_write(struct file *file, const char __user *data,
+			      size_t len, loff_t *ppos)
 {
 	/* See if we got the magic character 'V' and reload the timer */
 	if (len) {
 		if (!nowayout) {
 			size_t i;
 
-			/* note: just in case someone wrote the magic character
-			 * five months ago... */
+			/* note: just in case someone wrote the magic
+			   character five months ago... */
 			expect_release = 0;
 
-			/* scan to see whether or not we got the magic character */
+			/* scan to see whether or not we got the
+			   magic character */
 			for (i = 0; i != len; i++) {
 				char c;
 				if (get_user(c, data+i))
@@ -508,8 +506,8 @@ static ssize_t iTCO_wdt_write (struct file *file, const char __user *data,
 	return len;
 }
 
-static int iTCO_wdt_ioctl (struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg)
+static long iTCO_wdt_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	int new_options, retval = -EINVAL;
 	int new_heartbeat;
@@ -524,64 +522,52 @@ static int iTCO_wdt_ioctl (struct inode *inode, struct file *file,
 	};
 
 	switch (cmd) {
-		case WDIOC_GETSUPPORT:
-			return copy_to_user(argp, &ident,
-				sizeof (ident)) ? -EFAULT : 0;
-
-		case WDIOC_GETSTATUS:
-		case WDIOC_GETBOOTSTATUS:
-			return put_user(0, p);
-
-		case WDIOC_KEEPALIVE:
-			iTCO_wdt_keepalive();
-			return 0;
+	case WDIOC_GETSUPPORT:
+		return copy_to_user(argp, &ident, sizeof(ident)) ? -EFAULT : 0;
+	case WDIOC_GETSTATUS:
+	case WDIOC_GETBOOTSTATUS:
+		return put_user(0, p);
 
-		case WDIOC_SETOPTIONS:
-		{
-			if (get_user(new_options, p))
-				return -EFAULT;
-
-			if (new_options & WDIOS_DISABLECARD) {
-				iTCO_wdt_stop();
-				retval = 0;
-			}
+	case WDIOC_KEEPALIVE:
+		iTCO_wdt_keepalive();
+		return 0;
 
-			if (new_options & WDIOS_ENABLECARD) {
-				iTCO_wdt_keepalive();
-				iTCO_wdt_start();
-				retval = 0;
-			}
+	case WDIOC_SETOPTIONS:
+	{
+		if (get_user(new_options, p))
+			return -EFAULT;
 
-			return retval;
+		if (new_options & WDIOS_DISABLECARD) {
+			iTCO_wdt_stop();
+			retval = 0;
 		}
-
-		case WDIOC_SETTIMEOUT:
-		{
-			if (get_user(new_heartbeat, p))
-				return -EFAULT;
-
-			if (iTCO_wdt_set_heartbeat(new_heartbeat))
-				return -EINVAL;
-
+		if (new_options & WDIOS_ENABLECARD) {
 			iTCO_wdt_keepalive();
-			/* Fall */
+			iTCO_wdt_start();
+			retval = 0;
 		}
-
-		case WDIOC_GETTIMEOUT:
-			return put_user(heartbeat, p);
-
-		case WDIOC_GETTIMELEFT:
-		{
-			int time_left;
-
-			if (iTCO_wdt_get_timeleft(&time_left))
-				return -EINVAL;
-
-			return put_user(time_left, p);
-		}
-
-		default:
-			return -ENOTTY;
+		return retval;
+	}
+	case WDIOC_SETTIMEOUT:
+	{
+		if (get_user(new_heartbeat, p))
+			return -EFAULT;
+		if (iTCO_wdt_set_heartbeat(new_heartbeat))
+			return -EINVAL;
+		iTCO_wdt_keepalive();
+		/* Fall */
+	}
+	case WDIOC_GETTIMEOUT:
+		return put_user(heartbeat, p);
+	case WDIOC_GETTIMELEFT:
+	{
+		int time_left;
+		if (iTCO_wdt_get_timeleft(&time_left))
+			return -EINVAL;
+		return put_user(time_left, p);
+	}
+	default:
+		return -ENOTTY;
 	}
 }
 
@@ -590,12 +576,12 @@ static int iTCO_wdt_ioctl (struct inode *inode, struct file *file,
  */
 
 static const struct file_operations iTCO_wdt_fops = {
-	.owner =	THIS_MODULE,
-	.llseek =	no_llseek,
-	.write =	iTCO_wdt_write,
-	.ioctl =	iTCO_wdt_ioctl,
-	.open =		iTCO_wdt_open,
-	.release =	iTCO_wdt_release,
+	.owner =		THIS_MODULE,
+	.llseek =		no_llseek,
+	.write =		iTCO_wdt_write,
+	.unlocked_ioctl =	iTCO_wdt_ioctl,
+	.open =			iTCO_wdt_open,
+	.release =		iTCO_wdt_release,
 };
 
 static struct miscdevice iTCO_wdt_miscdev = {
@@ -608,7 +594,8 @@ static struct miscdevice iTCO_wdt_miscdev = {
  *	Init & exit routines
  */
 
-static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device_id *ent, struct platform_device *dev)
+static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
+		const struct pci_device_id *ent, struct platform_device *dev)
 {
 	int ret;
 	u32 base_address;
@@ -628,17 +615,19 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device
 		pci_dev_put(pdev);
 		return -ENODEV;
 	}
-	iTCO_wdt_private.iTCO_version = iTCO_chipset_info[ent->driver_data].iTCO_version;
+	iTCO_wdt_private.iTCO_version =
+			iTCO_chipset_info[ent->driver_data].iTCO_version;
 	iTCO_wdt_private.ACPIBASE = base_address;
 	iTCO_wdt_private.pdev = pdev;
 
-	/* Get the Memory-Mapped GCS register, we need it for the NO_REBOOT flag (TCO v2) */
-	/* To get access to it you have to read RCBA from PCI Config space 0xf0
-	   and use it as base. GCS = RCBA + ICH6_GCS(0x3410). */
+	/* Get the Memory-Mapped GCS register, we need it for the
+	   NO_REBOOT flag (TCO v2). To get access to it you have to
+	   read RCBA from PCI Config space 0xf0 and use it as base.
+	   GCS = RCBA + ICH6_GCS(0x3410). */
 	if (iTCO_wdt_private.iTCO_version == 2) {
 		pci_read_config_dword(pdev, 0xf0, &base_address);
 		RCBA = base_address & 0xffffc000;
-		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410),4);
+		iTCO_wdt_private.gcs = ioremap((RCBA + 0x3410), 4);
 	}
 
 	/* Check chipset's NO_REBOOT bit */
@@ -653,8 +642,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device
 
 	/* Set the TCO_EN bit in SMI_EN register */
 	if (!request_region(SMI_EN, 4, "iTCO_wdt")) {
-		printk(KERN_ERR PFX "I/O address 0x%04lx already in use\n",
-			SMI_EN );
+		printk(KERN_ERR PFX
+			"I/O address 0x%04lx already in use\n", SMI_EN);
 		ret = -EIO;
 		goto out;
 	}
@@ -663,18 +652,20 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device
 	outl(val32, SMI_EN);
 	release_region(SMI_EN, 4);
 
-	/* The TCO I/O registers reside in a 32-byte range pointed to by the TCOBASE value */
-	if (!request_region (TCOBASE, 0x20, "iTCO_wdt")) {
-		printk (KERN_ERR PFX "I/O address 0x%04lx already in use\n",
+	/* The TCO I/O registers reside in a 32-byte range pointed to
+	   by the TCOBASE value */
+	if (!request_region(TCOBASE, 0x20, "iTCO_wdt")) {
+		printk(KERN_ERR PFX "I/O address 0x%04lx already in use\n",
 			TCOBASE);
 		ret = -EIO;
 		goto out;
 	}
 
-	printk(KERN_INFO PFX "Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
-		iTCO_chipset_info[ent->driver_data].name,
-		iTCO_chipset_info[ent->driver_data].iTCO_version,
-		TCOBASE);
+	printk(KERN_INFO PFX
+		"Found a %s TCO device (Version=%d, TCOBASE=0x%04lx)\n",
+			iTCO_chipset_info[ent->driver_data].name,
+			iTCO_chipset_info[ent->driver_data].iTCO_version,
+			TCOBASE);
 
 	/* Clear out the (probably old) status */
 	outb(0, TCO1_STS);
@@ -683,27 +674,29 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev, const struct pci_device
 	/* Make sure the watchdog is not running */
 	iTCO_wdt_stop();
 
-	/* Check that the heartbeat value is within it's range ; if not reset to the default */
+	/* Check that the heartbeat value is within it's range;
+	   if not reset to the default */
 	if (iTCO_wdt_set_heartbeat(heartbeat)) {
 		iTCO_wdt_set_heartbeat(WATCHDOG_HEARTBEAT);
-		printk(KERN_INFO PFX "heartbeat value must be 2<heartbeat<39 (TCO v1) or 613 (TCO v2), using %d\n",
-			heartbeat);
+		printk(KERN_INFO PFX "heartbeat value must be 2 < heartbeat < 39 (TCO v1) or 613 (TCO v2), using %d\n",
+							heartbeat);
 	}
 
 	ret = misc_register(&iTCO_wdt_miscdev);
 	if (ret != 0) {
-		printk(KERN_ERR PFX "cannot register miscdev on minor=%d (err=%d)\n",
-			WATCHDOG_MINOR, ret);
+		printk(KERN_ERR PFX
+			"cannot register miscdev on minor=%d (err=%d)\n",
+							WATCHDOG_MINOR, ret);
 		goto unreg_region;
 	}
 
-	printk (KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
-		heartbeat, nowayout);
+	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
+							heartbeat, nowayout);
 
 	return 0;
 
 unreg_region:
-	release_region (TCOBASE, 0x20);
+	release_region(TCOBASE, 0x20);
 out:
 	if (iTCO_wdt_private.iTCO_version == 2)
 		iounmap(iTCO_wdt_private.gcs);
@@ -792,7 +785,8 @@ static int __init iTCO_wdt_init_module(void)
 	if (err)
 		return err;
 
-	iTCO_wdt_platform_device = platform_device_register_simple(DRV_NAME, -1, NULL, 0);
+	iTCO_wdt_platform_device = platform_device_register_simple(DRV_NAME,
+								-1, NULL, 0);
 	if (IS_ERR(iTCO_wdt_platform_device)) {
 		err = PTR_ERR(iTCO_wdt_platform_device);
 		goto unreg_platform_driver;

