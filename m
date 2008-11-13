Return-Path: <linux-kernel-owner+w=401wt.eu-S1754658AbYKMTh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbYKMTh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 14:37:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754169AbYKMTeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 14:34:13 -0500
Received: from gw.goop.org ([64.81.55.164]:34388 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbYKMTeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 14:34:05 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 07 of 38] x86: add io_apic_ops
X-Mercurial-Node: 43f6a940f3f0db210a84d05adde777dcb92b3340
Message-Id: <43f6a940f3f0db210a84.1226603405@abulafia.goop.org>
In-Reply-To: <patchbomb.1226603398@abulafia.goop.org>
Date: Thu, 13 Nov 2008 11:10:05 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Ian Campbell <ian.campbell@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xen dom0 needs to paravirtualize IO operations to the IO APIC, so add
a io_apic_ops for it to intercept.  Do this as ops structure because
there's at least some chance that another paravirtualized environment
may want to intercept these.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/io_apic.h |    9 +++++++
 arch/x86/kernel/io_apic.c      |   50 +++++++++++++++++++++++++++++++++++++---
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -21,6 +21,15 @@
 #define IO_APIC_REDIR_LEVEL_TRIGGER	(1 << 15)
 #define IO_APIC_REDIR_MASKED		(1 << 16)
 
+struct io_apic_ops {
+	void (*init)(void);
+	unsigned int (*read)(unsigned int apic, unsigned int reg);
+	void (*write)(unsigned int apic, unsigned int reg, unsigned int value);
+	void (*modify)(unsigned int apic, unsigned int reg, unsigned int value);
+};
+
+void __init set_io_apic_ops(const struct io_apic_ops *);
+
 /*
  * The structure of the IO-APIC:
  */
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -67,6 +67,25 @@
 
 #define __apicdebuginit(type) static type __init
 
+static void __init __ioapic_init_mappings(void);
+static unsigned int __io_apic_read(unsigned int apic, unsigned int reg);
+static void __io_apic_write(unsigned int apic, unsigned int reg,
+			    unsigned int val);
+static void __io_apic_modify(unsigned int apic, unsigned int reg,
+			     unsigned int val);
+
+static struct io_apic_ops io_apic_ops = {
+	.init = __ioapic_init_mappings,
+	.read = __io_apic_read,
+	.write = __io_apic_write,
+	.modify = __io_apic_modify,
+};
+
+void __init set_io_apic_ops(const struct io_apic_ops *ops)
+{
+	io_apic_ops = *ops;
+}
+
 /*
  *      Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
@@ -196,6 +215,24 @@
 	return pin;
 }
 
+static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
+{
+	return io_apic_ops.read(apic, reg);
+}
+
+static inline void io_apic_write(unsigned int apic, unsigned int reg,
+				 unsigned int value)
+{
+	io_apic_ops.write(apic, reg, value);
+}
+
+static inline void io_apic_modify(unsigned int apic, unsigned int reg,
+				  unsigned int value)
+{
+	io_apic_ops.modify(apic, reg, value);
+}
+
+
 struct io_apic {
 	unsigned int index;
 	unsigned int unused[3];
@@ -208,14 +245,15 @@
 		+ (mp_ioapics[idx].mp_apicaddr & ~PAGE_MASK);
 }
 
-static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
+static unsigned int __io_apic_read(unsigned int apic, unsigned int reg)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 	writel(reg, &io_apic->index);
 	return readl(&io_apic->data);
 }
 
-static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+static void __io_apic_write(unsigned int apic, unsigned int reg,
+			    unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 	writel(reg, &io_apic->index);
@@ -228,7 +266,8 @@
  *
  * Older SiS APIC requires we rewrite the index register
  */
-static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+static void __io_apic_modify(unsigned int apic, unsigned int reg,
+			     unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -3848,6 +3887,11 @@
 
 void __init ioapic_init_mappings(void)
 {
+	io_apic_ops.init();
+}
+
+static void __init __ioapic_init_mappings(void)
+{
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	struct resource *ioapic_res;
 	int i;


