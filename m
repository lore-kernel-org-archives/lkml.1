Return-Path: <linux-kernel-owner+w=401wt.eu-S933586AbXHVWEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586AbXHVWEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 18:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933772AbXHVWDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 18:03:47 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:33974 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934542AbXHVWDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 18:03:45 -0400
Subject: [PATCH] make kobject dynamic allocation check use kallsyms_lookup()
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, michal.k.k.piotrowski@gmail.com,
       akpm@linux-foundation.org, Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Wed, 22 Aug 2007 15:03:41 -0700
Message-Id: <20070822220341.7926F241@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


One of the top ten sysfs problems is that users use statically
allocated kobjects.  This patch reminds them that this is a
naughty thing.

One _really_ nice thing this patch does, is us the kallsyms
mechanism to print out exactly which symbol is being complained
about:

	The kobject at, or inside 'statickobj.2'@(0xc040d020) is not dynamically allocated.

This patch replaces the previous implementation's use of a
_sdata symbol in favor of using kallsyms_lookup().  If a
kobject's address is a resolvable symbol, then it isn't
dynamically allocated.

The one exception to this is init symbols.  The patch also
checks to see whether __init memory has been freed and if
it has will allow kobjects in those sections. 

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/arch/i386/kernel/vmlinux.lds.S |    2 --
 lxc-dave/include/linux/init.h           |    1 +
 lxc-dave/init/main.c                    |    9 +++++++++
 lxc-dave/lib/kobject.c                  |   31 ++++++++++++++++++++++---------
 4 files changed, 32 insertions(+), 11 deletions(-)

diff -puN lib/kobject.c~make-kobject-allocation-debugging-check-use-kallsyms_lookup lib/kobject.c
--- lxc/lib/kobject.c~make-kobject-allocation-debugging-check-use-kallsyms_lookup	2007-08-22 14:51:50.000000000 -0700
+++ lxc-dave/lib/kobject.c	2007-08-22 14:51:50.000000000 -0700
@@ -139,23 +139,36 @@ static int ptr_in_range(void *ptr, void 
 	return 0;
 }
 
-static void verify_dynamic_kobject_allocation(struct kobject *kobj)
+void verify_dynamic_kobject_allocation(struct kobject *kobj)
 {
-	if (ptr_in_range(kobj, &_sdata[0], &_edata[0]))
-		goto warn;
-	if (ptr_in_range(kobj, &__bss_start[0], &__bss_stop[0]))
-		goto warn;
-	return;
-warn:
+	char *namebuf;
+	const char *ret;
+
+	namebuf = kzalloc(KSYM_NAME_LEN, GFP_KERNEL);
+	ret = kallsyms_lookup((unsigned long)kobj, NULL, NULL, NULL,
+			namebuf);
+	/*
+	 * This is the X86_32-only part of this function.
+	 * This is here because it is valid to have a kobject
+	 * in an __init section, but only after those
+	 * sections have been freed back to the dynamic pool.
+	 */
+	if (!initmem_now_dynamic &&
+	    ptr_in_range(kobj, __init_begin, __init_end))
+		goto out;
+	if (!ret || !strlen(ret))
+		goto out;
 	pr_debug("---- begin silly warning ----\n");
 	pr_debug("This is a janitorial warning, not a kernel bug.\n");
 #ifdef CONFIG_DEBUG_KOBJECT
-	print_symbol("The kobject at, or inside %s is not dynamically allocated.\n",
-			(unsigned long)kobj);
+	pr_debug("The kobject at, or inside '%s'@(0x%p) is not dynamically allocated.\n",
+			namebuf, kobj);
 #endif
 	pr_debug("kobjects must be dynamically allocated, not static\n");
 	/* dump_stack(); */
 	pr_debug("---- end silly warning ----\n");
+out:
+	kfree(namebuf);
 }
 #else
 static void verify_dynamic_kobject_allocation(struct kobject *kobj)
diff -L sre -puN /dev/null /dev/null
diff -puN arch/i386/kernel/vmlinux.lds.S~make-kobject-allocation-debugging-check-use-kallsyms_lookup arch/i386/kernel/vmlinux.lds.S
--- lxc/arch/i386/kernel/vmlinux.lds.S~make-kobject-allocation-debugging-check-use-kallsyms_lookup	2007-08-22 14:51:50.000000000 -0700
+++ lxc-dave/arch/i386/kernel/vmlinux.lds.S	2007-08-22 14:51:50.000000000 -0700
@@ -71,8 +71,6 @@ SECTIONS
   	__tracedata_end = .;
   }
 
-  _sdata = .;			/* End of text section */
-
   RODATA
 
   /* writeable */
diff -puN init/main.c~make-kobject-allocation-debugging-check-use-kallsyms_lookup init/main.c
--- lxc/init/main.c~make-kobject-allocation-debugging-check-use-kallsyms_lookup	2007-08-22 14:51:50.000000000 -0700
+++ lxc-dave/init/main.c	2007-08-22 14:51:50.000000000 -0700
@@ -771,12 +771,21 @@ static void run_init_process(char *init_
 	kernel_execve(init_filename, argv_init, envp_init);
 }
 
+/*
+ * __init/__init_data sections are turned into normal
+ * dynamically allocated memory later in boot.  When
+ * this is 0, the memory is for the __init purposes,
+ * when it it some other value, the memory is dynamic.
+ */
+int initmem_now_dynamic;
+
 /* This is a non __init function. Force it to be noinline otherwise gcc
  * makes it inline to init() and it becomes part of init.text section
  */
 static int noinline init_post(void)
 {
 	free_initmem();
+	initmem_now_dynamic = 1;
 	unlock_kernel();
 	mark_rodata_ro();
 	system_state = SYSTEM_RUNNING;
diff -puN lib/Makefile~make-kobject-allocation-debugging-check-use-kallsyms_lookup lib/Makefile
diff -puN include/linux/kernel.h~make-kobject-allocation-debugging-check-use-kallsyms_lookup include/linux/kernel.h
diff -puN arch/i386/mm/init.c~make-kobject-allocation-debugging-check-use-kallsyms_lookup arch/i386/mm/init.c
diff -puN include/linux/init.h~make-kobject-allocation-debugging-check-use-kallsyms_lookup include/linux/init.h
--- lxc/include/linux/init.h~make-kobject-allocation-debugging-check-use-kallsyms_lookup	2007-08-22 14:51:50.000000000 -0700
+++ lxc-dave/include/linux/init.h	2007-08-22 14:51:50.000000000 -0700
@@ -83,6 +83,7 @@ extern initcall_t __security_initcall_st
 extern char __initdata boot_command_line[];
 extern char *saved_command_line;
 extern unsigned int reset_devices;
+extern int initmem_now_dynamic;
 
 /* used by init/main.c */
 void setup_arch(char **);
_
