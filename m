Return-Path: <linux-kernel-owner+w=401wt.eu-S1756027AbYGYUez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbYGYUez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 16:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYGYUer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 16:34:47 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45750 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750854AbYGYUeq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 16:34:46 -0400
Message-ID: <488A38E4.7000206@sgi.com>
Date: Fri, 25 Jul 2008 13:34:44 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [crash, bisected] Re: [PATCH 3/4] x86_64: Fold pda into per cpu
 area
References: <20080604003018.538497000@polaris-admin.engr.sgi.com>	<48691556.2080208@zytor.com> <48691E8B.4040605@sgi.com>	<m14p7asl3x.fsf@frodo.ebiederm.org> <48694B3B.3010600@goop.org>	<m1skuuov4t.fsf@frodo.ebiederm.org> <486A61A7.1000902@zytor.com>	<486A68DD.80702@goop.org> <m1d4lxgwxj.fsf@frodo.ebiederm.org>	<486A9D4F.8010508@goop.org> <m1skutffn4.fsf@frodo.ebiederm.org>	<486AA72B.6010401@goop.org> <486AC9D9.9030506@zytor.com>	<486AD6BD.9080600@sgi.com> <486ADD67.1020809@sgi.com>	<486ADD9F.3000305@zytor.com> <486C062C.3090408@sgi.com>	<m1wsk3r3g6.fsf@frodo.ebiederm.org> <48724FB4.3090305@sgi.com>	<m17ibxxytj.fsf@frodo.ebiederm.org> <4873B016.8010404@sgi.com> <m1r6a4c5im.fsf@frodo.ebiederm.org> <4873FD00.1060101@goop.org> <488A3236.5070404@sgi.com> <488A33BC.3040406@goop.org>
In-Reply-To: <488A33BC.3040406@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Mike Travis wrote:
>>... The first is in
>>
>> arch/x86/xen/smp.c:xen_cpu_up()
>>
>> 287 #ifdef CONFIG_X86_64
>> 288         /* Allocate node local memory for AP pdas */
>> 289         WARN_ON(cpu == 0);
>> 290         if (cpu > 0) {
>> 291                 rc = get_local_pda(cpu);
>> 292                 if (rc)
>> 293                         return rc;
>> 294         }
>> 295 #endif
>>
>> and the second is at:
>>
>> arch/x86/xen/enlighten.c:xen_start_kernel()
>>
>> 1748 #ifdef CONFIG_X86_64
>> 1749         /* Disable until direct per-cpu data access. */
>> 1750         have_vcpu_info_placement = 0;
>> 1751         x86_64_init_pda();
>> 1752 #endif
>>
>> I believe with the pda folded into the percpu area, get_local_pda()
>> and x86_64_init_pda() have been removed, so these are no longer
>> required, yes?
>>   
> 
> Well, presumably they need to be replaced with whatever setup you need
> to do now.
> 
> xen_start_kernel() is the first function called after a Xen kernel boot,
> and so it must make sure the early percpu setup is done before it can
> start using percpu variables.

Is this for the boot cpu (0), or for all cpus?  For the boot cpu, I have
this now in arch/x86/kernel/setup_percpu.c:

+#ifdef CONFIG_HAVE_ZERO_BASED_PER_CPU
+
+/* Initialize percpu offset for boot cpu (0) */
+unsigned long __per_cpu_offset[NR_CPUS] __read_mostly = {
+       [0] = (unsigned long)__per_cpu_load
+};
+#else
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
+#endif

So this should apply as well to the xen startup?

> 
> xen_cpu_up() needs to do whatever initialization needed for a new cpu's
> percpu area (presumably whatever do_boot_cpu() does).
> 

Does the startup include executing arch/x86/kernel/head_64.S:startup_64() ?
I see arch/x86/xen/xen-head.S:startup_xen() so I'm guessing not?

For the real startup, I do the following two things.  But I'm not comfortable
enough with xen to think I'll get it right putting this in xen-head.S.

-       lgdt    early_gdt_descr(%rip)
+
+#ifdef CONFIG_SMP
+        /*
+        * For zero-based percpu variables, the base (__per_cpu_load) must
+        * be added to the offset of per_cpu__gdt_page.  This is only needed
+        * for the boot cpu but we can't do this prior to secondary_startup_64.
+        * So we use a NULL gdt adrs to indicate that we are starting up the
+        * boot cpu and not the secondary cpus.  do_boot_cpu() will fixup
+        * the gdt adrs for those cpus.
+        */
+#define PER_CPU_GDT_PAGE       0
+       movq    early_gdt_descr_base(%rip), %rax
+       testq   %rax, %rax
+       jnz     1f
+       movq    $__per_cpu_load, %rax
+       addq    $per_cpu__gdt_page, %rax
+       movq    %rax, early_gdt_descr_base(%rip)
+#else
+#define PER_CPU_GDT_PAGE       per_cpu__gdt_page
+#endif
+1:     lgdt    early_gdt_descr(%rip)

and:

+        * Setup up the real PDA.
+        *
+        * For SMP, the boot cpu (0) uses the static pda which is the first
+        * element in the percpu area (@__per_cpu_load).  This pda is moved
+        * to the real percpu area once that is allocated.  Secondary cpus
+        * will use the initial_pda value setup in do_boot_cpu().
         */
        movl    $MSR_GS_BASE,%ecx
-       movq    $empty_zero_page,%rax
+       movq    initial_pda(%rip), %rax
        movq    %rax,%rdx
        shrq    $32,%rdx
        wrmsr
+#ifdef CONFIG_SMP
+       movq    %rax, %gs:pda_data_offset
+#endif

+       ENTRY(initial_pda)
+#ifdef CONFIG_SMP
+       .quad   __per_cpu_load          # Overwritten for secondary CPUs
+#else
+       .quad   per_cpu__pda
+#endif


Thanks!
Mike
