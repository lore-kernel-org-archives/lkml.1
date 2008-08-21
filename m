Return-Path: <linux-kernel-owner+w=401wt.eu-S1754958AbYHUIym@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbYHUIym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 04:54:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbYHUIyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 04:54:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53448 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbYHUIyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 04:54:22 -0400
Date: Thu, 21 Aug 2008 10:54:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: apic version warning.
Message-ID: <20080821085402.GA29541@elte.hu>
References: <86802c440808210101u1101b480p74ee387082ebdcb6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808210101u1101b480p74ee387082ebdcb6@mail.gmail.com>
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


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> after following patch,
> 
> commit 1b313f4a6d7bee7b2c034b3f1e203bc360a71cca
> Author: Cyrill Gorcunov <gorcunov@gmail.com>
> Date:   Mon Aug 18 20:45:57 2008 +0400
> 
>     x86: apic - generic_processor_info
> 
>     - use physid_set instead of phys_cpu and physids_or
>     - set phys_cpu_present_map bit AFTER check for allowed
>       number of processors
>     - add checking for APIC valid version in 64bit mode
>       (mostly not needed but added for merging purpose)
>     - add apic_version definition for 64bit mode which
>       is used now
> 
> we are getting warning for acpi path on 64 bit system
> 
> please add #ifdef for that.
> actually, 64 bit doesn't use that apic_version[]
> 
> 
> or using following patch?

yeah, i like that patch better - the more symmetry the better. Applied 
to tip/x86/apic.

	Ingo

--------------->
>From dd242cfc89fa7acdcaadcffbca61fca37a2f2c83 Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yhlu.kernel@gmail.com>
Date: Thu, 21 Aug 2008 01:01:19 -0700
Subject: [PATCH] x86: fix apic version warning

after following patch,

commit 1b313f4a6d7bee7b2c034b3f1e203bc360a71cca
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Mon Aug 18 20:45:57 2008 +0400

    x86: apic - generic_processor_info

    - use physid_set instead of phys_cpu and physids_or
    - set phys_cpu_present_map bit AFTER check for allowed
      number of processors
    - add checking for APIC valid version in 64bit mode
      (mostly not needed but added for merging purpose)
    - add apic_version definition for 64bit mode which
      is used now

we are getting warning for acpi path on 64 bit system.

make the 64-bit side fill in apic_version[] as well.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/acpi/boot.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 12e260e..d9770a5 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -239,10 +239,8 @@ static void __cpuinit acpi_register_lapic(int id, u8 enabled)
 		return;
 	}
 
-#ifdef CONFIG_X86_32
 	if (boot_cpu_physical_apicid != -1U)
 		ver = apic_version[boot_cpu_physical_apicid];
-#endif
 
 	generic_processor_info(id, ver);
 }
@@ -762,10 +760,8 @@ static void __init acpi_register_lapic_address(unsigned long address)
 	set_fixmap_nocache(FIX_APIC_BASE, address);
 	if (boot_cpu_physical_apicid == -1U) {
 		boot_cpu_physical_apicid  = read_apic_id();
-#ifdef CONFIG_X86_32
 		apic_version[boot_cpu_physical_apicid] =
 			 GET_APIC_VERSION(apic_read(APIC_LVR));
-#endif
 	}
 }
 
