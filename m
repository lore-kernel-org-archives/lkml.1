Return-Path: <linux-kernel-owner+w=401wt.eu-S1754607AbXLKO1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607AbXLKO1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 09:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbXLKO1r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 09:27:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51044 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbXLKO1q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 09:27:46 -0500
Date: Tue, 11 Dec 2007 15:27:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: dor.laor@qumranet.com
Cc: tglx@linutronix.de,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: Performance overhead of get_cycles_sync
Message-ID: <20071211142717.GA15903@elte.hu>
References: <475E8C8B.7070308@qumranet.com> <20071211133738.GA8150@elte.hu> <475E9A92.4030001@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475E9A92.4030001@qumranet.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Dor Laor <dor.laor@gmail.com> wrote:

> Here [include/asm-x86/tsc.h]:
>
> /* Like get_cycles, but make sure the CPU is synchronized. */
> static __always_inline cycles_t get_cycles_sync(void)
> {
>    unsigned long long ret;
>    unsigned eax, edx;
>
>    /*
>       * Use RDTSCP if possible; it is guaranteed to be synchronous
>      * and doesn't cause a VMEXIT on Hypervisors
>     */
>    alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
>               ASM_OUTPUT2("=a" (eax), "=d" (edx)),
>               "a" (0U), "d" (0U) : "ecx", "memory");
>    ret = (((unsigned long long)edx) << 32) | ((unsigned long long)eax);
>    if (ret)
>        return ret;
>
>    /*
>     * Don't do an additional sync on CPUs where we know
>     * RDTSC is already synchronous:
>     */
> //    alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
> //              "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
>    rdtscll(ret);

The patch below should resolve this - could you please test and Ack it? 
But this CPUID was present in v2.6.23 too, so why did it only show up in 
2.6.24-rc for you?

	Ingo

-------------->
Subject: x86: fix get_cycles_sync() overhead
From: Ingo Molnar <mingo@elte.hu>

get_cycles_sync() is causing massive overhead in KVM networking:

   http://lkml.org/lkml/2007/12/11/54

remove the explicit CPUID serialization - it causes VM exits and is
pointless: we care about GTOD coherency but that goes to user-space
via a syscall, and syscalls are serialization points anyway.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/asm-x86/tsc.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

Index: linux-x86.q/include/asm-x86/tsc.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/tsc.h
+++ linux-x86.q/include/asm-x86/tsc.h
@@ -39,8 +39,8 @@ static __always_inline cycles_t get_cycl
 	unsigned eax, edx;
 
 	/*
-  	 * Use RDTSCP if possible; it is guaranteed to be synchronous
- 	 * and doesn't cause a VMEXIT on Hypervisors
+	 * Use RDTSCP if possible; it is guaranteed to be synchronous
+	 * and doesn't cause a VMEXIT on Hypervisors
 	 */
 	alternative_io(ASM_NOP3, ".byte 0x0f,0x01,0xf9", X86_FEATURE_RDTSCP,
 		       ASM_OUTPUT2("=a" (eax), "=d" (edx)),
@@ -50,11 +50,11 @@ static __always_inline cycles_t get_cycl
 		return ret;
 
 	/*
-	 * Don't do an additional sync on CPUs where we know
-	 * RDTSC is already synchronous:
+	 * Use RDTSC on other CPUs. This might not be fully synchronous,
+	 * but it's not a problem: the only coherency we care about is
+	 * the GTOD output to user-space, and syscalls are synchronization
+	 * points anyway:
 	 */
-	alternative_io("cpuid", ASM_NOP2, X86_FEATURE_SYNC_RDTSC,
-			  "=a" (eax), "0" (1) : "ebx","ecx","edx","memory");
 	rdtscll(ret);
 
 	return ret;
