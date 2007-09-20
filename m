Return-Path: <linux-kernel-owner+w=401wt.eu-S1758864AbXITR3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864AbXITR3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 13:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755788AbXITR27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 13:28:59 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:48979 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754437AbXITR26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 13:28:58 -0400
Date: Thu, 20 Sep 2007 18:28:49 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Gerd Hoffmann <kraxel@suse.de>, Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH] kernel/printk.c: Concerns about the console handover
Message-ID: <Pine.LNX.4.64N.0709201749240.30788@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Move the hadover message to after the boot console has been released to 
avoid bad interactions between it and the real console.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 The 69331af79cf29e26d1231152a172a1a10c2df511 commit of May 8th added a 
"console handover: ..." message to register_console() that is output 
during the short period when both the boot and the newly-registered 
console are registered.

 This is presumably fine for boot consoles implemented entirely by Linux 
as they are fully controlled.  But it may produce problems when the boot 
console is actually implemented as a call to the firmware which may not be 
quite happy about how the OS driver for the piece of hardware involved 
controls it.

 I hit this problem with the DECstation.  Depending on the configuration 
the fimrware uses a graphics adapter or a predefined serial port for 
console output -- which device actually that is cannot be reliably 
determined by Linux, though an approximation may be possible.  Now if the 
firmware uses the serial port and Linux is asked to use the same serial 
port for the real console, then this printk() hangs forever in the 
firmware.  The driver used is drivers/serial/zs.c.

 The reason is by the time the ->write() call is issued for the boot 
console as a result of this printk(), the zs.c driver has been initialised 
and because at the moment the serial port has not been opened, the serial 
transmitter is disabled.  The firmware polls for the transmit buffer empty 
condition, but does not enable the module, presumably under the assumption 
it will not be called once an OS driver has taken control of the device 
(the register containing the enable bit is write-only anyway, so it would 
be hard to restore the previous value).  This causes a hang, because once 
a single character is put into the transmit buffer it will not become 
empty until the transmitter has been enabled.

 The serial console as implemented by zs.c handles the case correctly, by 
enabling the transmitter, outputting what should be output, waiting for 
the transmit shift register to drain and restoring the state of the 
transmitter enable (which is held in a shadow variable).

 I feel a bit uneasy about keeping serial transmitters enabled for lines 
that have not been opened; I gather others may agree as for example while 
not explicitly mentioned, I believe it is implied by what is said in 
Documentation/serial/driver referring to the ->shutdown() call: "Disable 
the port, [...]" -- with the transmitter enabled a port can hardly be 
considered fully disabled.  Below is a change which makes the problem 
disappear for me, but I suppose there was a deliberate reason for placing 
the printk() where it is now and nowhere else.

 Any suggestions will be appreciated.

  Maciej

patch-mips-2.6.23-rc5-20070904-printk-handover-0
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/kernel/printk.c linux-mips-2.6.23-rc5-20070904/kernel/printk.c
--- linux-mips-2.6.23-rc5-20070904.macro/kernel/printk.c	2007-09-04 04:56:21.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/kernel/printk.c	2007-09-19 21:10:16.000000000 +0000
@@ -1014,11 +1014,11 @@ void register_console(struct console *co
 		return;
 
 	if (bootconsole && (console->flags & CON_CONSDEV)) {
+		unregister_console(bootconsole);
+		console->flags &= ~CON_PRINTBUFFER;
 		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
 		       bootconsole->name, bootconsole->index,
 		       console->name, console->index);
-		unregister_console(bootconsole);
-		console->flags &= ~CON_PRINTBUFFER;
 	} else {
 		printk(KERN_INFO "console [%s%d] enabled\n",
 		       console->name, console->index);
