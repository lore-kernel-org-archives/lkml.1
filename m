Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbXHVDPG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbXHVDPG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 23:15:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbXHVDOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 23:14:55 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:43059 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbXHVDOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 23:14:54 -0400
X-IronPort-AV: i="4.19,292,1183348800"; 
   d="scan'208"; a="37707573:sNHT26171684"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fix - ensure we don't use bootconsoles after init has been released
Date: Tue, 21 Aug 2007 23:14:58 -0400
User-Agent: KMail/1.9.5
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Paul Mundt" <lethal@linux-sh.org>,
       Mike Frysinger <vapier.adi@gmail.com>
References: <200708192246.05783.rgetz@blackfin.uclinux.org>
In-Reply-To: <200708192246.05783.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708212314.58656.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 22 Aug 2007 03:14:53.0214 (UTC) FILETIME=[9BA29BE0:01C7E46A]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <rgetz@blackfin.uclinux.org>

Gerd Hoffmann pointed out that my patch from yesterday can lead 
to a null pointer dereference if the kernel is booted with no
console, and no earlyprintk defined. This fixes that issue.

 printk.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Signed-off-by: Robin Getz <rgetz@blackfin.uclinux.org>

---

Index: linux-2.6.x/kernel/printk.c
===================================================================
--- linux-2.6.x/kernel/printk.c	
+++ linux-2.6.x/kernel/printk.c
@@ -1106,10 +1106,12 @@
 
 static int __init disable_boot_consoles(void)
 {
-	if (console_drivers->flags & CON_BOOT) {
-		printk(KERN_INFO "turn off boot console %s%d\n",
-			console_drivers->name, console_drivers->index);
-		return unregister_console(console_drivers);
+	if (console_drivers != NULL) {
+		if (console_drivers->flags & CON_BOOT) {
+			printk(KERN_INFO "turn off boot console %s%d\n",
+				console_drivers->name, console_drivers->index);
+			return unregister_console(console_drivers);
+		}
 	}
 	return 0;
 }
