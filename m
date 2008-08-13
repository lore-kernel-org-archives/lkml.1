Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYHMSfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYHMSfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 14:35:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751152AbYHMSew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 14:34:52 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:61948 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750970AbYHMSew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 14:34:52 -0400
Date: Wed, 13 Aug 2008 22:34:50 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Dave Jones <davej@redhat.com>, Wim Van Sebroeck <wim@iguana.be>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adrian Bunk <bunk@kernel.org>
Subject: [PATCH v2] [WATCHDOG] mpc8xxx_wdt: fix modular build
Message-ID: <20080813183450.GA2473@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080806202918.GA29386@infomag.infomag.iguana.be> <20080813031044.GA11258@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <20080813031044.GA11258@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following build error when mpc8xxx_wdt is selected to
build as a module:

drivers/watchdog/mpc8xxx_wdt.c:304: error: redefinition of '__inittest'
drivers/watchdog/mpc8xxx_wdt.c:298: error: previous definition of '__inittest' was here
drivers/watchdog/mpc8xxx_wdt.c:304: error: redefinition of 'init_module'
drivers/watchdog/mpc8xxx_wdt.c:298: error: previous definition of 'init_module' was here

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---

CONFIG_8xxx_WDT_MODULE -> MODULE, per Adrian Bunk's comment.

 drivers/watchdog/mpc8xxx_wdt.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index f209496..8e50bc4 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -48,6 +48,7 @@ struct mpc8xxx_wdt_type {
 };
 
 static struct mpc8xxx_wdt __iomem *wd_base;
+static int mpc8xxx_wdt_init_late(void);
 
 static u16 timeout = 0xffff;
 module_param(timeout, ushort, 0);
@@ -213,6 +214,12 @@ static int __devinit mpc8xxx_wdt_probe(struct of_device *ofdev,
 	else
 		timeout_sec = timeout / freq;
 
+#ifdef MODULE
+	ret = mpc8xxx_wdt_init_late();
+	if (ret)
+		goto err_unmap;
+#endif
+
 	pr_info("WDT driver for MPC8xxx initialized. mode:%s timeout=%d "
 		"(%d seconds)\n", reset ? "reset" : "interrupt", timeout,
 		timeout_sec);
@@ -280,7 +287,7 @@ static struct of_platform_driver mpc8xxx_wdt_driver = {
  * very early to start pinging the watchdog (misc devices are not yet
  * available), and later module_init() just registers the misc device.
  */
-static int __init mpc8xxx_wdt_init_late(void)
+static int mpc8xxx_wdt_init_late(void)
 {
 	int ret;
 
@@ -295,7 +302,9 @@ static int __init mpc8xxx_wdt_init_late(void)
 	}
 	return 0;
 }
+#ifndef MODULE
 module_init(mpc8xxx_wdt_init_late);
+#endif
 
 static int __init mpc8xxx_wdt_init(void)
 {
-- 
1.5.6.3

