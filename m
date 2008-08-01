Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbYHAJjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbYHAJjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 05:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754042AbYHAJii
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 05:38:38 -0400
Received: from qb-out-0506.google.com ([72.14.204.235]:16382 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330AbYHAJid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 05:38:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=qg9h81O+FQ0h8EKAbQvTgO7hUKYAgySt7ZKH1JPQRGG3WUzXMpptuuQ1zf7C/JQdZO
         V4ZuOHIEDcwF00d5Wib2VDCOC+VUOEd2YsRlaDfzNaW38O0uucAkbzkc/WrDlPKKGCZ0
         BPbVCyYrifMEu/AjTsdFI0+lcwx896SOzZkVI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 03/16] add dyn_array support
Date: Fri,  1 Aug 2008 02:37:31 -0700
Message-Id: <1217583464-28494-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
References: <1217583464-28494-1-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-2-git-send-email-yhlu.kernel@gmail.com>
 <1217583464-28494-3-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so could put some crazy big array in bootmem in init stage.

use CONFIG_HAVE_DYN_ARRAY to enable it or not

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 include/asm-generic/vmlinux.lds.h |    7 +++++++
 include/linux/init.h              |   23 +++++++++++++++++++++++
 init/main.c                       |   25 +++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

Index: linux-2.6/include/asm-generic/vmlinux.lds.h
===================================================================
--- linux-2.6.orig/include/asm-generic/vmlinux.lds.h
+++ linux-2.6/include/asm-generic/vmlinux.lds.h
@@ -214,6 +214,13 @@
  * All archs are supposed to use RO_DATA() */
 #define RODATA RO_DATA(4096)
 
+#define DYN_ARRAY_INIT(align)							\
+	. = ALIGN((align));						\
+	.dyn_array.init : AT(ADDR(.dyn_array.init) - LOAD_OFFSET) {	\
+		VMLINUX_SYMBOL(__dyn_array_start) = .;			\
+		*(.dyn_array.init)					\
+		VMLINUX_SYMBOL(__dyn_array_end) = .;			\
+	}
 #define SECURITY_INIT							\
 	.security_initcall.init : AT(ADDR(.security_initcall.init) - LOAD_OFFSET) { \
 		VMLINUX_SYMBOL(__security_initcall_start) = .;		\
Index: linux-2.6/include/linux/init.h
===================================================================
--- linux-2.6.orig/include/linux/init.h
+++ linux-2.6/include/linux/init.h
@@ -249,6 +249,29 @@ struct obs_kernel_param {
 
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
+
+struct dyn_array {
+        void **name;
+        unsigned long size;
+        unsigned int *nr;
+        unsigned long align;
+        void (*init_work)(void *);
+};
+extern struct dyn_array *__dyn_array_start[], *__dyn_array_end[];
+
+#define DEFINE_DYN_ARRAY(nameX, sizeX, nrX, alignX, init_workX) \
+		static struct dyn_array __dyn_array_##nameX __initdata = \
+		{	.name = (void **)&nameX,\
+			.size = sizeX,\
+			.nr   = &nrX,\
+			.align = alignX,\
+			.init_work = init_workX,\
+		}; \
+		static struct dyn_array *__dyn_array_ptr_##nameX __used \
+		__attribute__((__section__(".dyn_array.init"))) = \
+			&__dyn_array_##nameX
+
+extern void pre_alloc_dyn_array(void);
 #endif /* __ASSEMBLY__ */
 
 /**
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -539,6 +539,29 @@ void __init __weak thread_info_cache_ini
 {
 }
 
+void pre_alloc_dyn_array(void)
+{
+#ifdef CONFIG_HAVE_DYN_ARRAY
+	unsigned long size, phys = 0;
+	struct dyn_array **daa;
+
+	for (daa = __dyn_array_start ; daa < __dyn_array_end; daa++) {
+		struct dyn_array *da = *daa;
+
+		size = da->size * (*da->nr);
+		print_fn_descriptor_symbol("dyna_array %s ", da->name);
+		printk(KERN_CONT "size:%#lx nr:%d align:%#lx",
+			da->size, *da->nr, da->align);
+		*da->name = __alloc_bootmem_nopanic(size, da->align, phys);
+		phys = virt_to_phys(*da->name);
+		printk(KERN_CONT " ==> [%#lx - %#lx]\n", phys, phys + size);
+
+		if (da->init_work)
+			da->init_work(da);
+	}
+#endif
+}
+
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
@@ -576,6 +599,8 @@ asmlinkage void __init start_kernel(void
 	printk(KERN_NOTICE);
 	printk(linux_banner);
 	setup_arch(&command_line);
+	printk(KERN_INFO "nr_irqs: %d\n", nr_irqs);
+	pre_alloc_dyn_array();
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
 	unwind_setup();
