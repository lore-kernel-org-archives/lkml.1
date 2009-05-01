Return-Path: <linux-kernel-owner+w=401wt.eu-S933763AbZEAAcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933763AbZEAAcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932147AbZEAAJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:09:30 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:62849 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932146AbZEAAJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:09:28 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@MIT.EDU>
Subject: [PATCH 09/11] x86: fix fragile computation of vsyscall address
Date: Thu, 30 Apr 2009 20:01:36 -0400
Message-Id: <1241136098-10376-10-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-9-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
 <1241136098-10376-2-git-send-email-tabbott@mit.edu>
 <1241136098-10376-3-git-send-email-tabbott@mit.edu>
 <1241136098-10376-4-git-send-email-tabbott@mit.edu>
 <1241136098-10376-5-git-send-email-tabbott@mit.edu>
 <1241136098-10376-6-git-send-email-tabbott@mit.edu>
 <1241136098-10376-7-git-send-email-tabbott@mit.edu>
 <1241136098-10376-8-git-send-email-tabbott@mit.edu>
 <1241136098-10376-9-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anders Kaseorg <andersk@mit.edu>

Previously, the address of the vsyscall page (VSYSCALL_PHYS_ADDR,
VSYSCALL_VIRT_ADDR) was computed by arithmetic on the address of the
last section.  This leads to bugs when new sections are inserted, such
as the one fixed by commit d312ceda567ab91acd756cde95ac5fbc6b40ed40.
Let's compute it from the current address instead.

Signed-off-by: Anders Kaseorg <andersk@mit.edu>
---
 arch/x86/kernel/vmlinux.lds.S |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 6b8a633..296b49c 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -137,24 +137,21 @@ SECTIONS
 #ifdef CONFIG_X86_64
 
 #define VSYSCALL_ADDR (-10*1024*1024)
-#define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
-#define VSYSCALL_VIRT_ADDR ((ADDR(.data.read_mostly) + \
-                            SIZEOF(.data.read_mostly) + 4095) & ~(4095))
 
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
@@ -194,11 +191,9 @@ SECTIONS
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
1.6.2.1

