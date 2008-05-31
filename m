Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYEaAel@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYEaAel (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 20:34:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755413AbYEaAdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 20:33:53 -0400
Received: from host217-43-228-68.range217-43.btcentralplus.com ([217.43.228.68]:41965
	"EHLO mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752421AbYEaAdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 20:33:50 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 3] xen: add new Xen elfnote types and use them
	appropriately
X-Mercurial-Node: 6c421e599ba136b73fd913bfbe1846a3b8fab3d1
Message-Id: <6c421e599ba136b73fd9.1212193984@localhost>
In-Reply-To: <patchbomb.1212193981@localhost>
Date: Sat, 31 May 2008 01:33:04 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define recently added XEN_ELFNOTEs, and use them appropriately.
Most significantly, this enables domain checkpointing (xm save -c).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/xen-head.S         |    5 +++++
 include/xen/interface/elfnote.h |   20 ++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -7,6 +7,7 @@
 #include <linux/init.h>
 #include <asm/boot.h>
 #include <xen/interface/elfnote.h>
+#include <asm/xen/interface.h>
 
 	__INIT
 ENTRY(startup_xen)
@@ -32,5 +33,9 @@
 	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
 	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
 	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
+	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
+		.quad _PAGE_PRESENT; .quad _PAGE_PRESENT)
+	ELFNOTE(Xen, XEN_ELFNOTE_SUSPEND_CANCEL, .long 1)
+	ELFNOTE(Xen, XEN_ELFNOTE_HV_START_LOW,   .long __HYPERVISOR_VIRT_START)
 
 #endif /*CONFIG_XEN */
diff --git a/include/xen/interface/elfnote.h b/include/xen/interface/elfnote.h
--- a/include/xen/interface/elfnote.h
+++ b/include/xen/interface/elfnote.h
@@ -120,6 +120,26 @@
  */
 #define XEN_ELFNOTE_BSD_SYMTAB    11
 
+/*
+ * The lowest address the hypervisor hole can begin at (numeric).
+ *
+ * This must not be set higher than HYPERVISOR_VIRT_START. Its presence
+ * also indicates to the hypervisor that the kernel can deal with the
+ * hole starting at a higher address.
+ */
+#define XEN_ELFNOTE_HV_START_LOW  12
+
+/*
+ * List of maddr_t-sized mask/value pairs describing how to recognize
+ * (non-present) L1 page table entries carrying valid MFNs (numeric).
+ */
+#define XEN_ELFNOTE_L1_MFN_VALID  13
+
+/*
+ * Whether or not the guest supports cooperative suspend cancellation.
+ */
+#define XEN_ELFNOTE_SUSPEND_CANCEL 14
+
 #endif /* __XEN_PUBLIC_ELFNOTE_H__ */
 
 /*


