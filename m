Return-Path: <linux-kernel-owner+w=401wt.eu-S1754069AbXDRP6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbXDRP6H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 11:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbXDRP6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 11:58:06 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:55767 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbXDRP6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 11:58:05 -0400
Date: Wed, 18 Apr 2007 11:55:52 -0400
From: Kyle McMartin <kyle@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: alan@redhat.com, bcollins@ubuntu.com
Subject: [RFC] [PATCH] Allow overriding module parameters from kernel command_line
Message-ID: <20070418155552.GA3744@athena.road.mcmartin.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

With the move to initramfs and heavily modular configs, which include
loading storage drivers from early userspace, it's becoming harder
to provide users with a way of overriding module parameters at boot.

Currently, users would have to break into the initramfs, edit the
modprobe options, and then let boot continue. They have a much easier time
dealing with adding options on the command line from Grub or what have you.

I hacked out this patch quickly to re-parse saved_command_line[] when we
load a module in an attempt to rectify this.

(The specific use-case I was looking at here was HPA commands failing on
 sata_nv controllers, and needing to pass the adma=0 option to the module...
 Users had a hard time testing without an easy way of overriding the module.)

Clearly this is not entirely optimal, because we're parsing command_line
after the module params are parsed. This ends of being a policy decision,
whether the /sbin/modprobe commandline should override the kernel
command_line, or vice versa.

Anyway, please comment...

Cheers,
	Kyle

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index c83588c..e8465db 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -98,7 +98,7 @@ struct kparam_array
 extern int parse_args(const char *name,
 		      char *args,
 		      struct kernel_param *params,
-		      unsigned num,
+		      unsigned num, unsigned strip_module,
 		      int (*unknown)(char *param, char *val));
 
 /* All the helper functions */
diff --git a/init/main.c b/init/main.c
index a92989e..a3d647f 100644
--- a/init/main.c
+++ b/init/main.c
@@ -478,7 +478,7 @@ void __init parse_early_param(void)
 
 	/* All fall through to do_early_param. */
 	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-	parse_args("early options", tmp_cmdline, NULL, 0, do_early_param);
+	parse_args("early options", tmp_cmdline, NULL, 0, 0, do_early_param);
 	done = 1;
 }
 
@@ -549,7 +549,7 @@ asmlinkage void __init start_kernel(void)
 	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
-		   __stop___param - __start___param,
+		   __stop___param - __start___param, 0,
 		   &unknown_bootoption);
 	if (!irqs_disabled()) {
 		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
diff --git a/kernel/module.c b/kernel/module.c
index dcdb32b..e576242 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1914,10 +1914,21 @@ static struct module *load_module(void __user *umod,
 			 sechdrs[setupindex].sh_addr,
 			 sechdrs[setupindex].sh_size
 			 / sizeof(struct kernel_param),
-			 NULL);
+			 0, NULL);
 	if (err < 0)
 		goto arch_cleanup;
 
+	/* Allow user to override module params from the command line. */
+	err = parse_args(mod->name, saved_command_line,
+			 (struct kernel_param *)
+			 sechdrs[setupindex].sh_addr,
+			 sechdrs[setupindex].sh_size
+			 / sizeof(struct kernel_param),
+			 1, NULL);
+	if (err < 0)
+		printk(KERN_WARNING "%s: Ignoring bad module parameters passed on "
+		       "kernel command line\n", mod->name);
+
 	err = mod_sysfs_setup(mod, 
 			      (struct kernel_param *)
 			      sechdrs[setupindex].sh_addr,
diff --git a/kernel/params.c b/kernel/params.c
index 1fc4ac7..7c9d3a0 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -50,10 +50,17 @@ static int parse_one(char *param,
 		     char *val,
 		     struct kernel_param *params, 
 		     unsigned num_params,
-		     int (*handle_unknown)(char *param, char *val))
+		     int (*handle_unknown)(char *param, char *val),
+		     unsigned strip_module)
 {
 	unsigned int i;
 
+	/* If we're parsing command_line[] for the module,
+	 * strip off the module name before looking the param up.
+	 */
+	if (strip_module)
+		strsep(&param, ".");
+
 	/* Find parameter */
 	for (i = 0; i < num_params; i++) {
 		if (parameq(param, params[i].name)) {
@@ -130,7 +137,7 @@ static char *next_arg(char *args, char **param, char **val)
 int parse_args(const char *name,
 	       char *args,
 	       struct kernel_param *params,
-	       unsigned num,
+	       unsigned num, unsigned strip_module,
 	       int (*unknown)(char *param, char *val))
 {
 	char *param, *val;
@@ -147,7 +154,7 @@ int parse_args(const char *name,
 
 		args = next_arg(args, &param, &val);
 		irq_was_disabled = irqs_disabled();
-		ret = parse_one(param, val, params, num, unknown);
+		ret = parse_one(param, val, params, num, unknown, strip_module);
 		if (irq_was_disabled && !irqs_disabled()) {
 			printk(KERN_WARNING "parse_args(): option '%s' enabled "
 					"irq's!\n", param);
