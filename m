Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030660Ab0B0SyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 13:54:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:38783 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030634Ab0B0SyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 13:54:15 -0500
Message-ID: <4B8969E2.7000506@kernel.org>
Date: Sat, 27 Feb 2010 10:52:18 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, ebiederm@xmission.com,
       garyhade@us.ibm.com, iranna.ankad@in.ibm.com, suresh.b.siddha@intel.com,
       tglx@linutronix.de, trenn@suse.de
Subject: Re: [tip:x86/apic] x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
References: <4B882182.4030205@kernel.org> <tip-519d637a93116ffbcd50e9e3f2591f41584f372c@git.kernel.org> <20100227130113.GA18661@elte.hu>
In-Reply-To: <20100227130113.GA18661@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2010 05:01 AM, Ingo Molnar wrote:
>  arch/x86/kernel/apic/io_apic.c:1042: error: implicit declaration of function ?remap_ioapic_gsi_to_irq?
> 
please check

[PATCH] x86: fix warning with remap_ioapic_gsi_to_irq when !CONFIG_ACPI

Ingo found:
| x86: Fix out of order gsi -- add remap_ioapic_gsi_to_irq()
cause:
 arch/x86/kernel/apic/io_apic.c:1042: error: implicit declaration of function ?remap_ioapic_gsi_to_irq?

actually when !CONFIG_ACPI, we have
#define acpi_ioapic 0

somehow we still get warning for
#if (!0) {
	...
} else {
	...
	remap_ioapic_gsi_to_irq...
}

gcc bug?

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/mpspec.h |    8 ++++++++
 1 file changed, 8 insertions(+)

Index: linux-2.6/arch/x86/include/asm/mpspec.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/mpspec.h
+++ linux-2.6/arch/x86/include/asm/mpspec.h
@@ -116,6 +116,14 @@ static inline int acpi_probe_gsi(void)
 {
 	return 0;
 }
+static inline int remap_ioapic_gsi_to_irq(int ioapic, u32 gsi)
+{
+	return gsi;
+}
+static inline int remap_ioapic_irq_to_gsi(int irq)
+{
+	return irq;
+}
 #endif /* CONFIG_ACPI */
 
 #define PHYSID_ARRAY_SIZE	BITS_TO_LONGS(MAX_APICS)
