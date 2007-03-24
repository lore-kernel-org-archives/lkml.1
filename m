Return-Path: <linux-kernel-owner+w=401wt.eu-S1751529AbXCXNGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbXCXNGb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 09:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXCXNGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 09:06:30 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33349 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751529AbXCXNGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 09:06:19 -0400
Date: Sat, 24 Mar 2007 14:06:22 +0100
From: Adrian Bunk <bunk@stusta.de>
To: kkeil@suse.de, kai.germaschewski@gmx.de, mac@melware.de
Cc: isdn4linux@listserv.isdn4linux.de, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: [RFC: 2.6 patch] fix ISDN_CAPI<->ISDN_DIVAS
Message-ID: <20070324130622.GE752@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap reported in kernel Bugzilla #8241 the following compile 
error with CONFIG_ISDN_CAPI=m, CONFIG_ISDN_DIVAS=y:

<--  snip  -->

...
WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/divacapi.ko] undefined!
WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/diva_mnt.ko] undefined!
WARNING: "DIVA_DIDD_Read" [drivers/isdn/hardware/eicon/diva_idi.ko] undefined!
WARNING: "proc_net_eicon" [drivers/isdn/hardware/eicon/diva_idi.ko] undefined!
make[1]: *** [__modpost] Error 1

<--  snip  -->


Kconfig contains the following strange thing:

menu "Active Eicon DIVA Server cards"
        depends on NET && ISDN && ISDN_CAPI!=n


It seems that except for ISDN_DIVAS_DIVACAPI (that already has a proper 
dependency), nothing here actually requires ISDN_CAPI?


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/isdn/Makefile               |    2 +-
 drivers/isdn/hardware/eicon/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.21-rc4-mm1/drivers/isdn/hardware/eicon/Kconfig.old	2007-03-23 21:30:30.000000000 +0100
+++ linux-2.6.21-rc4-mm1/drivers/isdn/hardware/eicon/Kconfig	2007-03-23 21:26:09.000000000 +0100
@@ -3,7 +3,7 @@
 #
 
 menu "Active Eicon DIVA Server cards"
-	depends on NET && ISDN && ISDN_CAPI!=n
+	depends on NET && ISDN
 
 config CAPI_EICON
 	bool "Support Eicon cards"
--- linux-2.6.21-rc4-mm1/drivers/isdn/Makefile.old	2007-03-23 21:27:19.000000000 +0100
+++ linux-2.6.21-rc4-mm1/drivers/isdn/Makefile	2007-03-23 21:27:38.000000000 +0100
@@ -4,7 +4,7 @@
 
 obj-$(CONFIG_ISDN_I4L)			+= i4l/
 obj-$(CONFIG_ISDN_CAPI)			+= capi/
-obj-$(CONFIG_ISDN_CAPI)			+= hardware/
+obj-$(CONFIG_ISDN)			+= hardware/
 obj-$(CONFIG_ISDN_DIVERSION)		+= divert/
 obj-$(CONFIG_ISDN_DRV_HISAX)		+= hisax/
 obj-$(CONFIG_ISDN_DRV_ICN)		+= icn/

