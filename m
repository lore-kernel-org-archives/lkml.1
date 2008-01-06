Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYAFXU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYAFXU3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 18:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbYAFXUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 18:20:21 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46040 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532AbYAFXUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 18:20:20 -0500
Date: Sun, 6 Jan 2008 15:19:46 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu
Subject: [patch 2/2] track and print last unloaded module in the oops trace
Message-ID: <20080106151946.50c3d8cc@laptopd505.fenrus.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: track and print last unloaded module in the oops trace
From: Arjan van de Ven <arjan@linux.intel.com>
CC: rusty@rustcorp.com.au
CC: ak@suse.de
CC: mingo@elte.hu

Based on a suggestion from Andi: 
In various cases, the unload of a module may leave some bad state around
that causes a kernel crash AFTER a module is unloaded; and it's then hard
to find which module caused that. 

This patch tracks the last unloaded module, and prints this as part of the
module list in the oops trace.

Right now, only the last 1 module is tracked; I expect that this is enough
for the vast majority of cases where this information matters; if it turns
out that tracking more is important, we can always extend it to that.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 kernel/module.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-2.6.24-rc6/kernel/module.c
===================================================================
--- linux-2.6.24-rc6.orig/kernel/module.c
+++ linux-2.6.24-rc6/kernel/module.c
@@ -655,6 +655,8 @@ static void wait_for_zero_refcount(struc
 	mutex_lock(&module_mutex);
 }
 
+static char last_unloaded_module[MODULE_NAME_LEN+1];
+
 asmlinkage long
 sys_delete_module(const char __user *name_user, unsigned int flags)
 {
@@ -721,6 +723,8 @@ sys_delete_module(const char __user *nam
 		mod->exit();
 		mutex_lock(&module_mutex);
 	}
+	/* Store the name of the last unloaded module for diagnostic purposes */
+	sprintf(last_unloaded_module, mod->name);
 	free_module(mod);
 
  out:
@@ -2501,6 +2505,8 @@ void print_modules(void)
 	printk("Modules linked in:");
 	list_for_each_entry(mod, &modules, list)
 		printk(" %s%s", mod->name, module_flags(mod, buf));
+	if (last_unloaded_module[0])
+		printk(" [last unloaded: %s]", last_unloaded_module);
 	printk("\n");
 }
 

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
