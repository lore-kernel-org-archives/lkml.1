Return-Path: <linux-kernel-owner+w=401wt.eu-S1763531AbYCGSr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763531AbYCGSr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 13:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759145AbYCGSrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 13:47:51 -0500
Received: from lx1.pxnet.com ([195.227.45.3]:38314 "EHLO lx1.pxnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758266AbYCGSru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 13:47:50 -0500
From: Tilman Schmidt <tilman@imap.cc>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Hansjoerg Lipp <hjlipp@web.de>, Karsten Keil <kkeil@suse.de>,
       Roland Kletzing <devzero@web.de>
Subject: [PATCH 2.6.25-rc4] gigaset: fix Oops on module unload regression
Message-Id: <20080307184708.C603F110055@xenon.ts.pxnet.com>
Date: Fri,  7 Mar 2008 19:47:08 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The card state mutex was only initialized when a device was connected,
but used during unload unconditionally, leading to an Oops if a driver
was loaded and unloaded again without ever connecting a device.

Fix this by initializing the mutex as soon as the structure is allocated.
Also add a missing mutex unlock revealed in the same execution path.

Thanks to Roland Kletzing for reporting this problem.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>
Tested-by: Roland Kletzing <devzero@web.de>
Cc: Hansjoerg Lipp <hjlipp@web.de>
Cc: Karsten Keil <kkeil@suse.de>
---
This fixes a possible Oops in 2.6.25-rc that was introduced by commit
e468c04894f36045cf93d1384183a461014b6840 (Gigaset: permit module unload).
Please merge as a regression fix for 2.6.25.

 drivers/isdn/gigaset/common.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/gigaset/common.c b/drivers/isdn/gigaset/common.c
index aacedec..827c32c 100644
--- a/drivers/isdn/gigaset/common.c
+++ b/drivers/isdn/gigaset/common.c
@@ -637,7 +637,6 @@ struct cardstate *gigaset_initcs(struct gigaset_driver *drv, int channels,
 		err("maximum number of devices exceeded");
 		return NULL;
 	}
-	mutex_init(&cs->mutex);
 
 	gig_dbg(DEBUG_INIT, "allocating bcs[0..%d]", channels - 1);
 	cs->bcs = kmalloc(channels * sizeof(struct bc_state), GFP_KERNEL);
@@ -898,8 +897,10 @@ int gigaset_shutdown(struct cardstate *cs)
 {
 	mutex_lock(&cs->mutex);
 
-	if (!(cs->flags & VALID_MINOR))
+	if (!(cs->flags & VALID_MINOR)) {
+		mutex_unlock(&cs->mutex);
 		return -1;
+	}
 
 	cs->waiting = 1;
 
@@ -1086,6 +1087,7 @@ struct gigaset_driver *gigaset_initdriver(unsigned minor, unsigned minors,
 		drv->cs[i].driver = drv;
 		drv->cs[i].ops = drv->ops;
 		drv->cs[i].minor_index = i;
+		mutex_init(&drv->cs[i].mutex);
 	}
 
 	gigaset_if_initdriver(drv, procname, devname);
-- 
1.5.4.7.gd8534-dirty

