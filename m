Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0BMBnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 20:43:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:26860 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab0BMBka convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 20:40:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,464,1262592000"; 
   d="scan'208,223";a="595625789"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       "Du, Alek" <alek.du@intel.com>, "Tang, Feng" <feng.tang@intel.com>,
       "H. Peter Anvin" <hpa@linux.intel.com>
Date: Fri, 12 Feb 2010 17:40:28 -0800
Subject: [PATCH 7/9] x86/pic: introduce legacy_pic abstraction
Thread-Topic: [PATCH 7/9] x86/pic: introduce legacy_pic abstraction
Thread-Index: AcqsTYVCRw8Jm4RiTMevjupOsbOZOA==
Message-ID: <43F901BD926A4E43B106BF17856F07559FB80D03@orsmsx508.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4fe315a8535a0baadc2252f10cc76f98ed73f72b Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Mon, 9 Nov 2009 11:24:14 -0800
Subject: [PATCH 7/9] x86/pic: introduce legacy_pic abstraction

this patch makes i8259a like legacy programmable interrupt controller code into a driver
so that legacy pic functions can be selected at runtime based on platform information, such
as HW subarchitecure ID.
default structure of legacy_pic maintains the current code path for x86pc.

Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
---
 arch/x86/include/asm/i8259.h |   13 ++++++++++++
 arch/x86/kernel/i8259.c      |   43 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
index 58d7091..e8a3e05 100644
--- a/arch/x86/include/asm/i8259.h
+++ b/arch/x86/include/asm/i8259.h
@@ -57,6 +57,19 @@ static inline void outb_pic(unsigned char value, unsigned int port)
 
 extern struct irq_chip i8259A_chip;
 
+struct legacy_pic {
+	int nr_legacy_irqs;
+	struct irq_chip *chip;
+	void (*mask_all)(void);
+	void (*restore_mask)(void);
+	void (*init)(int auto_eoi);
+	int (*irq_pending)(unsigned int irq);
+	void (*make_irq)(unsigned int irq);
+};
+
+extern struct legacy_pic *legacy_pic;
+extern struct legacy_pic null_legacy_pic;
+
 extern void mask_8259A(void);
 extern void unmask_8259A(void);
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index df89102..b80987c 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -358,3 +358,46 @@ void init_8259A(int auto_eoi)
 
 	spin_unlock_irqrestore(&i8259A_lock, flags);
 }
+/*
+ * make i8259 a driver so that we can select pic functions at run time. the goal
+ * is to make x86 binary compatible among pc compatible and non-pc compatible
+ * platforms, such as x86 MID.
+ */
+
+static void __init legacy_pic_noop(void) { };
+static void __init legacy_pic_uint_noop(unsigned int unused) { };
+static void __init legacy_pic_int_noop(int unused) { };
+
+static struct irq_chip dummy_pic_chip  = {
+	.name = "dummy pic",
+	.mask = legacy_pic_uint_noop,
+	.unmask = legacy_pic_uint_noop,
+	.disable = legacy_pic_uint_noop,
+	.mask_ack = legacy_pic_uint_noop,
+};
+static int legacy_pic_irq_pending_noop(unsigned int irq)
+{
+	return 0;
+}
+
+struct legacy_pic null_legacy_pic = {
+	.nr_legacy_irqs = 0,
+	.chip = &dummy_pic_chip,
+	.mask_all = legacy_pic_noop,
+	.restore_mask = legacy_pic_noop,
+	.init = legacy_pic_int_noop,
+	.irq_pending = legacy_pic_irq_pending_noop,
+	.make_irq = legacy_pic_uint_noop,
+};
+
+struct legacy_pic default_legacy_pic = {
+	.nr_legacy_irqs = NR_IRQS_LEGACY,
+	.chip  = &i8259A_chip,
+	.mask_all  = mask_8259A,
+	.restore_mask = unmask_8259A,
+	.init = init_8259A,
+	.irq_pending = i8259A_irq_pending,
+	.make_irq = make_8259A_irq,
+};
+
+struct legacy_pic *legacy_pic = &default_legacy_pic;
-- 
1.6.5.3

