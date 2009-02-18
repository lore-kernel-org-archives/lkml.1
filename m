Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbZBRVgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbZBRVgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbZBRVfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:35:30 -0500
Received: from kroah.org ([198.145.64.141]:56070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753930AbZBRVf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:35:29 -0500
Date: Wed, 18 Feb 2009 13:32:17 -0800
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
       alan@lxorguk.ukuu.org.uk, Wim Van Sebroeck <wim@iguana.be>
Subject: [patch 03/39] WATCHDOG: iTCO_wdt: fix SMI_EN regression 2
Message-ID: <20090218213217.GD19814@kroah.com>
References: <20090218212144.965748151@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="watchdog-itco_wdt-fix-smi_en-regression-2.patch"
In-Reply-To: <20090218213021.GA19814@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wim Van Sebroeck <wim@iguana.be>

commit 12d60e28bed3f593aac5385acbdbb089eb8ae21e upstream.

bugzilla: #12363
commit 7cd5b08be3c489df11b559fef210b81133764ad4 added a second regression:
some Dell's and Compaq's lockup on boot. So we revert most of the code.
The ICH9 reboot issue remains in place and will need some more fixing... :-(

Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/watchdog/Kconfig               |    2 -
 drivers/watchdog/iTCO_vendor_support.c |   32 ++++++++++++++++++++++++++----
 drivers/watchdog/iTCO_wdt.c            |   35 +++++++++++++--------------------
 3 files changed, 43 insertions(+), 26 deletions(-)

--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -1,7 +1,7 @@
 /*
  *	intel TCO vendor specific watchdog driver support
  *
- *	(c) Copyright 2006-2008 Wim Van Sebroeck <wim@iguana.be>.
+ *	(c) Copyright 2006-2009 Wim Van Sebroeck <wim@iguana.be>.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -19,7 +19,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_vendor_support"
-#define DRV_VERSION	"1.02"
+#define DRV_VERSION	"1.03"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -77,6 +77,26 @@ MODULE_PARM_DESC(vendorsupport, "iTCO ve
  *	    20.6 seconds.
  */
 
+static void supermicro_old_pre_start(unsigned long acpibase)
+{
+	unsigned long val32;
+
+	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
+	val32 = inl(SMI_EN);
+	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
+	outl(val32, SMI_EN);	/* Needed to activate watchdog */
+}
+
+static void supermicro_old_pre_stop(unsigned long acpibase)
+{
+	unsigned long val32;
+
+	/* Bit 13: TCO_EN -> 1 = Enables the TCO logic to generate SMI# */
+	val32 = inl(SMI_EN);
+	val32 |= 0x00002000;	/* Turn on SMI clearing watchdog */
+	outl(val32, SMI_EN);	/* Needed to deactivate watchdog */
+}
+
 static void supermicro_old_pre_keepalive(unsigned long acpibase)
 {
 	/* Reload TCO Timer (done in iTCO_wdt_keepalive) + */
@@ -228,14 +248,18 @@ static void supermicro_new_pre_set_heart
 void iTCO_vendor_pre_start(unsigned long acpibase,
 			   unsigned int heartbeat)
 {
-	if (vendorsupport == SUPERMICRO_NEW_BOARD)
+	if (vendorsupport == SUPERMICRO_OLD_BOARD)
+		supermicro_old_pre_start(acpibase);
+	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
 		supermicro_new_pre_start(heartbeat);
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_start);
 
 void iTCO_vendor_pre_stop(unsigned long acpibase)
 {
-	if (vendorsupport == SUPERMICRO_NEW_BOARD)
+	if (vendorsupport == SUPERMICRO_OLD_BOARD)
+		supermicro_old_pre_stop(acpibase);
+	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
 		supermicro_new_pre_stop();
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_stop);
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -1,7 +1,7 @@
 /*
- *	intel TCO Watchdog Driver (Used in i82801 and i6300ESB chipsets)
+ *	intel TCO Watchdog Driver (Used in i82801 and i63xxESB chipsets)
  *
- *	(c) Copyright 2006-2008 Wim Van Sebroeck <wim@iguana.be>.
+ *	(c) Copyright 2006-2009 Wim Van Sebroeck <wim@iguana.be>.
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -63,7 +63,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_wdt"
-#define DRV_VERSION	"1.04"
+#define DRV_VERSION	"1.05"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -236,16 +236,16 @@ MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tb
 
 /* Address definitions for the TCO */
 /* TCO base address */
-#define	TCOBASE		iTCO_wdt_private.ACPIBASE + 0x60
+#define TCOBASE		iTCO_wdt_private.ACPIBASE + 0x60
 /* SMI Control and Enable Register */
-#define	SMI_EN		iTCO_wdt_private.ACPIBASE + 0x30
+#define SMI_EN		iTCO_wdt_private.ACPIBASE + 0x30
 
 #define TCO_RLD		TCOBASE + 0x00	/* TCO Timer Reload and Curr. Value */
 #define TCOv1_TMR	TCOBASE + 0x01	/* TCOv1 Timer Initial Value	*/
-#define	TCO_DAT_IN	TCOBASE + 0x02	/* TCO Data In Register		*/
-#define	TCO_DAT_OUT	TCOBASE + 0x03	/* TCO Data Out Register	*/
-#define	TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register		*/
-#define	TCO2_STS	TCOBASE + 0x06	/* TCO2 Status Register		*/
+#define TCO_DAT_IN	TCOBASE + 0x02	/* TCO Data In Register		*/
+#define TCO_DAT_OUT	TCOBASE + 0x03	/* TCO Data Out Register	*/
+#define TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register		*/
+#define TCO2_STS	TCOBASE + 0x06	/* TCO2 Status Register		*/
 #define TCO1_CNT	TCOBASE + 0x08	/* TCO1 Control Register	*/
 #define TCO2_CNT	TCOBASE + 0x0a	/* TCO2 Control Register	*/
 #define TCOv2_TMR	TCOBASE + 0x12	/* TCOv2 Timer Initial Value	*/
@@ -338,7 +338,6 @@ static int iTCO_wdt_unset_NO_REBOOT_bit(
 static int iTCO_wdt_start(void)
 {
 	unsigned int val;
-	unsigned long val32;
 
 	spin_lock(&iTCO_wdt_private.io_lock);
 
@@ -351,11 +350,6 @@ static int iTCO_wdt_start(void)
 		return -EIO;
 	}
 
-	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
-	val32 = inl(SMI_EN);
-	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
-	outl(val32, SMI_EN);
-
 	/* Force the timer to its reload value by writing to the TCO_RLD
 	   register */
 	if (iTCO_wdt_private.iTCO_version == 2)
@@ -378,7 +372,6 @@ static int iTCO_wdt_start(void)
 static int iTCO_wdt_stop(void)
 {
 	unsigned int val;
-	unsigned long val32;
 
 	spin_lock(&iTCO_wdt_private.io_lock);
 
@@ -390,11 +383,6 @@ static int iTCO_wdt_stop(void)
 	outw(val, TCO1_CNT);
 	val = inw(TCO1_CNT);
 
-	/* Bit 13: TCO_EN -> 1 = Enables the TCO logic to generate SMI# */
-	val32 = inl(SMI_EN);
-	val32 |= 0x00002000;
-	outl(val32, SMI_EN);
-
 	/* Set the NO_REBOOT bit to prevent later reboots, just for sure */
 	iTCO_wdt_set_NO_REBOOT_bit();
 
@@ -649,6 +637,7 @@ static int __devinit iTCO_wdt_init(struc
 	int ret;
 	u32 base_address;
 	unsigned long RCBA;
+	unsigned long val32;
 
 	/*
 	 *      Find the ACPI/PM base I/O address which is the base
@@ -695,6 +684,10 @@ static int __devinit iTCO_wdt_init(struc
 		ret = -EIO;
 		goto out;
 	}
+	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
+	val32 = inl(SMI_EN);
+	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
+	outl(val32, SMI_EN);
 
 	/* The TCO I/O registers reside in a 32-byte range pointed to
 	   by the TCOBASE value */
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -399,7 +399,7 @@ config ITCO_WDT
 	---help---
 	  Hardware driver for the intel TCO timer based watchdog devices.
 	  These drivers are included in the Intel 82801 I/O Controller
-	  Hub family (from ICH0 up to ICH8) and in the Intel 6300ESB
+	  Hub family (from ICH0 up to ICH10) and in the Intel 63xxESB
 	  controller hub.
 
 	  The TCO (Total Cost of Ownership) timer is a watchdog timer

