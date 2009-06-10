Return-Path: <linux-kernel-owner+w=401wt.eu-S1756986AbZFJITE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986AbZFJITE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 04:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbZFJISu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 04:18:50 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:49111 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754984AbZFJISr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 04:18:47 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAK4HL0pR9RoT/2dsb2JhbADNXwiEBAU
Date: Wed, 10 Jun 2009 10:18:45 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Rui Santos <rsantos@grupopie.com>
Cc: Stephen Clark <sclark46@earthlink.net>,
       Denys Fedoryschenko <denys@visp.net.lb>,
       Johannes Dewender <arch@jonnyjd.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Frans Pop <elendil@planet.nl>,
       Rutger Nijlunsing <bugzilla.kernel@tux.tmfweb.nl>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andriy Gapon <avg@icyb.net.ua>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [WATCHDOG] iTCO_wdt.c - ICH9 reboot issue - testing wanted
Message-ID: <20090610081845.GH16090@infomag.iguana.be>
References: <20090430094918.GC4141@infomag.iguana.be> <4A2967F6.2000303@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A2967F6.2000303@grupopie.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

> With your patch, the Intel DG35EC board will not allow my distribution
> reboot or halt the machine. In order to circumvent that problem, I've
> made a few addition to your previous patch witch allows the restore of
> the changed Bit 0 to it's previous value if the module is unloaded.
> My only doubt is if it should be done every time the gbl_smi_en is zero,
> or in conjunction with nowayout when the value also equals zero. This
> patch has what I described and a commented gbl_smi_en only.

Forget the previous patch. I don't like having this hack in the main iTCO_wdt code.
So I added it to the iTCO_vendor_support code with the necessary warnings.
Can you test this (please note that the iTCO_vendor_support module needs to be
loaded with the vendorsupport=911 module parameter).

Thanks in advance,
Wim.

---
commit 8a590d97277819e6693a47ca776ceee9ac74fda3
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Jun 8 17:41:51 2009 +0000

    [WATCHDOG] iTCO_wdt: Fix ICH7+ reboot issue.
    
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
    of the SMI#. The trick can only be enabled by setting the vendorsupport module
    parameter to 911. This trick doesn't work well on laptop's.
    
    Note: this is a dirty hack. Please handle with care. The only real fix is that
    the bug in the SMM bios code get's fixed.
    
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/drivers/watchdog/iTCO_vendor_support.c b/drivers/watchdog/iTCO_vendor_support.c
index 843ef62..5133bca 100644
--- a/drivers/watchdog/iTCO_vendor_support.c
+++ b/drivers/watchdog/iTCO_vendor_support.c
@@ -19,7 +19,7 @@
 
 /* Module and version information */
 #define DRV_NAME	"iTCO_vendor_support"
-#define DRV_VERSION	"1.03"
+#define DRV_VERSION	"1.04"
 #define PFX		DRV_NAME ": "
 
 /* Includes */
@@ -44,11 +44,14 @@
 #define SUPERMICRO_OLD_BOARD	1
 /* SuperMicro Pentium 4 / Xeon 4 / EMT64T Era Systems */
 #define SUPERMICRO_NEW_BOARD	2
+/* Broken BIOS */
+#define BROKEN_BIOS		911
 
 static int vendorsupport;
 module_param(vendorsupport, int, 0);
 MODULE_PARM_DESC(vendorsupport, "iTCO vendor specific support mode, default="
-			"0 (none), 1=SuperMicro Pent3, 2=SuperMicro Pent4+");
+			"0 (none), 1=SuperMicro Pent3, 2=SuperMicro Pent4+, "
+							"911=Broken SMI BIOS");
 
 /*
  *	Vendor Specific Support
@@ -243,25 +246,92 @@ static void supermicro_new_pre_set_heartbeat(unsigned int heartbeat)
 }
 
 /*
+ *	Vendor Support: 911
+ *	Board: Some Intel ICHx based motherboards
+ *	iTCO chipset: ICH7+
+ *
+ *	Some Intel motherboards have a broken BIOS implementation: i.e.
+ *	the SMI handler clear's the TIMEOUT bit in the TC01_STS register
+ *	and does not reload the time. Thus the TCO watchdog does not reboot
+ *	the system.
+ *
+ *	These are the conclusions of Andriy Gapon <avg@icyb.net.ua> after
+ *	debugging: the SMI handler is quite simple - it tests value in
+ *	TCO1_CNT against 0x800, i.e. checks TCO_TMR_HLT. If the bit is set
+ *	the handler goes into an infinite loop, apparently to allow the
+ *	second timeout and reboot. Otherwise it simply clears TIMEOUT bit
+ *	in TCO1_STS and that's it.
+ *	So the logic seems to be reversed, because it is hard to see how
+ *	TIMEOUT can get set to 1 and SMI generated when TCO_TMR_HLT is set
+ *	(other than a transitional effect).
+ *
+ *	The only fix found to get the motherboard(s) to reboot is to put
+ *	the glb_smi_en bit to 0. This is a dirty hack that bypasses the
+ *	broken code by disabling Global SMI.
+ *
+ *	WARNING: globally disabling SMI could possibly lead to dramatic
+ *	problems, especially on laptops! I.e. various ACPI things where
+ *	SMI is used for communication between OS and firmware.
+ *
+ *	Don't use this fix if you don't need to!!!
+ */
+
+static void broken_bios_start(unsigned long acpibase)
+{
+	unsigned long val32;
+
+	val32 = inl(SMI_EN);
+	/* Bit 13: TCO_EN     -> 0 = Disables TCO logic generating an SMI#
+	   Bit  0: GBL_SMI_EN -> 0 = No SMI# will be generated by ICH. */
+	val32 &= 0xffffdffe;
+	outl(val32, SMI_EN);
+}
+
+static void broken_bios_stop(unsigned long acpibase)
+{
+	unsigned long val32;
+
+	val32 = inl(SMI_EN);
+	/* Bit 13: TCO_EN     -> 1 = Enables TCO logic generating an SMI#
+	   Bit  0: GBL_SMI_EN -> 1 = Turn global SMI on again. */
+	val32 |= 0x00002001;
+	outl(val32, SMI_EN);
+}
+
+/*
  *	Generic Support Functions
  */
 
 void iTCO_vendor_pre_start(unsigned long acpibase,
 			   unsigned int heartbeat)
 {
-	if (vendorsupport == SUPERMICRO_OLD_BOARD)
+	switch (vendorsupport) {
+	case SUPERMICRO_OLD_BOARD:
 		supermicro_old_pre_start(acpibase);
-	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
+		break;
+	case SUPERMICRO_NEW_BOARD:
 		supermicro_new_pre_start(heartbeat);
+		break;
+	case BROKEN_BIOS:
+		broken_bios_start(acpibase);
+		break;
+	}
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_start);
 
 void iTCO_vendor_pre_stop(unsigned long acpibase)
 {
-	if (vendorsupport == SUPERMICRO_OLD_BOARD)
+	switch (vendorsupport) {
+	case SUPERMICRO_OLD_BOARD:
 		supermicro_old_pre_stop(acpibase);
-	else if (vendorsupport == SUPERMICRO_NEW_BOARD)
+		break;
+	case SUPERMICRO_NEW_BOARD:
 		supermicro_new_pre_stop();
+		break;
+	case BROKEN_BIOS:
+		broken_bios_stop(acpibase);
+		break;
+	}
 }
 EXPORT_SYMBOL(iTCO_vendor_pre_stop);
 
