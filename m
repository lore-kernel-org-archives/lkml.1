Return-Path: <linux-kernel-owner+w=401wt.eu-S1754251AbZARTEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbZARTEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZARTEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:04:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:32860 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915AbZARTEo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:04:44 -0500
Date: Sun, 18 Jan 2009 20:04:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>, "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: put trigger in to detect mismatched apic versions.
Message-ID: <20090118190428.GA858@elte.hu>
References: <49704DF6.8040205@sgi.com> <20090116092540.GC4305@elte.hu> <4970C984.30202@sgi.com> <20090116223011.GB3899@elte.hu> <497116A8.5080900@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497116A8.5080900@sgi.com>
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


* Mike Travis <travis@sgi.com> wrote:

> Ingo Molnar wrote:
> > * Mike Travis <travis@sgi.com> wrote:
> > 
> >> Hi Ingo,
> >>
> >> I did notice that the versions all came up the same, and that the checks 
> >> were very specific.  I was trying to be as transparent and unintrusive 
> >> as possible.  Since there's so few calls, I though this was a good 
> >> approach but apparently I was wrong.
> >>
> >> I like the idea of collapsing the array down to one and checking to see 
> >> if all apic's have the same version, but is this really the case? Must 
> >> all apics be the same?
> > 
> > Could you please send a patch that doesnt change the code, only adds a 
> > 'boot APIC version' kind of variable as an apic_version __read_mostly 
> > variable and does a WARN_ONCE() if that mismatches? We can then stick that 
> > into -tip and see whether it triggers.
> > 
> > The max array size is ~128K, right? So if the WARN_ONCE() does not 
> > trigger, we can just drop the array and use the central apic_version 
> > variable ...
> > 
> > And even if it _does_ trigger, the version incompatibilities between APIC 
> > protocols are very rare. They only happen across wildly different CPU 
> > architectures like when going from very old external apics to integrated 
> > apics, or going from apics to x-apics. We wont see any mixing across those 
> > boundaries.
> > 
> > 	Ingo
> 
> Btw, I checked with our UV architect and the problem is that we need a 
> 16 bit apic id which is what caused the MAX_APICS to be bumped to 32k. 
> The lower 8 bits are the normal apic id, and the upper bit relate to the 
> node.  This means cpu 0 on node 0 has the same apic id as cpu 0 on node 
> 1, etc.  I also asked about whether we could rely on always having the 
> same apic version, and the answer was yes, though it's really only 
> relevant between the cpus on a node.
> 
> Thanks,
> Mike
> --- 
> Subject: x86: put trigger in to detect mismatched apic versions.
> 
> Fire off one message if two apic's discovered with different
> apic versions.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> ---
>  arch/x86/kernel/apic.c |    5 +++++
>  1 file changed, 5 insertions(+)

Applied to tip/x86/urgent, thanks Mike! Note: for such changes we want a 
more comprehensive changelog that explains the motivation - i wrote one 
up, see the commit below.

	Ingo

------------->
>From a3b106db3578da7cf416aa0f85fc195a68a946f2 Mon Sep 17 00:00:00 2001
From: Mike Travis <travis@sgi.com>
Date: Fri, 16 Jan 2009 15:22:16 -0800
Subject: [PATCH] x86: put trigger in to detect mismatched apic versions

Impact: add debug warning

Fire off one message if two apic's discovered with different
apic versions. (this code is only called during CPU init)

The goal of this is to pave the way of the removal of the apic_version[]
array. We dont expect any apic version incompatibilities in the x86
landscape of systems [if so we dont handle them very well and probably
never will handle deep apic version assymetries well], but it's prudent
to have a debug check for one kernel cycle nevertheless.

Signed-off-by: Mike Travis <travis@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index d19aa3a..4b6df24 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -1837,6 +1837,11 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	num_processors++;
 	cpu = cpumask_next_zero(-1, cpu_present_mask);
 
+	if (version != apic_version[boot_cpu_physical_apicid])
+		WARN_ONCE(1,
+			"ACPI: apic version mismatch, bootcpu: %x cpu %d: %x\n",
+			apic_version[boot_cpu_physical_apicid], cpu, version);
+
 	physid_set(apicid, phys_cpu_present_map);
 	if (apicid == boot_cpu_physical_apicid) {
 		/*
