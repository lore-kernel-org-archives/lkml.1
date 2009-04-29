Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbZD2Hq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbZD2Hq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbZD2Hp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:26 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55954 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbZD2HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 08/13] x86, vmlinux.lds: move vsyscall output sections
Date: Wed, 29 Apr 2009 09:47:24 +0200
Message-Id: <1240991249-27117-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simple move, no functional change

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/vmlinux.lds.S    |   71 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux_64.lds.S |   68 ------------------------------------
 2 files changed, 71 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 3d741dd..168de19 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -154,6 +154,77 @@ SECTIONS
 #endif
 	}
 
+#ifdef CONFIG_X86_64
+
+#define VSYSCALL_ADDR (-10*1024*1024)
+#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
+                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
+                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
+
+#define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
+#define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
+
+#define VVIRT_OFFSET (VSYSCALL_ADDR - VSYSCALL_VIRT_ADDR)
+#define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
+
+	. = VSYSCALL_ADDR;
+	.vsyscall_0 : AT(VSYSCALL_PHYS_ADDR) {
+		*(.vsyscall_0)
+	} :user
+
+	__vsyscall_0 = VSYSCALL_VIRT_ADDR;
+
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
+		*(.vsyscall_fn)
+	}
+
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	.vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data)) {
+		*(.vsyscall_gtod_data)
+	}
+
+	vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
+	.vsyscall_clock : AT(VLOAD(.vsyscall_clock)) {
+		*(.vsyscall_clock)
+	}
+	vsyscall_clock = VVIRT(.vsyscall_clock);
+
+
+	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
+		*(.vsyscall_1)
+	}
+	.vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) {
+		*(.vsyscall_2)
+	}
+
+	.vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) {
+		*(.vgetcpu_mode)
+	}
+	vgetcpu_mode = VVIRT(.vgetcpu_mode);
+
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+	.jiffies : AT(VLOAD(.jiffies)) {
+		*(.jiffies)
+	}
+	jiffies = VVIRT(.jiffies);
+
+	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
+		*(.vsyscall_3)
+	}
+
+	. = VSYSCALL_VIRT_ADDR + PAGE_SIZE;
+
+#undef VSYSCALL_ADDR
+#undef VSYSCALL_PHYS_ADDR
+#undef VSYSCALL_VIRT_ADDR
+#undef VLOAD_OFFSET
+#undef VLOAD
+#undef VVIRT_OFFSET
+#undef VVIRT
+
+#endif /* CONFIG_X86_64 */
 
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 8262701..013aa0e 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,71 +1,3 @@
-#define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-
-#define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
-#define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
-
-#define VVIRT_OFFSET (VSYSCALL_ADDR - VSYSCALL_VIRT_ADDR)
-#define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
-
-	. = VSYSCALL_ADDR;
-	.vsyscall_0 : AT(VSYSCALL_PHYS_ADDR) {
-		*(.vsyscall_0)
-	} :user
-
-	__vsyscall_0 = VSYSCALL_VIRT_ADDR;
-
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
-		*(.vsyscall_fn)
-	}
-
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-	.vsyscall_gtod_data : AT(VLOAD(.vsyscall_gtod_data)) {
-		*(.vsyscall_gtod_data)
-	}
-
-	vsyscall_gtod_data = VVIRT(.vsyscall_gtod_data);
-	.vsyscall_clock : AT(VLOAD(.vsyscall_clock)) {
-		*(.vsyscall_clock)
-	}
-	vsyscall_clock = VVIRT(.vsyscall_clock);
-
-
-	.vsyscall_1 ADDR(.vsyscall_0) + 1024: AT(VLOAD(.vsyscall_1)) {
-		*(.vsyscall_1)
-	}
-	.vsyscall_2 ADDR(.vsyscall_0) + 2048: AT(VLOAD(.vsyscall_2)) {
-		*(.vsyscall_2)
-	}
-
-	.vgetcpu_mode : AT(VLOAD(.vgetcpu_mode)) {
-		*(.vgetcpu_mode)
-	}
-	vgetcpu_mode = VVIRT(.vgetcpu_mode);
-
-	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-	.jiffies : AT(VLOAD(.jiffies)) {
-		*(.jiffies)
-	}
-	jiffies = VVIRT(.jiffies);
-
-	.vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3)) {
-		*(.vsyscall_3)
-	}
-
-	. = VSYSCALL_VIRT_ADDR + PAGE_SIZE;
-
-#undef VSYSCALL_ADDR
-#undef VSYSCALL_PHYS_ADDR
-#undef VSYSCALL_VIRT_ADDR
-#undef VLOAD_OFFSET
-#undef VLOAD
-#undef VVIRT_OFFSET
-#undef VVIRT
-
 	/* init_task */
 	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
 		. = ALIGN(THREAD_SIZE);
-- 
1.6.0.6

