Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab0BWG2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:28:07 -0500
Received: from mga11.intel.com ([192.55.52.93]:33015 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab0BWG2F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:28:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,524,1262592000"; 
   d="scan'208";a="543033968"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
CC: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Date: Mon, 22 Feb 2010 22:28:00 -0800
Subject: RE: [tip:x86/mrst] x86, pic: Introduce legacy_pic abstraction
Thread-Topic: [tip:x86/mrst] x86, pic: Introduce legacy_pic abstraction
Thread-Index: AcqxzCSjSmVYMZaFTSmnneE5Cvo0xwCg5u6Q
Message-ID: <43F901BD926A4E43B106BF17856F0755A318D2CD@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559FB80D03@orsmsx508.amr.corp.intel.com>
 <tip-ef3548668c02cc8c3922f4423f32b53e662811c6@git.kernel.org>
In-Reply-To: <tip-ef3548668c02cc8c3922f4423f32b53e662811c6@git.kernel.org>
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

this patch replaces the current one with section mismatch fix in i8259.c.

static void legacy_pic_noop(void) { };
static void legacy_pic_uint_noop(unsigned int unused) { };
static void legacy_pic_int_noop(int unused) { };




>From 0821c36d1de8a20a8e690c620913ea2c2bc3ff27 Mon Sep 17 00:00:00 2001
From: Jacob Pan <jacob.jun.pan@intel.com>
Date: Mon, 9 Nov 2009 11:24:14 -0800
Subject: [PATCH] x86/pic: introduce legacy_pic abstraction

this patch makes i8259a like legacy programmable interrupt controller code into
a driver so that legacy pic functions can be selected at runtime based on
platform information, such as HW subarchitecure ID.

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
index df89102..ed4a488 100644
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
+static void legacy_pic_noop(void) { };
+static void legacy_pic_uint_noop(unsigned int unused) { };
+static void legacy_pic_int_noop(int unused) { };
+
+static struct irq_chip dummy_pic_chip = {
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
1.5.6.5


>-----Original Message-----
>From: tip tree robot [mailto:bounces.tip@hpa.at.zytor.com] On Behalf Of tip-bot
>for Jacob Pan
>Sent: Friday, February 19, 2010 5:29 PM
>To: linux-tip-commits@vger.kernel.org
>Cc: linux-kernel@vger.kernel.org; hpa@zytor.com; mingo@redhat.com; Pan, Jacob
>jun; tglx@linutronix.de
>Subject: [tip:x86/mrst] x86, pic: Introduce legacy_pic abstraction
>
>Commit-ID:  ef3548668c02cc8c3922f4423f32b53e662811c6
>Gitweb:     http://git.kernel.org/tip/ef3548668c02cc8c3922f4423f32b53e662811c6
>Author:     Jacob Pan <jacob.jun.pan@intel.com>
>AuthorDate: Mon, 9 Nov 2009 11:24:14 -0800
>Committer:  H. Peter Anvin <hpa@zytor.com>
>CommitDate: Fri, 19 Feb 2010 16:25:17 -0800
>
>x86, pic: Introduce legacy_pic abstraction
>
>This patch makes i8259A like legacy programmable interrupt controller
>code into a driver so that legacy pic functions can be selected at
>runtime based on platform information, such as HW subarchitecure ID.
>Default structure of legacy_pic maintains the current code path for
>x86pc.
>
>Signed-off-by: Jacob Pan <jacob.jun.pan@intel.com>
>LKML-Reference:
><43F901BD926A4E43B106BF17856F07559FB80D03@orsmsx508.amr.corp.intel.com>
>Signed-off-by: H. Peter Anvin <hpa@zytor.com>
>---
> arch/x86/include/asm/i8259.h |   13 ++++++++++++
> arch/x86/kernel/i8259.c      |   43 ++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 56 insertions(+), 0 deletions(-)
>
>diff --git a/arch/x86/include/asm/i8259.h b/arch/x86/include/asm/i8259.h
>index 58d7091..e8a3e05 100644
>--- a/arch/x86/include/asm/i8259.h
>+++ b/arch/x86/include/asm/i8259.h
>@@ -57,6 +57,19 @@ static inline void outb_pic(unsigned char value, unsigned
>int port)
>
> extern struct irq_chip i8259A_chip;
>
>+struct legacy_pic {
>+	int nr_legacy_irqs;
>+	struct irq_chip *chip;
>+	void (*mask_all)(void);
>+	void (*restore_mask)(void);
>+	void (*init)(int auto_eoi);
>+	int (*irq_pending)(unsigned int irq);
>+	void (*make_irq)(unsigned int irq);
>+};
>+
>+extern struct legacy_pic *legacy_pic;
>+extern struct legacy_pic null_legacy_pic;
>+
> extern void mask_8259A(void);
> extern void unmask_8259A(void);
>
>diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
>index df89102..b80987c 100644
>--- a/arch/x86/kernel/i8259.c
>+++ b/arch/x86/kernel/i8259.c
>@@ -358,3 +358,46 @@ void init_8259A(int auto_eoi)
>
> 	spin_unlock_irqrestore(&i8259A_lock, flags);
> }
>+/*
>+ * make i8259 a driver so that we can select pic functions at run time. the
>goal
>+ * is to make x86 binary compatible among pc compatible and non-pc compatible
>+ * platforms, such as x86 MID.
>+ */
>+
>+static void __init legacy_pic_noop(void) { };
>+static void __init legacy_pic_uint_noop(unsigned int unused) { };
>+static void __init legacy_pic_int_noop(int unused) { };
>+
>+static struct irq_chip dummy_pic_chip  = {
>+	.name = "dummy pic",
>+	.mask = legacy_pic_uint_noop,
>+	.unmask = legacy_pic_uint_noop,
>+	.disable = legacy_pic_uint_noop,
>+	.mask_ack = legacy_pic_uint_noop,
>+};
>+static int legacy_pic_irq_pending_noop(unsigned int irq)
>+{
>+	return 0;
>+}
>+
>+struct legacy_pic null_legacy_pic = {
>+	.nr_legacy_irqs = 0,
>+	.chip = &dummy_pic_chip,
>+	.mask_all = legacy_pic_noop,
>+	.restore_mask = legacy_pic_noop,
>+	.init = legacy_pic_int_noop,
>+	.irq_pending = legacy_pic_irq_pending_noop,
>+	.make_irq = legacy_pic_uint_noop,
>+};
>+
>+struct legacy_pic default_legacy_pic = {
>+	.nr_legacy_irqs = NR_IRQS_LEGACY,
>+	.chip  = &i8259A_chip,
>+	.mask_all  = mask_8259A,
>+	.restore_mask = unmask_8259A,
>+	.init = init_8259A,
>+	.irq_pending = i8259A_irq_pending,
>+	.make_irq = make_8259A_irq,
>+};
>+
>+struct legacy_pic *legacy_pic = &default_legacy_pic;
