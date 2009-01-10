Return-Path: <linux-kernel-owner+w=401wt.eu-S1755040AbZAJKwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040AbZAJKwd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 05:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbZAJKwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 05:52:25 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:60793 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbZAJKwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 05:52:24 -0500
Date: Sat, 10 Jan 2009 11:52:19 +0100
From: Erik Ekman <erik@kryo.se>
To: linux-kernel@vger.kernel.org
Cc: abelay@mit.edu, bjorn.helgaas@hp.com
Subject: [PATCH -tip][RFC] pnpbios: Fix warning if no hotplug
Message-Id: <20090110115219.1ebb94cd.erik@kryo.se>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pnpbios: Fix warning if no hotplug

When hotplug is turned off, I get:
drivers/pnp/pnpbios/core.c: In function 'pnpbios_thread_init':
drivers/pnp/pnpbios/core.c:578: warning: unused variable 'task'

Is this a good way to fix this? Or should I just a #ifdef
CONFIG_HOTPLUG around the task variable?

Signed-off-by: Erik Ekman <erik@kryo.se>
---
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index 996f648..e706d22 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -575,8 +575,6 @@ fs_initcall(pnpbios_init);
 
 static int __init pnpbios_thread_init(void)
 {
-	struct task_struct *task;
-
 #if defined(CONFIG_PPC)
 	if (check_legacy_ioport(PNPBIOS_BASE))
 		return 0;
@@ -584,10 +582,13 @@ static int __init pnpbios_thread_init(void)
 	if (pnpbios_disabled)
 		return 0;
 #ifdef CONFIG_HOTPLUG
-	init_completion(&unload_sem);
-	task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
-	if (!IS_ERR(task))
-		unloading = 0;
+	{
+		struct task_struct *task;
+		init_completion(&unload_sem);
+		task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
+		if (!IS_ERR(task))
+			unloading = 0;
+	}
 #endif
 	return 0;
 }
