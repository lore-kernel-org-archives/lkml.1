Return-Path: <linux-kernel-owner+w=401wt.eu-S1755843AbYFRTtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843AbYFRTtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 15:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752712AbYFRTt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 15:49:26 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:24369 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752470AbYFRTtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 15:49:25 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEANgCWUjZiDgU/2dsb2JhbACBW7AT
Date: Wed, 18 Jun 2008 21:49:17 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Subject: [WATCHDOG] v2.6.26 hpwdt.c fixes
Message-ID: <20080618194917.GC2741@infomag.infomag.iguana.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from 'master' branch of
	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
or if master.kernel.org hasn't synced up yet:
	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git

This will update the following files:

 drivers/watchdog/Makefile |    1 +
 drivers/watchdog/hpwdt.c  |   35 +++++++++++++++++++----------------
 2 files changed, 20 insertions(+), 16 deletions(-)

with these Changes:

Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Wed Jun 18 16:22:48 2008 +0000

    Revert "[WATCHDOG] hpwdt: Fix NMI handling."
    
    The old setup works better.
    
    Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Date:   Thu Jun 12 20:20:32 2008 +0000

    [WATCHDOG] hpwdt: Add CFLAGS to get driver working
    
    To get this driver working we need the CFLAGS_hpwdt.o += -O in the Makefile.
    
    Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Author: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
Date:   Thu Jun 12 20:20:32 2008 +0000

    Revert "[WATCHDOG] make watchdog/hpwdt.c:asminline_call() static"
    
    The driver needs the asmlinkage tag and the CFLAGS line in the Makefile.
    Without it the driver doesn't work.
    
    Signed-off-by: Thomas Mingarelli <Thomas.Mingarelli@hp.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

The Changes can also be looked at on:
	http://www.kernel.org/git/?p=linux/kernel/git/wim/linux-2.6-watchdog.git;a=summary

For completeness, I added the overal diff below.

Greetings,
Wim.

================================================================================
diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
index 25b352b..8662a6b 100644
--- a/drivers/watchdog/Makefile
+++ b/drivers/watchdog/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.o
 obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
 obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o iTCO_vendor_support.o
 obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
+CFLAGS_hpwdt.o += -O
 obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o
 obj-$(CONFIG_SCx200_WDT) += scx200_wdt.o
diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index 6a63535..2686f3e 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -145,8 +145,8 @@ MODULE_DEVICE_TABLE(pci, hpwdt_devices);
 
 #define HPWDT_ARCH	32
 
-static void asminline_call(struct cmn_registers *pi86Regs,
-			   unsigned long *pRomEntry)
+asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
+			       unsigned long *pRomEntry)
 {
 	asm("pushl       %ebp               \n\t"
 	    "movl        %esp, %ebp         \n\t"
@@ -333,8 +333,8 @@ static int __devinit detect_cru_service(void)
 
 #define HPWDT_ARCH	64
 
-static void asminline_call(struct cmn_registers *pi86Regs,
-			   unsigned long *pRomEntry)
+asmlinkage void asminline_call(struct cmn_registers *pi86Regs,
+			       unsigned long *pRomEntry)
 {
 	asm("pushq      %rbp            \n\t"
 	    "movq       %rsp, %rbp      \n\t"
@@ -418,20 +418,23 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 	static unsigned long rom_pl;
 	static int die_nmi_called;
 
-	if (ulReason == DIE_NMI || ulReason == DIE_NMI_IPI) {
-		spin_lock_irqsave(&rom_lock, rom_pl);
-		if (!die_nmi_called)
-			asminline_call(&cmn_regs, cru_rom_addr);
-		die_nmi_called = 1;
-		spin_unlock_irqrestore(&rom_lock, rom_pl);
-		if (cmn_regs.u1.ral != 0) {
-			panic("An NMI occurred, please see the Integrated "
-			      "Management Log for details.\n");
-		}
+	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
+		return NOTIFY_OK;
+
+	spin_lock_irqsave(&rom_lock, rom_pl);
+	if (!die_nmi_called)
+		asminline_call(&cmn_regs, cru_rom_addr);
+	die_nmi_called = 1;
+	spin_unlock_irqrestore(&rom_lock, rom_pl);
+	if (cmn_regs.u1.ral == 0) {
+		printk(KERN_WARNING "hpwdt: An NMI occurred, "
+		       "but unable to determine source.\n");
+	} else {
+		panic("An NMI occurred, please see the Integrated "
+			"Management Log for details.\n");
 	}
 
-	die_nmi_called = 0;
-	return NOTIFY_DONE;
+	return NOTIFY_STOP;
 }
 
 /*
