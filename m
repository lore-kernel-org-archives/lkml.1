Return-Path: <linux-kernel-owner+w=401wt.eu-S1752706AbYASSQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706AbYASSQS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 13:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYASSQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 13:16:03 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:43453 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751043AbYASSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 13:16:01 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080118172720.86C4F14AAE@wotan.suse.de>
References: <20080118627.198787000@suse.de>
	 <20080118172720.86C4F14AAE@wotan.suse.de>
Content-Type: text/plain
Date: Sat, 19 Jan 2008 18:15:48 +0000
Message-Id: <1200766548.32050.32.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.181
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] [4/7] Convert TSC disabling to generic cpuid disable
	bitmap
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-18 at 18:27 +0100, Andi Kleen wrote:
> Index: linux/arch/x86/xen/time.c
> ===================================================================
> --- linux.orig/arch/x86/xen/time.c
> +++ linux/arch/x86/xen/time.c
> @@ -592,7 +592,7 @@ __init void xen_time_init(void)
>         set_normalized_timespec(&wall_to_monotonic,
>                                 -xtime.tv_sec, -xtime.tv_nsec);
>  
> -       tsc_disable = 0;
> +       setup_clear_cpu_cap(X86_FEATURE_TSC);
>  
>         xen_setup_timer(cpu);
>         xen_setup_cpu_clockevents();

That inverts the meaning, doesn't it? Previously the code force the TSC
to be on and now it forcefully disables it. Now when booting a Xen guest
I get:
        Kernel panic - not syncing: Kernel compiled for Pentium+, requires TSC feature!

I think you want something like the following
---
>From eab0f03f2659670673496b48c03c0f79151e7bbf Mon Sep 17 00:00:00 2001
From: Ian Campbell <ijc@hellion.org.uk>
Date: Sat, 19 Jan 2008 18:08:23 +0000
Subject: [PATCH] x86: Xen requires TSC support to be forced on, not disabled.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
---
 arch/x86/xen/time.c          |    2 +-
 include/asm-x86/cpufeature.h |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 6f5c74a..b3721fd 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -592,7 +592,7 @@ __init void xen_time_init(void)
 	set_normalized_timespec(&wall_to_monotonic,
 				-xtime.tv_sec, -xtime.tv_nsec);
 
-	setup_clear_cpu_cap(X86_FEATURE_TSC);
+	setup_force_cpu_cap(X86_FEATURE_TSC);
 
 	xen_setup_timer(cpu);
 	xen_setup_cpu_clockevents();
diff --git a/include/asm-x86/cpufeature.h b/include/asm-x86/cpufeature.h
index 91a7665..b6f969c 100644
--- a/include/asm-x86/cpufeature.h
+++ b/include/asm-x86/cpufeature.h
@@ -135,6 +135,10 @@
 	clear_cpu_cap(&boot_cpu_data, bit);	\
 	set_bit(bit, cleared_cpu_caps); 	\
 } while (0)
+#define setup_force_cpu_cap(bit) do { \
+	set_cpu_cap(&boot_cpu_data, bit);	\
+	clear_bit(bit, cleared_cpu_caps); 	\
+} while (0)
 
 #define cpu_has_fpu		boot_cpu_has(X86_FEATURE_FPU)
 #define cpu_has_vme		boot_cpu_has(X86_FEATURE_VME)
-- 
1.5.3.8


-- 
Ian Campbell

All that glitters is not gold; all that wander are not lost.

