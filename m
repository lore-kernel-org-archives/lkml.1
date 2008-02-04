Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYBDO6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYBDO6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 09:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbYBDO6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 09:58:04 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:51729 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYBDO6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 09:58:02 -0500
Date: Mon, 4 Feb 2008 15:58:01 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Petr Vandrovec <petr@vandrovec.name>, Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Commit f06e4ec breaks vmware
In-Reply-To: <20080204115144.GA17850@elte.hu>
Message-ID: <Pine.LNX.4.64.0802041316470.16441@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0802020120150.18790@fbirervta.pbzchgretzou.qr>
 <20080204115144.GA17850@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 3 2008 20:19, Petr Vandrovec wrote:
>> 
>> sad to say, but f06e4ec... breaks booting the kernel in vmware (bisected).
>> Booting just stops after
>> 
>>  Checking for 'hlt' instruction...
>> 
>> commit f06e4ec1c15691b0cfd2397ae32214fa36c90d71
>> Author: Ingo Molnar <mingo@elte.hu>
>> Date:   Wed Jan 30 13:32:39 2008 +0100
>> 
>>     x86: read_tsc sync
>>     
>>     make native_read_tsc() always non-speculative.
>> 
>> Any debugging hints?
>
> It does not make lot of sense...  What is processor (AMD/Intel, VT/SVM, ...),
> kernel (32/64), and product?

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 8
model name      : AMD Athlon(tm) XP 2000+
stepping        : 0
cpu MHz         : 1666.779
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 mmx fxsr sse syscall mmxext 3dnowext 3dnow up ts
bogomips        : 3334.92
clflush size    : 32

No hardware virtualization.
Host: 32-bit 2.6.23.14, VMware Workstation 6.0.2-b59824.
Guest: 32-bit f06e4ec...


> Can you try adding
>
> monitor_control.disable_rdtscopt_bt="TRUE"

Nope.

> monitor_control.virtual_rdtsc="FALSE"

No change either.


But booting the guest kernel with 'notsc' works around the issue.


On Feb 4 2008 12:51, Ingo Molnar wrote:
>
>if latest -git still fails, does the patch below solve the problem?

Latest git (9135f1901ee6449dfe338adf6e40e9c2025b8150) works, as does the 
patch on top of f06e4ec1c15691b0cfd2397ae32214fa36c90d71.


>@@ -407,8 +407,7 @@ void default_idle(void);
>  */
> static inline void rdtsc_barrier(void)
> {
>-	alternative(ASM_NOP3, "mfence", X86_FEATURE_MFENCE_RDTSC);
>-	alternative(ASM_NOP3, "lfence", X86_FEATURE_LFENCE_RDTSC);
>+	smp_mb();
> }
> 
> #endif
>
