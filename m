Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZBGMrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZBGMrK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 07:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZBGMqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 07:46:42 -0500
Received: from ozlabs.org ([203.10.76.45]:45012 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994AbZBGMqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 07:46:40 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Sat, 07 Feb 2009 23:15:22 +1030
Subject: [PATCH 8/9] module: clarify the force-loading taint message.
Message-Id: <20090207124638.8A662DDDE0@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: Message cleanup

Two of three callers of try_to_force_load() are not because of a
missing version, so change the messages:

Old:
	<modname>: no version for "magic" found: kernel tainted.
New:
	<modname>: bad vermagic: kernel tainted.

Old:
	<modname>: no version for "nocrc" found: kernel tainted.
New:
	<modname>: no versions for exported symbols: kernel tainted.

Old:
	<modname>: no version for "<symname>" found: kernel tainted.
New:
	<modname>: <symname>: kernel tainted.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 kernel/module.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -961,12 +961,12 @@ static struct module_attribute *modinfo_
 
 static const char vermagic[] = VERMAGIC_STRING;
 
-static int try_to_force_load(struct module *mod, const char *symname)
+static int try_to_force_load(struct module *mod, const char *reason)
 {
 #ifdef CONFIG_MODULE_FORCE_LOAD
 	if (!test_taint(TAINT_FORCED_MODULE))
-		printk("%s: no version for \"%s\" found: kernel tainted.\n",
-		       mod->name, symname);
+		printk(KERN_WARNING "%s: %s: kernel tainted.\n",
+		       mod->name, reason);
 	add_taint_module(mod, TAINT_FORCED_MODULE);
 	return 0;
 #else
@@ -1978,7 +1977,7 @@ static noinline struct module *load_modu
 	modmagic = get_modinfo(sechdrs, infoindex, "vermagic");
 	/* This is allowed: modprobe --force will invalidate it. */
 	if (!modmagic) {
-		err = try_to_force_load(mod, "magic");
+		err = try_to_force_load(mod, "bad vermagic");
 		if (err)
 			goto free_hdr;
 	} else if (!same_magic(modmagic, vermagic, versindex)) {
@@ -2167,8 +2166,8 @@ static noinline struct module *load_modu
 	    || (mod->num_unused_gpl_syms && !mod->unused_gpl_crcs)
 #endif
 		) {
-		printk(KERN_WARNING "%s: No versions for exported symbols.\n", mod->name);
-		err = try_to_force_load(mod, "nocrc");
+		err = try_to_force_load(mod,
+					"no versions for exported symbols");
 		if (err)
 			goto cleanup;
 	}

