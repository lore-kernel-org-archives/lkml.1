Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZDOTyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZDOTyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 15:54:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZDOTyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 15:54:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:52993 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbZDOTyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 15:54:37 -0400
Message-ID: <49E63B15.1040102@kernel.org>
Date: Wed, 15 Apr 2009 12:52:53 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joerg Roedel <joerg.roedel@amd.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       stable@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] x86: used used_vectors in init_IRQ
References: <49E62DFD.6010904@kernel.org> <20090415192550.GA27004@elte.hu> <49E636F2.7030902@kernel.org> <20090415193827.GB32675@elte.hu> <49E6397D.1020201@kernel.org> <20090415194705.GA8290@elte.hu>
In-Reply-To: <20090415194705.GA8290@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Ingo Molnar wrote:
>>> * Yinghai Lu <yinghai@kernel.org> wrote:
>>>
>>>> Ingo Molnar wrote:
>>>>
>>>>> Note, i removed the -stable tag because i dont think .29 nor 
>>>>> .30-rc2 is affected. Your patch to irqinit*.c (and the later 
>>>>> unification by Pekka) is something still pending in the 
>>>>> perfcounters and x86 trees, queued for .31.
>>>> not sure .29, but it seems we need this for 2.6.30
>>>>
>> you are right...
>>
>> in trap_init with linus tree
>>
>> still have
>> #ifdef CONFIG_X86_64
>>         set_bit(IA32_SYSCALL_VECTOR, used_vectors);
>> #else
>>         set_bit(SYSCALL_VECTOR, used_vectors);
>> #endif
>>
>>
>> so one patch (merge irqinit_32/64) in tip for .31 expose that bug.
>>
>> aka we don't back port ...
> 
> ok, good!
> 

for memo:
exposed by:
commit bb3f0b59ad005d2d2ecbbe9bd048eab6d1ecbd31
Author: Yinghai Lu <yinghai@kernel.org>
Date:   Sun Jan 25 02:38:09 2009 -0800

    x86: make irqinit_32.c more like irqinit_64.c, v2
    
    Impact: cleanup
    
    1. add smp_intr_init and apic_intr_init for 32bit, the same as 64bit
    2. move the apic_intr_init() call before set gate with interrupt[i]
    3. for 64bit, if ia32_emulation is not used, will make per_cpu to use 0x80 vector.
    
    [ v2: should use !test_bit() instead of test_bit() with 32bit ]
    
    Signed-off-by: Yinghai Lu <yinghai@kernel.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index ed5aee5..d36a502 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -979,8 +979,13 @@ void __init trap_init(void)
 #endif
        set_intr_gate(19, &simd_coprocessor_error);
 
+       /* Reserve all the builtin and the syscall vector: */
+       for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
+               set_bit(i, used_vectors);
+
 #ifdef CONFIG_IA32_EMULATION
        set_system_intr_gate(IA32_SYSCALL_VECTOR, ia32_syscall);
+       set_bit(IA32_SYSCALL_VECTOR, used_vectors);
 #endif
 
 #ifdef CONFIG_X86_32
@@ -997,17 +1002,9 @@ void __init trap_init(void)
        }
 
        set_system_trap_gate(SYSCALL_VECTOR, &system_call);
-#endif
-
-       /* Reserve all the builtin and the syscall vector: */
-       for (i = 0; i < FIRST_EXTERNAL_VECTOR; i++)
-               set_bit(i, used_vectors);
-
-#ifdef CONFIG_X86_64
-       set_bit(IA32_SYSCALL_VECTOR, used_vectors);
-#else
        set_bit(SYSCALL_VECTOR, used_vectors);
 #endif
+
        /*
         * Should be a barrier for any external CPU state:
         */


