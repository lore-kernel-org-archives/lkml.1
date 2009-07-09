Return-Path: <linux-kernel-owner+w=401wt.eu-S1753120AbZGIRF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120AbZGIRF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 13:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZGIRFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 13:05:17 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:19463 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbZGIRFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 13:05:16 -0400
X-IronPort-AV: E=Sophos;i="4.42,374,1243828800"; 
   d="scan'208";a="3655429"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Ingo Molnar" <mingo@elte.hu>
Subject: [PATCH] kernel.printk.c - ensure that "console enabled" messages are printed on the console
Date: Thu, 9 Jul 2009 13:08:37 -0400
User-Agent: KMail/1.9.5
CC: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <200907040017.26921.rgetz@blackfin.uclinux.org>
In-Reply-To: <200907040017.26921.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <200907091308.37370.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 09 Jul 2009 17:05:14.0479 (UTC) FILETIME=[6D3697F0:01CA00B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Today, when a console is registered without CON_PRINTBUFFER, end users never
see the announcement of it being added, and never know if they missed something,
if the console is really at the start or not, and just leads to general confusion.

This re-orders existing code, to make sure the console is added, before 
the "console [%s%d] enabled" is printed out - ensuring that this message
is _always_ seen.

This has the desired/intended side effect of making sure that 
"console enabled:" messages are printed on the bootconsole, and the real
console. This does cause the same line is printed twice if the bootconsole
and real console are the same device, but if they are on different devices,
the message is printed to both consoles.

Signed-off-by : Robin Getz <rgetz@blackfin.uclinux.org>

---

 printk.c |   44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

patch generated for -tip

---

diff --git a/kernel/printk.c b/kernel/printk.c
index 41fe609..60f35b9 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1240,22 +1240,14 @@ void register_console(struct console *newcon)
 	if (!(newcon->flags & CON_ENABLED))
 		return;
 
-	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV)) {
-		/* we need to iterate through twice, to make sure we print
-		 * everything out, before we unregister the console(s)
-		 */
-		printk(KERN_INFO "console handover:");
-		for_each_console(bcon)
-			printk("boot [%s%d] ", bcon->name, bcon->index);
-		printk(" -> real [%s%d]\n", newcon->name, newcon->index);
-		for_each_console(bcon)
-			unregister_console(bcon);
+	/*
+	 * If we have a bootconsole, and are switching to a real console,
+	 * don't print everything out again, since when the boot console, and
+	 * the real console are the same physical device, it's annoying to
+	 * see the beginning boot messages twice
+	 */
+	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV))
 		newcon->flags &= ~CON_PRINTBUFFER;
-	} else {
-		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
-			(newcon->flags & CON_BOOT) ? "boot" : "" ,
-			newcon->name, newcon->index);
-	}
 
 	/*
 	 *	Put this console in the list - keep the
@@ -1281,6 +1273,28 @@ void register_console(struct console *newcon)
 		spin_unlock_irqrestore(&logbuf_lock, flags);
 	}
 	release_console_sem();
+
+	/*
+	 *  By unregistering the bootconsoles after we enable the real console
+	 * we get the "console xxx enabled" message on all the consoles - 
+	 * boot consoles, real consoles, etc - this is to ensure that end
+	 * users know there might be something in the kernel's log buffer that
+	 * went to the bootconsole (that they do not see on the real console)
+	 */
+	if (bcon && ((newcon->flags & (CON_CONSDEV | CON_BOOT)) == CON_CONSDEV)) {
+		/* we need to iterate through twice, to make sure we print
+		 * everything out, before we unregister the console(s)
+		 */
+		printk(KERN_INFO "console [%s%d] enabled, bootconsole disabled\n",
+			newcon->name, newcon->index);
+		for_each_console(bcon)
+			if (bcon->flags & CON_BOOT)
+				unregister_console(bcon);
+	} else {
+		printk(KERN_INFO "%sconsole [%s%d] enabled\n",
+			(newcon->flags & CON_BOOT) ? "boot" : "" ,
+			newcon->name, newcon->index);
+	}
 }
 EXPORT_SYMBOL(register_console);
 
