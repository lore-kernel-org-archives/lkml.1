Return-Path: <linux-kernel-owner+w=401wt.eu-S1751563AbXHTEIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563AbXHTEIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 00:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750785AbXHTEIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 00:08:44 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:32426 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXHTEIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 00:08:44 -0400
X-IronPort-AV: i="4.19,283,1183348800"; 
   d="scan'208"; a="48903371:sNHT33240452"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] ensure we don't use bootconsoles after init has been released
Date: Mon, 20 Aug 2007 00:08:45 -0400
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Gerd Hoffmann" <kraxel@redhat.com>,
       "Mike Frysinger" <vapier.adi@gmail.com>
References: <200708192246.05783.rgetz@blackfin.uclinux.org> <8bd0f97a0708192011m1b957e57je313850a255dcac7@mail.gmail.com>
In-Reply-To: <8bd0f97a0708192011m1b957e57je313850a255dcac7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708200008.45327.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 20 Aug 2007 04:08:42.0137 (UTC) FILETIME=[CB65A890:01C7E2DF]
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

linux-2.6.x-old/kernel/printk.c |   15 +++++++++++++++
1 file changed, 15 insertions(+)

Index: linux-2.6.x-old/kernel/printk.c
===================================================================
--- linux-2.6.x-old/kernel/printk.c	(revision 3583)
+++ linux-2.6.x-old/kernel/printk.c	(working copy)
@@ -1104,6 +1104,21 @@
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
+	return 0;
+}
+late_initcall(disable_boot_consoles);
+
 /**
  * tty_write_message - write a message to a certain tty, not just the console.
  * @tty: the destination tty_struct
