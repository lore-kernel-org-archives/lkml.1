Return-Path: <linux-kernel-owner+w=401wt.eu-S1750936AbYKNXBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbYKNXBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:01:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYKNXAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:22 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52169 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbYKNXAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:17 -0500
Message-Id: <20081114224949.272601332@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 13/16] Tracepoints : use modules notifiers
Content-Disposition: inline; filename=tracepoints-use-modules-notifiers.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use module notifiers for tracepoint updates rather than adding a hook in
module.c.

Impact: cleanup.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/module.c     |    5 -----
 kernel/tracepoint.c |   29 +++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 5 deletions(-)

Index: linux.trees.git/kernel/tracepoint.c
===================================================================
--- linux.trees.git.orig/kernel/tracepoint.c	2008-11-14 17:39:56.000000000 -0500
+++ linux.trees.git/kernel/tracepoint.c	2008-11-14 17:40:39.000000000 -0500
@@ -541,3 +541,32 @@ void tracepoint_iter_reset(struct tracep
 	iter->tracepoint = NULL;
 }
 EXPORT_SYMBOL_GPL(tracepoint_iter_reset);
+
+int tracepoint_module_notify(struct notifier_block *self,
+			     unsigned long val, void *data)
+{
+	struct module *mod = data;
+
+	switch (val) {
+	case MODULE_STATE_COMING:
+		tracepoint_update_probe_range(mod->tracepoints,
+			mod->tracepoints + mod->num_tracepoints);
+		break;
+	case MODULE_STATE_GOING:
+		tracepoint_update_probe_range(mod->tracepoints,
+			mod->tracepoints + mod->num_tracepoints);
+		break;
+	}
+	return 0;
+}
+
+struct notifier_block tracepoint_module_nb = {
+	.notifier_call = tracepoint_module_notify,
+	.priority = 0,
+};
+
+static int init_tracepoints(void)
+{
+	return register_module_notifier(&tracepoint_module_nb);
+}
+__initcall(init_tracepoints);
Index: linux.trees.git/kernel/module.c
===================================================================
--- linux.trees.git.orig/kernel/module.c	2008-11-14 17:39:28.000000000 -0500
+++ linux.trees.git/kernel/module.c	2008-11-14 17:40:39.000000000 -0500
@@ -2188,11 +2188,6 @@ static noinline struct module *load_modu
 		debug = section_objs(hdr, sechdrs, secstrings, "__verbose",
 				     sizeof(*debug), &num_debug);
 		dynamic_printk_setup(debug, num_debug);
-
-#ifdef CONFIG_TRACEPOINTS
-		tracepoint_update_probe_range(mod->tracepoints,
-			mod->tracepoints + mod->num_tracepoints);
-#endif
 	}
 
 	/* sechdrs[0].sh_size is always zero */

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
