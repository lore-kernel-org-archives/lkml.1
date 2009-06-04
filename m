Return-Path: <linux-kernel-owner+w=401wt.eu-S1756664AbZFDBry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756664AbZFDBry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 21:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755681AbZFDBr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 21:47:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40349 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755671AbZFDBr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 21:47:28 -0400
Date: Wed, 3 Jun 2009 21:46:37 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: jdike@addtoit.com, rusty@rustcorp.com.au, hch@infradead.org,
       Amerigo Wang <amwang@redhat.com>, mingo@elte.hu,
       akpm@linux-foundation.org
Message-Id: <20090604014849.6332.35945.sendpatchset@localhost.localdomain>
In-Reply-To: <20090604014813.6332.18486.sendpatchset@localhost.localdomain>
References: <20090604014813.6332.18486.sendpatchset@localhost.localdomain>
Subject: [Patch 4/5] module: trim exception table in module_free()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just as the comment said, trim the exception table entries when
module_free() mod->module_init.

Currently, this is only done for x86. Other platforms should
also fix it like this (except sparc32).

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
Index: linux-2.6/arch/x86/kernel/module.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/module.c
+++ linux-2.6/arch/x86/kernel/module.c
@@ -27,6 +27,7 @@
 #include <asm/system.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
+#include <asm/uaccess.h>
 
 #if 0
 #define DEBUGP printk
@@ -60,12 +61,24 @@ void *module_alloc(unsigned long size)
 }
 #endif
 
+static void trim_init_extable(struct module *m)
+{
+	/*trim the beginning*/
+	while (m->num_exentries && within_module_init(m->extable[0].insn, m)) {
+		m->extable++;
+		m->num_exentries--;
+	}
+	/*trim the end*/
+	while (m->num_exentries &&
+		within_module_init(m->extable[m->num_exentries-1].insn, m))
+		m->num_exentries--;
+}
+
 /* Free memory returned from module_alloc */
 void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
-	/* FIXME: If module_region == mod->init_region, trim exception
-	   table entries. */
+	trim_init_extable(mod);
 }
 
 /* We don't need anything special. */
