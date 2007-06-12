Return-Path: <linux-kernel-owner+w=401wt.eu-S1756762AbXFLFO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762AbXFLFO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 01:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751763AbXFLFOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 01:14:52 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:9570 "EHLO
	asav05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbXFLFOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 01:14:51 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmYmAKzIbUZKhRO4UGdsb2JhbACHM4gMAQEbDQYRAQ
From: Dmitry Torokhov <dtor@insightbb.com>
To: Paul Albrecht <albrecht@rdi1.com>
Subject: Re: [BUG] via c3/2.6.20 -- ps/2 keyboard doesn't work with console
Date: Tue, 12 Jun 2007 01:14:48 -0400
User-Agent: KMail/1.9.3
Cc: lkml <linux-kernel@vger.kernel.org>
References: <1181236651.15435.1.camel@albrecht.rdi1.com> <d120d5000706111228g4ada3a8dxf8e31dc62cfab476@mail.gmail.com> <1181588095.2436.5.camel@albrecht.rdi1.com>
In-Reply-To: <1181588095.2436.5.camel@albrecht.rdi1.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706120114.48645.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2007 14:54, Paul Albrecht wrote:
> 
> Is i8042.noaux a workaround or a fix?
> 

Just a workaround. Do you have a PS/2 mouse you could test with? If so could
you check if both keybioard and mouse work with mouse plugged in and without
i8042.noaux.

Also cxould you please try the patch below (again with mouse if you have one
and without).

Thanks a lot!

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
 1 file changed, 29 insertions(+), 7 deletions(-)

Index: linux/drivers/input/serio/i8042-x86ia64io.h
===================================================================
--- linux.orig/drivers/input/serio/i8042-x86ia64io.h
+++ linux/drivers/input/serio/i8042-x86ia64io.h
@@ -356,6 +356,7 @@ static void i8042_pnp_exit(void)
 static int __init i8042_pnp_init(void)
 {
 	char kbd_irq_str[4] = { 0 }, aux_irq_str[4] = { 0 };
+	int pnp_data_busted = 0;
 	int err;
 
 	if (i8042_nopnp) {
@@ -403,27 +404,48 @@ static int __init i8042_pnp_init(void)
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
