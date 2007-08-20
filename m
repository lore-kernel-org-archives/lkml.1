Return-Path: <linux-kernel-owner+w=401wt.eu-S1762103AbXHTRPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762103AbXHTRPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 13:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759982AbXHTRO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 13:14:57 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:1244 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759607AbXHTRO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 13:14:56 -0400
X-IronPort-AV: i="4.19,285,1183348800"; 
   d="scan'208"; a="37595387:sNHT46471348"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Paul Mundt" <lethal@linux-sh.org>
Subject: Re: [PATCH 1/1] ensure we don't use bootconsoles after init has been released
Date: Mon, 20 Aug 2007 13:14:57 -0400
User-Agent: KMail/1.9.5
Cc: "Mike Frysinger" <vapier.adi@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Gerd Hoffmann" <kraxel@redhat.com>
References: <200708192246.05783.rgetz@blackfin.uclinux.org> <8bd0f97a0708192011m1b957e57je313850a255dcac7@mail.gmail.com> <20070820033143.GA4918@linux-sh.org>
In-Reply-To: <20070820033143.GA4918@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708201314.57801.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 20 Aug 2007 17:14:53.0277 (UTC) FILETIME=[9F9668D0:01C7E34D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Try #3...

From: Robin Getz <rgetz@blackfin.uclinux.org>
 
This is a followup to the cleanups for earlyprintk patch from Gerd Hoffmann
 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=69331af79cf29e26d1231152a172a1a10c2df511
 
This ensures that a bootconsole is unregistered if it is not replaced.
The current implementation spews garbage out the bootconsole in this case,
since the bootconsole structure is normally in the init section, and is
freed, but still used.
 
Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>
CC: Gerd Hoffmann <kraxel@redhat.com>
CC: Paul Mundt <lethal@linux-sh.org>
CC: Mike Frysinger <vapier.adi@gmail.com>
---
 printk.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)


Index: linux-2.6.x/kernel/printk.c
===================================================================
--- linux-2.6.x/kernel/printk.c
+++ linux-2.6.x/kernel/printk.c
@@ -1104,6 +1104,19 @@
 }
 EXPORT_SYMBOL(unregister_console);
 
+static int __init disable_boot_consoles(void)
+{
+	printk(KERN_INFO "here\n");
+
+	if (console_drivers->flags & CON_BOOT) {
+		printk(KERN_INFO "turn off boot console %s%d\n",
+			console_drivers->name, console_drivers->index);
+		return unregister_console(console_drivers);
+	}
+	return 0;
+}
+late_initcall(disable_boot_consoles);
+
 /**
  * tty_write_message - write a message to a certain tty, not just the console.
  * @tty: the destination tty_struct
