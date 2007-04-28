Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbXD1Xke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbXD1Xke (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754410AbXD1Xkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:40:33 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:49509 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbXD1XkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:40:10 -0400
Message-ID: <4633DB56.6070000@simon.arlott.org.uk>
Date: Sun, 29 Apr 2007 00:40:06 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: randy.dunlap@oracle.com, herbert@gondor.apana.org.au, michal@logix.cz
Subject: [PATCH] crypto: Remove pointless padlock module
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When this is compiled in it is run too early to do anything useful:
[    6.052000] padlock: No VIA PadLock drivers have been loaded.
[    6.052000] padlock: Using VIA PadLock ACE for AES algorithm.
[    6.052000] padlock: Using VIA PadLock ACE for SHA1/SHA256 algorithms.

When it's a module it isn't doing anything special, the same functionality 
can be provided in userspace by "probeall padlock padlock-aes padlock-sha" 
in modules.conf if it is required.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Michal Ludvig <michal@logix.cz>
---
 drivers/crypto/Kconfig   |   16 ++----------
 drivers/crypto/Makefile  |    1 -
 drivers/crypto/padlock.c |   58 ----------------------------------------------
 3 files changed, 3 insertions(+), 72 deletions(-)
 delete mode 100644 drivers/crypto/padlock.c

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index ff8c4be..f85cecc 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -1,10 +1,10 @@
 menu "Hardware crypto devices"
 
 config CRYPTO_DEV_PADLOCK
-	tristate "Support for VIA PadLock ACE"
-	depends on X86_32
+	bool "Support for VIA PadLock ACE"
+	depends on CRYPTO && X86_32
+	default y
 	select CRYPTO_ALGAPI
-	default m
 	help
 	  Some VIA processors come with an integrated crypto engine
 	  (so called VIA PadLock ACE, Advanced Cryptography Engine)
@@ -14,16 +14,6 @@ config CRYPTO_DEV_PADLOCK
 	  The instructions are used only when the CPU supports them.
 	  Otherwise software encryption is used.
 
-	  Selecting M for this option will compile a helper module
-	  padlock.ko that should autoload all below configured
-	  algorithms. Don't worry if your hardware does not support
-	  some or all of them. In such case padlock.ko will
-	  simply write a single line into the kernel log informing
-	  about its failure but everything will keep working fine.
-
-	  If you are unsure, say M. The compiled module will be
-	  called padlock.ko
-
 config CRYPTO_DEV_PADLOCK_AES
 	tristate "PadLock driver for AES algorithm"
 	depends on CRYPTO_DEV_PADLOCK
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index 6059cf8..d070030 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -1,4 +1,3 @@
-obj-$(CONFIG_CRYPTO_DEV_PADLOCK) += padlock.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_AES) += padlock-aes.o
 obj-$(CONFIG_CRYPTO_DEV_PADLOCK_SHA) += padlock-sha.o
 obj-$(CONFIG_CRYPTO_DEV_GEODE) += geode-aes.o
diff --git a/drivers/crypto/padlock.c b/drivers/crypto/padlock.c
deleted file mode 100644
index d6d7dd5..0000000
--- a/drivers/crypto/padlock.c
+++ /dev/null
@@ -1,58 +0,0 @@
-/*
- * Cryptographic API.
- *
- * Support for VIA PadLock hardware crypto engine.
- *
- * Copyright (c) 2006  Michal Ludvig <michal@logix.cz>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/crypto.h>
-#include <linux/cryptohash.h>
-#include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/scatterlist.h>
-#include "padlock.h"
-
-static int __init padlock_init(void)
-{
-	int success = 0;
-
-	if (crypto_has_cipher("aes-padlock", 0, 0))
-		success++;
-
-	if (crypto_has_hash("sha1-padlock", 0, 0))
-		success++;
-
-	if (crypto_has_hash("sha256-padlock", 0, 0))
-		success++;
-
-	if (!success) {
-		printk(KERN_WARNING PFX "No VIA PadLock drivers have been loaded.\n");
-		return -ENODEV;
-	}
-
-	printk(KERN_NOTICE PFX "%d drivers are available.\n", success);
-
-	return 0;
-}
-
-static void __exit padlock_fini(void)
-{
-}
-
-module_init(padlock_init);
-module_exit(padlock_fini);
-
-MODULE_DESCRIPTION("Load all configured PadLock algorithms.");
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Michal Ludvig");
-
-- 
1.5.0.1

-- 
Simon Arlott
