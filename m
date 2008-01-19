Return-Path: <linux-kernel-owner+w=401wt.eu-S1761813AbYASPPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813AbYASPPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 10:15:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbYASPPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 10:15:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50699 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758866AbYASPPl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 10:15:41 -0500
Date: Sat, 19 Jan 2008 16:15:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: travis@sgi.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] x86: Add config variables for SMP_MAX
Message-ID: <20080119151522.GA7774@elte.hu>
References: <20080118183011.354965000@sgi.com> <20080118183011.917801000@sgi.com> <20080119145243.GA27974@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080119145243.GA27974@elte.hu>
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

> > 	NR_CPUS:      max limit now 4096
> > 	NODES_SHIFT:  max limit now 9
> > 	THREAD_ORDER: max limit now 3
> > 	X86_SMP_MAX:  say Y to enable possible cpus == NR_CPUS
> > 
> > Signed-off-by: Mike Travis <travis@sgi.com>
> 
> i've bisected a boot failure down to this patch (sans the THREAD_ORDER 
> bits): it causes an instant reboot of the 64-bit kernel upon bootup. 
> Failing config attached.

and then it crashes with:

 [    0.000000] Bootmem setup node 0 0000000000000000-000000003fff0000
 [    0.000000] KERN_NOTICE cpu_to_node(0): usage too early!
 PANIC: early exception 06 rip 10:ffffffff81f77f30 error 0 cr2 f06f53
 [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.24-rc8 #422
 [    0.000000]
 [    0.000000] Call Trace:
 [    0.000000]  [<ffffffff81f76b4a>] ? setup_node_bootmem+0x1a0/0x1b8
 [    0.000000]  [<ffffffff81f77f30>] ? acpi_scan_nodes+0x204/0x255
 [    0.000000]  [<ffffffff81f77f30>] ? acpi_scan_nodes+0x204/0x255
 [    0.000000]  [<ffffffff81f77103>] ? numa_initmem_init+0x343/0x471

moral: PLEASE do not use BUG() on in early init code, unless absolutely 
necessary.

	Ingo

---
 include/asm-x86/topology.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux/include/asm-x86/topology.h
===================================================================
--- linux.orig/include/asm-x86/topology.h
+++ linux/include/asm-x86/topology.h
@@ -70,10 +70,11 @@ static inline int cpu_to_node(int cpu)
 	if(x86_cpu_to_node_map_early_ptr) {
 		printk("KERN_NOTICE cpu_to_node(%d): usage too early!\n",
 			(int)cpu);
-		BUG();
+		dump_stack();
+		return 0;
 	}
 #endif
-	if(per_cpu_offset(cpu))
+	if (per_cpu_offset(cpu))
 		return per_cpu(x86_cpu_to_node_map, cpu);
 	else
 		return NUMA_NO_NODE;
