Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbZEMDSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbZEMDSk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 23:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbZEMDGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 23:06:34 -0400
Received: from adsl-99-35-133-201.dsl.pltn13.sbcglobal.net ([99.35.133.201]:36239
	"EHLO abulafia.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756119AbZEMDGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 23:06:12 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Matthew Wilcox <willy@linux.intel.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 10/10] xen: define BIOVEC_PHYS_MERGEABLE()
Date: Tue, 12 May 2009 14:48:11 -0700
Message-Id: <1242164891-3859-11-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1242164891-3859-1-git-send-email-jeremy@goop.org>
References: <1242164891-3859-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running in Xen domain with device access, we need to make sure
the block subsystem doesn't merge requests across pages which aren't
machine physically contiguous.  To do this, we define our own
BIOVEC_PHYS_MERGEABLE.  When CONFIG_XEN isn't enabled, or we're not
running in a Xen domain, this has identical behaviour to the normal
implementation.  When running under Xen, we also make sure the
underlying machine pages are the same or adjacent.

[ Impact: allow Xen control of bio merging ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/io.h |   13 +++++++++++++
 drivers/xen/Makefile      |    2 +-
 drivers/xen/biomerge.c    |   14 ++++++++++++++
 3 files changed, 28 insertions(+), 1 deletions(-)
 create mode 100644 drivers/xen/biomerge.c

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 57c7b26..c75e9eb 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -7,6 +7,8 @@
 #include <asm-generic/int-ll64.h>
 #include <asm/page.h>
 
+#include <asm/xen/hypervisor.h>
+
 extern int isapnp_disable;
 
 #define build_mmio_read(name, size, type, reg, barrier) \
@@ -201,6 +203,17 @@ extern void __iomem *early_memremap(resource_size_t phys_addr,
 				    unsigned long size);
 extern void early_iounmap(void __iomem *addr, unsigned long size);
 
+#ifdef CONFIG_XEN
+struct bio_vec;
+
+extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
+				      const struct bio_vec *vec2);
+
+#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
+	(__BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&				\
+	 (!xen_domain() || xen_biovec_phys_mergeable(vec1, vec2)))
+#endif	/* CONFIG_XEN */
+
 #define IO_SPACE_LIMIT 0xffff
 
 #endif /* _ASM_X86_IO_H */
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index ec2a39b..e6c8b85 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,4 +1,4 @@
-obj-y	+= grant-table.o features.o events.o manage.o
+obj-y	+= grant-table.o features.o events.o manage.o biomerge.o
 obj-y	+= xenbus/
 
 obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
diff --git a/drivers/xen/biomerge.c b/drivers/xen/biomerge.c
new file mode 100644
index 0000000..d40f534
--- /dev/null
+++ b/drivers/xen/biomerge.c
@@ -0,0 +1,14 @@
+#include <linux/bio.h>
+#include <asm/io.h>
+#include <xen/page.h>
+
+bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
+			       const struct bio_vec *vec2)
+{
+	unsigned long mfn1 = pfn_to_mfn(page_to_pfn(vec1->bv_page));
+	unsigned long mfn2 = pfn_to_mfn(page_to_pfn(vec2->bv_page));
+
+	return __BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&
+		((mfn1 == mfn2) || ((mfn1+1) == mfn2));
+}
+
-- 
1.6.0.6

