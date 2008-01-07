Return-Path: <linux-kernel-owner+w=401wt.eu-S1756335AbYAGKFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbYAGKFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 05:05:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753873AbYAGKFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 05:05:37 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42158 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537AbYAGKFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 05:05:36 -0500
Subject: Re: [PATCH] block2mtd lockdep_init_map warning
From: Peter Zijlstra <peterz@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, dwmw2@infradead.org,
       linux-mtd@lists.infradead.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <200801061911.m06JBldW020012@agora.fsl.cs.sunysb.edu>
References: <200801061911.m06JBldW020012@agora.fsl.cs.sunysb.edu>
Content-Type: text/plain
Date: Mon, 07 Jan 2008 11:05:26 +0100
Message-Id: <1199700326.7143.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2008-01-06 at 14:11 -0500, Erez Zadok wrote:

> > Ingo, Peter, does either of you actually care about this problem?  In
> > the last round when I debugged this problem there was a notable lack of
> > reaction from either of you.
> 
> The problem appears to be an interaction of two components--module loading
> and lockdep--that's perhaps why it wasn't given enough attention.

Would something like this work for people?

Not-Yet-Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -1160,6 +1160,7 @@ struct task_struct {
 	int lockdep_depth;
 	struct held_lock held_locks[MAX_LOCK_DEPTH];
 	unsigned int lockdep_recursion;
+	struct module *loading_module;
 #endif
 
 /* journalling filesystem info */
Index: linux-2.6/kernel/module.c
===================================================================
--- linux-2.6.orig/kernel/module.c
+++ linux-2.6/kernel/module.c
@@ -2023,6 +2023,9 @@ static struct module *load_module(void _
 		printk(KERN_WARNING "%s: Ignoring obsolete parameters\n",
 		       mod->name);
 
+#ifdef CONFIG_LOCKDEP
+	current->loading_module = mod;
+#endif
 	/* Size of section 0 is 0, so this works well if no params */
 	err = parse_args(mod->name, mod->args,
 			 (struct kernel_param *)
@@ -2030,6 +2033,9 @@ static struct module *load_module(void _
 			 sechdrs[setupindex].sh_size
 			 / sizeof(struct kernel_param),
 			 NULL);
+#ifdef CONFIG_LOCKDEP
+	current->loading_module = NULL
+#endif
 	if (err < 0)
 		goto arch_cleanup;
 
@@ -2454,6 +2460,17 @@ int is_module_address(unsigned long addr
 		}
 	}
 
+#ifdef CONFIG_LOCKDEP
+	if (current->loading_module) {
+		mod = current->loading_module;
+		if (within(addr, mod->module_init, mod->init_text_size)
+		    || within(addr, mod->module_core, mod->core_text_size)) {
+			preempt_enable();
+			return 1;
+		}
+	}
+#endif
+
 	preempt_enable();
 
 	return 0;



