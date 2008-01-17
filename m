Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbYAQN4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbYAQN4k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 08:56:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbYAQN4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 08:56:32 -0500
Received: from lizzard.sbs.de ([194.138.37.39]:22223 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752190AbYAQN4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 08:56:31 -0500
Message-ID: <478F5E82.8060300@siemens.com>
Date: Thu, 17 Jan 2008 14:56:18 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [PATCH 16/21] KGDB: This allows for KGDB to better deal with
 autoloaded   modules.
References: <4713B289.20204@windriver.com>
In-Reply-To: <4713B289.20204@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Wessel wrote:
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> 
...
> --- linux-2.6-kgdb.orig/kernel/module.c
> +++ linux-2.6-kgdb/kernel/module.c
> @@ -65,6 +65,7 @@ extern int module_sysfs_initialized;
>   * (add/delete uses stop_machine). */
>  static DEFINE_MUTEX(module_mutex);
>  static LIST_HEAD(modules);
> +static DECLARE_MUTEX(notify_mutex);

These days, notify_mutex should better be a real mutex.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>

---
 kernel/module.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: b/kernel/module.c
===================================================================
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -66,7 +66,7 @@ extern int module_sysfs_initialized;
  * (add/delete uses stop_machine). */
 static DEFINE_MUTEX(module_mutex);
 static LIST_HEAD(modules);
-static DECLARE_MUTEX(notify_mutex);
+static DEFINE_MUTEX(notify_mutex);
 
 static BLOCKING_NOTIFIER_HEAD(module_notify_list);
 
@@ -712,10 +712,10 @@ sys_delete_module(const char __user *nam
 	if (ret != 0)
 		goto out;
 
-	down(&notify_mutex);
+	mutex_lock(&notify_mutex);
 	blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GOING,
 								 mod);
-	up(&notify_mutex);
+	mutex_unlock(&notify_mutex);
 
 
 	/* Never wait if forced. */
@@ -730,10 +730,10 @@ sys_delete_module(const char __user *nam
 	}
 	free_module(mod);
 
-	down(&notify_mutex);
+	mutex_lock(&notify_mutex);
 	blocking_notifier_call_chain(&module_notify_list, MODULE_STATE_GONE,
 			NULL);
-	up(&notify_mutex);
+	mutex_unlock(&notify_mutex);
 
  out:
 	mutex_unlock(&module_mutex);
@@ -2182,11 +2182,11 @@ sys_init_module(void __user *umod,
 		/* Init routine failed: abort.  Try to protect us from
                    buggy refcounters. */
 		mod->state = MODULE_STATE_GOING;
-		down(&notify_mutex);
+		mutex_lock(&notify_mutex);
 		blocking_notifier_call_chain(&module_notify_list,
 				MODULE_STATE_GOING,
 				mod);
-		up(&notify_mutex);
+		mutex_unlock(&notify_mutex);
 		synchronize_sched();
 		module_put(mod);
 		mutex_lock(&module_mutex);
