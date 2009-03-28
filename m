Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZC1OBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZC1OBU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 10:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbZC1OBJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 10:01:09 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46239 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbZC1OBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 10:01:08 -0400
Date: Sat, 28 Mar 2009 14:00:49 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>, Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: Commit 7a192ec is build breaking
Message-ID: <20090328140049.GA4344@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit:

    platform driver: fix incorrect use of 'platform_bus_type' with 'struct device_driver'

contains this:

-static int __exit pxa2xx_flash_remove(struct device *dev)
+static int __exit pxa2xx_flash_remove(struct platform_device *dev)
...
-       .remove         = __exit_p(pxa2xx_flash_remove),
+       .remove         = __devexit_p(pxa2xx_flash_remove),

which leads to the following build error:

`pxa2xx_flash_remove' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

This is not the only instance of it in this patch - all __exit_p's
touched by this patch have been converted to __devexit_p's without
regard to the original function.

Let's revert this change and, if we are going to convert functions
to be __devexit/__devinit, lets have that as a _separate_ patch doing
just that change.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/mips/basler/excite/excite_iodev.c |    2 +-
 drivers/mtd/maps/pxa2xx-flash.c        |    2 +-
 drivers/mtd/nand/excite_nandflash.c    |    3 +--
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/mips/basler/excite/excite_iodev.c b/arch/mips/basler/excite/excite_iodev.c
index dfbfd7e..2ab56ea 100644
--- a/arch/mips/basler/excite/excite_iodev.c
+++ b/arch/mips/basler/excite/excite_iodev.c
@@ -71,7 +71,7 @@ static struct platform_driver iodev_driver = {
 		.owner		= THIS_MODULE,
 	},
 	.probe		= iodev_probe,
-	.remove		= __devexit_p(iodev_remove),
+	.remove		= __exit_p(iodev_remove),
 };
 
 
diff --git a/drivers/mtd/maps/pxa2xx-flash.c b/drivers/mtd/maps/pxa2xx-flash.c
index e9026cb..bf933a9 100644
--- a/drivers/mtd/maps/pxa2xx-flash.c
+++ b/drivers/mtd/maps/pxa2xx-flash.c
@@ -177,7 +177,7 @@ static struct platform_driver pxa2xx_flash_driver = {
 		.owner		= THIS_MODULE,
 	},
 	.probe		= pxa2xx_flash_probe,
-	.remove		= __devexit_p(pxa2xx_flash_remove),
+	.remove		= __exit_p(pxa2xx_flash_remove),
 	.suspend	= pxa2xx_flash_suspend,
 	.resume		= pxa2xx_flash_resume,
 	.shutdown	= pxa2xx_flash_shutdown,
diff --git a/drivers/mtd/nand/excite_nandflash.c b/drivers/mtd/nand/excite_nandflash.c
index 72446fb..630b4d6 100644
--- a/drivers/mtd/nand/excite_nandflash.c
+++ b/drivers/mtd/nand/excite_nandflash.c
@@ -224,7 +224,7 @@ static struct platform_driver excite_nand_driver = {
 		.owner		= THIS_MODULE,
 	},
 	.probe = excite_nand_probe,
-	.remove = __devexit_p(excite_nand_remove)
+	.remove = __exit_p(excite_nand_remove)
 };
 
 static int __init excite_nand_init(void)


-- 
Russell King
