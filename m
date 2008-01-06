Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbYAFXTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbYAFXTd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 18:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbYAFXT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 18:19:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:46027 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756094AbYAFXTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 18:19:25 -0500
Date: Sun, 6 Jan 2008 15:18:50 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: rusty@rustcorp.com.au, ak@suse.de, mingo@elte.hu
Subject: [patch 1/2] show being-loaded/being-unloaded indicator for modules
 in oopses
Message-ID: <20080106151850.3eab58b0@laptopd505.fenrus.org>
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

Subject: show being-loaded/being-unloaded indicator for modules in oopses
From: Arjan van de Ven <arjan@linux.intel.com>
CC: rusty@rustcorp.com.au
CC: ak@suse.de
CC: mingo@elte.hu

It's rather common that an oops/WARN_ON/BUG happens during the load or
unload of a module. Unfortunatly, it's not always easy to see directly
which module is being loaded/unloaded from the oops itself. Worse,
it's not even always possible to ask the bug reporter, since there
are so many components (udev etc) that auto-load modules that there's
a good chance that even the reporter doesn't know which module this is.

This patch extends the existing "show if it's tainting" print code,
which is used as part of printing the modules in the oops/BUG/WARN_ON
to include a "+" for "being loaded" and a "-" for "being unloaded".

As a result this extension, the "taint_flags()" function gets renamed to
"module_flags()" (and takes a module struct as argument, not a taint
flags int).

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

---
 kernel/module.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

Index: linux-2.6.24-rc6/kernel/module.c
===================================================================
--- linux-2.6.24-rc6.orig/kernel/module.c
+++ linux-2.6.24-rc6/kernel/module.c
@@ -2355,21 +2355,30 @@ static void m_stop(struct seq_file *m, v
 	mutex_unlock(&module_mutex);
 }
 
-static char *taint_flags(unsigned int taints, char *buf)
+static char *module_flags(struct module *mod, char *buf)
 {
 	int bx = 0;
 
-	if (taints) {
+	if (mod->taints ||
+	    mod->state == MODULE_STATE_GOING ||
+	    mod->state == MODULE_STATE_COMING) {
 		buf[bx++] = '(';
-		if (taints & TAINT_PROPRIETARY_MODULE)
+		if (mod->taints & TAINT_PROPRIETARY_MODULE)
 			buf[bx++] = 'P';
-		if (taints & TAINT_FORCED_MODULE)
+		if (mod->taints & TAINT_FORCED_MODULE)
 			buf[bx++] = 'F';
 		/*
 		 * TAINT_FORCED_RMMOD: could be added.
 		 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
 		 * apply to modules.
 		 */
+
+		/* Show a - for module-is-being-unloaded */
+		if (mod->state == MODULE_STATE_GOING)
+			buf[bx++] = '-';
+		/* Show a + for module-is-being-loaded */
+		if (mod->state == MODULE_STATE_COMING)
+			buf[bx++] = '+';
 		buf[bx++] = ')';
 	}
 	buf[bx] = '\0';
@@ -2396,7 +2405,7 @@ static int m_show(struct seq_file *m, vo
 
 	/* Taints info */
 	if (mod->taints)
-		seq_printf(m, " %s", taint_flags(mod->taints, buf));
+		seq_printf(m, " %s", module_flags(mod, buf));
 
 	seq_printf(m, "\n");
 	return 0;
@@ -2491,7 +2500,7 @@ void print_modules(void)
 
 	printk("Modules linked in:");
 	list_for_each_entry(mod, &modules, list)
-		printk(" %s%s", mod->name, taint_flags(mod->taints, buf));
+		printk(" %s%s", mod->name, module_flags(mod, buf));
 	printk("\n");
 }
 


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
