Return-Path: <linux-kernel-owner+w=401wt.eu-S1759371AbZHRR5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759371AbZHRR5y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 13:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752345AbZHRR5y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 13:57:54 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:8151 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174AbZHRR5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 13:57:53 -0400
X-SpamScore: -29
X-BigFish: VPS-29(zz62a3L1432R98dN936eM179dN14e1Izz1202hzzz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KOL386-01-R0B-02
X-M-MSG: 
Date: Tue, 18 Aug 2009 19:57:40 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i386: fix section mismatches for init code with
	!HOTPLUG_CPU
Message-ID: <20090818175740.GV9915@erda.amd.com>
References: <4A8AE7CD020000780001054B@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4A8AE7CD020000780001054B@vpn.id2.novell.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Aug 2009 17:57:42.0407 (UTC) FILETIME=[620C4970:01CA202D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.08.09 16:41:33, Jan Beulich wrote:
> Commit 0e83815be719d3391bf5ea24b7fe696c07dbd417 changed the section the
> initial_code variable gets allocated in, in an attempt to address a
> section conflict warning. This, however created a new section conflict
> when building without HOTPLUG_CPU. The apparently only (reasonable) way
> to address this is to always use __REFDATA.

Hmm, not sure if I am missing something, but my patch actually
shouldn't have changed the !HOTPLUG_CPU case:

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 8663afb..0d98a01 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -602,7 +602,11 @@ ignore_int:
 #endif
        iret
 
-.section .cpuinit.data,"wa"
+#ifndef CONFIG_HOTPLUG_CPU
+       __CPUINITDATA
+#else
+       __REFDATA
+#endif
 .align 4
 ENTRY(initial_code)
        .long i386_start_kernel

I compiled -rc6 with HOTPLUG_CPU disabled and got with and without my
patch the following warning:

WARNING: vmlinux.o(.cpuinit.data+0x0): Section mismatch in reference from the variable initial_code to the function .init.text:i386_start_kernel()
The variable __cpuinitdata initial_code references
a function __init i386_start_kernel().
If i386_start_kernel is only used by initial_code then
annotate i386_start_kernel with a matching annotation.

So, the warning was there before.

The problem with that warning is that i386_start_kernel() is in __init
that is calling a chain of other __init functions. Thomas moved
initial_code to __CPUINITDATA (commit 583323b9), and thus, also
i386_start_kernel() should be __cpuinit. But initial_code seems to be
overwritten before with __cpuinit start_secondary() in
smpboot.c. Weird ...

>
> Once at it, also fix a second section mismatch when not using
> HOTPLUG_CPU.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Robert Richter <robert.richter@amd.com>
>
> ---
>  arch/x86/kernel/head_32.S |    8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
>
> --- linux-2.6.31-rc6/arch/x86/kernel/head_32.S        2009-08-18 15:31:16.000000000 +0200
> +++ 2.6.31-rc6-i386-head-sections/arch/x86/kernel/head_32.S   2009-08-18 10:38:31.000000000 +0200
> @@ -261,9 +261,7 @@ page_pde_offset = (__PAGE_OFFSET >> 20);
>   * which will be freed later
>   */
>
> -#ifndef CONFIG_HOTPLUG_CPU
> -.section .init.text,"ax",@progbits
> -#endif
> +__CPUINIT

This was here before (HOTPLUG_CPU case):

.section .text.head,"ax",@progbits

In the case a cpu is enabled again, do __cpuinit sections still exist?

-Robert

>
>  #ifdef CONFIG_SMP
>  ENTRY(startup_32_smp)
> @@ -602,11 +600,7 @@ ignore_int:
>  #endif
>       iret
>
> -#ifndef CONFIG_HOTPLUG_CPU
> -     __CPUINITDATA
> -#else
>       __REFDATA
> -#endif
>  .align 4
>  ENTRY(initial_code)
>       .long i386_start_kernel
>
>
>
>

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

