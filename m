Return-Path: <linux-kernel-owner+w=401wt.eu-S1760260AbZEHPwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260AbZEHPwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754023AbZEHPwJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:52:09 -0400
Received: from smtp.citrix.com ([66.165.176.89]:33026 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777AbZEHPwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:52:08 -0400
X-IronPort-AV: E=Sophos;i="4.40,318,1238990400"; 
   d="scan'208";a="4154778"
Subject: Re: [PATCH 6/8] x86: use flush_tlb_others to
	implement	flush_tlb_all
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
In-Reply-To: <4A0454A2.7060104@goop.org>
References: <1241727902-3176-1-git-send-email-jeremy@goop.org>
	 <1241727902-3176-7-git-send-email-jeremy@goop.org>
	 <1241796269.15972.41.camel@zakaz.uk.xensource.com>
	 <4A0454A2.7060104@goop.org>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 8 May 2009 16:52:07 +0100
Message-ID: <1241797927.15972.51.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-08 at 11:49 -0400, Jeremy Fitzhardinge wrote:
> Ian Campbell wrote:
> > On Thu, 2009-05-07 at 13:25 -0700, Jeremy Fitzhardinge wrote:
> >   
> >> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >>
> >> Use the flush_tlb_others() call to implement flush_tlb_all().
> >>     
> >
> > This causes:
> >         BUG: spinlock bad magic on CPU#0, swapper/0
> >          lock: c05b7588, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
> >         Pid: 0, comm: swapper Not tainted 2.6.30-rc3-x86_32p-xen0-tip-01797-g3db7847 #1054
> >         Call Trace:
> >          [<c023e656>] spin_bug+0x96/0xf0
> >          [<c023e90f>] _raw_spin_lock+0x6f/0x150
> >   
> 
> Ah, right.  I had another change (somewhere around here) to explicitly 
> initialize the tlb flush code from the normal early init code, rather 
> than make it implicit via initcall.  Otherwise we have an unknown point 
> at which we're allowed to start using global flushes, which is a bit flakey.

That was my v1, which I still happen to have lying around:

---

Subject: initialise tlbflush locks before any callers

Now that flush_tlb_all() is implemented via flush_tlb_others() the later
can be called before the core_initcalls are run. Explicitly call
init_smp_flush early on.

Also there is no need for init_smp_flush to be __cpuinit.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

[ Impact: initialise spinlock before use ]

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 16a5c84..2a4848d 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -129,6 +129,8 @@ static inline void reset_lazy_tlbstate(void)
 
 #define local_flush_tlb() __flush_tlb()
 
+extern int init_smp_flush(void);
+
 extern void flush_tlb_all(void);
 extern void flush_tlb_current_task(void);
 extern void flush_tlb_mm(struct mm_struct *);
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index e69bdad..0f030fb 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -229,7 +229,7 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	flush_tlb_others_ipi(cpumask, mm, va);
 }
 
-static int __cpuinit init_smp_flush(void)
+int __init init_smp_flush(void)
 {
 	int i;
 
@@ -238,7 +238,6 @@ static int __cpuinit init_smp_flush(void)
 
 	return 0;
 }
-core_initcall(init_smp_flush);
 
 void flush_tlb_current_task(void)
 {
diff --git a/init/main.c b/init/main.c
index 33ce929..f798501 100644
--- a/init/main.c
+++ b/init/main.c
@@ -651,6 +651,7 @@ asmlinkage void __init start_kernel(void)
 	vfs_caches_init_early();
 	cpuset_init_early();
 	page_cgroup_init();
+	init_smp_flush();
 	mem_init();
 	enable_debug_pagealloc();
 	cpu_hotplug_init();

> 
>     J

