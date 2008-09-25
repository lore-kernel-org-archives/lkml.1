Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYIYPU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYIYPU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYIYPUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:20:51 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:13851 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbYIYPUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:20:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=jUzWDbya5eJ22xLttWClF3a4vIua90E0hJj1++FpzJBxFhTo8LI4+Yd2VnqDWvO7zI
         izucgI3eZE3Xoi0iFJyC2LFPidPdy8gJMCVuToY+GfdLXpV8QZC7LMoYsjBfAP1bcS+W
         NDYoKuf5aW5GRjYhg+W090gL7uPg07pxE6hTU=
Message-ID: <19f34abd0809250820q2df15e93u43374b7317e2f7be@mail.gmail.com>
Date: Thu, 25 Sep 2008 17:20:49 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: v2.6.27-rc7: x86: #GP on panic?
Cc: "Ingo Molnar" <mingo@elte.hu>, x86@kernel.org,
       linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <19f34abd0809250707i18ded94aib177c884d4d6a3bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com>
	 <20080925080417.GB27048@elte.hu> <48DB5186.8060502@zytor.com>
	 <19f34abd0809250707i18ded94aib177c884d4d6a3bd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 4:07 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Thu, Sep 25, 2008 at 10:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Ingo Molnar wrote:
>>>
>>> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>>
>>>> Hi,
>>>>
>>>> With 2.6.27-rc7 on qemu-x86_64, it seems that panic will trigger a
>>>> General Protection Fault. I haven't seen it before.
>>>
>>>> [    4.523641] Code: eb fd 55 48 89 e5 53 51 83 3d 25 e8 78 00 00 75
>>>> 1a 31 d2 31 f6 48 c7 c7 e1 9c 01 81 e8 f7 a4 03 00 9c 5b fa e8 94 09
>>>> 00 00 53 9d <5a> 5b c9 c3 55 31 c0 48 89 e5 89 04 25 b0 c0 5f ff 65 83
>>>> 04 25
>>>
>>> hm, 0x5a is a simple pop %rdx. A #GP there means the stack segment is
>>> bust?
>>>
>>
>> No, that would be #SS (and segments don't really exist in 64-bit mode
>> anyway.)  In 32-bit mode it could mean a code segment overrun.
>>
>> *However*...
>>
>> [    4.523477] general protection fault: fff2 [1] SMP
>>
>> There is an error code attached to the #GP, which is supposed to mean that
>> somehow a segment selector was involved. This doesn't look like a very valid
>> segment selector at all.
>>
>>> hm:
>>>
>>>> ffffffff8101a6b9 <disable_local_APIC>
>>>> ffffffff81019d25:       53                      push   %rbx
>>>> ffffffff81019d26:       9d                      popfq
>>>> ffffffff81019d27:       5a                      pop    %rdx
>>>
>>> so it's preceded by a popfq and on the next instruction we #GP.
>>>
>>> but the stack and flags state looks good:
>>>
>>>  [    4.523641] RSP: 0018:ffff880007867d70  EFLAGS: 00000286
>>>
>>
>> My guess is that the popfq enables interrupts, and we try to take an
>> interrupt through an IDT entry which isn't set up correctly.
>
> I'm sorry for the false alarm. I discovered that it did not happen on
> a clean kernel. My kernel was using this patch.

No, I was wrong! It *does* happen for vanilla as well, but it doesn't
happen reliably.

[    4.043370] Kernel panic - not syncing: VFS: Unable to mount root
fs on unknown-block(2,0)
[    4.048765] general protection fault: fff2 [1] SMP
[    4.048765] CPU 0
[    4.048765] Modules linked in:
[    4.048765] Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc7 #8
[    4.048765] RIP: 0010:[<ffffffff81019d27>]  [<ffffffff81019d27>]
native_smp_send_stop+0x29/0x2d
[    4.048765] RSP: 0018:ffff880007867d70  EFLAGS: 00000286
[    4.048765] RAX: 00000000000000ff RBX: 0000000000000286 RCX: 0000000000000000
[    4.048765] RDX: 0000000000000005 RSI: ffffffff81019ce1 RDI: 0000000000000000
[    4.048765] RBP: ffff880007867d80 R08: 0000000000000000 R09: ffff880087867bff
[    4.048765] R10: ffff880087867bff R11: 000000000000000a R12: ffff88000707b018
[    4.048765] R13: ffff88000707b000 R14: 0000000000008001 R15: ffffffff8159d550
[    4.048765] FS:  0000000000000000(0000) GS:ffffffff816fae00(0000)
knlGS:0000000000000000
[    4.048765] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[    4.048765] CR2: 0000000000000000 CR3: 0000000000201000 CR4: 00000000000006a0
[    4.048765] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.048765] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[    4.048765] Process swapper (pid: 1, threadinfo ffff880007866000,
task ffff880007868000)
[    4.048765] Stack:  000000000000506f ffffffff8159d52d
ffff880007867e70 ffffffff81034454
[    4.048765]  0000003000000010 ffff880007867e80 ffff880007867db0
ffff880007867e80
[    4.048765]  ffff880007867dd0 ffff880007867e80 ffff880007899360
000000000000500e
[    4.048765] Call Trace:
[    4.048765]  [<ffffffff81034454>] panic+0xe8/0x193
[    4.048765]  [<ffffffff8118ef5f>] ? kobject_put+0x44/0x49
[    4.048765]  [<ffffffff8121778e>] ? put_device+0x15/0x17
[    4.048765]  [<ffffffff8121ad49>] ? class_for_each_device+0xfe/0x10e
[    4.048765]  [<ffffffff81715059>] mount_block_root+0x1ee/0x205
[    4.048765]  [<ffffffff81009417>] ? name_to_dev_t+0x1bb/0xda4
[    4.048765]  [<ffffffff817152cd>] mount_root+0xe5/0xea
[    4.048765]  [<ffffffff81715449>] prepare_namespace+0x177/0x1a4
[    4.048765]  [<ffffffff810aaede>] ? putname+0x37/0x39
[    4.048765]  [<ffffffff81714d0f>] kernel_init+0x16a/0x178
[    4.048765]  [<ffffffff8102bde3>] ? schedule_tail+0x24/0x5d
[    4.048765]  [<ffffffff8100cf79>] child_rip+0xa/0x11
[    4.048765]  [<ffffffff811b92a4>] ? acpi_ds_init_one_object+0x0/0x88
[    4.048765]  [<ffffffff81714ba5>] ? kernel_init+0x0/0x178
[    4.048765]  [<ffffffff8100cf6f>] ? child_rip+0x0/0x11
[    4.048765]
[    4.048765]
[    4.048765] Code: eb fd 55 48 89 e5 53 51 83 3d 25 e8 78 00 00 75
1a 31 d2 31 f6 48 c7 c7 e1 9c 01 81 e8 a7 a4 03 00 9c 5b fa e8 94 09
00 00 53 9d <5a> 5b c9 c3 55 31 c0 48 89 e5 89 04 25 b0 c0 5f ff 65 83
04 25
[    4.048765] RIP  [<ffffffff81019d27>] native_smp_send_stop+0x29/0x2d
[    4.048765]  RSP <ffff880007867d70>
[    4.048765] ---[ end trace 4eaa2a86a8e2da22 ]---

This was after 49 successful boots (qemu running the same clean kernel
in a loop over and over).

Could be a qemu thing, though.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
