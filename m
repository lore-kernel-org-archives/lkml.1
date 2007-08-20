Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXHTCqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXHTCqR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 22:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755612AbXHTCqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 22:46:07 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:10665 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910AbXHTCqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 22:46:04 -0400
X-IronPort-AV: i="4.19,282,1183348800"; 
   d="scan'208"; a="37548302:sNHT24964177"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] ensure we don't use bootconsoles after init has been released
Date: Sun, 19 Aug 2007 22:46:05 -0400
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Gerd Hoffmann" <kraxel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708192246.05783.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 20 Aug 2007 02:46:02.0864 (UTC) FILETIME=[3F70A700:01C7E2D4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

This is a followup to the cleanups for earlyprintk patch from Gerd Hoffmann

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69331af79cf29e26d1231152a172a1a10c2df511

This ensures that a bootconsole is unregistered if it is not replaced. 
The current implementation spews garbage out the bootconsole in this case,
since the bootconsole structure is normally in the init section, and is
freed, but still used.

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>

---
 linux-2.6.x/kernel/printk.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


Index: linux-2.6.x/kernel/printk.c
===================================================================
--- linux-2.6.x/kernel/printk.c
+++ linux-2.6.x/kernel/printk.c
@@ -1104,6 +1104,20 @@
 }
 EXPORT_SYMBOL(unregister_console);
 
+static int __init disable_boot_consoles(void)
+{
+	struct console *con;
+
+	for (con = console_drivers; con; con = con->next) {
+		if (con->flags & CON_BOOT) {
+			printk(KERN_INFO "Turn off boot console %s%d\n",
+				con->name, con->index);
+			unregister_console(con);
+		}
+	}
+}
+late_initcall(disable_boot_consoles);
+
 /**
  * tty_write_message - write a message to a certain tty, not just the console.
  * @tty: the destination tty_struct
