Return-Path: <linux-kernel-owner+w=401wt.eu-S1752838AbYHLDPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbYHLDPf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 23:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752514AbYHLDOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 23:14:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:18352 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbYHLDOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 23:14:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,192,1217833200"; 
   d="scan'208";a="325417076"
Subject: [PATCH -v3 3/7] kexec jump: check code size in control page
From: Huang Ying <ying.huang@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, mingo@elte.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 11:14:28 +0800
Message-Id: <1218510868.24951.42.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kexec/Kexec-jump require code size in control page is less than
PAGE_SIZE/2. This patch add link-time checking for this.

ASSERT() of ld link script is used as the link-time checking
mechanism.

Signed-off-by: Huang Ying <ying.huang@intel.com>

---
 arch/x86/kernel/machine_kexec_32.c   |    2 +-
 arch/x86/kernel/relocate_kernel_32.S |   10 +++++++---
 arch/x86/kernel/vmlinux_32.lds.S     |    6 ++++++
 include/asm-x86/kexec.h              |    4 ++++
 4 files changed, 18 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/machine_kexec_32.c
+++ b/arch/x86/kernel/machine_kexec_32.c
@@ -138,7 +138,7 @@ void machine_kexec(struct kimage *image)
 	}
 
 	control_page = page_address(image->control_code_page);
-	memcpy(control_page, relocate_kernel, PAGE_SIZE/2);
+	memcpy(control_page, relocate_kernel, KEXEC_CONTROL_CODE_MAX_SIZE);
 
 	relocate_kernel_ptr = control_page;
 	page_list[PA_CONTROL_PAGE] = __pa(control_page);
--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -20,10 +20,11 @@
 #define PAGE_ATTR (_PAGE_PRESENT | _PAGE_RW | _PAGE_ACCESSED | _PAGE_DIRTY)
 #define PAE_PGD_ATTR (_PAGE_PRESENT)
 
-/* control_page + PAGE_SIZE/2 ~ control_page + PAGE_SIZE * 3/4 are
- * used to save some data for jumping back
+/* control_page + KEXEC_CONTROL_CODE_MAX_SIZE
+ * ~ control_page + PAGE_SIZE are used as data storage and stack for
+ * jumping back
  */
-#define DATA(offset)		(PAGE_SIZE/2+(offset))
+#define DATA(offset)		(KEXEC_CONTROL_CODE_MAX_SIZE+(offset))
 
 /* Minimal CPU state */
 #define ESP			DATA(0x0)
@@ -376,3 +377,6 @@ swap_pages:
 	popl	%ebx
 	popl	%ebp
 	ret
+
+	.globl kexec_control_code_size
+.set kexec_control_code_size, . - relocate_kernel
--- a/include/asm-x86/kexec.h
+++ b/include/asm-x86/kexec.h
@@ -41,6 +41,10 @@
 # define PAGES_NR		17
 #endif
 
+#ifdef CONFIG_X86_32
+# define KEXEC_CONTROL_CODE_MAX_SIZE	2048
+#endif
+
 #ifndef __ASSEMBLY__
 
 #include <linux/string.h>
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -209,3 +209,9 @@ SECTIONS
 
   DWARF_DEBUG
 }
+
+/* Link time checks */
+#include <asm/kexec.h>
+
+ASSERT(kexec_control_code_size <= KEXEC_CONTROL_CODE_MAX_SIZE,
+       "kexec control code size is too big")


