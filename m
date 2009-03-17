Return-Path: <linux-kernel-owner+w=401wt.eu-S1762270AbZCQD1a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762270AbZCQD1a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 23:27:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbZCQD1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 23:27:21 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:36660 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651AbZCQD1U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 23:27:20 -0400
Message-ID: <49BF17F4.7040908@cosmosbay.com>
Date: Tue, 17 Mar 2009 04:24:36 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: [PATCH] module: fix refptr allocation and release order
References: <200903171250.16585.rusty@rustcorp.com.au>
In-Reply-To: <200903171250.16585.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Tue, 17 Mar 2009 04:24:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell a écrit :
> From: Masami Hiramatsu <mhiramat@redhat.com>
> 
> Impact: fix ref-after-free crash on failed module load
> 
> Fix refptr bug: Change refptr allocation and release order not to access a module
> data structure pointed by 'mod' after freeing mod->module_core.
> This bug will cause kernel panic(e.g. failed to find undefined symbols).
> 
> This bug was reported on systemtap bugzilla.
> http://sources.redhat.com/bugzilla/show_bug.cgi?id=9927
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Eric Dumazet <dada1@cosmosbay.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>


My original patch did not have this problem, because I used a local variable
to hold refptr.

http://www.archivum.info/linux-kernel@vger.kernel.org/2008-05/msg07400.html

A simpler patch could just use a local variable again, since we are very
late in rc phase ?


From: Masami Hiramatsu <mhiramat@redhat.com>

Impact: fix ref-after-free crash on failed module load

Fix refptr bug: Change refptr release not to access a module
data structure pointed by 'mod' after freeing mod->module_core.
This bug will cause kernel panic(e.g. failed to find undefined symbols).

This bug was reported on systemtap bugzilla.
http://sources.redhat.com/bugzilla/show_bug.cgi?id=9927

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>


diff --git a/kernel/module.c b/kernel/module.c
index ba22484..4dd1228 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1874,6 +1874,9 @@ static noinline struct module *load_module(void __user *umod,
 	struct kernel_param *kp;
 	struct module *mod;
 	long err = 0;
+#if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
+	void *refptr = NULL;
+#endif
 	void *percpu = NULL, *ptr = NULL; /* Stops spurious gcc warning */
 	unsigned long *mseg;
 	mm_segment_t old_fs;
@@ -2018,6 +2021,7 @@ static noinline struct module *load_module(void __user *umod,
 #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
 	mod->refptr = percpu_modalloc(sizeof(local_t), __alignof__(local_t),
 				      mod->name);
+	refptr = mod->refptr;
 	if (!mod->refptr) {
 		err = -ENOMEM;
 		goto free_mod;
@@ -2292,10 +2296,14 @@ static noinline struct module *load_module(void __user *umod,
  free_core:
 	module_free(mod, mod->module_core);
  free_percpu:
+	/*
+	 * Do not access to mod anymore, it's now freed
+	 */
 	if (percpu)
 		percpu_modfree(percpu);
 #if defined(CONFIG_MODULE_UNLOAD) && defined(CONFIG_SMP)
-	percpu_modfree(mod->refptr);
+	if (refptr)
+		percpu_modfree(refptr);
 #endif
  free_mod:
 	kfree(args);

