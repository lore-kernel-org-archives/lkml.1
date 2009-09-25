Return-Path: <linux-kernel-owner+w=401wt.eu-S1751467AbZIYD6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbZIYD6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 23:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZIYD6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 23:58:54 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:38471 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZIYD6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 23:58:54 -0400
Date: Fri, 25 Sep 2009 12:58:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Woodhouse <David.Woodhouse@intel.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Bryan Wu <cooloney@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] mtd/maps: gpio-addr-flash: Fix up the GENERIC_GPIO=n build.
Message-ID: <20090925035825.GB12810@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Woodhouse <David.Woodhouse@intel.com>,
	Mike Frysinger <vapier@gentoo.org>, Bryan Wu <cooloney@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/gpio.h takes care of wrapping in to asm/gpio.h or defining a stubbed out
interface. gpio-addr-flush unfortunately references asm/gpio.h directly and as
a result blows up when CONFIG_GENERIC_GPIO is disabled.

  CC      drivers/mtd/maps/gpio-addr-flash.o
In file included from /home/pmundt/devel/git/sh-2.6/arch/sh/include/asm/gpio.h:24,
                 from drivers/mtd/maps/gpio-addr-flash.c:27:
include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
include/asm-generic/gpio.h:170: error: implicit declaration of function 'gpio_get_value'
include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
include/asm-generic/gpio.h:176: error: implicit declaration of function 'gpio_set_value'
In file included from drivers/mtd/maps/gpio-addr-flash.c:27:
/home/pmundt/devel/git/sh-2.6/arch/sh/include/asm/gpio.h: At top level:
/home/pmundt/devel/git/sh-2.6/arch/sh/include/asm/gpio.h:131: error: field 'chip' has incomplete type
drivers/mtd/maps/gpio-addr-flash.c: In function 'gpio_flash_probe':
drivers/mtd/maps/gpio-addr-flash.c:232: error: implicit declaration of function 'gpio_request'
drivers/mtd/maps/gpio-addr-flash.c:236: error: implicit declaration of function 'gpio_free'
drivers/mtd/maps/gpio-addr-flash.c:240: error: implicit declaration of function 'gpio_direction_output'
make[3]: *** [drivers/mtd/maps/gpio-addr-flash.o] Error 1
make[2]: *** [drivers/mtd/maps] Error 2
make[1]: *** [drivers/mtd] Error 2
make: *** [drivers] Error 2

I've opted to just switch to the linux/ version instead of adding a depends on,
as the driver still builds and does the error handling properly.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Bryan Wu <cooloney@kernel.org>

---

 drivers/mtd/maps/gpio-addr-flash.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mtd/maps/gpio-addr-flash.c b/drivers/mtd/maps/gpio-addr-flash.c
index 44ef9a4..3d7c911 100644
--- a/drivers/mtd/maps/gpio-addr-flash.c
+++ b/drivers/mtd/maps/gpio-addr-flash.c
@@ -22,8 +22,7 @@
 #include <linux/mtd/physmap.h>
 #include <linux/platform_device.h>
 #include <linux/types.h>
-
-#include <asm/gpio.h>
+#include <linux/gpio.h>
 #include <asm/io.h>
 
 #define pr_devinit(fmt, args...) ({ static const __devinitconst char __fmt[] = fmt; printk(__fmt, ## args); })
