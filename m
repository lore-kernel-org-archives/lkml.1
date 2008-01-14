Return-Path: <linux-kernel-owner+w=401wt.eu-S1756184AbYANLOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184AbYANLOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 06:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYANLOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 06:14:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48997 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039AbYANLOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 06:14:42 -0500
Date: Mon, 14 Jan 2008 12:14:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/10] x86: Change NR_CPUS arrays in numa_64
Message-ID: <20080114111428.GA24237@elte.hu>
References: <20080113183453.973425000@sgi.com> <20080113183455.077460000@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080113183455.077460000@sgi.com>
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


* travis@sgi.com <travis@sgi.com> wrote:

> Change the following static arrays sized by NR_CPUS to
> per_cpu data variables:
> 
> 	char cpu_to_node_map[NR_CPUS];

x86.git randconfig testing found the !NUMA build bugs below.

	Ingo

--------------->
---
 arch/x86/kernel/setup_64.c   |    2 ++
 arch/x86/kernel/smpboot_64.c |    4 ++++
 2 files changed, 6 insertions(+)

Index: linux/arch/x86/kernel/setup_64.c
===================================================================
--- linux.orig/arch/x86/kernel/setup_64.c
+++ linux/arch/x86/kernel/setup_64.c
@@ -379,7 +379,9 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_SMP
 	/* setup to use the early static init tables during kernel startup */
 	x86_cpu_to_apicid_early_ptr = (void *)&x86_cpu_to_apicid_init;
+#ifdef CONFIG_NUMA
 	x86_cpu_to_node_map_early_ptr = (void *)&x86_cpu_to_node_map_init;
+#endif
 	x86_bios_cpu_apicid_early_ptr = (void *)&x86_bios_cpu_apicid_init;
 #endif
 
Index: linux/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux.orig/arch/x86/kernel/smpboot_64.c
+++ linux/arch/x86/kernel/smpboot_64.c
@@ -864,8 +864,10 @@ void __init smp_set_apicids(void)
 		if (per_cpu_offset(cpu)) {
 			per_cpu(x86_cpu_to_apicid, cpu) =
 						x86_cpu_to_apicid_init[cpu];
+#ifdef CONFIG_NUMA
 			per_cpu(x86_cpu_to_node_map, cpu) =
 						x86_cpu_to_node_map_init[cpu];
+#endif
 			per_cpu(x86_bios_cpu_apicid, cpu) =
 						x86_bios_cpu_apicid_init[cpu];
 		}
@@ -876,7 +878,9 @@ void __init smp_set_apicids(void)
 
 	/* indicate the early static arrays are gone */
 	x86_cpu_to_apicid_early_ptr = NULL;
+#ifdef CONFIG_NUMA
 	x86_cpu_to_node_map_early_ptr = NULL;
+#endif
 	x86_bios_cpu_apicid_early_ptr = NULL;
 }
 
