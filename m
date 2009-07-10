Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZGJKpB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZGJKpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:45:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754863AbZGJKov
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:44:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:53629 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568AbZGJKou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:44:50 -0400
Date: Fri, 10 Jul 2009 10:43:11 GMT
From: tip-bot for Robin Getz <rgetz@blackfin.uclinux.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       rgetz@blackfin.uclinux.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       rgetz@blackfin.uclinux.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <200907091308.37370.rgetz@blackfin.uclinux.org>
References: <200907091308.37370.rgetz@blackfin.uclinux.org>
Subject: [tip:core/printk] printk: Ensure that "console enabled" messages are printed on the console
Message-ID: <tip-8259cf4342029aad37660e524178c8858f48b0ab@git.kernel.org>
Git-Commit-ID: 8259cf4342029aad37660e524178c8858f48b0ab
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 10 Jul 2009 10:43:12 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8259cf4342029aad37660e524178c8858f48b0ab
Gitweb:     http://git.kernel.org/tip/8259cf4342029aad37660e524178c8858f48b0ab
Author:     Robin Getz <rgetz@blackfin.uclinux.org>
AuthorDate: Thu, 9 Jul 2009 13:08:37 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 10 Jul 2009 12:24:47 +0200

printk: Ensure that "console enabled" messages are printed on the console

Today, when a console is registered without CON_PRINTBUFFER,
end users never see the announcement of it being added, and
never know if they missed something, if the console is really
at the start or not, and just leads to general confusion.

This re-orders existing code, to make sure the console is
added, before the "console [%s%d] enabled" is printed out -
ensuring that this message is _always_ seen.

This has the desired/intended side effect of making sure that
"console enabled:" messages are printed on the bootconsole, and
the real console. This does cause the same line is printed
twice if the bootconsole and real console are the same device,
but if they are on different devices, the message is printed to
both consoles.

Signed-off-by : Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>
LKML-Reference: <200907091308.37370.rgetz@blackfin.uclinux.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/printk.c |   44 +++++++++++++++++++++++++++++---------------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 41fe609..668df35 100644
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
+	 * By unregistering the bootconsoles after we enable the real console
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
 
