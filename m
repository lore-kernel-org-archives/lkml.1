Return-Path: <linux-kernel-owner+w=401wt.eu-S1755909AbYKNXDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909AbYKNXDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:03:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYKNXAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:25 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52208 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYKNXAV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:21 -0500
Message-Id: <20081114224947.972705093@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:38 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 05/16] Markers use module notifier
Content-Disposition: inline; filename=markers-use-modules-notifiers.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use module notifiers instead of adding a hook in module.c.

Impact: cleanup.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/marker.c |   29 +++++++++++++++++++++++++++++
 kernel/module.c |    4 ----
 2 files changed, 29 insertions(+), 4 deletions(-)

Index: linux.trees.git/kernel/marker.c
===================================================================
--- linux.trees.git.orig/kernel/marker.c	2008-11-14 17:39:27.000000000 -0500
+++ linux.trees.git/kernel/marker.c	2008-11-14 17:39:28.000000000 -0500
@@ -846,3 +846,32 @@ void *marker_get_private_data(const char
 	return ERR_PTR(-ENOENT);
 }
 EXPORT_SYMBOL_GPL(marker_get_private_data);
+
+int marker_module_notify(struct notifier_block *self,
+			 unsigned long val, void *data)
+{
+	struct module *mod = data;
+
+	switch (val) {
+	case MODULE_STATE_COMING:
+		marker_update_probe_range(mod->markers,
+			mod->markers + mod->num_markers);
+		break;
+	case MODULE_STATE_GOING:
+		marker_update_probe_range(mod->markers,
+			mod->markers + mod->num_markers);
+		break;
+	}
+	return 0;
+}
+
+struct notifier_block marker_module_nb = {
+	.notifier_call = marker_module_notify,
+	.priority = 0,
+};
+
+static int init_markers(void)
+{
+	return register_module_notifier(&marker_module_nb);
+}
+__initcall(init_markers);
Index: linux.trees.git/kernel/module.c
===================================================================
--- linux.trees.git.orig/kernel/module.c	2008-11-14 17:38:29.000000000 -0500
+++ linux.trees.git/kernel/module.c	2008-11-14 17:39:28.000000000 -0500
@@ -2185,10 +2185,6 @@ static noinline struct module *load_modu
 		struct mod_debug *debug;
 		unsigned int num_debug;
 
-#ifdef CONFIG_MARKERS
-		marker_update_probe_range(mod->markers,
-			mod->markers + mod->num_markers);
-#endif
 		debug = section_objs(hdr, sechdrs, secstrings, "__verbose",
 				     sizeof(*debug), &num_debug);
 		dynamic_printk_setup(debug, num_debug);

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
