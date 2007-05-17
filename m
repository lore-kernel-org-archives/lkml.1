Return-Path: <linux-kernel-owner+w=401wt.eu-S1757405AbXEQMg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405AbXEQMg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbXEQMgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:36:09 -0400
Received: from mail.suse.de ([195.135.220.2]:56205 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755555AbXEQMgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:36:07 -0400
From: Andi Kleen <ak@suse.de>
To: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [BUG] (regression) AMD k6-III/450 won't boot w/2.6.22-rc1
Date: Thu, 17 May 2007 14:35:30 +0200
User-Agent: KMail/1.9.1
Cc: Bob Tracy <rct@gherkin.frus.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       Joachim Deguara <joachim.deguara@amd.com>
References: <20070516131558.E15BFDBA1@gherkin.frus.com> <464B28F2.9050400@redhat.com>
In-Reply-To: <464B28F2.9050400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705171435.31010.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 17:53, Chuck Ebbert wrote:
> Bob Tracy wrote:
> > Jan Engelhardt wrote:
> >>> On Tue, 15 May 2007 22:13:14 -0500 (CDT) Bob Tracy wrote:
> >>>> The 2.6.22-rc1 boot panics early in amd_mcheck_init() with my
> >>>> k6-III/450.
> >
> > Intel machine check architecture supported.
> > general protection fault: 0000 [#1]
> > PREEMPT
> > Modules linked in:
> > CPU:   0
> > EIP: 0060:[<c01079f4>]  Not tainted VLI
> > EFLAGS: 00010286   (2.6.22-rc1 #1)
> > EIP is at amd_mcheck_init+0x2b/0xc3
>
> rdmsr with ecx == 0x179 (Machine Check Global Capabilities Register)
>
> Probably K6 doesn't have that.

Hmpf.

We cold either use rdmsr_safe or add a family check again or clear it 
in k6 setup.  I think clearing it in setup is cleanest.

Does this patch work?

-Andi

Clear MCE flag on AMD K6

It reports machine check capability in CPUID, but doesn't actually
implement all the necessary MSRs of the standard Intel machine
check architecture.

This fixes a boot failure recently introduced.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/arch/i386/kernel/cpu/amd.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/amd.c
+++ linux/arch/i386/kernel/cpu/amd.c
@@ -280,6 +280,10 @@ static void __cpuinit init_amd(struct cp
 
 	if (c->x86 == 0x10 && !force_mwait)
 		clear_bit(X86_FEATURE_MWAIT, c->x86_capability);
+
+	/* K6s reports MCEs but don't actually have all the MSRs */
+	if (c->x86 < 6) 
+		clear_bit(X86_FEATURE_MCE, c->x86_capability);
 }
 
 static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 * c, unsigned 
int size)
Index: linux/arch/i386/kernel/cpu/mcheck/k7.c
===================================================================
--- linux.orig/arch/i386/kernel/cpu/mcheck/k7.c
+++ linux/arch/i386/kernel/cpu/mcheck/k7.c
@@ -72,12 +72,12 @@ void amd_mcheck_init(struct cpuinfo_x86 
 	u32 l, h;
 	int i;
 
-	machine_check_vector = k7_machine_check;
-	wmb();
-
 	if (!cpu_has(c, X86_FEATURE_MCE))
 		return;
 
+	machine_check_vector = k7_machine_check;
+	wmb();
+
 	printk (KERN_INFO "Intel machine check architecture supported.\n");
 	rdmsr (MSR_IA32_MCG_CAP, l, h);
 	if (l & (1<<8))	/* Control register present ? */
