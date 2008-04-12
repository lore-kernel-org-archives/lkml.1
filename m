Return-Path: <linux-kernel-owner+w=401wt.eu-S1761268AbYDLJwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761268AbYDLJwi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 05:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758622AbYDLJwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 05:52:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46053 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758474AbYDLJwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 05:52:30 -0400
Date: Sat, 12 Apr 2008 11:53:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Andrew Morton <akpm@osdl.org>
Subject: s2ram: warn when interrupts should be disabled but are not
Message-ID: <20080412095311.GA1729@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sysdevs should be suspended/resumed with IRQs disabled; if something
reenables them by mistake, we want to know early.

Signed-off-by: Pavel Machek <pavel@suse.cz>

---
commit fc3bccaf69e6c05464e7154369639bd5c96ccdc1
tree bf960093ddb840242a00b4ec456ec79472b1c2ad
parent 308e9d5309f378209e931f63f729806ec0a4d9f1
author Pavel <pavel@amd.ucw.cz> Sat, 12 Apr 2008 11:52:05 +0200
committer Pavel <pavel@amd.ucw.cz> Sat, 12 Apr 2008 11:52:05 +0200

 drivers/ata/ahci.c |    2 +-
 drivers/base/sys.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/base/sys.c b/drivers/base/sys.c
index 8e13fd9..e214467 100644
--- a/drivers/base/sys.c
+++ b/drivers/base/sys.c
@@ -22,6 +22,7 @@ #include <linux/string.h>
 #include <linux/pm.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
+#include <linux/hardirq.h>
 
 #include "base.h"
 
@@ -367,6 +368,7 @@ int sysdev_suspend(pm_message_t state)
 			/* Call auxillary drivers first */
 			list_for_each_entry(drv, &cls->drivers, entry) {
 				if (drv->suspend) {
+					WARN_ON(!irqs_disabled());
 					ret = drv->suspend(sysdev, state);
 					if (ret)
 						goto aux_driver;
@@ -442,6 +444,7 @@ int sysdev_resume(void)
 		list_for_each_entry(sysdev, &cls->kset.list, kobj.entry) {
 			pr_debug(" %s\n", kobject_name(&sysdev->kobj));
 
+			WARN_ON(!irqs_disabled());
 			__sysdev_resume(sysdev);
 		}
 	}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
