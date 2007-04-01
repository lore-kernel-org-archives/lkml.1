Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbXDARfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbXDARfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 13:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933645AbXDARfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 13:35:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40374 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbXDARfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 13:35:43 -0400
Date: Sun, 1 Apr 2007 19:35:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch] driver core: if built-in, do not wait in driver_unregister()
Message-ID: <20070401173508.GA11401@elte.hu>
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327015929.GY16477@stusta.de> <20070330120416.GA19373@elte.hu> <20070401074929.GA4722@ucw.cz> <Pine.LNX.4.64.0704011011080.6730@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704011011080.6730@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I would suggest that for 2.6.21, the minimal fix is actually something 
> like the appended. Comments? Ingo, does this fix things for you?

yeah - it does the trick: i just booted the .config in question and your 
patch works fine and the bootup does not hang in slgt_init() anymore:

 Calling initcall 0xc1e78d86: slgt_init+0x0/0x1ee()
 SyncLink GT $Revision: 4.36 $
 SyncLink GT no devices found
 initcall 0xc1e78d86: slgt_init+0x0/0x1ee() returned -19
 Calling initcall 0xc1e78f74: n_hdlc_init+0x0/0x9c()
 HDLC line discipline: version $Revision: 4.8 $, maxframe=4096
 N_HDLC line discipline registered.
 initcall 0xc1e78f74: n_hdlc_init+0x0/0x9c() returned 0

thanks! Find below the full patch with metadata filled in (no other 
changes).

	Ingo

------------------------->
Subject: [patch] driver core: if built-in, do not wait in driver_unregister()
From: Linus Torvalds <torvalds@linux-foundation.org>

built-in drivers suffered bootup hangs with certain driver unregistry
sequences, due to sysfs breakage.

do the minimal fix for v2.6.21: only wait if the driver is a module.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/base/driver.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux/drivers/base/driver.c
===================================================================
--- linux.orig/drivers/base/driver.c
+++ linux/drivers/base/driver.c
@@ -183,7 +183,14 @@ int driver_register(struct device_driver
 void driver_unregister(struct device_driver * drv)
 {
 	bus_remove_driver(drv);
-	wait_for_completion(&drv->unloaded);
+	/*
+	 * If the driver is a module, we are probably in
+	 * the module unload path, and we want to wait
+	 * for everything to unload before we can actually
+	 * finish the unload.
+	 */
+	if (drv->owner)
+		wait_for_completion(&drv->unloaded);
 }
 
 /**
