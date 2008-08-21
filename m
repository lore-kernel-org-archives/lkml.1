Return-Path: <linux-kernel-owner+w=401wt.eu-S1759585AbYHUSuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759585AbYHUSuW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 14:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYHUSuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 14:50:08 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:42626 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbYHUSuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 14:50:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MJ2XvUZnd/8uajDuRU8TC9oYHp4dohiEAr4THFDrc4/Zob6pobI+WSfmcHqrlrwwul
         xY2dJHElt0jpLPwuwwQ5pEBvuMBcbAbzbQTsL8gPAApxc5JWgxdR5k+I1DhGEx1fc3fZ
         y8xhFClCIiTauqqKrA9Pg9yGWarMh9A+lyX+g=
Date: Thu, 21 Aug 2008 20:49:05 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jack Steiner <steiner@sgi.com>
Subject: Re: [PATCH] x86: silence section mismatch warning - uv_cpu_init
Message-ID: <20080821184859.GA5403@joi>
References: <1219259268-5868-2-git-send-email-marcin.slusarz@gmail.com> <20080821103444.GE19452@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821103444.GE19452@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 12:34:44PM +0200, Ingo Molnar wrote:
> 
> * Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > WARNING: vmlinux.o(.cpuinit.text+0x3cc4): Section mismatch in reference from the function uv_cpu_init() to the function .init.text:uv_system_init()
> > The function __cpuinit uv_cpu_init() references
> > a function __init uv_system_init().
> > If uv_system_init is only used by uv_cpu_init then
> > annotate uv_system_init with a matching annotation.
> > 
> > uv_system_init was ment to be called only once, so make explicit by 
> > creating properly-named function and annotate it as __ref.
> > 
> > Old code relied on uv_node_to_blade being initialized to 0, but it'a 
> > not initialized from anywhere and it's not static either.
> 
> this needs a proper fix as the patch is too ugly. If something should be 
> called only once then it has to go into a codepath that will only 
> initialize it once.

Agreed. However it was the easiest solution.
Below is a new version of this fix. It was compile and boot tested
only on simple x86-64 box, so it needs testing on affected hardware
(where is_uv_system() == true).

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH v2] x86: fix section mismatch warning - uv_cpu_init

WARNING: vmlinux.o(.cpuinit.text+0x3cc4): Section mismatch in reference from the function uv_cpu_init() to the function .init.text:uv_system_init()
The function __cpuinit uv_cpu_init() references
a function __init uv_system_init().
If uv_system_init is only used by uv_cpu_init then
annotate uv_system_init with a matching annotation.

uv_system_init was ment to be called only once, so do it from codepath
(native_smp_prepare_cpus) which is called once, right before activation
of other cpus (smp_init).

Note: old code relied on uv_node_to_blade being initialized to 0,
but it'a not initialized from anywhere.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>
---
 arch/x86/kernel/genx2apic_uv_x.c |    8 +++++---
 arch/x86/kernel/smpboot.c        |    3 +++
 include/asm-x86/genapic_32.h     |    1 +
 include/asm-x86/genapic_64.h     |    1 +
 4 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 2d7e307..bfa837c 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -293,7 +293,9 @@ static __init void uv_rtc_init(void)
 		sn_rtc_cycles_per_second = ticks_per_sec;
 }
 
-static __init void uv_system_init(void)
+static bool uv_system_inited;
+
+void __init uv_system_init(void)
 {
 	union uvh_si_addr_map_config_u m_n_config;
 	union uvh_node_id_u node_id;
@@ -383,6 +385,7 @@ static __init void uv_system_init(void)
 	map_mmr_high(max_pnode);
 	map_config_high(max_pnode);
 	map_mmioh_high(max_pnode);
+	uv_system_inited = true;
 }
 
 /*
@@ -391,8 +394,7 @@ static __init void uv_system_init(void)
  */
 void __cpuinit uv_cpu_init(void)
 {
-	if (!uv_node_to_blade)
-		uv_system_init();
+	BUG_ON(!uv_system_inited);
 
 	uv_blade_info[uv_numa_blade_id()].nr_online_cpus++;
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e139e61..7985c5b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1221,6 +1221,9 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	printk(KERN_INFO "CPU%d: ", 0);
 	print_cpu_info(&cpu_data(0));
 	setup_boot_clock();
+
+	if (is_uv_system())
+		uv_system_init();
 out:
 	preempt_enable();
 }
diff --git a/include/asm-x86/genapic_32.h b/include/asm-x86/genapic_32.h
index b02ea6e..754d635 100644
--- a/include/asm-x86/genapic_32.h
+++ b/include/asm-x86/genapic_32.h
@@ -118,6 +118,7 @@ enum uv_system_type {UV_NONE, UV_LEGACY_APIC, UV_X2APIC, UV_NON_UNIQUE_APIC};
 #define get_uv_system_type()		UV_NONE
 #define is_uv_system()			0
 #define uv_wakeup_secondary(a, b)	1
+#define uv_system_init()		do {} while (0)
 
 
 #endif
diff --git a/include/asm-x86/genapic_64.h b/include/asm-x86/genapic_64.h
index 0f85046..a47d631 100644
--- a/include/asm-x86/genapic_64.h
+++ b/include/asm-x86/genapic_64.h
@@ -42,6 +42,7 @@ extern int is_uv_system(void);
 extern struct genapic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 extern void uv_cpu_init(void);
+extern void uv_system_init(void);
 extern int uv_wakeup_secondary(int phys_apicid, unsigned int start_rip);
 
 extern void setup_apic_routing(void);
-- 
1.5.4.5

