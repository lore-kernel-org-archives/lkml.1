Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbYJJWqM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbYJJWqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 18:46:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752688AbYJJWpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 18:45:55 -0400
Received: from kroah.org ([198.145.64.141]:39626 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752455AbYJJWpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 18:45:54 -0400
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Andreas Gruenbacher <agruen@suse.de>,
       Jeff Mahoney <jeffm@suse.de>
Subject: [PATCH 01/23] Staging: add TAINT_CRAP for all drivers/staging code
Date: Fri, 10 Oct 2008 15:42:25 -0700
Message-Id: <1223678567-30143-1-git-send-email-greg@kroah.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <20081010224130.GA30117@kroah.com>
References: <20081010224130.GA30117@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@suse.de>

We need to add a flag for all code that is in the drivers/staging/
directory to prevent all other kernel developers from worrying about
issues here, and to notify users that the drivers might not be as good
as they are normally used to.

Based on code from Andreas Gruenbacher and Jeff Mahoney to provide a
TAINT flag for the support level of a kernel module in the Novell
enterprise kernel release.

This is the kernel portion of this feature, the ability for the flag to
be set needs to be done in the build process and will happen in a
follow-up patch.

Cc: Andreas Gruenbacher <agruen@suse.de>
Cc: Jeff Mahoney <jeffm@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/sysctl/kernel.txt |    1 +
 include/linux/kernel.h          |    1 +
 kernel/module.c                 |   11 +++++++++++
 kernel/panic.c                  |    6 ++++--
 4 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index e1ff0d9..bde799e 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -369,4 +369,5 @@ can be ORed together:
   2 - A module was force loaded by insmod -f.
       Set by modutils >= 2.4.9 and module-init-tools.
   4 - Unsafe SMP processors: SMP with CPUs not designed for SMP.
+ 64 - A module from drivers/staging was loaded.
 
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2651f80..b36805c 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -260,6 +260,7 @@ extern enum system_states {
 #define TAINT_DIE			(1<<7)
 #define TAINT_OVERRIDDEN_ACPI_TABLE	(1<<8)
 #define TAINT_WARN			(1<<9)
+#define TAINT_CRAP			(1<<10)
 
 extern void dump_stack(void) __cold;
 
diff --git a/kernel/module.c b/kernel/module.c
index 9db1191..152b165 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1806,6 +1806,7 @@ static noinline struct module *load_module(void __user *umod,
 	Elf_Ehdr *hdr;
 	Elf_Shdr *sechdrs;
 	char *secstrings, *args, *modmagic, *strtab = NULL;
+	char *staging;
 	unsigned int i;
 	unsigned int symindex = 0;
 	unsigned int strindex = 0;
@@ -1960,6 +1961,14 @@ static noinline struct module *load_module(void __user *umod,
 		goto free_hdr;
 	}
 
+	staging = get_modinfo(sechdrs, infoindex, "staging");
+	if (staging) {
+		add_taint_module(mod, TAINT_CRAP);
+		printk(KERN_WARNING "%s: module is from the staging directory,"
+		       " the quality is unknown, you have been warned.\n",
+		       mod->name);
+	}
+
 	/* Now copy in args */
 	args = strndup_user(uargs, ~0UL >> 1);
 	if (IS_ERR(args)) {
@@ -2556,6 +2565,8 @@ static char *module_flags(struct module *mod, char *buf)
 			buf[bx++] = 'P';
 		if (mod->taints & TAINT_FORCED_MODULE)
 			buf[bx++] = 'F';
+		if (mod->taints & TAINT_CRAP)
+			buf[bx++] = 'C';
 		/*
 		 * TAINT_FORCED_RMMOD: could be added.
 		 * TAINT_UNSAFE_SMP, TAINT_MACHINE_CHECK, TAINT_BAD_PAGE don't
diff --git a/kernel/panic.c b/kernel/panic.c
index 12c5a0a..98e2047 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -155,6 +155,7 @@ EXPORT_SYMBOL(panic);
  *  'U' - Userspace-defined naughtiness.
  *  'A' - ACPI table overridden.
  *  'W' - Taint on warning.
+ *  'C' - modules from drivers/staging are loaded.
  *
  *	The string is overwritten by the next call to print_taint().
  */
@@ -163,7 +164,7 @@ const char *print_tainted(void)
 {
 	static char buf[20];
 	if (tainted) {
-		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c%c",
+		snprintf(buf, sizeof(buf), "Tainted: %c%c%c%c%c%c%c%c%c%c%c",
 			tainted & TAINT_PROPRIETARY_MODULE ? 'P' : 'G',
 			tainted & TAINT_FORCED_MODULE ? 'F' : ' ',
 			tainted & TAINT_UNSAFE_SMP ? 'S' : ' ',
@@ -173,7 +174,8 @@ const char *print_tainted(void)
 			tainted & TAINT_USER ? 'U' : ' ',
 			tainted & TAINT_DIE ? 'D' : ' ',
 			tainted & TAINT_OVERRIDDEN_ACPI_TABLE ? 'A' : ' ',
-			tainted & TAINT_WARN ? 'W' : ' ');
+			tainted & TAINT_WARN ? 'W' : ' ',
+			tainted & TAINT_CRAP ? 'C' : ' ');
 	}
 	else
 		snprintf(buf, sizeof(buf), "Not tainted");
-- 
1.6.0.2

