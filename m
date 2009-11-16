Return-Path: <linux-kernel-owner+w=401wt.eu-S1752624AbZKPQLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624AbZKPQLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:11:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753216AbZKPQLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:11:50 -0500
Received: from hera.kernel.org ([140.211.167.34]:41350 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbZKPQLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:11:48 -0500
Date: Mon, 16 Nov 2009 16:10:36 GMT
From: tip-bot for Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, gorcunov@openvz.org, macro@linux-mips.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       gorcunov@openvz.org, yinghai@kernel.org, macro@linux-mips.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20091116151426.GC5653@lenovo>
References: <20091116151426.GC5653@lenovo>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86: io-apic: IO-APIC MMIO should not fail on resource insertion
Message-ID: <tip-e79c65a97c01d5da4317f44f9f98b3814e091a43@git.kernel.org>
Git-Commit-ID: e79c65a97c01d5da4317f44f9f98b3814e091a43
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e79c65a97c01d5da4317f44f9f98b3814e091a43
Gitweb:     http://git.kernel.org/tip/e79c65a97c01d5da4317f44f9f98b3814e091a43
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Mon, 16 Nov 2009 18:14:26 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 16 Nov 2009 16:37:10 +0100

x86: io-apic: IO-APIC MMIO should not fail on resource insertion

If IO-APIC base address is 1K aligned we should not fail
on resourse insertion procedure. For this sake we define
IO_APIC_SLOT_SIZE constant which should cover all IO-APIC
direct accessible registers.

An example of a such configuration is there

	http://marc.info/?l=linux-kernel&m=118114792006520

 |
 | Quoting the message
 |
 | IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
 | IOAPIC[1]: apic_id 3, version 32, address 0xfec80000, GSI 24-47
 | IOAPIC[2]: apic_id 4, version 32, address 0xfec80400, GSI 48-71
 | IOAPIC[3]: apic_id 5, version 32, address 0xfec84000, GSI 72-95
 | IOAPIC[4]: apic_id 8, version 32, address 0xfec84400, GSI 96-119
 |

Reported-by: "Maciej W. Rozycki" <macro@linux-mips.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20091116151426.GC5653@lenovo>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/apicdef.h |    6 ++++++
 arch/x86/kernel/apic/io_apic.c |   11 +++++------
 2 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/apicdef.h b/arch/x86/include/asm/apicdef.h
index 3b62da9..7fe3b30 100644
--- a/arch/x86/include/asm/apicdef.h
+++ b/arch/x86/include/asm/apicdef.h
@@ -11,6 +11,12 @@
 #define IO_APIC_DEFAULT_PHYS_BASE	0xfec00000
 #define	APIC_DEFAULT_PHYS_BASE		0xfee00000
 
+/*
+ * This is the IO-APIC register space as specified
+ * by Intel docs:
+ */
+#define IO_APIC_SLOT_SIZE		1024
+
 #define	APIC_ID		0x20
 
 #define	APIC_LVR	0x30
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 20ea839..ff23719 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -4100,18 +4100,17 @@ void __init ioapic_init_mappings(void)
 #ifdef CONFIG_X86_32
 fake_ioapic_page:
 #endif
-			ioapic_phys = (unsigned long)
-				alloc_bootmem_pages(PAGE_SIZE);
+			ioapic_phys = (unsigned long)alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
 		}
 		set_fixmap_nocache(idx, ioapic_phys);
-		apic_printk(APIC_VERBOSE,
-			    "mapped IOAPIC to %08lx (%08lx)\n",
-			    __fix_to_virt(idx), ioapic_phys);
+		apic_printk(APIC_VERBOSE, "mapped IOAPIC to %08lx (%08lx)\n",
+			__fix_to_virt(idx) + (ioapic_phys & ~PAGE_MASK),
+			ioapic_phys);
 		idx++;
 
 		ioapic_res->start = ioapic_phys;
-		ioapic_res->end = ioapic_phys + PAGE_SIZE-1;
+		ioapic_res->end = ioapic_phys + IO_APIC_SLOT_SIZE - 1;
 		ioapic_res++;
 	}
 }
