Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbYCSTyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbYCSTyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbYCSTg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:36:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54751 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777AbYCSTg4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:36:56 -0400
Date: Wed, 19 Mar 2008 20:36:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       tglx@linutronix.de, ak@suse.de
Subject: Re: [PATCH 0/79] smpboot integration
Message-ID: <20080319193600.GA19221@elte.hu>
References: <12059475744092-git-send-email-gcosta@redhat.com> <20080319184812.GA7646@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080319184812.GA7646@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> the small fix below was needed - it is possible to build ACPI on 
> 32-bit with APIC support disabled. Otherwise it's looking good in my 
> testing.

another fix for a small (and rare) build bug i found is below: it is 
possible to build a kernel with CONFIG_X86_MPPARSE but without 
CONFIG_SMP. In that case x86_bios_cpu_apicid has to be provided, and the 
use of the early-apicids has to be inhibited.

	Ingo

---
 arch/x86/kernel/mpparse_32.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/arch/x86/kernel/mpparse_32.c
===================================================================
--- linux.orig/arch/x86/kernel/mpparse_32.c
+++ linux/arch/x86/kernel/mpparse_32.c
@@ -76,6 +76,10 @@ unsigned disabled_cpus __cpuinitdata;
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
 
+#ifndef CONFIG_SMP
+DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
+#endif
+
 /*
  * Intel MP BIOS table parsing routines:
  */
@@ -230,6 +234,7 @@ static void __cpuinit MP_processor_info 
 			def_to_bigsmp = 1;
 		}
 	}
+#ifdef CONFIG_SMP
 	/* are we being called early in kernel startup? */
 	if (x86_cpu_to_apicid_early_ptr) {
 		u16 *cpu_to_apicid = x86_cpu_to_apicid_early_ptr;
@@ -241,6 +246,7 @@ static void __cpuinit MP_processor_info 
 		per_cpu(x86_cpu_to_apicid, cpu) = m->mpc_apicid;
 		per_cpu(x86_bios_cpu_apicid, cpu) = m->mpc_apicid;
 	}
+#endif
 	cpu_set(cpu, cpu_present_map);
 }
 
