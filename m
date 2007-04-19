Return-Path: <linux-kernel-owner+w=401wt.eu-S2993172AbXDSIDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993172AbXDSIDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 04:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993164AbXDSICY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 04:02:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45727 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993168AbXDSICO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 04:02:14 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: "<Andrew Morton" <akpm@osdl.org>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH] pnpbios: Conert to use the kthread API.
Date: Thu, 19 Apr 2007 01:58:37 -0600
Message-Id: <11769695601507-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.5.1.1.g2de0
In-Reply-To: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

This patches modifies the pnpbios kernel thread to start
with ktrhead_run not kernel_thread and deamonize.  Doing
this makes the code a little simpler and easier to maintain.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/pnp/pnpbios/core.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index c2ed53f..3a201b7 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -62,6 +62,7 @@
 #include <linux/delay.h>
 #include <linux/acpi.h>
 #include <linux/freezer.h>
+#include <linux/kthread.h>
 
 #include <asm/page.h>
 #include <asm/desc.h>
@@ -159,9 +160,7 @@ static int pnp_dock_thread(void * unused)
 {
 	static struct pnp_docking_station_info now;
 	int docked = -1, d = 0;
-	daemonize("kpnpbiosd");
-	allow_signal(SIGKILL);
-	while(!unloading && !signal_pending(current))
+	while (!unloading)
 	{
 		int status;
 		
@@ -170,11 +169,8 @@ static int pnp_dock_thread(void * unused)
 		 */
 		msleep_interruptible(2000);
 
-		if(signal_pending(current)) {
-			if (try_to_freeze())
-				continue;
-			break;
-		}
+		if (try_to_freeze())
+			continue;
 
 		status = pnp_bios_dock_station_info(&now);
 
@@ -582,6 +578,7 @@ subsys_initcall(pnpbios_init);
 
 static int __init pnpbios_thread_init(void)
 {
+	struct task_struct *task;
 #if defined(CONFIG_PPC_MERGE)
 	if (check_legacy_ioport(PNPBIOS_BASE))
 		return 0;
@@ -590,7 +587,8 @@ static int __init pnpbios_thread_init(void)
 		return 0;
 #ifdef CONFIG_HOTPLUG
 	init_completion(&unload_sem);
-	if (kernel_thread(pnp_dock_thread, NULL, CLONE_KERNEL) > 0)
+	task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
+	if (!IS_ERR(task))
 		unloading = 0;
 #endif
 	return 0;
-- 
1.5.0.g53756

