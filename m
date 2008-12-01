Return-Path: <linux-kernel-owner+w=401wt.eu-S1755049AbYLAMzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049AbYLAMzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751342AbYLAMzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:55:06 -0500
Received: from ozlabs.org ([203.10.76.45]:44003 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751324AbYLAMzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:55:04 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 1 Dec 2008 23:25:00 +1030
Subject: [RFC 1/8] param: allow parse_args to work non-destructively.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812012325.00136.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are currently several places where we make a temporary command line
to mangle: it's fairly simple for parse_args() to demangle in place.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/moduleparam.h |    3 +-
 init/main.c                 |    6 ++---
 kernel/module.c             |    2 -
 kernel/params.c             |   46 +++++++++++++++++++++++++++++++++++++-------
 4 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -136,7 +136,8 @@ extern int parse_args(const char *name,
 		      char *args,
 		      struct kernel_param *params,
 		      unsigned num,
-		      int (*unknown)(char *param, char *val));
+		      int (*unknown)(char *param, char *val),
+		      bool restore_args);
 
 /* All the helper functions */
 /* The macros to do compile-time type checking stolen from Jakub
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -509,7 +509,7 @@ void __init parse_early_param(void)
 
 	/* All fall through to do_early_param. */
 	strlcpy(tmp_cmdline, boot_command_line, COMMAND_LINE_SIZE);
-	parse_args("early options", tmp_cmdline, NULL, 0, do_early_param);
+	parse_args("early options", tmp_cmdline, NULL, 0, do_early_param, true);
 	done = 1;
 }
 
@@ -589,7 +589,7 @@ asmlinkage void __init start_kernel(void
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
-		   &unknown_bootoption);
+		   &unknown_bootoption, false);
 	if (!irqs_disabled()) {
 		printk(KERN_WARNING "start_kernel(): bug: interrupts were "
 				"enabled *very* early, fixing it\n");
diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2239,7 +2239,7 @@ static noinline struct module *load_modu
 	 */
 	list_add_rcu(&mod->list, &modules);
 
-	err = parse_args(mod->name, mod->args, kp, num_kp, NULL);
+	err = parse_args(mod->name, mod->args, kp, num_kp, NULL, false);
 	if (err < 0)
 		goto unlink;
 
diff --git a/kernel/params.c b/kernel/params.c
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -72,9 +72,36 @@ static int parse_one(char *param,
 	return -ENOENT;
 }
 
+struct replacements {
+	unsigned int num;
+	struct {
+		char *pos;
+		char oldc;
+	} replace[3];
+};
+
+static void replace(char *place, char newc, struct replacements *replacements)
+{
+	BUG_ON(replacements->num == ARRAY_SIZE(replacements->replace));
+	replacements->replace[replacements->num].pos = place;
+	replacements->replace[replacements->num].oldc = *place;
+	*place = newc;
+	replacements->num++;
+
+}
+
+static void unreplace_all(struct replacements *replaced)
+{
+	unsigned int i;
+
+	for (i = 0; i < replaced->num; i++)
+		*replaced->replace[i].pos = replaced->replace[i].oldc;
+}
+
 /* You can use " around spaces, but can't escape ". */
 /* Hyphens and underscores equivalent in parameter names. */
-static char *next_arg(char *args, char **param, char **val)
+static char *next_arg(char *args, char **param, char **val,
+		      struct replacements *replacements)
 {
 	unsigned int i, equals = 0;
 	int in_quote = 0, quoted = 0;
@@ -101,21 +128,21 @@ static char *next_arg(char *args, char *
 	if (!equals)
 		*val = NULL;
 	else {
-		args[equals] = '\0';
+		replace(&args[equals], '\0', replacements);
 		*val = args + equals + 1;
 
 		/* Don't include quotes in value. */
 		if (**val == '"') {
 			(*val)++;
 			if (args[i-1] == '"')
-				args[i-1] = '\0';
+				replace(&args[i-1], '\0', replacements);
 		}
 		if (quoted && args[i-1] == '"')
-			args[i-1] = '\0';
+			replace(&args[i-1], '\0', replacements);
 	}
 
 	if (args[i]) {
-		args[i] = '\0';
+		replace(&args[i], '\0', replacements);
 		next = args + i + 1;
 	} else
 		next = args + i;
@@ -131,7 +158,8 @@ int parse_args(const char *name,
 	       char *args,
 	       struct kernel_param *params,
 	       unsigned num,
-	       int (*unknown)(char *param, char *val))
+	       int (*unknown)(char *param, char *val),
+	       bool restore_args)
 {
 	char *param, *val;
 
@@ -144,14 +172,18 @@ int parse_args(const char *name,
 	while (*args) {
 		int ret;
 		int irq_was_disabled;
+		struct replacements replaced = { .num = 0 };
 
-		args = next_arg(args, &param, &val);
+		args = next_arg(args, &param, &val, &replaced);
 		irq_was_disabled = irqs_disabled();
 		ret = parse_one(param, val, params, num, unknown);
 		if (irq_was_disabled && !irqs_disabled()) {
 			printk(KERN_WARNING "parse_args(): option '%s' enabled "
 					"irq's!\n", param);
 		}
+		if (restore_args)
+			unreplace_all(&replaced);
+
 		switch (ret) {
 		case -ENOENT:
 			printk(KERN_ERR "%s: Unknown parameter `%s'\n",


