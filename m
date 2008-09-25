Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYIYIxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYIYIxz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 04:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbYIYIxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 04:53:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42564 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbYIYIxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 04:53:45 -0400
Message-ID: <48DB5186.8060502@zytor.com>
Date: Thu, 25 Sep 2008 01:53:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Vegard Nossum <vegard.nossum@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.27-rc7: x86: #GP on panic?
References: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com> <20080925080417.GB27048@elte.hu>
In-Reply-To: <20080925080417.GB27048@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
> 
>> Hi,
>>
>> With 2.6.27-rc7 on qemu-x86_64, it seems that panic will trigger a 
>> General Protection Fault. I haven't seen it before.
> 
>> [    4.523641] Code: eb fd 55 48 89 e5 53 51 83 3d 25 e8 78 00 00 75
>> 1a 31 d2 31 f6 48 c7 c7 e1 9c 01 81 e8 f7 a4 03 00 9c 5b fa e8 94 09
>> 00 00 53 9d <5a> 5b c9 c3 55 31 c0 48 89 e5 89 04 25 b0 c0 5f ff 65 83
>> 04 25
> 
> hm, 0x5a is a simple pop %rdx. A #GP there means the stack segment is 
> bust?
> 

No, that would be #SS (and segments don't really exist in 64-bit mode 
anyway.)  In 32-bit mode it could mean a code segment overrun.

*However*...

[    4.523477] general protection fault: fff2 [1] SMP

There is an error code attached to the #GP, which is supposed to mean 
that somehow a segment selector was involved. This doesn't look like a 
very valid segment selector at all.

> hm:
> 
>> ffffffff8101a6b9 <disable_local_APIC>
>> ffffffff81019d25:       53                      push   %rbx
>> ffffffff81019d26:       9d                      popfq
>> ffffffff81019d27:       5a                      pop    %rdx
> 
> so it's preceded by a popfq and on the next instruction we #GP.
> 
> but the stack and flags state looks good:
> 
>   [    4.523641] RSP: 0018:ffff880007867d70  EFLAGS: 00000286
> 

My guess is that the popfq enables interrupts, and we try to take an 
interrupt through an IDT entry which isn't set up correctly.

	-hpa

