Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbZDEUQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbZDEUQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 16:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbZDEUQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 16:16:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:34709 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753566AbZDEUQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 16:16:23 -0400
Subject: Re: [PATCH] x86: fix BUG: using smp_processor_id() in preemptible
 [00000000] code: oprofiled/3319
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Levon <levon@movementarian.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0904051243310.4023@localhost.localdomain>
References: <1238958725.3522.1.camel@ht.satnam>
	 <alpine.LFD.2.00.0904051243310.4023@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 06 Apr 2009 01:44:55 +0530
Message-Id: <1238962495.3301.0.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-05 at 12:51 -0700, Linus Torvalds wrote:
> 
> On Mon, 6 Apr 2009, Jaswinder Singh Rajput wrote:
> >
> > Fixed this bug on P4 HT machine:
> 
> I don't think this really is correct.
> 
> Anything that does that "get_stagger()" thing should already either be 
> tied to a specific CPU (because it's going to actually touch the variables 
> for "that CPU"), or it should likely set up the data structures for _all_ 
> cases.
> 
> Just as an example, look at something like "p4_setup_ctrs()": it will use 
> that stagger to determine what MSR to read. But if we are preemptable, the 
> CPU we actually do the MSR read on may be a _different_ CPU than the CPU 
> that we did the "get_stagger()" on!
> 
> So I really think that protecting against preemption inside of 
> "get_stagger()" is fundamentally buggy. Because if you need it, then by 
> the time you return the value from the function, the value has now lost 
> all meaning because you might have preempted to another CPU after doing 
> the put_cpu().
> 
> So I think the "get_cpu()/put_cpu()" should be done around the whole 
> sequence (ie from before "get_stagger()" to after the stagger has been 
> used to initialize some data structures or do wrmsr/rdmsr calls.
> 
> Of course, this is all ancient code, so whatever. But I really think this 
> patch is actively bad - it just hides the issue rather than fixing 
> anything.
> 

Subject: [PATCH] x86: fix BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/3319

Fixed this bug on P4 HT machine:
[  474.968698] BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/3319
[  474.968711] caller is get_stagger+0xe/0x2c
[  474.968716] Pid: 3319, comm: oprofiled Not tainted 2.6.29 #8
[  474.968720] Call Trace:
[  474.968730]  [<c03dee3a>] ? printk+0x14/0x16
[  474.968737]  [<c021bcb8>] debug_smp_processor_id+0xa4/0xb8
[  474.968742]  [<c034d64d>] get_stagger+0xe/0x2c
[  474.968747]  [<c034daa7>] p4_fill_in_addresses+0x33/0x2d4
[  474.968751]  [<c034cc06>] nmi_setup+0xce/0x194
[  474.968756]  [<c034acf9>] oprofile_setup+0x35/0x90
[  474.968760]  [<c034bc55>] event_buffer_open+0x47/0x63
[  474.968766]  [<c0179a8d>] __dentry_open+0x148/0x237
[  474.968770]  [<c0179c20>] nameidata_to_filp+0x31/0x48
[  474.968775]  [<c034bc0e>] ? event_buffer_open+0x0/0x63
[  474.968780]  [<c018493e>] do_filp_open+0x335/0x660
[  474.968786]  [<c0161f85>] ? lru_cache_add_lru+0x2c/0x2e
[  474.968792]  [<c0171808>] ? page_add_new_anon_rmap+0x5d/0x6a
[  474.968797]  [<c017985d>] do_sys_open+0x47/0xc1
[  474.968801]  [<c0179923>] sys_open+0x23/0x2b
[  474.968806]  [<c01029f4>] sysenter_do_call+0x12/0x26

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/oprofile/op_model_p4.c |   17 ++++++++++++++++-
 1 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 4c4a51c..8db034d 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -379,12 +379,18 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 static unsigned int get_stagger(void)
 {
 #ifdef CONFIG_SMP
-	int cpu = smp_processor_id();
+	int cpu = get_cpu();
 	return (cpu != first_cpu(per_cpu(cpu_sibling_map, cpu)));
 #endif
 	return 0;
 }
 
+static inline void put_stagger(void)
+{
+#ifdef CONFIG_SMP
+	put_cpu();
+#endif
+}
 
 /* finally, mediate access to a real hardware counter
    by passing a "virtual" counter numer to this macro,
@@ -482,6 +488,7 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
 		}
 	}
+	put_stagger();
 }
 
 
@@ -506,6 +513,7 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 		printk(KERN_ERR
 		       "oprofile: P4 event code 0x%lx out of range\n",
 		       counter_config[ctr].event);
+		put_stagger();
 		return;
 	}
 
@@ -538,6 +546,7 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 			else
 				CCCR_SET_PMI_OVF_1(cccr);
 			CCCR_WRITE(cccr, high, VIRT_CTR(stag, ctr));
+			put_stagger();
 			return;
 		}
 	}
@@ -545,6 +554,7 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 	printk(KERN_ERR
 	       "oprofile: P4 event code 0x%lx no binding, stag %d ctr %d\n",
 	       counter_config[ctr].event, stag, ctr);
+	put_stagger();
 }
 
 
@@ -559,6 +569,7 @@ static void p4_setup_ctrs(struct op_msrs const * const msrs)
 	rdmsr(MSR_IA32_MISC_ENABLE, low, high);
 	if (!MISC_PMC_ENABLED_P(low)) {
 		printk(KERN_ERR "oprofile: P4 PMC not available\n");
+		put_stagger();
 		return;
 	}
 
@@ -589,6 +600,7 @@ static void p4_setup_ctrs(struct op_msrs const * const msrs)
 			reset_value[i] = 0;
 		}
 	}
+	put_stagger();
 }
 
 
@@ -638,6 +650,7 @@ static int p4_check_ctrs(struct pt_regs * const regs,
 	/* P4 quirk: you have to re-unmask the apic vector */
 	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
 
+	put_stagger();
 	/* See op_model_ppro.c */
 	return 1;
 }
@@ -657,6 +670,7 @@ static void p4_start(struct op_msrs const * const msrs)
 		CCCR_SET_ENABLE(low);
 		CCCR_WRITE(low, high, VIRT_CTR(stag, i));
 	}
+	put_stagger();
 }
 
 
@@ -674,6 +688,7 @@ static void p4_stop(struct op_msrs const * const msrs)
 		CCCR_SET_DISABLE(low);
 		CCCR_WRITE(low, high, VIRT_CTR(stag, i));
 	}
+	put_stagger();
 }
 
 static void p4_shutdown(struct op_msrs const * const msrs)
-- 
1.6.0.6



