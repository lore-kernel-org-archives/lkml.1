Return-Path: <linux-kernel-owner+w=401wt.eu-S1756774AbZDQTEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774AbZDQTEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 15:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbZDQTEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 15:04:22 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52371 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710AbZDQTEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 15:04:22 -0400
Date: Fri, 17 Apr 2009 21:03:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git-pull -tip] x86: fix section mismatch warnings
Message-ID: <20090417190355.GA21614@elte.hu>
References: <1239918902.10567.22.camel@ht.satnam> <20090417164141.GJ8253@elte.hu> <1239991281.3153.4.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239991281.3153.4.camel@ht.satnam>
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


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Fri, 2009-04-17 at 18:41 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > The following changes since commit 88dc4c8e38d64db32907e0bd605f8c1ec4c4d1bd:
> > >   Ingo Molnar (1):
> > >         Merge branch 'tracing/ftrace'
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master
> > > 
> > > Jaswinder Singh Rajput (3):
> > >       x86: mm/numa_32.c calculate_numa_remap_pages should use __init
> > >       x86: apic/es7000_32.c find_unisys_acpi_oem_table and es7000_acpi_madt_oem_check should use __init
> > >       x86: smpboot.c wakeup_secondary_cpu_via_nmi do not required __devinit
> > 
> > The commit logs lack analysis. The suggestions in the warnings are 
> > advisory and can be wrong. Analysis explaining what happened, maybe 
> > even when it happened, and what should be done about it to fix that 
> > issue is needed in such changelogs.
> > 
> > The commits might be correct - or they might be bogus. The commit 
> > logs dont give us any help in deciding that. I.e. if you did that 
> > work, you should document it. If you _didnt_ do that analysis work, 
> > you shouldnt send patches addressing these types of warnings.
> > 
> 
> I was busy in another stuff, So I am sending analysis of first 
> commit. If you want you can apply this patch and ignore others :
> 
> [PATCH-tip] x86: mm/numa_32.c calculate_numa_remap_pages should use __init
> 
> calculate_numa_remap_pages() is called only by __init initmem_init()
> further calculate_numa_remap_pages is calling:
> 	__init find_e820_area() and __init reserve_early()
> 
> So calculate_numa_remap_pages() should be __init calculate_numa_remap_pages().
> 
> Impact: fix Section mismatch warnings
>  WARNING: arch/x86/built-in.o(.text+0x82ea3): Section mismatch in reference from the function calculate_numa_remap_pages() to the function .init.text:find_e820_area()
>  The function calculate_numa_remap_pages() references
>  the function __init find_e820_area().
>  This is often because calculate_numa_remap_pages lacks a __init
>  annotation or the annotation of find_e820_area is wrong.
> 
>  WARNING: arch/x86/built-in.o(.text+0x82f5f): Section mismatch in reference from the function calculate_numa_remap_pages() to the function .init.text:reserve_early()
>  The function calculate_numa_remap_pages() references
>  the function __init reserve_early().
>  This is often because calculate_numa_remap_pages lacks a __init
>  annotation or the annotation of reserve_early is wrong.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Yes, this one is perfect, it contains precisely the information we 
need. It's also helpful for other reasons: people looking at such 
commit logs will learn how to do section warning analysis correct.

Btw., the impact line i added is slightly different:

    [ Impact: save memory, address Section mismatch warning ]

Note that the main impact is that we now save a little bit of RAM, 
by marking one more function __init.

Below is the full commit.

Thanks,

	Ingo

-------------------->
>From 445b9e51e9ebd7eb1b9ba724b38342015769b48e Mon Sep 17 00:00:00 2001
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
Date: Fri, 17 Apr 2009 23:31:20 +0530
Subject: [PATCH] x86: mm/numa_32.c calculate_numa_remap_pages should use __init

calculate_numa_remap_pages() is called only by __init initmem_init()
further calculate_numa_remap_pages is calling:
	__init find_e820_area() and __init reserve_early()

So calculate_numa_remap_pages() should be __init calculate_numa_remap_pages().

 WARNING: arch/x86/built-in.o(.text+0x82ea3): Section mismatch in reference from the function calculate_numa_remap_pages() to the function .init.text:find_e820_area()
 The function calculate_numa_remap_pages() references
 the function __init find_e820_area().
 This is often because calculate_numa_remap_pages lacks a __init
 annotation or the annotation of find_e820_area is wrong.

 WARNING: arch/x86/built-in.o(.text+0x82f5f): Section mismatch in reference from the function calculate_numa_remap_pages() to the function .init.text:reserve_early()
 The function calculate_numa_remap_pages() references
 the function __init reserve_early().
 This is often because calculate_numa_remap_pages lacks a __init
 annotation or the annotation of reserve_early is wrong.

[ Impact: save memory, address Section mismatch warning ]

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
LKML-Reference: <1239991281.3153.4.camel@ht.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/numa_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index 3daefa0..d253006 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -257,7 +257,7 @@ void resume_map_numa_kva(pgd_t *pgd_base)
 }
 #endif
 
-static unsigned long calculate_numa_remap_pages(void)
+static __init unsigned long calculate_numa_remap_pages(void)
 {
 	int nid;
 	unsigned long size, reserve_pages = 0;
