Return-Path: <linux-kernel-owner+w=401wt.eu-S1753452AbYKFG0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbYKFG0e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYKFG00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:26:26 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYKFG0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:26:25 -0500
Date: Thu, 6 Nov 2008 07:26:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH] x86: make NR_IRQS on 32bit is same to 64bit
Message-ID: <20081106062608.GC6384@elte.hu>
References: <4910C845.4060909@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4910C845.4060909@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Impact: so NR_IRQS is bigger enough for system with lots of apic/pins
> 
> Now: if IO_APIC is there, will have big NR_IRQS
> 
> otherwise still use 224
> 
> Signed-off-by: Yinghai <yinghai@kernel.org>

applied to tip/x86/urgent, thanks Yinghai! Below are the final form of 
the two commit.

Clean-up sidenote: i think we can now remove the VISWS #ifdef portion 
for good? Mind sending a patch for that too?

	Ingo

---------------->
commit 1b4897688011cd05e07f00dcfe6af3331eb36a3c
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Tue Nov 4 14:10:13 2008 -0800

    x86: size NR_IRQS on 32-bit systems the same way as 64-bit
    
    Impact: make NR_IRQS big enough for system with lots of apic/pins
    
    If lots of IO_APIC's are there (or can be there), size the same way
    as 64-bit, depending on MAX_IO_APICS and NR_CPUS.
    
    This fixes the boot problem reported by Ben Hutchings on a 32-bit
    server with 5 IO-APICs and 240 IO-APIC pins.
    
    Signed-off-by: Yinghai <yinghai@kernel.org>
    Tested-by: Ben Hutchings <bhutchings@solarflare.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index d843ed0..503aadc 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
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

commit c78d0cf2925bffae8a6f00e7d9b8e971b0392edd
Author: Ben Hutchings <bhutchings@solarflare.com>
Date:   Wed Nov 5 12:04:46 2008 +0000

    x86: don't allow nr_irqs > NR_IRQS
    
    Impact: fix boot hang on 32-bit systems with more than 224 IO-APIC pins
    
    On some 32-bit systems with a lot of IO-APICs probe_nr_irqs() can
    return a value larger than NR_IRQS. This will lead to probe_irq_on()
    overrunning the irq_desc array.
    
    I hit this when running net-next-2.6 (close to 2.6.28-rc3) on a
    Supermicro dual Xeon system.  NR_IRQS is 224 but probe_nr_irqs() detects
    5 IOAPICs and returns 240.  Here are the log messages:
    
    Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
    Tue Nov  4 16:53:47 2008 IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
    Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x02] address[0xfec81000] gsi_base[24])
    Tue Nov  4 16:53:47 2008 IOAPIC[1]: apic_id 2, version 32, address 0xfec81000, GSI 24-47
    Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x03] address[0xfec81400] gsi_base[48])
    Tue Nov  4 16:53:47 2008 IOAPIC[2]: apic_id 3, version 32, address 0xfec81400, GSI 48-71
    Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x04] address[0xfec82000] gsi_base[72])
    Tue Nov  4 16:53:47 2008 IOAPIC[3]: apic_id 4, version 32, address 0xfec82000, GSI 72-95
    Tue Nov  4 16:53:47 2008 ACPI: IOAPIC (id[0x05] address[0xfec82400] gsi_base[96])
    Tue Nov  4 16:53:47 2008 IOAPIC[4]: apic_id 5, version 32, address 0xfec82400, GSI 96-119
    Tue Nov  4 16:53:47 2008 ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
    Tue Nov  4 16:53:47 2008 ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
    Tue Nov  4 16:53:47 2008 Enabling APIC mode:  Flat.  Using 5 I/O APICs
    
    Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
    Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index b764d74..7a3f202 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -3611,6 +3611,8 @@ int __init probe_nr_irqs(void)
 	/* something wrong ? */
 	if (nr < nr_min)
 		nr = nr_min;
+	if (WARN_ON(nr > NR_IRQS))
+		nr = NR_IRQS;
 
 	return nr;
 }
