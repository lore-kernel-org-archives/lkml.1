Return-Path: <linux-kernel-owner+w=401wt.eu-S1754317AbYIMFS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317AbYIMFS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 01:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYIMFRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 01:17:54 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:40806 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752022AbYIMFRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 01:17:54 -0400
From: Jeffrey Brian Arnold <jbarnold@MIT.EDU>
To: linux-kernel@vger.kernel.org
Cc: Tim Abbott <tabbott@MIT.EDU>, Anders Kaseorg <andersk@MIT.EDU>,
       Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>
Subject: [RFC v2 PATCH 8/9] Ksplice: ARM support
Date: Sat, 13 Sep 2008 01:14:44 -0400
Message-Id: <9db918711d1108cc89f991e2494f58d60cbd2555.1221282535.git.jbarnold@mit.edu>
X-Mailer: git-send-email 1.6.0
In-Reply-To: <95a158bee29bdcfa7d2bb537fdfe1e6af21599c7.1221282535.git.jbarnold@mit.edu>
References: <1221282885-1150-1-git-send-email-jbarnold@mit.edu>
 <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
 <8cfda1c8f6c46e2f0fa9e9279aa2b2a213fba7a4.1221282535.git.jbarnold@mit.edu>
 <bdf8d7b52e2cb9ff3bbed52cedd28294086c9f56.1221282535.git.jbarnold@mit.edu>
 <401afda17296e380049b129c92a9ae27e8e47fc3.1221282535.git.jbarnold@mit.edu>
 <a827aed330aec871b73c468cf61c27048b26574d.1221282535.git.jbarnold@mit.edu>
 <6ba306125ffc8fbcf9ceb2960645827523247689.1221282535.git.jbarnold@mit.edu>
 <95a158bee29bdcfa7d2bb537fdfe1e6af21599c7.1221282535.git.jbarnold@mit.edu>
In-Reply-To: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
References: <bfbae790a8f63d8697062036d47e0756e9f3ad5f.1221282535.git.jbarnold@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for Ksplice on ARM.

Signed-off-by: Jeffrey Brian Arnold <jbarnold@mit.edu>
Signed-off-by: Anders Kaseorg <andersk@mit.edu>
Signed-off-by: Tim Abbott <tabbott@mit.edu>
---
 arch/arm/Kconfig               |    1 +
 arch/arm/kernel/ksplice-arch.c |   79 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/kernel/ksplice-arch.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 70dba16..e73f205 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -14,6 +14,7 @@ config ARM
 	select HAVE_OPROFILE
 	select HAVE_ARCH_KGDB
 	select HAVE_KPROBES if (!XIP_KERNEL)
+	select HAVE_KSPLICE if (!XIP_KERNEL)
 	select HAVE_KRETPROBES if (HAVE_KPROBES)
 	select HAVE_FTRACE if (!XIP_KERNEL)
 	select HAVE_DYNAMIC_FTRACE if (HAVE_FTRACE)
diff --git a/arch/arm/kernel/ksplice-arch.c b/arch/arm/kernel/ksplice-arch.c
new file mode 100644
index 0000000..981cf75
--- /dev/null
+++ b/arch/arm/kernel/ksplice-arch.c
@@ -0,0 +1,79 @@
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
+#include <linux/thread_info.h>
+#define KSPLICE_IP(x) thread_saved_pc(x)
+#define KSPLICE_SP(x) thread_saved_fp(x)
+
+static const struct ksplice_symbol trampoline_symbol = {
+	.name = NULL,
+	.label = "<trampoline>",
+};
+
+static const struct ksplice_reloc trampoline_reloc = {
+	.symbol = &trampoline_symbol,
+	.pcrel = 1,
+	.addend = -8,
+	.size = 4,
+	.dst_mask = 0x00ffffffL,
+	.rightshift = 2,
+	.signed_addend = 1,
+};
+
+static abort_t trampoline_target(struct ksplice_pack *pack, unsigned long addr,
+				 unsigned long *new_addr)
+{
+	abort_t ret;
+	uint32_t word;
+	if (probe_kernel_read(&word, (void *)addr, sizeof(word)) == -EFAULT)
+		return NO_MATCH;
+
+	if ((word & 0xff000000) != 0xea000000)
+		return NO_MATCH;
+
+	ret = read_reloc_value(pack, &trampoline_reloc, addr, new_addr);
+	if (ret != OK)
+		return ret;
+
+	*new_addr += addr;
+	return OK;
+}
+
+static abort_t prepare_trampoline(struct ksplice_pack *pack,
+				  struct ksplice_trampoline *t)
+{
+	t->size = 4;
+	*(uint32_t *)t->trampoline = 0xea000000;
+	return write_reloc_value(pack, &trampoline_reloc,
+				 (unsigned long)t->trampoline,
+				 t->repladdr - t->oldaddr);
+}
+
+static abort_t handle_paravirt(struct ksplice_pack *pack,
+			       unsigned long pre_addr, unsigned long run_addr,
+			       int *matched)
+{
+	*matched = 0;
+	return OK;
+}
+
+static bool valid_stack_ptr(const struct thread_info *tinfo, const void *p)
+{
+	return p > (const void *)tinfo
+	    && p <= (const void *)tinfo + THREAD_SIZE - sizeof(long);
+}
-- 
1.5.4.3

