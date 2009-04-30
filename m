Return-Path: <linux-kernel-owner+w=401wt.eu-S1762317AbZD3Jtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762317AbZD3Jtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 05:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761765AbZD3JtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 05:49:23 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:17122 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758647AbZD3JtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 05:49:20 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAGMR+UlR9Rtd/2dsb2JhbADPSgeDeAU
Date: Thu, 30 Apr 2009 11:49:18 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Clark <sclark46@earthlink.net>,
       Denys Fedoryschenko <denys@visp.net.lb>,
       Johannes Dewender <arch@jonnyjd.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>,
       Rutger Nijlunsing <bugzilla.kernel@tux.tmfweb.nl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Cc: Andriy Gapon <avg@icyb.net.ua>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [WATCHDOG] iTCO_wdt.c - ICH9 reboot issue - testing wanted
Message-ID: <20090430094918.GC4141@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I'm looking for people that can test the below patch(es).
I'm mainly interested in knowing if you experience any side-effects when using this patch.
(See also bugzilla 9868, 10195, 12363 & 12162).

For people not using the watchdog or without any reboot problems the driver should
work as normal after compilation/installation/...

For people that have the ICH9 reboot problems: load the module with module-parameter
gbl_smi_en=0 and test the watchdog functionality again.

Thanks in advance,
Wim.

The Changes are:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Thu Apr 30 09:13:33 2009 +0000

    [WATCHDOG] iTCO_wdt: Fix ICH9 reboot issue.
    
    Bugzilla: 9868 & 10195.
    There seems to be a bug into the SMM code that handles TCO Timeout SMI.
    Andriy Gapon found that the code on his DG33TL system does the following:
    > The handler is quite simple - it tests value in TCO1_CNT against 0x800, i.e.
    > checks TCO_TMR_HLT. If the bit is set the handler goes into an infinite loop,
    > apparently to allow the second timeout and reboot. Otherwise it simply clears
    > TIMEOUT bit in TCO1_STS and that's it.
    > So the logic seems to be reversed, because it is hard to see how TIMEOUT can
    > get set to 1 and SMI generated when TCO_TMR_HLT is set (other than a
    > transitional effect).
    
    The only trick we have is to bypass the SMM code by turning of the generation
    of the SMI#. The trick can only be enabled by setting the gbl_smi_en module
    parameter to 0.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Tue Apr 14 20:20:07 2009 +0000

    [WATCHDOG] iTCO_wdt: Cleanup code
    
    Clean-up the iTCO_wdt code so that checkpatch.pl get's happy...
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index d3c0f6d..843ef62 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -35,9 +35,9 @@
 #include "iTCO_vendor.h"
 
 /* iTCO defines */
-#define	SMI_EN		acpibase + 0x30	/* SMI Control and Enable Register */
-#define	TCOBASE		acpibase + 0x60	/* TCO base address */
-#define	TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register */
+#define	SMI_EN		(acpibase + 0x30) /* SMI Control and Enable Register */
+#define	TCOBASE		(acpibase + 0x60) /* TCO base address */
+#define	TCO1_STS	(TCOBASE + 0x04)  /* TCO1 Status Register */
 
 /* List of vendor support modes */
 /* SuperMicro Pentium 3 Era 370SSE+-OEM1/P3TSSE */
diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index 648250b..b76d1ec 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -63,7 +63,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_wdt"
-#define DRV_VERSION	"1.05"
+#define DRV_VERSION	"1.06"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -236,19 +236,19 @@ MODULE_DEVICE_TABLE(pci, iTCO_wdt_pci_tbl);
 
 /* Address definitions for the TCO */
 /* TCO base address */
-#define TCOBASE		iTCO_wdt_private.ACPIBASE + 0x60
+#define TCOBASE		(iTCO_wdt_private.ACPIBASE + 0x60)
 /* SMI Control and Enable Register */
-#define SMI_EN		iTCO_wdt_private.ACPIBASE + 0x30
-
-#define TCO_RLD		TCOBASE + 0x00	/* TCO Timer Reload and Curr. Value */
-#define TCOv1_TMR	TCOBASE + 0x01	/* TCOv1 Timer Initial Value	*/
-#define TCO_DAT_IN	TCOBASE + 0x02	/* TCO Data In Register		*/
-#define TCO_DAT_OUT	TCOBASE + 0x03	/* TCO Data Out Register	*/
-#define TCO1_STS	TCOBASE + 0x04	/* TCO1 Status Register		*/
-#define TCO2_STS	TCOBASE + 0x06	/* TCO2 Status Register		*/
-#define TCO1_CNT	TCOBASE + 0x08	/* TCO1 Control Register	*/
-#define TCO2_CNT	TCOBASE + 0x0a	/* TCO2 Control Register	*/
-#define TCOv2_TMR	TCOBASE + 0x12	/* TCOv2 Timer Initial Value	*/
+#define SMI_EN		(iTCO_wdt_private.ACPIBASE + 0x30)
+
+#define TCO_RLD		(TCOBASE + 0x00) /* TCO Timer Reload and Curr. Value */
+#define TCOv1_TMR	(TCOBASE + 0x01) /* TCOv1 Timer Initial Value	*/
+#define TCO_DAT_IN	(TCOBASE + 0x02) /* TCO Data In Register	*/
+#define TCO_DAT_OUT	(TCOBASE + 0x03) /* TCO Data Out Register	*/
+#define TCO1_STS	(TCOBASE + 0x04) /* TCO1 Status Register	*/
+#define TCO2_STS	(TCOBASE + 0x06) /* TCO2 Status Register	*/
+#define TCO1_CNT	(TCOBASE + 0x08) /* TCO1 Control Register	*/
+#define TCO2_CNT	(TCOBASE + 0x0a) /* TCO2 Control Register	*/
+#define TCOv2_TMR	(TCOBASE + 0x12) /* TCOv2 Timer Initial Value	*/
 
 /* internal variables */
 static unsigned long is_active;
@@ -277,6 +277,13 @@ MODULE_PARM_DESC(heartbeat, "Watchdog heartbeat in seconds. "
 	"(2<heartbeat<39 (TCO v1) or 613 (TCO v2), default="
 				__MODULE_STRING(WATCHDOG_HEARTBEAT) ")");
 
+#define GBL_SMI_EN_DEFAULT 1	/* 1 = don't turn GBL_SMI_EN off */
+static int gbl_smi_en = GBL_SMI_EN_DEFAULT;
+module_param(gbl_smi_en, int, 0);
+MODULE_PARM_DESC(gbl_smi_en,
+	"Turn GBL_SMI_EN off to fix reboot issues on ICH9..., default="
+				__MODULE_STRING(GBL_SMI_EN_DEFAULT) ")");
+
 static int nowayout = WATCHDOG_NOWAYOUT;
 module_param(nowayout, int, 0);
 MODULE_PARM_DESC(nowayout,
@@ -688,9 +695,12 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 		ret = -EIO;
 		goto out;
 	}
-	/* Bit 13: TCO_EN -> 0 = Disables TCO logic generating an SMI# */
 	val32 = inl(SMI_EN);
+	/* Bit 13: TCO_EN     -> 0 = Disables TCO logic generating an SMI#
+	   Bit  0: GBL_SMI_EN -> 0 = No SMI# will be generated by ICH9. */
 	val32 &= 0xffffdfff;	/* Turn off SMI clearing watchdog */
+	if (gbl_smi_en == 0)
+		val32 &= 0xfffffffe;	/* Turn off GBL_SMI_EN */
 	outl(val32, SMI_EN);
 
 	/* The TCO I/O registers reside in a 32-byte range pointed to
@@ -733,8 +743,8 @@ static int __devinit iTCO_wdt_init(struct pci_dev *pdev,
 		goto unreg_region;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
-							heartbeat, nowayout);
+	printk(KERN_INFO PFX "initialized. heartbeat=%d sec, gbl_smi_en=%d "
+		"(nowayout=%d)\n", heartbeat, gbl_smi_en, nowayout);
 
 	return 0;
 
