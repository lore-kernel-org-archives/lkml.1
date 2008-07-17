Return-Path: <linux-kernel-owner+w=401wt.eu-S933498AbYGQXWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498AbYGQXWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 19:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933395AbYGQXVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 19:21:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:39912 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760657AbYGQXVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 19:21:38 -0400
Date: Thu, 17 Jul 2008 16:21:38 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] modules: extend initcall_debug functionality to the module
 loader
Message-ID: <20080717162138.50a57cb1@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] modules: extend initcall_debug functionality to the module loader

The kernel has this really nice facility where if you put "initcall_debug"
on the kernel commandline, it'll print which function it's going to execute
just before calling an initcall, and then after the call completes it will
1) print if it had an error code
2) checks for a few simple bugs (like leaving irqs off)
and
3) print how long the init call took in milliseconds.

While trying to optimize the boot speed of my laptop, I have been loving
number 3 to figure out what to optimize...
... and then I wished that the same thing was done for module loading.

This patch makes the module loader use this exact same functionality;
it's a logical extension in my view (since modules are just sort of
late binding initcalls anyway) and so far I've found it quite useful
in finding where things are too slow in my boot.

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 include/linux/init.h |    2 ++
 init/main.c          |    6 ++++--
 kernel/module.c      |    2 +-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 21d658c..e875fcc 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -142,6 +142,8 @@ extern initcall_t __security_initcall_start[], __security_initcall_end[];
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
 extern unsigned int reset_devices;
+extern int do_one_initcall(initcall_t fn);
+
 
 /* used by init/main.c */
 void setup_arch(char **);
diff --git a/init/main.c b/init/main.c
index edeace0..4480ca7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -685,7 +685,7 @@ asmlinkage void __init start_kernel(void)
 	rest_init();
 }
 
-static int __initdata initcall_debug;
+static int initcall_debug;
 
 static int __init initcall_debug_setup(char *str)
 {
@@ -694,7 +694,7 @@ static int __init initcall_debug_setup(char *str)
 }
 __setup("initcall_debug", initcall_debug_setup);
 
-static void __init do_one_initcall(initcall_t fn)
+int do_one_initcall(initcall_t fn)
 {
 	int count = preempt_count();
 	ktime_t t0, t1, delta;
@@ -734,6 +734,8 @@ static void __init do_one_initcall(initcall_t fn)
 		print_fn_descriptor_symbol(KERN_WARNING "initcall %s", fn);
 		printk(" returned with %s\n", msgbuf);
 	}
+
+	return result;
 }
 
 
diff --git a/kernel/module.c b/kernel/module.c
index 5f80478..b69ac29 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2220,7 +2220,7 @@ sys_init_module(void __user *umod,
 
 	/* Start the module */
 	if (mod->init != NULL)
-		ret = mod->init();
+		ret = do_one_initcall(mod->init);
 	if (ret < 0) {
 		/* Init routine failed: abort.  Try to protect us from
                    buggy refcounters. */
-- 
1.5.5.1

