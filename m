Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753263AbYLRKxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbYLRKxc (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 05:53:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751049AbYLRKxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 05:53:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39170 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbYLRKxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 05:53:22 -0500
Date: Thu, 18 Dec 2008 11:53:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Pull request: merge-x86-12-16
Message-ID: <20081218105300.GB14332@elte.hu>
References: <49498AB4.3020500@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49498AB4.3020500@sgi.com>
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

> Hi Ingo,
> 
> Would you pull the following?
> 
> Thanks!
> Mike
> --- 
> The following changes since commit b77f911294aa099e53af754b9277b34783f629b4:
>   Rusty Russell (1):
>         x86: Introduce topology_core_cpumask()/topology_thread_cpumask()
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo.git merge-x86-12-16
> 
> Mike Travis (2):
>       x86: fix cpu_mask_to_apicid_and to include cpu_online_mask
>       x86: use possible_cpus=NUM to extend the possible cpus allowed
> 
>  Documentation/cpu-hotplug.txt                 |   17 +++++-----
>  arch/x86/include/asm/bigsmp/apic.h            |    4 ++-
>  arch/x86/include/asm/es7000/apic.h            |   40 +++++++++++-------------
>  arch/x86/include/asm/mach-default/mach_apic.h |    3 +-
>  arch/x86/include/asm/summit/apic.h            |   30 ++++++++++--------
>  arch/x86/kernel/apic.c                        |   16 ++++++----
>  arch/x86/kernel/genapic_flat_64.c             |    4 ++-
>  arch/x86/kernel/genx2apic_cluster.c           |    4 ++-
>  arch/x86/kernel/genx2apic_phys.c              |    4 ++-
>  arch/x86/kernel/genx2apic_uv_x.c              |    4 ++-
>  arch/x86/kernel/smpboot.c                     |   25 +++++++++++++--
>  11 files changed, 92 insertions(+), 59 deletions(-)

pulled, thanks Travis!

Note, your patches from yesterday worked fine in -tip testing. There was 
one trivial build issue that needed to be addressed, see it below. (your 
change crossed with another change from the sparseirq tree - that is what 
caused this complication)

	Ingo

----------------->
>From d733e00d7c10cc68333fbb88108bb15bb044f61b Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 17 Dec 2008 13:35:51 +0100
Subject: [PATCH] x86: update io_apic.c to the new cpumask code

Impact: build fix

The sparseirq tree crossed with the cpumask changes, fix the fallout.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/io_apic.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index 6bd51ce..58938cc 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -347,13 +347,14 @@ void arch_free_chip_data(struct irq_desc *old_desc, struct irq_desc *desc)
 	}
 }
 
-static void set_extra_move_desc(struct irq_desc *desc, cpumask_t mask)
+static void
+set_extra_move_desc(struct irq_desc *desc, const struct cpumask *mask)
 {
 	struct irq_cfg *cfg = desc->chip_data;
 
 	if (!cfg->move_in_progress) {
 		/* it means that domain is not changed */
-		if (!cpus_intersects(desc->affinity, mask))
+		if (!cpumask_intersects(&desc->affinity, mask))
 			cfg->move_desc_pending = 1;
 	}
 }
