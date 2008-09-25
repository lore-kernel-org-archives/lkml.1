Return-Path: <linux-kernel-owner+w=401wt.eu-S1751904AbYIYOHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbYIYOHm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYIYOHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:07:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:5507 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753185AbYIYOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=L1dnTQ9x2Cxy/kR7RsomyV5XJ9ACxSLsplolpnbjEeDap0Y+yadb1EIoFmRp9/uDhC
         OZuoSPpSq0osPGX9tfqGKXDHuoqeMEgrti+qkjAsvxzxpB/7NOBu4SB/kza1CEk2L0rj
         TQEdKiHOgifjeCQtWNKa8GPeSSdqhWsAC5aqo=
Message-ID: <19f34abd0809250707i18ded94aib177c884d4d6a3bd@mail.gmail.com>
Date: Thu, 25 Sep 2008 16:07:32 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: v2.6.27-rc7: x86: #GP on panic?
Cc: "Ingo Molnar" <mingo@elte.hu>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <48DB5186.8060502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com>
	 <20080925080417.GB27048@elte.hu> <48DB5186.8060502@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 10:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Ingo Molnar wrote:
>>
>> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>
>>> Hi,
>>>
>>> With 2.6.27-rc7 on qemu-x86_64, it seems that panic will trigger a
>>> General Protection Fault. I haven't seen it before.
>>
>>> [    4.523641] Code: eb fd 55 48 89 e5 53 51 83 3d 25 e8 78 00 00 75
>>> 1a 31 d2 31 f6 48 c7 c7 e1 9c 01 81 e8 f7 a4 03 00 9c 5b fa e8 94 09
>>> 00 00 53 9d <5a> 5b c9 c3 55 31 c0 48 89 e5 89 04 25 b0 c0 5f ff 65 83
>>> 04 25
>>
>> hm, 0x5a is a simple pop %rdx. A #GP there means the stack segment is
>> bust?
>>
>
> No, that would be #SS (and segments don't really exist in 64-bit mode
> anyway.)  In 32-bit mode it could mean a code segment overrun.
>
> *However*...
>
> [    4.523477] general protection fault: fff2 [1] SMP
>
> There is an error code attached to the #GP, which is supposed to mean that
> somehow a segment selector was involved. This doesn't look like a very valid
> segment selector at all.
>
>> hm:
>>
>>> ffffffff8101a6b9 <disable_local_APIC>
>>> ffffffff81019d25:       53                      push   %rbx
>>> ffffffff81019d26:       9d                      popfq
>>> ffffffff81019d27:       5a                      pop    %rdx
>>
>> so it's preceded by a popfq and on the next instruction we #GP.
>>
>> but the stack and flags state looks good:
>>
>>  [    4.523641] RSP: 0018:ffff880007867d70  EFLAGS: 00000286
>>
>
> My guess is that the popfq enables interrupts, and we try to take an
> interrupt through an IDT entry which isn't set up correctly.

I'm sorry for the false alarm. I discovered that it did not happen on
a clean kernel. My kernel was using this patch.

diff --git a/arch/x86/kernel/cpu/common_64.c b/arch/x86/kernel/cpu/common_64.c
index a11f5d4..abf5bc8 100644
--- a/arch/x86/kernel/cpu/common_64.c
+++ b/arch/x86/kernel/cpu/common_64.c
@@ -261,6 +261,8 @@ void __init early_cpu_init(void)
                 cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
        early_cpu_support_print();
        early_identify_cpu(&boot_cpu_data);
+
+       setup_clear_cpu_cap(X86_FEATURE_PSE);
 }

 /* Do some early cpuid on the boot CPU to get some parameter that are

:-(


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
