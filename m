Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYAUOuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYAUOuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2008 09:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753720AbYAUOuC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jan 2008 09:50:02 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41730 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475AbYAUOuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2008 09:50:00 -0500
Date: Mon, 21 Jan 2008 15:49:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mel Gorman <mel@csn.ul.ie>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, apw@shadowen.org
Subject: Re: [PATCH 0/2] Relax restrictions on setting CONFIG_NUMA on x86
Message-ID: <20080121144923.GA8959@elte.hu>
References: <20080118153529.12646.5260.sendpatchset@skynet.skynet.ie> <20080121093702.8FC2.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080121143508.GA8485@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080121143508.GA8485@csn.ul.ie>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mel@csn.ul.ie> wrote:

> > I think this patch become easy to the porting of fakenuma.
> 
> It would be great if that was available, particularly if it could fake 
> memoryless nodes as that is a place where we've found a few 
> difficult-to-reproduce bugs.

yeah. Your previous patch (see below) had build problems - are those 
resolved meanwhile?

	Ingo

----------->
Subject: x86: allow any x86 sub-architecture type to set CONFIG_NUMA
From: Mel Gorman <mel@csn.ul.ie>

While there are a limited number of x86 sub-architecture types that can
really support NUMA, there is nothing stopping other machines booting that
type of kernel. The fact that X86_GENERICARCH can set NUMA currently is an
indicator of that. This restriction only limits potential testing coverage.
This patch allows any sub-architecture to set CONFIG_NUMA if they wish.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---

 arch/x86/Kconfig       |    2 +-
 include/asm-x86/acpi.h |    1 +
 include/linux/acpi.h   |    1 -
 3 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-x86.q/arch/x86/Kconfig
===================================================================
--- linux-x86.q.orig/arch/x86/Kconfig
+++ linux-x86.q/arch/x86/Kconfig
@@ -816,7 +816,7 @@ config X86_PAE
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
 	depends on SMP
-	depends on X86_64 || (X86_32 && (X86_NUMAQ || (X86_SUMMIT || X86_GENERICARCH) && ACPI) && EXPERIMENTAL)
+	depends on X86_64 || (X86_32 && ACPI && EXPERIMENTAL)
 	default n if X86_PC
 	default y if (X86_NUMAQ || X86_SUMMIT)
 	help
Index: linux-x86.q/include/asm-x86/acpi.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/acpi.h
+++ linux-x86.q/include/asm-x86/acpi.h
@@ -79,6 +79,7 @@ int __acpi_release_global_lock(unsigned 
 	    :"0"(n_hi), "1"(n_lo))
 
 #ifdef CONFIG_ACPI
+#define NR_NODE_MEMBLKS MAX_NUMNODES
 extern int acpi_lapic;
 extern int acpi_ioapic;
 extern int acpi_noirq;
Index: linux-x86.q/include/linux/acpi.h
===================================================================
--- linux-x86.q.orig/include/linux/acpi.h
+++ linux-x86.q/include/linux/acpi.h
@@ -95,7 +95,6 @@ void acpi_table_print_madt_entry (struct
 
 /* the following four functions are architecture-dependent */
 #ifdef CONFIG_HAVE_ARCH_PARSE_SRAT
-#define NR_NODE_MEMBLKS MAX_NUMNODES
 #define acpi_numa_slit_init(slit) do {} while (0)
 #define acpi_numa_processor_affinity_init(pa) do {} while (0)
 #define acpi_numa_memory_affinity_init(ma) do {} while (0)
