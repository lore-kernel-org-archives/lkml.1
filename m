Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbZFHNmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbZFHNmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZFHNmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:42:06 -0400
Received: from www.tglx.de ([62.245.132.106]:40406 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545AbZFHNmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:42:05 -0400
Date: Mon, 8 Jun 2009 15:41:52 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Tang, Feng" <feng.tang@intel.com>
cc: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: RE: [PATCH] tick: add check for the existence of broadcast clock
 event device
In-Reply-To: <EADF0A36011179459010BDF5142A457501C9CD39CC@pdsmsx502.ccr.corp.intel.com>
Message-ID: <alpine.LFD.2.00.0906081109080.3419@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop> <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain> <20090606204736.00700bd0@feng-desktop> <alpine.LFD.2.00.0906061450220.3419@localhost.localdomain> <alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
 <20090608095730.0c945e78@feng-desktop> <alpine.LFD.2.00.0906080739020.3419@localhost.localdomain> <20090608141250.6a5735fa@feng-desktop> <alpine.LFD.2.00.0906080828021.3419@localhost.localdomain> <20090608144740.62f2ed95@feng-desktop>
 <alpine.LFD.2.00.0906080857260.3419@localhost.localdomain> <EADF0A36011179459010BDF5142A457501C9CD39CC@pdsmsx502.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng,

can you please fix your mail client to do proper line breaks around 78
characters ?

On Mon, 8 Jun 2009, Tang, Feng wrote:
> >From: Thomas Gleixner [mailto:tglx@linutronix.de]
> >Why is that a problem ? You already have a special case for apbt0 in
> >the early setup code. So where is the problem when you have an apbt1
> >init call on CPU1 _before_ the local APIC is initialized on CPU1.
 
> Yes, your proposal makes good sense. But our apbt0 initialization is
> an x86 legacy one like HPET and is put into the same position where
> hpet_enable() exists, it keeps the impact to x86 arch dependent code
> be minimal, if we put the apbt1 init code into x86's cpu
> initialization code, I think it will cause much more complains,
> that's why we chose to follow hpet's method to use delayed init.

I understand that, but HPET does not rely on some magic events
happening. That's what I'm worried about. The boot code is fragile and
I prefer some explicit setup call over a fragile solution which
happens to work.

There is not much to complain about a platform specific function call
to set up special devices if there is a requirement for a call order.

In fact you can avoid setting up the local APIC timer at all. So what
you want is something like the patch below. You can set the
setup_secondary_clock pointer in the quirks structure when you detect
that you are running on such a system.

> The reason we proposed to add pointer check is there are already
> such checks in the broadcast code, adding these won't do harm to
> existing code.

I have no objections against the NULL pointer check in the broadcast
code, but I really wanted to understand why it's necessary. The patch
papers over the real problem and just works because CPU0 sends an
IPI. The correct solution is to use the real timer right away and not
rely on magic wakeups via IPIs. Ok ?

Thanks,

	tglx
---
Subject: x86: add quirk for secondary clock setup
From: Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 08 Jun 2009 13:05:35 +0200

Some newer platforms require to use a separate per cpu clock event
device instead of the local APIC timer. Allow them to override the
setup for the secondary clock with a quirk.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/setup.h |    1 +
 arch/x86/kernel/smpboot.c    |   13 ++++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -31,6 +31,7 @@ struct x86_quirks {
 	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
 				unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
+	void (*setup_secondary_clock)(void);
 };
 
 extern void x86_quirk_pre_intr_init(void);
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -263,6 +263,17 @@ static void __cpuinit smp_callin(void)
 }
 
 /*
+ * Setup secondary clock
+ */
+notrace static void __cpuinit __setup_secondary_clock(void)
+{
+	if (x86_quirks->setup_secondary_clock)
+		x86_quirks->setup_secondary_clock();
+	else
+		setup_secondary_clock();
+}
+
+/*
  * Activate a secondary processor.
  */
 notrace static void __cpuinit start_secondary(void *unused)
@@ -323,7 +334,7 @@ notrace static void __cpuinit start_seco
 	/* enable local interrupts */
 	local_irq_enable();
 
-	setup_secondary_clock();
+	__setup_secondary_clock();
 
 	wmb();
 	cpu_idle();
