Return-Path: <linux-kernel-owner+w=401wt.eu-S1753640AbYIMFPV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640AbYIMFPV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 01:15:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753751AbYIMFOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 01:14:53 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40410 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbYIMFOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 01:14:52 -0400
From: Jeffrey Brian Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC v2 PATCH 7/9] Ksplice: x86-32 and x86-64 support
Date: Sat, 13 Sep 2008 01:14:43 -0400
Message-Id: <95a158bee29bdcfa7d2bb537fdfe1e6af21599c7.1221282535.git.jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <6ba306125ffc8fbcf9ceb2960645827523247689.1221282535.git.jbarnold@mit.edu>
References: <1221282885-1150-1-git-send-email-jbarnold@mit.edu>
 <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
 <8cfda1c8f6c46e2f0fa9e9279aa2b2a213fba7a4.1221282535.git.jbarnold@mit.edu>
 <bdf8d7b52e2cb9ff3bbed52cedd28294086c9f56.1221282535.git.jbarnold@mit.edu>
 <401afda17296e380049b129c92a9ae27e8e47fc3.1221282535.git.jbarnold@mit.edu>
 <a827aed330aec871b73c468cf61c27048b26574d.1221282535.git.jbarnold@mit.edu>
 <6ba306125ffc8fbcf9ceb2960645827523247689.1221282535.git.jbarnold@mit.edu>
In-Reply-To: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
References: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Ksplice on x86.

Signed-off-by: Jeffrey Brian Arnold <jbarnold@mit.edu>
Signed-off-by: Anders Kaseorg <andersk@mit.edu>
Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 arch/x86/Kconfig               |    1 +
 arch/x86/kernel/ksplice-arch.c |   91 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_32.c          |    6 +-
 arch/x86/mm/init_64.c          |    4 +-
 4 files changed, 97 insertions(+), 5 deletions(-)
 create mode 100644 arch/x86/kernel/ksplice-arch.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ed92864..b5ec2f4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -23,6 +23,7 @@ config X86
 	select HAVE_OPROFILE
 	select HAVE_IOREMAP_PROT
 	select HAVE_KPROBES
+	select HAVE_KSPLICE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select HAVE_KRETPROBES
 	select HAVE_DYNAMIC_FTRACE
diff --git a/arch/x86/kernel/ksplice-arch.c b/arch/x86/kernel/ksplice-arch.c
new file mode 100644
index 0000000..52314c4
--- /dev/null
+++ b/arch/x86/kernel/ksplice-arch.c
@@ -0,0 +1,91 @@
+/*  Copyright (C) 2007-2008  Jeffrey Brian Arnold <jbarnold@mit.edu>
+ *  Copyright (C) 2008  Anders Kaseorg <andersk@mit.edu>,
+ *                      Tim Abbott <tabbott@mit.edu>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License, version 2.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 51 Franklin Street - Fifth Floor, Boston, MA
+ *  02110-1301, USA.
+ */
+
+#define KSPLICE_IP(x) ((x)->thread.ip)
+#define KSPLICE_SP(x) ((x)->thread.sp)
+
+static const struct ksplice_symbol trampoline_symbol = {
+	.name = NULL,
+	.label = "<trampoline>",
+};
+
+static const struct ksplice_reloc trampoline_reloc = {
+	.symbol = &trampoline_symbol,
+	.pcrel = 1,
+	.addend = -4,
+	.size = 4,
+	.dst_mask = 0xffffffffL,
+	.rightshift = 0,
+	.signed_addend = 1,
+};
+
+static abort_t trampoline_target(struct ksplice_pack *pack, unsigned long addr,
+				 unsigned long *new_addr)
+{
+	abort_t ret;
+	unsigned char byte;
+
+	if (probe_kernel_read(&byte, (void *)addr, sizeof(byte)) == -EFAULT)
+		return NO_MATCH;
+
+	if (byte != 0xe9)
+		return NO_MATCH;
+
+	ret = read_reloc_value(pack, &trampoline_reloc, addr + 1, new_addr);
+	if (ret != OK)
+		return ret;
+
+	*new_addr += addr + 1;
+	return OK;
+}
+
+static abort_t prepare_trampoline(struct ksplice_pack *pack,
+				  struct ksplice_trampoline *t)
+{
+	t->size = 5;
+	t->trampoline[0] = 0xe9;
+	return write_reloc_value(pack, &trampoline_reloc,
+				 (unsigned long)t->trampoline + 1,
+				 t->repladdr - (t->oldaddr + 1));
+}
+
+static abort_t handle_paravirt(struct ksplice_pack *pack,
+			       unsigned long pre_addr, unsigned long run_addr,
+			       int *matched)
+{
+	unsigned char run[5], pre[5];
+	*matched = 0;
+
+	if (probe_kernel_read(&run, (void *)run_addr, sizeof(run)) == -EFAULT ||
+	    probe_kernel_read(&pre, (void *)pre_addr, sizeof(pre)) == -EFAULT)
+		return OK;
+
+	if ((run[0] == 0xe8 && pre[0] == 0xe8) ||
+	    (run[0] == 0xe9 && pre[0] == 0xe9))
+		if (run_addr + 1 + *(int32_t *)&run[1] ==
+		    pre_addr + 1 + *(int32_t *)&pre[1])
+			*matched = 5;
+	return OK;
+}
+
+static bool valid_stack_ptr(const struct thread_info *tinfo, const void *p)
+{
+	return p > (const void *)tinfo
+	    && p <= (const void *)tinfo + THREAD_SIZE - sizeof(long);
+}
+
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index d37f293..5998d5c 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -1036,8 +1036,8 @@ void mark_rodata_ro(void)
 	unsigned long start = PFN_ALIGN(_text);
 	unsigned long size = PFN_ALIGN(_etext) - start;
 
-#ifndef CONFIG_DYNAMIC_FTRACE
-	/* Dynamic tracing modifies the kernel text section */
+#if !defined(CONFIG_DYNAMIC_FTRACE) && !defined(CONFIG_KSPLICE)
+	/* Dynamic tracing and Ksplice modify the kernel text section */
 	set_pages_ro(virt_to_page(start), size >> PAGE_SHIFT);
 	printk(KERN_INFO "Write protecting the kernel text: %luk\n",
 		size >> 10);
@@ -1050,7 +1050,7 @@ void mark_rodata_ro(void)
 	printk(KERN_INFO "Testing CPA: write protecting again\n");
 	set_pages_ro(virt_to_page(start), size>>PAGE_SHIFT);
 #endif
-#endif /* CONFIG_DYNAMIC_FTRACE */
+#endif /* !CONFIG_DYNAMIC_FTRACE && !CONFIG_KSPLICE */
 
 	start += size;
 	size = (unsigned long)__end_rodata - start;
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d3746ef..31db657 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -857,8 +857,8 @@ void mark_rodata_ro(void)
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 
-#ifdef CONFIG_DYNAMIC_FTRACE
-	/* Dynamic tracing modifies the kernel text section */
+#if defined(CONFIG_DYNAMIC_FTRACE) || defined(CONFIG_KSPLICE)
+	/* Dynamic tracing and Ksplice modify the kernel text section */
 	start = rodata_start;
 #endif
 
-- 
1.5.4.3

