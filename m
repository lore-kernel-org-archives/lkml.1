Return-Path: <linux-kernel-owner+w=401wt.eu-S1030799AbXDWFLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030799AbXDWFLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 01:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbXDWFLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 01:11:25 -0400
Received: from yue.linux-ipv6.org ([203.178.140.15]:32808 "EHLO
	yue.st-paulia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbXDWFLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 01:11:24 -0400
Date: Mon, 23 Apr 2007 14:11:19 +0900 (JST)
Message-Id: <20070423.141119.130123635.yoshfuji@linux-ipv6.org>
To: akpm@linux-foundation.org
Cc: ak@suse.de, linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] x86: Fix potential overflow in perfctr reservation
From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
In-Reply-To: <20070422010917.6427e7a2.akpm@linux-foundation.org>
References: <200704172359.l3HNxAMV024586@hera.kernel.org>
	<20070422010917.6427e7a2.akpm@linux-foundation.org>
Organization: USAGI/WIDE Project
X-URL: http://www.yoshifuji.org/%7Ehideaki/
X-Fingerprint: 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
X-PGP-Key-URL: http://www.yoshifuji.org/%7Ehideaki/hideaki@yoshifuji.org.asc
X-Face: "5$Al-.M>NJ%a'@hhZdQm:."qn~PA^gq4o*>iCFToq*bAi#4FRtx}enhuQKz7fNqQz\BYU]
 $~O_5m-9'}MIs`XGwIEscw;e5b>n"B_?j/AkL~i/MEa<!5P`&C$@oP>ZBLP
X-Mailer: Mew version 3.3 on Emacs 20.7 / Mule 4.1 (AOI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

In article <20070422010917.6427e7a2.akpm@linux-foundation.org> (at Sun, 22 Apr 2007 01:09:17 -0700), Andrew Morton <akpm@linux-foundation.org> says:

> >     [PATCH] x86: Fix potential overflow in perfctr reservation
:
> The created a warning storm:
> 
> 
> arch/i386/kernel/nmi.c: In function 'avail_to_resrv_perfctr_nmi_bit':
> arch/i386/kernel/nmi.c:129: warning: passing argument 2 of 'constant_test_bit' from incompatible pointer type
> arch/i386/kernel/nmi.c:129: warning: passing argument 2 of 'variable_test_bit' from incompatible pointer type
:
> diff -puN arch/i386/kernel/nmi.c~fix-x86-fix-potential-overflow-in-perfctr-reservation arch/i386/kernel/nmi.c
> --- a/arch/i386/kernel/nmi.c~fix-x86-fix-potential-overflow-in-perfctr-reservation
> +++ a/arch/i386/kernel/nmi.c
> @@ -126,7 +126,7 @@ int avail_to_resrv_perfctr_nmi_bit(unsig
>  	int cpu;
>  	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
>  	for_each_possible_cpu (cpu) {
> -		if (test_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)))
> +		if (test_bit(counter, per_cpu(perfctr_nmi_owner, cpu)))
>  			return 0;
>  	}
>  	return 1;
:
> 
> I worry rather a lot about how well runtime tested this very late change
> was, and whether it works correctly even with this fix applied.  Perhaps
> we should jsut revert?

Is DEFINE_PER_CPU(type, var[num]) is really valid?
I guess it should be DEFINE_PER_CPU(type[num], var), no?

----
[I386] NMI: Fix per_cpu() usage.

Per-cpu array should be declared as DEFINE_PER_CPU(type[size], name),
not as DEFINE_PER_CPU(type, name[size]).

Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

diff --git a/arch/i386/kernel/nmi.c b/arch/i386/kernel/nmi.c
index 9f1e8c1..eddb4f7 100644
--- a/arch/i386/kernel/nmi.c
+++ b/arch/i386/kernel/nmi.c
@@ -48,8 +48,8 @@ int nmi_watchdog_enabled;
 #define NMI_MAX_COUNTER_BITS 66
 #define NMI_MAX_COUNTER_LONGS BITS_TO_LONGS(NMI_MAX_COUNTER_BITS)
 
-static DEFINE_PER_CPU(unsigned long, perfctr_nmi_owner[NMI_MAX_COUNTER_LONGS]);
-static DEFINE_PER_CPU(unsigned long, evntsel_nmi_owner[NMI_MAX_COUNTER_LONGS]);
+static DEFINE_PER_CPU(unsigned long [NMI_MAX_COUNTER_LONGS], perfctr_nmi_owner);
+static DEFINE_PER_CPU(unsigned long [NMI_MAX_COUNTER_LONGS], evntsel_nmi_owner);
 
 static cpumask_t backtrace_mask = CPU_MASK_NONE;
 /* nmi_active:
@@ -126,7 +126,7 @@ int avail_to_resrv_perfctr_nmi_bit(unsigned int counter)
 	int cpu;
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 	for_each_possible_cpu (cpu) {
-		if (test_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)))
+		if (test_bit(counter, per_cpu(perfctr_nmi_owner, cpu)))
 			return 0;
 	}
 	return 1;
@@ -142,7 +142,7 @@ int avail_to_resrv_perfctr_nmi(unsigned int msr)
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
 	for_each_possible_cpu (cpu) {
-		if (test_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)))
+		if (test_bit(counter, per_cpu(perfctr_nmi_owner, cpu)))
 			return 0;
 	}
 	return 1;
@@ -157,7 +157,7 @@ static int __reserve_perfctr_nmi(int cpu, unsigned int msr)
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	if (!test_and_set_bit(counter, &per_cpu(perfctr_nmi_owner, cpu)))
+	if (!test_and_set_bit(counter, per_cpu(perfctr_nmi_owner, cpu)))
 		return 1;
 	return 0;
 }
@@ -171,7 +171,7 @@ static void __release_perfctr_nmi(int cpu, unsigned int msr)
 	counter = nmi_perfctr_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	clear_bit(counter, &per_cpu(perfctr_nmi_owner, cpu));
+	clear_bit(counter, per_cpu(perfctr_nmi_owner, cpu));
 }
 
 int reserve_perfctr_nmi(unsigned int msr)
@@ -207,7 +207,7 @@ int __reserve_evntsel_nmi(int cpu, unsigned int msr)
 	counter = nmi_evntsel_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	if (!test_and_set_bit(counter, &per_cpu(evntsel_nmi_owner, cpu)[0]))
+	if (!test_and_set_bit(counter, per_cpu(evntsel_nmi_owner, cpu)))
 		return 1;
 	return 0;
 }
@@ -221,7 +221,7 @@ static void __release_evntsel_nmi(int cpu, unsigned int msr)
 	counter = nmi_evntsel_msr_to_bit(msr);
 	BUG_ON(counter > NMI_MAX_COUNTER_BITS);
 
-	clear_bit(counter, &per_cpu(evntsel_nmi_owner, cpu)[0]);
+	clear_bit(counter, per_cpu(evntsel_nmi_owner, cpu));
 }
 
 int reserve_evntsel_nmi(unsigned int msr)

-- 
YOSHIFUJI Hideaki @ USAGI Project  <yoshfuji@linux-ipv6.org>
GPG-FP  : 9022 65EB 1ECF 3AD1 0BDF  80D8 4807 F894 E062 0EEA
