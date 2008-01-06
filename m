Return-Path: <linux-kernel-owner+w=401wt.eu-S1756216AbYAFOkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbYAFOkR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754438AbYAFOjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:39:42 -0500
Received: from il.qumranet.com ([82.166.9.18]:46585 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753175AbYAFOjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:41 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Marcelo Tosatti <marcelo@kvack.org>
Subject: [PATCH 02/33] KVM: MMU: emulated cmpxchg8b should be atomic on i386
Date: Sun,  6 Jan 2008 16:39:08 +0200
Message-Id: <1199630379-28638-3-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcelo Tosatti <marcelo@kvack.org>

Emulate cmpxchg8b atomically on i386. This is required to avoid a guest
pte walker from seeing a splitted write.

[avi: make it compile]

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86.c |   26 ++++++++++++++++++++++++++
 1 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 9db4e32..3b79684 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -25,6 +25,7 @@
 #include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/mman.h>
+#include <linux/highmem.h>
 
 #include <asm/uaccess.h>
 #include <asm/msr.h>
@@ -1674,6 +1675,31 @@ static int emulator_cmpxchg_emulated(unsigned long addr,
 		reported = 1;
 		printk(KERN_WARNING "kvm: emulating exchange as write\n");
 	}
+#ifndef CONFIG_X86_64
+	/* guests cmpxchg8b have to be emulated atomically */
+	if (bytes == 8) {
+		gpa_t gpa = vcpu->mmu.gva_to_gpa(vcpu, addr);
+		struct page *page;
+		char *addr;
+		u64 val;
+
+		if (gpa == UNMAPPED_GVA ||
+		   (gpa & PAGE_MASK) == APIC_DEFAULT_PHYS_BASE)
+			goto emul_write;
+
+		if (((gpa + bytes - 1) & PAGE_MASK) != (gpa & PAGE_MASK))
+			goto emul_write;
+
+		val = *(u64 *)new;
+		page = gfn_to_page(vcpu->kvm, gpa >> PAGE_SHIFT);
+		addr = kmap_atomic(page, KM_USER0);
+		set_64bit((u64 *)(addr + offset_in_page(gpa)), val);
+		kunmap_atomic(addr, KM_USER0);
+		kvm_release_page_dirty(page);
+	}
+emul_write:
+#endif
+
 	return emulator_write_emulated(addr, new, bytes, vcpu);
 }
 
-- 
1.5.3.7

