Return-Path: <linux-kernel-owner+w=401wt.eu-S1754897AbYHHI3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897AbYHHI3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 04:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYHHI3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 04:29:31 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38267 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbYHHI3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 04:29:30 -0400
Date: Fri, 8 Aug 2008 10:29:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>, Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH] watchdog: Fix build with CONFIG_ITCO_VENDOR_SUPPORT=n
Message-ID: <20080808102921.3ec92c4f@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel 2.6.27-rc2-git2 fails to build with
CONFIG_ITCO_VENDOR_SUPPORT=n:

  CC [M]  drivers/watchdog/iTCO_vendor_support.o
drivers/watchdog/iTCO_vendor_support.c:247: error: expected identifier or '(' before '{' token
drivers/watchdog/iTCO_vendor_support.c:249: error: expected identifier or '(' before '{' token
drivers/watchdog/iTCO_vendor_support.c:255: error: 'iTCO_vendor_pre_start' undeclared here (not in a function)
drivers/watchdog/iTCO_vendor_support.c:255: warning: type defaults to 'int' in declaration of 'iTCO_vendor_pre_start'
drivers/watchdog/iTCO_vendor_support.c:257: error: expected identifier or '(' before '{' token
drivers/watchdog/iTCO_vendor_support.c:258: error: expected identifier or '(' before '{' token
drivers/watchdog/iTCO_vendor_support.c:264: error: 'iTCO_vendor_pre_stop' undeclared here (not in a function)
drivers/watchdog/iTCO_vendor_support.c:264: warning: type defaults to 'int' in declaration of 'iTCO_vendor_pre_stop'
drivers/watchdog/iTCO_vendor_support.c:266: error: expected identifier or '(' before '{' token
drivers/watchdog/iTCO_vendor_support.c:267: error: expected identifier or '(' before '{' token
drivers/watchdog/iTCO_vendor_support.c:273: error: 'iTCO_vendor_pre_keepalive' undeclared here (not in a function)
drivers/watchdog/iTCO_vendor_support.c:273: warning: type defaults to 'int' in declaration of 'iTCO_vendor_pre_keepalive'
drivers/watchdog/iTCO_vendor_support.c:275: error: expected identifier or '(' before '{' token
drivers/watchdog/iTCO_vendor_support.c:276: error: expected identifier or '(' before '{' token
drivers/watchdog/iTCO_vendor_support.c:280: error: 'iTCO_vendor_pre_set_heartbeat' undeclared here (not in a function)
drivers/watchdog/iTCO_vendor_support.c:280: warning: type defaults to 'int' in declaration of 'iTCO_vendor_pre_set_heartbeat'
drivers/watchdog/iTCO_vendor_support.c:282:39: error: macro "iTCO_vendor_check_noreboot_on" passed 1 arguments, but takes just 0
drivers/watchdog/iTCO_vendor_support.c:283: error: expected '=', ',', ';', 'asm' or '__attribute__' before '{' token
drivers/watchdog/iTCO_vendor_support.c:291: error: 'iTCO_vendor_check_noreboot_on' undeclared here (not in a function)
drivers/watchdog/iTCO_vendor_support.c:291: warning: type defaults to 'int' in declaration of 'iTCO_vendor_check_noreboot_on'
make[2]: *** [drivers/watchdog/iTCO_vendor_support.o] Error 1
make[1]: *** [drivers/watchdog] Error 2
make: *** [drivers] Error 2

The problem is that iTCO_vendor_support.ko is still being built while
iTCO_vendor.h claims that its functions do not exist. The following
Makefile update fixes that. It causes iTCO_vendor_support.ko to no
longer be built if CONFIG_ITCO_VENDOR_SUPPORT=n.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/Makefile |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.27-rc2.orig/drivers/watchdog/Makefile	2008-08-08 10:14:31.000000000 +0200
+++ linux-2.6.27-rc2/drivers/watchdog/Makefile	2008-08-08 10:15:56.000000000 +0200
@@ -66,7 +66,10 @@ obj-$(CONFIG_IB700_WDT) += ib700wdt.o
 obj-$(CONFIG_IBMASR) += ibmasr.o
 obj-$(CONFIG_WAFER_WDT) += wafer5823wdt.o
 obj-$(CONFIG_I6300ESB_WDT) += i6300esb.o
-obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o iTCO_vendor_support.o
+obj-$(CONFIG_ITCO_WDT) += iTCO_wdt.o
+ifeq ($(CONFIG_ITCO_VENDOR_SUPPORT),y)
+obj-$(CONFIG_ITCO_WDT) += iTCO_vendor_support.o
+endif
 obj-$(CONFIG_IT8712F_WDT) += it8712f_wdt.o
 obj-$(CONFIG_HP_WATCHDOG) += hpwdt.o
 obj-$(CONFIG_SC1200_WDT) += sc1200wdt.o


-- 
Jean Delvare
