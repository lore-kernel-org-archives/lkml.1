Return-Path: <linux-kernel-owner+w=401wt.eu-S1760444AbZCQCUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760444AbZCQCUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 22:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753247AbZCQCUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 22:20:23 -0400
Received: from ozlabs.org ([203.10.76.45]:39878 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbZCQCUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 22:20:22 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] module: fix refptr allocation and release order
Date: Tue, 17 Mar 2009 12:50:15 +1030
User-Agent: KMail/1.11.1 (Linux/2.6.27-11-generic; KDE/4.2.1; i686; ; )
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "systemtap-ml" <systemtap@sources.redhat.com>,
       Eric Dumazet <dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903171250.16585.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Impact: fix ref-after-free crash on failed module load

Fix refptr bug: Change refptr allocation and release order not to access a module
data structure pointed by 'mod' after freeing mod->module_core.
This bug will cause kernel panic(e.g. failed to find undefined symbols).

This bug was reported on systemtap bugzilla.
http://sources.redhat.com/bugzilla/show_bug.cgi?id=9927

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

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
