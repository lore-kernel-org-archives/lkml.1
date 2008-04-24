Return-Path: <linux-kernel-owner+w=401wt.eu-S1757380AbYDXFDD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380AbYDXFDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 01:03:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbYDXFBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 01:01:42 -0400
Received: from ozlabs.org ([203.10.76.45]:37187 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755688AbYDXFBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 01:01:41 -0400
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 24 Apr 2008 00:01:35 -0500
Subject: [PATCH 6/6] module: add MODULE_STATE_GOING notifier call
Cc: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804241501.35631.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Provide module unload callback. Required by the gcov profiling
infrastructure to keep track of profiling data structures.

Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
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






