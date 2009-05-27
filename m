Return-Path: <linux-kernel-owner+w=401wt.eu-S1764108AbZE0Hjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764108AbZE0Hjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763935AbZE0Hhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:37:53 -0400
Received: from claw.goop.org ([74.207.240.146]:41695 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763933AbZE0Hhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:37:51 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>, Greg KH <gregkh@suse.de>,
       Jens Axboe <jens.axboe@oracle.com>, Chris Wright <chrisw@redhat.com>,
       kurt.hackel@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Ky Srinivasan <ksrinivasan@novell.com>, Beulich <jbeulich@novell.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Avi Kivity <avi@redhat.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 02/17] x86: add io_apic_ops to allow interception
Date: Wed, 27 May 2009 00:37:15 -0700
Message-Id: <1243409850-21577-3-git-send-email-jeremy@goop.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1243409850-21577-1-git-send-email-jeremy@goop.org>
References: <1243409850-21577-1-git-send-email-jeremy@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

Xen dom0 needs to paravirtualize IO operations to the IO APIC, so add
a io_apic_ops for it to intercept.  Do this as ops structure because
there's at least some chance that another paravirtualized environment
may want to intercept these.

[ Impact: indirect IO APIC access via io_apic_ops ]

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/io_apic.h |    9 +++++++
 arch/x86/kernel/apic/io_apic.c |   50 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 9d826e4..8cbfe73 100644
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
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 30da617..c24f116 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -66,6 +66,25 @@
 
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
@@ -385,6 +404,24 @@ set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
 }
 #endif
 
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
@@ -405,14 +442,15 @@ static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
 	writel(vector, &io_apic->eoi);
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
@@ -425,7 +463,8 @@ static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned i
  *
  * Older SiS APIC requires we rewrite the index register
  */
-static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+static void __io_apic_modify(unsigned int apic, unsigned int reg,
+			     unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -4141,6 +4180,11 @@ static struct resource * __init ioapic_setup_resources(void)
 
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
-- 
1.6.0.6

