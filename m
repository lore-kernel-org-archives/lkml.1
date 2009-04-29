Return-Path: <linux-kernel-owner+w=401wt.eu-S1758357AbZD2JIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758357AbZD2JIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbZD2JGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:06:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:60498 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756237AbZD2JGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:06:14 -0400
Date: Wed, 29 Apr 2009 09:04:46 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-8-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-8-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: move vsyscall output sections
Message-ID: <tip-ff6f87e1626e10beef675084c9b5384a9477e3d5@git.kernel.org>
Git-Commit-ID: ff6f87e1626e10beef675084c9b5384a9477e3d5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:04:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff6f87e1626e10beef675084c9b5384a9477e3d5
Gitweb:     http://git.kernel.org/tip/ff6f87e1626e10beef675084c9b5384a9477e3d5
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Wed, 29 Apr 2009 09:47:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 10:20:32 +0200

x86, vmlinux.lds: move vsyscall output sections

[ Impact: cleanup ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-8-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S    |   71 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux_64.lds.S |   68 ------------------------------------
 2 files changed, 71 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 067bdb0..b3106c2 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -159,6 +159,77 @@ SECTIONS
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
