Return-Path: <linux-kernel-owner+w=401wt.eu-S1758427AbYG3VLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758427AbYG3VLo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbYG3VJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:09:45 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:3175 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757427AbYG3VJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:09:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=JetXB/0Hz/So2r0xKfKhV+WJK0X9mEMYsfqRqnszeV0v0GCnCudqCkLwVP7ausTq08
         vazKwQ+WnWR6T0qZwcFwQHFcqpsFGK8cz2FK/THZopgK1RG+PY0PPzSJiBgGMjR3C0JB
         ujInSfNfQ87pRN/H3F+rS3atkkcA+f5eHjVHE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/7] add dyn_array support
Date: Wed, 30 Jul 2008 12:37:18 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <200807291414.55479.yhlu.kernel@gmail.com> <200807300311.48510.yhlu.kernel@gmail.com> <200807301210.31511.yhlu.kernel@gmail.com>
In-Reply-To: <200807301210.31511.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807301237.20139.yhlu.kernel@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[
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
