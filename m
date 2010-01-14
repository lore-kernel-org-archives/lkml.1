Return-Path: <linux-kernel-owner+w=401wt.eu-S1757571Ab0ANWg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab0ANWg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126Ab0ANWg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:36:57 -0500
Received: from kroah.org ([198.145.64.141]:60562 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755710Ab0ANW2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:34 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       David Hardeman <david@hardeman.nu>, Dmitry Torokhov <dtor@mail.ru>,
       Alessandro Zummo <a.zummo@towertech.it>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/52] rtc_cmos: convert shutdown to new pnp_driver->shutdown
Date: Thu, 14 Jan 2010 14:26:59 -0800
Message-Id: <1263508051-7868-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-19-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit 004731b2c7c658d36bee167cb1e1a399c2cbccc9 upstream.

commit abd6633c67925f90775bb74755f9c547e30f1f20 ("pnp: add a shutdown
method to pnp drivers") adds shutdown method to bus driver blindly.  With
it, driver->shutdown is no longer valid.

Use pnp_driver->shutdown instead.

Addresses http://bugzilla.kernel.org/show_bug.cgi?id=14889

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Reported-by: Malte Schröder <maltesch@gmx.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: David Hardeman <david@hardeman.nu>
Cc: Dmitry Torokhov <dtor@mail.ru>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/rtc/rtc-cmos.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f7a4701..473e5f2 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1099,9 +1099,9 @@ static int cmos_pnp_resume(struct pnp_dev *pnp)
 #define	cmos_pnp_resume		NULL
 #endif
 
-static void cmos_pnp_shutdown(struct device *pdev)
+static void cmos_pnp_shutdown(struct pnp_dev *pnp)
 {
-	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(pdev))
+	if (system_state == SYSTEM_POWER_OFF && !cmos_poweroff(&pnp->dev))
 		return;
 
 	cmos_do_shutdown();
@@ -1120,15 +1120,12 @@ static struct pnp_driver cmos_pnp_driver = {
 	.id_table	= rtc_ids,
 	.probe		= cmos_pnp_probe,
 	.remove		= __exit_p(cmos_pnp_remove),
+	.shutdown	= cmos_pnp_shutdown,
 
 	/* flag ensures resume() gets called, and stops syslog spam */
 	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
 	.suspend	= cmos_pnp_suspend,
 	.resume		= cmos_pnp_resume,
-	.driver		= {
-		.name	  = (char *)driver_name,
-		.shutdown = cmos_pnp_shutdown,
-	}
 };
 
 #endif	/* CONFIG_PNP */
-- 
1.6.6

