Return-Path: <linux-kernel-owner+w=401wt.eu-S1752915AbYAYAtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915AbYAYAtT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 19:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751951AbYAYAtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 19:49:03 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:45190 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbYAYAtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 19:49:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm 3/5] HWRNG: Add possibility to remove hwrng devices during suspend/resume
Date: Fri, 25 Jan 2008 01:35:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Michael Buesch <mb@bu3sch.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       bcm43xx-dev@lists.berlios.de,
       Alessandro Rubini <rubini@vision.unipv.it>,
       Richard Purdie <rpurdie@rpsys.net>
References: <200801250127.21966.rjw@sisk.pl>
In-Reply-To: <200801250127.21966.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801250135.26009.rjw@sisk.pl>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Make it possible to unregister a Hardware Random Number Generator
device object in a safe way during a suspend/resume cycle.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Michael Buesch <mb@bu3sch.de>
---
 drivers/char/hw_random/core.c |   10 +++++-----
 include/linux/hw_random.h     |   10 +++++++++-
 2 files changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6.24-rc8-mm1/drivers/char/hw_random/core.c
===================================================================
--- linux-2.6.24-rc8-mm1.orig/drivers/char/hw_random/core.c
+++ linux-2.6.24-rc8-mm1/drivers/char/hw_random/core.c
@@ -234,11 +234,11 @@ static DEVICE_ATTR(rng_available, S_IRUG
 		   NULL);
 
 
-static void unregister_miscdev(void)
+static void unregister_miscdev(bool suspended)
 {
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_available);
 	device_remove_file(rng_miscdev.this_device, &dev_attr_rng_current);
-	misc_deregister(&rng_miscdev);
+	__misc_deregister(&rng_miscdev, suspended);
 }
 
 static int register_miscdev(void)
@@ -313,7 +313,7 @@ out:
 }
 EXPORT_SYMBOL_GPL(hwrng_register);
 
-void hwrng_unregister(struct hwrng *rng)
+void __hwrng_unregister(struct hwrng *rng, bool suspended)
 {
 	int err;
 
@@ -332,11 +332,11 @@ void hwrng_unregister(struct hwrng *rng)
 		}
 	}
 	if (list_empty(&rng_list))
-		unregister_miscdev();
+		unregister_miscdev(suspended);
 
 	mutex_unlock(&rng_mutex);
 }
-EXPORT_SYMBOL_GPL(hwrng_unregister);
+EXPORT_SYMBOL_GPL(__hwrng_unregister);
 
 
 MODULE_DESCRIPTION("H/W Random Number Generator (RNG) driver");
Index: linux-2.6.24-rc8-mm1/include/linux/hw_random.h
===================================================================
--- linux-2.6.24-rc8-mm1.orig/include/linux/hw_random.h
+++ linux-2.6.24-rc8-mm1/include/linux/hw_random.h
@@ -44,7 +44,15 @@ struct hwrng {
 /** Register a new Hardware Random Number Generator driver. */
 extern int hwrng_register(struct hwrng *rng);
 /** Unregister a Hardware Random Number Generator driver. */
-extern void hwrng_unregister(struct hwrng *rng);
+extern void __hwrng_unregister(struct hwrng *rng, bool suspended);
+static inline void hwrng_unregister(struct hwrng *rng)
+{
+	__hwrng_unregister(rng, false);
+}
+static inline void hwrng_unregister_suspended(struct hwrng *rng)
+{
+	__hwrng_unregister(rng, true);
+}
 
 #endif /* __KERNEL__ */
 #endif /* LINUX_HWRANDOM_H_ */

