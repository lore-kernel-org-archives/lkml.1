Return-Path: <linux-kernel-owner+w=401wt.eu-S1760137AbYDUMfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760137AbYDUMfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 08:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759042AbYDUMee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 08:34:34 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:23577 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758928AbYDUMed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 08:34:33 -0400
Message-ID: <480C89D7.4050104@de.ibm.com>
Date: Mon, 21 Apr 2008 14:34:31 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, rusty@rustcorp.com.au
Subject: [RFC PATCH 4/8] module: add MODULE_STATE_GOING notifier call
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Provide module unload callback. Required by the gcov profiling
infrastructure to keep track of profiling data structures.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
---
 kernel/module.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

Index: linux-2.6.25/kernel/module.c
===================================================================
--- linux-2.6.25.orig/kernel/module.c
+++ linux-2.6.25/kernel/module.c
@@ -737,12 +737,13 @@ sys_delete_module(const char __user *nam
 	if (!forced && module_refcount(mod) != 0)
 		wait_for_zero_refcount(mod);
 
+	mutex_unlock(&module_mutex);
 	/* Final destruction now noone is using it. */
-	if (mod->exit != NULL) {
-		mutex_unlock(&module_mutex);
+	if (mod->exit != NULL)
 		mod->exit();
-		mutex_lock(&module_mutex);
-	}
+	blocking_notifier_call_chain(&module_notify_list,
+				     MODULE_STATE_GOING, mod);
+	mutex_lock(&module_mutex);
 	/* Store the name of the last unloaded module for diagnostic purposes */
 	strlcpy(last_unloaded_module, mod->name, sizeof(last_unloaded_module));
 	free_module(mod);
@@ -2185,6 +2186,8 @@ sys_init_module(void __user *umod,
 		mod->state = MODULE_STATE_GOING;
 		synchronize_sched();
 		module_put(mod);
+		blocking_notifier_call_chain(&module_notify_list,
+					     MODULE_STATE_GOING, mod);
 		mutex_lock(&module_mutex);
 		free_module(mod);
 		mutex_unlock(&module_mutex);





