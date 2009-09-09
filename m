Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbZIICsl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbZIICsl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:48:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbZIICsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:48:40 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45594 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751184AbZIICsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:48:40 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@redhat.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 1/5] x86: fix fragile computation of vsyscall address
Date: Tue,  8 Sep 2009 22:48:14 -0400
Message-Id: <1252464498-26293-1-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Kaseorg <andersk@ksplice.com>

Previously, the address of the vsyscall page (VSYSCALL_PHYS_ADDR,
VSYSCALL_VIRT_ADDR) was computed by arithmetic on the address of the
last section.  This leads to bugs when new sections are inserted, such
as the one fixed by commit d312ceda567ab91acd756cde95ac5fbc6b40ed40.
Let's compute it from the current address instead.

Signed-off-by: Anders Kaseorg <andersk@ksplice.com>
Signed-off-by: Tim Abbott <tabbott@ksplice.com>
---
 arch/x86/kernel/vmlinux.lds.S |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 9fc1782..e771251 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -135,24 +135,21 @@ SECTIONS
 #ifdef CONFIG_X86_64
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data) + SIZEOF(.data) + \
-                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data) + SIZEOF(.data) + \
-                            PAGE_SIZE - 1) & ~(PAGE_SIZE - 1))
 
-#define VLOAD_OFFSET (VSYSCALL_ADDR - VSYSCALL_PHYS_ADDR)
+#define VLOAD_OFFSET (VSYSCALL_ADDR - __vsyscall_0 + LOAD_OFFSET)
 #define VLOAD(x) (ADDR(x) - VLOAD_OFFSET)
 
-#define VVIRT_OFFSET (VSYSCALL_ADDR - VSYSCALL_VIRT_ADDR)
+#define VVIRT_OFFSET (VSYSCALL_ADDR - __vsyscall_0)
 #define VVIRT(x) (ADDR(x) - VVIRT_OFFSET)
 
+	. = ALIGN(4096);
+	__vsyscall_0 = .;
+
 	. = VSYSCALL_ADDR;
-	.vsyscall_0 : AT(VSYSCALL_PHYS_ADDR) {
+	.vsyscall_0 : AT(VLOAD(.vsyscall_0)) {
 		*(.vsyscall_0)
 	} :user
 
-	__vsyscall_0 = VSYSCALL_VIRT_ADDR;
-
 	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
 	.vsyscall_fn : AT(VLOAD(.vsyscall_fn)) {
 		*(.vsyscall_fn)
@@ -192,11 +189,9 @@ SECTIONS
 		*(.vsyscall_3)
 	}
 
-	. = VSYSCALL_VIRT_ADDR + PAGE_SIZE;
+	. = __vsyscall_0 + PAGE_SIZE;
 
 #undef VSYSCALL_ADDR
-#undef VSYSCALL_PHYS_ADDR
-#undef VSYSCALL_VIRT_ADDR
 #undef VLOAD_OFFSET
 #undef VLOAD
 #undef VVIRT_OFFSET
-- 
1.6.3.3

