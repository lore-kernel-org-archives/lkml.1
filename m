Return-Path: <linux-kernel-owner+w=401wt.eu-S1753856AbYEJOCG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856AbYEJOCG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 10:02:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYEJOBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 10:01:55 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35754 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764AbYEJOBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 10:01:53 -0400
Subject: Re: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager:
	multiple definition of `phys_cpu_present_map'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, toralf.foerster@gmx.de,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Travis <travis@sgi.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>
In-Reply-To: <20080510131752.GA888@elte.hu>
References: <200805091114.00244.toralf.foerster@gmx.de>
	 <20080509095244.GJ2543@hacking> <20080509095837.GB19617@elte.hu>
	 <1210342946.3069.4.camel@localhost.localdomain>
	 <20080509144722.GA20566@elte.hu>  <20080510131752.GA888@elte.hu>
Content-Type: text/plain
Date: Sat, 10 May 2008 09:01:48 -0500
Message-Id: <1210428108.4002.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-05-10 at 15:17 +0200, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > I already told you that this was incorrect.  This is what I sent as 
> > > the replacement on 28 April and I didn't hear back from you.
> > > 
> > > http://marc.info/?l=linux-kernel&m=120941111400620
> > 
> > ok - picked it up for testing - could you please send a signoff line 
> > as well?
> 
> Alexey, the patch from James failed in testing on visws:
> 
>  arch/x86/kernel/built-in.o: In function `init_apic_mappings':
>  : undefined reference to `boot_cpu_physical_apicid'
>  arch/x86/kernel/built-in.o: In function `init_apic_mappings':
>  : undefined reference to `boot_cpu_physical_apicid'
>  arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
>  : undefined reference to `boot_cpu_physical_apicid'
>  arch/x86/kernel/built-in.o: In function `APIC_init_uniprocessor':
> 
> config is at:
> 
>   http://redhat.com/~mingo/misc/config-Sat_May_10_15_05_47_CEST_2008.bad

OK, so these symbols are required on visws as well.  So that makes the
gating config symbol X86_LOCAL_APIC.

Could you run this through the same config to verify; thanks!

James

---

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [VOYAGER] fix duplicate phys_cpu_present_map symbol

The phys_cpu_present_map is an expected symbol in the SMP harness.
Unfortunately, x86 recently moved this and a few others to
kernel/setup.c where it doesn't quite work because voyager has to
define its own.  Use CONFIG_X86_LOCAL_APIC to isolate these
definitions and fix up another area in setup.c where CONFIG_X86_SMP
should be used instead of CONFIG_SMP.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 arch/x86/kernel/setup.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cc6f5eb..3f1f642 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -12,6 +12,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 
+#ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
 unsigned disabled_cpus __cpuinitdata;
 /* Processor that is doing the boot up */
@@ -23,8 +24,9 @@ EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map;
+#endif
 
-#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_SMP)
+#if defined(CONFIG_HAVE_SETUP_PER_CPU_AREA) && defined(CONFIG_X86_SMP)
 /*
  * Copy data used in early init routines from the initial arrays to the
  * per cpu data areas.  These arrays then become expendable and the
-- 
1.5.4.4



