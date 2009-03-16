Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbZCPWOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbZCPWOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755527AbZCPWNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:13:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755945AbZCPWNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:13:54 -0400
Message-ID: <49BECF10.60505@redhat.com>
Date: Mon, 16 Mar 2009 18:13:36 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: [PATCH -rc][BUGFIX] module: fix refptr allocation and release order
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix refptr bug: Change refptr allocation and release order not to access a module
data structure pointed by 'mod' after freeing mod->module_core.
This bug will cause kernel panic(e.g. failed to find undefined symbols).

This bug was reported on systemtap bugzilla.
http://sources.redhat.com/bugzilla/show_bug.cgi?id=9927

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>

 kernel/module.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index ba22484..1196f5d 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2015,14 +2015,6 @@ static noinline struct module *load_module(void __user *umod,
 	if (err < 0)
 		goto free_mod;

-#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
-	mod->refptr = percpu_modalloc(sizeof(local_t), __alignof__(local_t),
-				      mod->name);
-	if (!mod->refptr) {
-		err = -ENOMEM;
-		goto free_mod;
-	}
-#endif
 	if (pcpuindex) {
 		/* We have a special allocation for this section. */
 		percpu = percpu_modalloc(sechdrs[pcpuindex].sh_size,
@@ -2030,7 +2022,7 @@ static noinline struct module *load_module(void __user *umod,
 					 mod->name);
 		if (!percpu) {
 			err = -ENOMEM;
-			goto free_percpu;
+			goto free_mod;
 		}
 		sechdrs[pcpuindex].sh_flags &= ~(unsigned long)SHF_ALLOC;
 		mod->percpu = percpu;
@@ -2082,6 +2074,14 @@ static noinline struct module *load_module(void __user *umod,
 	/* Module has been moved. */
 	mod = (void *)sechdrs[modindex].sh_addr;

+#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+	mod->refptr = percpu_modalloc(sizeof(local_t), __alignof__(local_t),
+				      mod->name);
+	if (!mod->refptr) {
+		err = -ENOMEM;
+		goto free_init;
+	}
+#endif
 	/* Now we've moved module, initialize linked lists, etc. */
 	module_unload_init(mod);

@@ -2288,15 +2288,17 @@ static noinline struct module *load_module(void __user *umod,
 	ftrace_release(mod->module_core, mod->core_size);
  free_unload:
 	module_unload_free(mod);
+ free_init:
+#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+	percpu_modfree(mod->refptr);
+#endif
 	module_free(mod, mod->module_init);
  free_core:
 	module_free(mod, mod->module_core);
+	/* mod will be freed with core. Don't access it beyond this line! */
  free_percpu:
 	if (percpu)
 		percpu_modfree(percpu);
-#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
-	percpu_modfree(mod->refptr);
-#endif
  free_mod:
 	kfree(args);
  free_hdr:
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com


