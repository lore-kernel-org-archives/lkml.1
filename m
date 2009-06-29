Return-Path: <linux-kernel-owner+w=401wt.eu-S1758867AbZF2LAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758867AbZF2LAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 07:00:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753248AbZF2LAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 07:00:04 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:15599 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZF2LAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 07:00:02 -0400
X-IronPort-AV: E=Sophos;i="4.42,309,1243828800"; 
   d="scan'208";a="798003"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Ingo Molnar" <mingo@elte.hu>
Subject: RFC - printk handling more than one CON_BOOT
Date: Mon, 29 Jun 2009 07:03:21 -0400
User-Agent: KMail/1.9.5
CC: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200906290703.21539.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 29 Jun 2009 11:00:04.0727 (UTC) FILETIME=[C1DA4070:01C9F8A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today, register_console() assumes the following usage (with respect to boot
consoles/early_printk).

The first console to register with register_console() with a flags set to
CON_BOOT is the one and only bootconsole. 

If another register_console() is called with an additional CON_BOOT, today it
is silently rejected.

As soon as a console without the CON_BOOT set calls register_console(), the
one and only bootconsole is automatically unregistered.

Once there is a "standard" console - register_console() will silently reject
any consoles with it's CON_BOOT, set.


This changeset allows multiple boot consoles, and changes the functionality
to, be mostly the same as the above.

Any number of bootconsoles can be registered.
A "real" console will unregister all the bootconsoles.
Once a "real" console is registered, no more bootconsoles can be added.

Thoughts?

The use case is to have a console buffer which goes to serial, and a console
buffer which goes to a fixed memory buffer at the same time. (serial is what
most people use, but if serial is hosed for some reason, having things in
a buffer (which gets printed out by the bootloader) is the only way to
tell what is going on).

If you don't object I will send a properly formatted patch...

-------------


Index: kernel/printk.c
===================================================================
--- kernel/printk.c	(revision 6860)
+++ kernel/printk.c	(working copy)
@@ -1126,9 +1126,24 @@
 	unsigned long flags;
 	struct console *bootconsole = NULL;
 
+	/* before we register a new CON_BOOT console, make sure we don't
+	 * already have a valid console
+	 */
 	if (console_drivers) {
-		if (console->flags & CON_BOOT)
-			return;
+		if (console->flags & CON_BOOT) {
+			for (bootconsole = console_drivers;
+				bootconsole != NULL;
+				bootconsole = bootconsole->next) {
+				if (!(bootconsole->flags & CON_BOOT))
+					break;
+			}
+			if ((console->flags & CON_BOOT) &&
+				!(bootconsole->flags & CON_BOOT))
+				return;
+			if (!(bootconsole->flags & CON_BOOT))
+				bootconsole = NULL;
+		}
+
 		if (console_drivers->flags & CON_BOOT)
 			bootconsole = console_drivers;
 	}
@@ -1195,15 +1210,32 @@
 	if (!(console->flags & CON_ENABLED))
 		return;
 
-	if (bootconsole && (console->flags & CON_CONSDEV)) {
-		printk(KERN_INFO "console handover: boot [%s%d] -> real [%s%d]\n",
-		       bootconsole->name, bootconsole->index,
-		       console->name, console->index);
-		unregister_console(bootconsole);
+	if (bootconsole && (console->flags & CON_CONSDEV) &&
+		!(console->flags & CON_BOOT)) {
+		/* we need to iterate through twice, to make sure we print
+		 * everything out, before we unregister the console(s)
+		 */
+		printk(KERN_INFO "console handover: ");
+		for (bootconsole = console_drivers; bootconsole != NULL;
+			bootconsole = bootconsole->next) {
+			if (bootconsole->flags & CON_BOOT)
+				printk("boot [%s%d] ", bootconsole->name,
+					bootconsole->index);
+		}
+		printk(" -> real [%s%d]\n", console->name, console->index);
+		for (bootconsole = console_drivers; bootconsole != NULL;
+			bootconsole = bootconsole->next) {
+			if (bootconsole->flags & CON_BOOT)
+				unregister_console(bootconsole);
+		}
 		console->flags &= ~CON_PRINTBUFFER;
 	} else {
-		printk(KERN_INFO "console [%s%d] enabled\n",
-		       console->name, console->index);
+		if (console->flags & CON_BOOT)
+			printk(KERN_INFO "bootconsole [%s%d] enabled\n",
+				console->name, console->index);
+		else
+			printk(KERN_INFO "console [%s%d] enabled\n",
+				console->name, console->index);
 	}
 
 	/*
