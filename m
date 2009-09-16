Return-Path: <linux-kernel-owner+w=401wt.eu-S1760093AbZIPVCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760093AbZIPVCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbZIPVCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:02:43 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:56883 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760080AbZIPVCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:02:42 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>
Subject: [PATCH v3 1/5] x86: fix fragile computation of vsyscall address
Date: Wed, 16 Sep 2009 16:44:26 -0400
Message-Id: <1253133870-25140-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253133870-25140-1-git-send-email-tabbott@ksplice.com>
References: <1253133870-25140-1-git-send-email-tabbott@ksplice.com>
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
---
 arch/x86/kernel/vmlinux.lds.S |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 0ccb57d..b96ca47 100644
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

