Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZFESqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZFESqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:46:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753288AbZFESqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:46:17 -0400
Received: from 195-23-16-24.net.novis.pt ([195.23.16.24]:56204 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbZFESqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:46:14 -0400
Message-ID: <4A2967F6.2000303@grupopie.com>
Date: Fri, 05 Jun 2009 19:46:14 +0100
From: Rui Santos <rsantos@grupopie.com>
Organization: GrupoPIE, Portugal SA
User-Agent: Thunderbird 2.0.0.21 (X11/20090310)
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: Stephen Clark <sclark46@earthlink.net>,
       Denys Fedoryschenko <denys@visp.net.lb>,
       Johannes Dewender <arch@jonnyjd.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>,
       Rutger Nijlunsing <bugzilla.kernel@tux.tmfweb.nl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andriy Gapon <avg@icyb.net.ua>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] iTCO_wdt.c - ICH9 reboot issue - testing wanted
References: <20090430094918.GC4141@infomag.iguana.be>
In-Reply-To: <20090430094918.GC4141@infomag.iguana.be>
Content-Type: multipart/mixed;
 boundary="------------000906060209040709000403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000906060209040709000403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Wim Van Sebroeck wrote:
> Hi All,
>   
Hi Wim, Hi All,
> I'm looking for people that can test the below patch(es).
> I'm mainly interested in knowing if you experience any side-effects when using this patch.
> (See also bugzilla 9868, 10195, 12363 & 12162).
>
> For people not using the watchdog or without any reboot problems the driver should
> work as normal after compilation/installation/...
>
> For people that have the ICH9 reboot problems: load the module with module-parameter
> gbl_smi_en=0 and test the watchdog functionality again.
>   

With your patch, the Intel DG35EC board will not allow my distribution
reboot or halt the machine. In order to circumvent that problem, I've
made a few addition to your previous patch witch allows the restore of
the changed Bit 0 to it's previous value if the module is unloaded.
My only doubt is if it should be done every time the gbl_smi_en is zero,
or in conjunction with nowayout when the value also equals zero. This
patch has what I described and a commented gbl_smi_en only.

Can anyone share his/her thoughts on this matter.

> Thanks in advance,
> Wim.
>   
Regards,
Rui


--------------000906060209040709000403
Content-Type: text/x-patch;
 name="linux-2.6.30-rc8-watchdog.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.30-rc8-watchdog.patch"

diff -upr linux-2.6.30-rc8.ori/drivers/watchdog/iTCO_wdt.c linux-2.6.30-rc8.new/drivers/watchdog/iTCO_wdt.c
--- linux-2.6.30-rc8.ori/drivers/watchdog/iTCO_wdt.c	2009-06-05 19:26:07.000000000 +0100
+++ linux-2.6.30-rc8.new/drivers/watchdog/iTCO_wdt.c	2009-06-05 19:33:03.000000000 +0100
@@ -63,7 +63,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_wdt"
-#define DRV_VERSION	"1.05"
+#define DRV_VERSION	"1.06"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -277,6 +277,13 @@ MODULE_PARM_DESC(heartbeat, "Watchdog he
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
@@ -412,6 +419,23 @@ static int iTCO_wdt_keepalive(void)
 	return 0;
 }
 
+static int iTCO_wdt_restore_gbl_smi_en(void)
+{
+	unsigned long val32;
+
+	/* Remove the TCO_EN bit in SMI_EN register */
+	if (!request_region(SMI_EN, 4, "iTCO_wdt"))
+		printk(KERN_ERR PFX "Restore of gbl_smi_en was not successful\n");
+	else {
+		val32 = inl(SMI_EN);
+		val32 |= 0x00000001;
+		outl(val32, SMI_EN);
+		release_region(SMI_EN, 4);
+	}
+
+	return 0;
+}
+
 static int iTCO_wdt_set_heartbeat(int t)
 {
 	unsigned int val16;
@@ -688,9 +712,12 @@ static int __devinit iTCO_wdt_init(struc
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
@@ -733,8 +760,8 @@ static int __devinit iTCO_wdt_init(struc
 		goto unreg_region;
 	}
 
-	printk(KERN_INFO PFX "initialized. heartbeat=%d sec (nowayout=%d)\n",
-							heartbeat, nowayout);
+	printk(KERN_INFO PFX "initialized. heartbeat=%d sec, gbl_smi_en=%d "
+		"(nowayout=%d)\n", heartbeat, gbl_smi_en, nowayout);
 
 	return 0;
 
@@ -847,6 +874,9 @@ unreg_platform_driver:
 
 static void __exit iTCO_wdt_cleanup_module(void)
 {
+	//if (gbl_smi_en == 0)
+	if (gbl_smi_en == 0 && nowayout == 0)
+		iTCO_wdt_restore_gbl_smi_en();
 	platform_device_unregister(iTCO_wdt_platform_device);
 	platform_driver_unregister(&iTCO_wdt_driver);
 	printk(KERN_INFO PFX "Watchdog Module Unloaded.\n");

--------------000906060209040709000403--
