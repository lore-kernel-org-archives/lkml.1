Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbXFOFPm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbXFOFPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 01:15:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751062AbXFOFPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 01:15:34 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:35881 "EHLO
	asav04.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbXFOFPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 01:15:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlE4AD29cUZKhRO4UGdsb2JhbACHMYgDAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [RFT] i8042 - trust PNP more on i386
Date: Fri, 15 Jun 2007 01:15:31 -0400
User-Agent: KMail/1.9.3
Cc: Vojtech Pavlik <vojtech@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706150115.32412.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Historically we did not trust PNP data on i386 because of all the
issues with data put into BIOS by BIOS writers. However there are
bunch of boxes that get really unhappy if we try to poke AUX port
when they don't have mouse attached and BIOS disabled AUX port when
booting. Our keyboard/mouse probels leave keyboard dead.

So the idea is teh following - if we find properly described keyboard
device in PNP tables and all the resources are specified correctly but
mouse device is not there we assume that BIOS can be trusted and don't
create AUX port.

I would appreciate if yo ugive this patch a spin.
 
-- 
Dmitry

Input: i8042 - give more trust PNP data on i386

On some boxes that don't have PS/2 mice connected at startup BIOS
completely disables AUX port and attempts to access it result in
hosed keyboard. Historically we do not trust ACPI/PNP data on
i386 and try to poke AUX port even if we did not find an active
PNP node for it. However in cases when BIOS writers got KBD port
properly described we can assume that they did the right thing
for AUX port as well.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/serio/i8042-x86ia64io.h |   36 +++++++++++++++++++++++++++-------
 1 files changed, 29 insertions(+), 7 deletions(-)

Index: work/drivers/input/serio/i8042-x86ia64io.h
===================================================================
--- work.orig/drivers/input/serio/i8042-x86ia64io.h
+++ work/drivers/input/serio/i8042-x86ia64io.h
@@ -355,6 +355,7 @@ static void i8042_pnp_exit(void)
 static int __init i8042_pnp_init(void)
 {
 	char kbd_irq_str[4] = { 0 }, aux_irq_str[4] = { 0 };
+	int pnp_data_busted = 0;
 	int err;
 
 	if (i8042_nopnp) {
@@ -402,27 +403,48 @@ static int __init i8042_pnp_init(void)
 #endif
 
 	if (((i8042_pnp_data_reg & ~0xf) == (i8042_data_reg & ~0xf) &&
-	      i8042_pnp_data_reg != i8042_data_reg) || !i8042_pnp_data_reg) {
-		printk(KERN_WARNING "PNP: PS/2 controller has invalid data port %#x; using default %#x\n",
+	      i8042_pnp_data_reg != i8042_data_reg) ||
+	    !i8042_pnp_data_reg) {
+		printk(KERN_WARNING
+			"PNP: PS/2 controller has invalid data port %#x; "
+			"using default %#x\n",
 			i8042_pnp_data_reg, i8042_data_reg);
 		i8042_pnp_data_reg = i8042_data_reg;
+		pnp_data_busted = 1;
 	}
 
 	if (((i8042_pnp_command_reg & ~0xf) == (i8042_command_reg & ~0xf) &&
-	      i8042_pnp_command_reg != i8042_command_reg) || !i8042_pnp_command_reg) {
-		printk(KERN_WARNING "PNP: PS/2 controller has invalid command port %#x; using default %#x\n",
+	      i8042_pnp_command_reg != i8042_command_reg) ||
+	    !i8042_pnp_command_reg) {
+		printk(KERN_WARNING
+			"PNP: PS/2 controller has invalid command port %#x; "
+			"using default %#x\n",
 			i8042_pnp_command_reg, i8042_command_reg);
 		i8042_pnp_command_reg = i8042_command_reg;
+		pnp_data_busted = 1;
 	}
 
 	if (!i8042_nokbd && !i8042_pnp_kbd_irq) {
-		printk(KERN_WARNING "PNP: PS/2 controller doesn't have KBD irq; using default %d\n", i8042_kbd_irq);
+		printk(KERN_WARNING
+			"PNP: PS/2 controller doesn't have KBD irq; "
+			"using default %d\n", i8042_kbd_irq);
 		i8042_pnp_kbd_irq = i8042_kbd_irq;
+		pnp_data_busted = 1;
 	}
 
 	if (!i8042_noaux && !i8042_pnp_aux_irq) {
-		printk(KERN_WARNING "PNP: PS/2 controller doesn't have AUX irq; using default %d\n", i8042_aux_irq);
-		i8042_pnp_aux_irq = i8042_aux_irq;
+		if (!pnp_data_busted && i8042_pnp_kbd_irq) {
+			printk(KERN_WARNING
+				"PNP: PS/2 appears to have AUX port disabled, "
+				"if this is incorrect please boot with "
+				"i8042.nopnp\n");
+			i8042_noaux = 1;
+		} else {
+			printk(KERN_WARNING
+				"PNP: PS/2 controller doesn't have AUX irq; "
+				"using default %d\n", i8042_aux_irq);
+			i8042_pnp_aux_irq = i8042_aux_irq;
+		}
 	}
 
 	i8042_data_reg = i8042_pnp_data_reg;
