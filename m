Return-Path: <linux-kernel-owner+w=401wt.eu-S1754109AbYHMMXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbYHMMXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 08:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbYHMMXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 08:23:44 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:60962 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751885AbYHMMXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 08:23:43 -0400
Date: Wed, 13 Aug 2008 16:23:41 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Dave Jones <davej@redhat.com>, Wim Van Sebroeck <wim@iguana.be>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] [WATCHDOG] mpc8xxx_wdt: fix modular build
Message-ID: <20080813122341.GA31815@oksana.dev.rtsoft.ru>
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

On Tue, Aug 12, 2008 at 11:10:44PM -0400, Dave Jones wrote:
> On Wed, Aug 06, 2008 at 10:29:18PM +0200, Wim Van Sebroeck wrote:
>  > Hi Linus,
>  > 
>  > Please pull from 'master' branch of
>  > 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
>  > or if master.kernel.org hasn't synced up yet:
>  > 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
>  > 
>  > This will update the following files:
>  > 
>  > Author: Anton Vorontsov <avorontsov@ru.mvista.com>
>  > Date:   Thu Jul 3 23:51:36 2008 -0700
>  > 
>  >     [WATCHDOG] mpc8xxx_wdt: add support for MPC8xx watchdogs
> 
> This is broken when built modular because this...
> 
>  > +}
>  > +module_init(mpc8xxx_wdt_init_late);
> 
> and this ..
> 
>  > +arch_initcall(mpc8xxx_wdt_init);
> 
> Can't be mixed.  You end up with two init_module invocations
> 
> drivers/watchdog/mpc8xxx_wdt.c:304: error: redefinition of '__inittest'
> drivers/watchdog/mpc8xxx_wdt.c:298: error: previous definition of '__inittest' was here
> drivers/watchdog/mpc8xxx_wdt.c:304: error: redefinition of 'init_module'
> drivers/watchdog/mpc8xxx_wdt.c:298: error: previous definition of 'init_module' was here
> 
> Given they both call different routines though, I'm not sure the right fix here.

Thanks for noticing!

Unfortunately I don't see any elegant way to fix this. In the long term,
it would be great if we could work with misc (thus watchdog) subsystem at
arch_initcall() time (yes, we need this early on 8xx). Until this happen,
I think this patch is the best fix we can do.

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
 
+#ifdef CONFIG_8xxx_WDT_MODULE
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
+#ifndef CONFIG_8xxx_WDT_MODULE
 module_init(mpc8xxx_wdt_init_late);
+#endif
 
 static int __init mpc8xxx_wdt_init(void)
 {
-- 
1.5.6.3

