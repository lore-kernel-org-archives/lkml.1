Return-Path: <linux-kernel-owner+w=401wt.eu-S1756149AbYHCDBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149AbYHCDBf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 23:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbYHCDAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 23:00:20 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:17221 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbYHCDAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 23:00:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=F3n8uLxRGOPfPWIWZiuiyMtAXgCct1vWNrL/tVPrrtvTjgmOsX3TNLT3XWYKPrXtiD
         +9x0ZSYcc+WNJVzOWNA4VZOhcsbaVJqQ9RihnBG+nSd/+G03gYOagKF9L7zIKDgqV/ih
         +6Em+0xqv214rnxnIkpp8MBjHZOJwSods/594=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 03/25] add dyn_array support
Date: Sat,  2 Aug 2008 19:59:03 -0700
Message-Id: <1217732365-16595-4-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-2-git-send-email-yhlu.kernel@gmail.com>
 <1217732365-16595-3-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could have crazy big arrays and allocate them in bootmem at init stage.
also also to allocate array according to size we need to use to avoid wasting
memory
use CONFIG_HAVE_DYN_ARRAY to enable it or not

usage:

|static struct irq_desc irq_desc_init __initdata = {
|       .status = IRQ_DISABLED,
|       .chip = &no_irq_chip,
|       .handle_irq = handle_bad_irq,
|       .depth = 1,
|       .lock = __SPIN_LOCK_UNLOCKED(irq_desc->lock),
|#ifdef CONFIG_SMP
|       .affinity = CPU_MASK_ALL
|#endif
|};
|
|static void __init init_work(void *data)
|{
|       struct dyn_array *da = data;
|       struct  irq_desc *desc;
|       int i;
|
|       desc = *da->name;
|
|       for (i = 0; i < *da->nr; i++)
|               memcpy(&desc[i], &irq_desc_init, sizeof(struct irq_desc));
|}
|
|struct irq_desc *irq_desc;
|DEFINE_DYN_ARRAY(irq_desc, sizeof(struct irq_desc), nr_irqs, PAGE_SIZE, init_work);

after pre_alloc_dyn_array() after setup_arch(), that array is ready to use
in this way could replace irq_desc[NR_IRQS] array with dyn_array irq_desc[nr_irqs]

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 include/asm-generic/vmlinux.lds.h |    7 +++++++
 include/linux/init.h              |   23 +++++++++++++++++++++++
 init/main.c                       |   24 ++++++++++++++++++++++++
 3 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index a44ec7a..1c3daac 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
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
diff --git a/include/linux/init.h b/include/linux/init.h
index 915c5b9..c31cd94 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -249,6 +249,29 @@ struct obs_kernel_param {
 
 /* Relies on boot_command_line being set */
 void __init parse_early_param(void);
+
+struct dyn_array {
+	void **name;
+	unsigned long size;
+	unsigned int *nr;
+	unsigned long align;
+	void (*init_work)(void *);
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
diff --git a/init/main.c b/init/main.c
index 3f8fa37..54864c0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -539,6 +539,29 @@ void __init __weak thread_info_cache_init(void)
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
@@ -576,6 +599,7 @@ asmlinkage void __init start_kernel(void)
 	printk(KERN_NOTICE);
 	printk(linux_banner);
 	setup_arch(&command_line);
+	pre_alloc_dyn_array();
 	mm_init_owner(&init_mm, &init_task);
 	setup_command_line(command_line);
 	unwind_setup();
-- 
1.5.4.5

