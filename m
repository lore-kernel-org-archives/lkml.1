Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZAVI23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZAVI23 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 03:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750788AbZAVI2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 03:28:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38222 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755427AbZAVI2M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 03:28:12 -0500
Date: Thu, 22 Jan 2009 09:28:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avuton Olrich <avuton@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fail to early boot with v2.6.27-rc2 to at least v2.6.29-rc2
	due to dc1e35c
Message-ID: <20090122082801.GA10012@elte.hu>
References: <3aa654a40901190604l2149c592ne4fbf782fa46655f@mail.gmail.com> <4977BFFE.3040305@zytor.com> <3aa654a40901211826s430487c1i882fb5c4b8fa92a9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3aa654a40901211826s430487c1i882fb5c4b8fa92a9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Avuton Olrich <avuton@gmail.com> wrote:

> On Wed, Jan 21, 2009 at 4:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> > Avuton Olrich wrote:
> >>
> >> Hello,
> >>
> >> My computer fails to make it past 'Unpacking kernel' with anything
> >> later than dc1e35, to at least v2.6.29-rc2 due to dc1e35c, at least so
> >> git bisect told me. While writing this bug I discovered I was using
> >> gcc-4.1.1 when I thought I was using gcc-4.3.2; I upgraded, recompiled
> >> 2.6.28.1 and same results so I assume the same results would come from
> >> me doing the 4 hour bisect again.
> >>
> >
> > Hi Avuton,
> >
> > Could you apply these two patches and verify that they work, even with the
> > BIOS CPUID level limit enabled?
> 
> Worked perfect, again thanks!

Thanks Avuton - i've updated the commit with your Tested-by tag, see the 
final commit below.

	Ingo

--------------------->
>From 066941bd4eeb159307a5d7d795100d0887c00442 Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@linux.intel.com>
Date: Wed, 21 Jan 2009 15:04:32 -0800
Subject: [PATCH] x86: unmask CPUID levels on Intel CPUs

Impact: Fixes crashes with misconfigured BIOSes on XSAVE hardware

Avuton Olrich reported early boot crashes with v2.6.28 and
bisected it down to dc1e35c6e95e8923cf1d3510438b63c600fee1e2
("x86, xsave: enable xsave/xrstor on cpus with xsave support").

If the CPUID limit bit in MSR_IA32_MISC_ENABLE is set, clear it to
make all CPUID information available.  This is required for some
features to work, in particular XSAVE.

Reported-and-bisected-by: Avuton Olrich <avuton@gmail.com>
Tested-by: Avuton Olrich <avuton@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/intel.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8ea6929..43c1dcf 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -29,6 +29,16 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	u64 misc_enable;
+
+	/* Unmask CPUID levels if masked */
+	if (!rdmsrl_safe(MSR_IA32_MISC_ENABLE, &misc_enable) &&
+	    (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID)) {
+		misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
+		wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+		c->cpuid_level = cpuid_eax(0);
+	}
+
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
