Return-Path: <linux-kernel-owner+w=401wt.eu-S1756464AbZHFRpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464AbZHFRpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 13:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755996AbZHFRpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 13:45:42 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:17069
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755986AbZHFRpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 13:45:42 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz1432R98dN655Nzz1202hzzz32i6bh203h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KNYUNU-01-6ZZ-02
X-M-MSG: 
Date: Thu, 6 Aug 2009 19:44:33 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] x86, smpboot: use zalloc_cpumask_var instead of alloc/clear
Message-ID: <20090806174433.GG7198@alberich.amd.com>
References: <20090805154402.GA6520@alberich.amd.com> <20090805154811.GC6520@alberich.amd.com> <20090806183046.8aaa7404.sfr@canb.auug.org.au> <20090806161552.GE7198@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090806161552.GE7198@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 06 Aug 2009 17:44:34.0252 (UTC) FILETIME=[8F5060C0:01CA16BD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 06:15:52PM +0200, Andreas Herrmann wrote:
> On Thu, Aug 06, 2009 at 06:30:46PM +1000, Stephen Rothwell wrote:
> > Hi Andrea,
> > 
> > On Wed, 5 Aug 2009 17:48:11 +0200 Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > >
> > > @@ -1061,8 +1070,10 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
> > >  	for_each_possible_cpu(i) {
> > >  		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
> > >  		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> > > +		alloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
> > >  		alloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
> > >  		cpumask_clear(per_cpu(cpu_core_map, i));
> > > +		cpumask_clear(per_cpu(cpu_node_map, i));
> > 
> > I noticed this in linux-next ... you can use zalloc_cpumask_var() instead
> > of alloc_cpumask_var() followed by cpumask_clear().
> 
> I know, there is a collision with a patch in linux-next that replaced
> alloc_cpumask_var/cpumask_clear with the zalloc version.
> 
> (a) Either that patch should be adapted to change also the new allocation.
> (b) I can also change all those allocation to zalloc with my patch.
> 
> Make your choice:
> 
> [ ] (a)
> [ ] (b)


My choice is
 [X] (c) Do this in a separate patch.

See below.

Regards,
Andreas

-- 
>From 5d7e6138d4bc2d8c5191e6bf9cfbe9d5a27d79b0 Mon Sep 17 00:00:00 2001
From: Andreas Herrmann <andreas.herrmann3@amd.com>
Date: Thu, 6 Aug 2009 19:31:58 +0200
Subject: [PATCH] x86, smpboot: use zalloc_cpumask_var instead of alloc/clear

Suggested-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/smpboot.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index f50af56..f797214 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1068,14 +1068,10 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 #endif
 	current_thread_info()->cpu = 0;  /* needed? */
 	for_each_possible_cpu(i) {
-		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
-		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
-		alloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
-		alloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
-		cpumask_clear(per_cpu(cpu_core_map, i));
-		cpumask_clear(per_cpu(cpu_node_map, i));
-		cpumask_clear(per_cpu(cpu_sibling_map, i));
-		cpumask_clear(cpu_data(i).llc_shared_map);
+		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
+		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
-- 
1.6.3.3



