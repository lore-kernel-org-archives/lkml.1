Return-Path: <linux-kernel-owner+w=401wt.eu-S1756560AbYKDWMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560AbYKDWMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 17:12:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYKDWMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 17:12:09 -0500
Received: from hera.kernel.org ([140.211.167.34]:41579 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753517AbYKDWMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 17:12:08 -0500
Message-ID: <4910C845.4060909@kernel.org>
Date: Tue, 04 Nov 2008 14:10:13 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Subject: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Impact: so NR_IRQS is bigger enough for system with lots of apic/pins

Now: if IO_APIC is there, will have big NR_IRQS

otherwise still use 224

Signed-off-by: Yinghai <yinghai@kernel.org>

---
 arch/x86/include/asm/irq_vectors.h |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/x86/include/asm/irq_vectors.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/irq_vectors.h
+++ linux-2.6/arch/x86/include/asm/irq_vectors.h
@@ -101,30 +101,22 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
-#ifdef CONFIG_X86_64
+#if defined(CONFIG_X86_IO_APIC) && !defined(CONFIG_PARAVIRT) && !defined(CONFIG_X86_VISWS) && !defined(CONFIG_X86_VOYAGER)
 # if NR_CPUS < MAX_IO_APICS
 #  define NR_IRQS (NR_VECTORS + (32 * NR_CPUS))
 # else
 #  define NR_IRQS (NR_VECTORS + (32 * MAX_IO_APICS))
 # endif
 
-#elif !defined(CONFIG_X86_VOYAGER)
+#elif defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS) || defined(CONFIG_X86_VOYAGER)
 
-# if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
-
-#  define NR_IRQS		224
-
-# else /* IO_APIC || PARAVIRT */
-
-#  define NR_IRQS		16
-
-# endif
+# define NR_IRQS		224
 
-#else /* !VISWS && !VOYAGER */
+#else /* IO_APIC || PARAVIRT */
 
-# define NR_IRQS		224
+# define NR_IRQS		16
 
-#endif /* VISWS */
+#endif
 
 /* Voyager specific defines */
 /* These define the CPIs we use in linux */
