Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262Ab0AVOHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab0AVOHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 09:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754083Ab0AVOHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 09:07:46 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42652 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab0AVOHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 09:07:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aadhYVaXN4xnaB8P9cGa7VbaF/iwuFzkGO9f2VXqNI0GWxXMWIKO1TdV2/KfQ+c2tH
         V2KjwSBzdJZ2HUG0TppugNJpKyTG6lgCfbWPOrHc2+dXV73NNn54Nbi0eghB+Hqc5mf5
         Rl8dP0krG7NJKn49CQffXvb712fjKEuWD7o9I=
MIME-Version: 1.0
In-Reply-To: <48239d391001220238r151c4dfbjd8f6e7863718dad8@mail.gmail.com>
References: <48239d391001210326y25986d59hd10d390ef9c8ddea@mail.gmail.com>
	 <20100121122839.GB26015@nokia.com>
	 <48239d391001210523l5762775dm8382ad82e7b10e4a@mail.gmail.com>
	 <48239d391001210816n7dd469acr920be41e98129cb4@mail.gmail.com>
	 <20100121162437.GC3628@gandalf>
	 <48239d391001210932w5523cc4ajc3b5459966ab395e@mail.gmail.com>
	 <48239d391001220238r151c4dfbjd8f6e7863718dad8@mail.gmail.com>
Date: Fri, 22 Jan 2010 17:07:42 +0300
Message-ID: <48239d391001220607j666e7759y7e8ac393792bdab3@mail.gmail.com>
Subject: Re: MUSB crash on OMAP3 board with second load of gadget
From: Sergey Lapin <slapinid@gmail.com>
To: me@felipebalbi.com
Cc: felipe.balbi@nokia.com,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0 at 1:38 PM, Sergey Lapin <slapinid@gmail.com> wrote:
> Hi,
>
>> [  580.082427] [<c0030ac4>] (__irq_svc+0x44/0xa8) from [<c00420dc>]
>> (omap3_enter_idle+0x124/0x158)
>> [  580.091186] [<c00420dc>] (omap3_enter_idle+0x124/0x158) from
>> [<c022d708>] (cpuidle_idle_call+0xa4/0x180)
>> [  580.100738] [<c022d708>] (cpuidle_idle_call+0xa4/0x180) from
>> [<c00324dc>] (cpu_idle+0x48/0x98)
>> [  580.109436] [<c00324dc>] (cpu_idle+0x48/0x98) from [<c0008934>]
>> (start_kernel+0x268/0x2c8)
>> [  580.117767] [<c0008934>] (start_kernel+0x268/0x2c8) from
>> [<80008034>] (0x80008034)
>> [  580.125366] Code: c03a876b e92d4013 e5903004 e1a04000 (e593c000)
>> [  580.131652] ---[ end trace 42b8f4f7e396999c ]---
>> [  580.136291] Kernel panic - not syncing: Fatal exception in interrupt
>>
>
> I've managed to debug that in my case,
> drivers/usb/musb/musb_gadget_ep0.c:
> musb_read_setup():
>        /* clean up any leftover transfers */
>        r = next_ep0_request(musb);
> in this place we have somewhat corrupted usb_request. Any ideas why?
>
> By the way, crash is not reproduced if cable is removed before module unloading
> (and all USB activity processed).
>
> S.
>

Is this panic looks like list corruption bug which was mentioned earlier?
with my new test script I get these panic messages with the same frequency
as 6b6b6b6b ones.

If I understand right, 6b6b6b6b = slab corruption, and 00200200 =
LIST_POISON2, which means list corruption.

[  275.079284] Unable to handle kernel paging request at virtual
address 00200200
[  275.086578] pgd = c0004000
[  275.089294] [00200200] *pgd=00000000
[  275.092895] Internal error: Oops: 5 [#1] PREEMPT
[  275.097534] last sysfs file: /sys/module/musb_hdrc/parameters/debug
[  275.103851] Modules linked in: g_mass_storage [last unloaded: g_mass_storage]
[  275.111053] CPU: 0    Not tainted  (2.6.33-rc5-07242-gb226820-dirty #14)
[  275.117828] PC is at list_del+0xc/0x90
[  275.121582] LR is at musb_g_giveback+0x20/0x118
[  275.126159] pc : [<c01b71cc>]    lr : [<c021daa4>]    psr: 200001d3
[  275.126159] sp : c03f7db0  ip : 00074df4  fp : c7832048
[  275.137725] r10: fa0ab000  r9 : fa0ab100  r8 : fa0ab100
[  275.142974] r7 : 00000001  r6 : c7832064  r5 : 00000000  r4 : c718c618
[  275.149536] r3 : 00200200  r2 : 00000000  r1 : c718c600  r0 : c718c618
[  275.156097] Flags: nzCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM
Segment kernel
[  275.163635] Control: 10c5387d  Table: 8725c019  DAC: 00000017
[  275.169403] Process swapper (pid: 0, stack limit = 0xc03f62e8)
[  275.175292] Stack: (0xc03f7db0 to 0xc03f8000)
[  275.179687] 7da0:                                     c718c618
c718c600 c718c600 c021daa4
[  275.187896] 7dc0: c7832048 c02f10dc c03affcf c03f7ddc c718c618
c718c600 00000000 c7832000
[  275.196136] 7de0: 00000001 c021c3c4 00000006 00000100 00000000
00000040 c03f6000 06800099
[  275.204376] 7e00: 00000100 00000040 00000000 00000000 000000f0
c7832000 00000008 00000099
[  275.212615] 7e20: 00000000 00000000 00000000 c021b4f0 00000008
00000001 00000000 00000000
[  275.220855] 7e40: c7832000 60000153 0000005c c03f6000 0000005c
c021b628 c78bdc80 c78bdc80
[  275.229095] 7e60: 0000005c c0090d58 c78bdc80 c04099cc 0000005c
00000104 00000103 c03f6000
[  275.237304] 7e80: 00000002 c0092e1c 0000005c c03f7f40 00000000
c0030070 ffffffff fa200000
[  275.245544] 7ea0: 00000000 c0030ac4 00000000 00000003 00000000
c0436700 0000005c c03f6000
[  275.253784] 7ec0: 00000000 00000002 00000001 0000000a 00000002
00000000 00074c9f c03f7ef0
[  275.262023] 7ee0: c0063e28 c0063e40 20000153 ffffffff c78bdc80
c78bdc80 0000005c 00000000
[  275.270263] 7f00: c78bdc80 0000005c 00000000 00000003 00000002
00000001 c03f6000 0000001f
[  275.278472] 7f20: 00000000 c006401c 0000005c c0030074 ffffffff
fa200000 00000003 c0030ac4
[  275.286743] 7f40: 002e19b8 00000000 002e19b8 00000000 c04316b4
00000003 00000003 c04316b4
[  275.294982] 7f60: 800273e0 411fc082 0000001f 00000000 00000000
c03f7f88 c00420ec c00420f8
[  275.303222] 7f80: 60000053 ffffffff 00000000 002e19b8 386d712e
178b0dd5 386d712e 175cf41d
[  275.311462] 7fa0: c03fbd50 c03fbe20 c0430cdc c03fbd50 c0476b48
c022d93c c03f6000 c0430cdc
[  275.319702] 7fc0: c0029014 c03f9c10 800273e0 c00324dc c045c9c0
c0008934 c000848c 00000000
[  275.327911] 7fe0: 00000000 c0029018 00000000 10c53c7d c0430df0
80008034 00000000 00000000
[  275.336181] [<c01b71cc>] (list_del+0xc/0x90) from [<c021daa4>]
(musb_g_giveback+0x20/0x118)
[  275.344573] [<c021daa4>] (musb_g_giveback+0x20/0x118) from
[<c021c3c4>] (musb_g_ep0_irq+0x358/0x940)
[  275.353790] [<c021c3c4>] (musb_g_ep0_irq+0x358/0x940) from
[<c021b4f0>] (musb_interrupt+0x2fc/0x3d4)
[  275.362976] [<c021b4f0>] (musb_interrupt+0x2fc/0x3d4) from
[<c021b628>] (generic_interrupt+0x60/0x94)
[  275.372283] [<c021b628>] (generic_interrupt+0x60/0x94) from
[<c0090d58>] (handle_IRQ_event+0xa4/0x1e0)
[  275.381652] [<c0090d58>] (handle_IRQ_event+0xa4/0x1e0) from
[<c0092e1c>] (handle_level_irq+0xc0/0x150)
[  275.391052] [<c0092e1c>] (handle_level_irq+0xc0/0x150) from
[<c0030070>] (asm_do_IRQ+0x70/0x90)
[  275.399810] [<c0030070>] (asm_do_IRQ+0x70/0x90) from [<c0030ac4>]
(__irq_svc+0x44/0xa8)
[  275.407867] Exception stack(0xc03f7ea8 to 0xc03f7ef0)
[  275.412933] 7ea0:                   00000000 00000003 00000000
c0436700 0000005c c03f6000
[  275.421173] 7ec0: 00000000 00000002 00000001 0000000a 00000002
00000000 00074c9f c03f7ef0
[  275.429412] 7ee0: c0063e28 c0063e40 20000153 ffffffff
[  275.434509] [<c0030ac4>] (__irq_svc+0x44/0xa8) from [<c0063e40>]
(__do_softirq+0x54/0x1e8)
[  275.442840] [<c0063e40>] (__do_softirq+0x54/0x1e8) from
[<c006401c>] (irq_exit+0x48/0x9c)
[  275.451080] [<c006401c>] (irq_exit+0x48/0x9c) from [<c0030074>]
(asm_do_IRQ+0x74/0x90)
[  275.459045] [<c0030074>] (asm_do_IRQ+0x74/0x90) from [<c0030ac4>]
(__irq_svc+0x44/0xa8)
[  275.467102] Exception stack(0xc03f7f40 to 0xc03f7f88)
[  275.472198] 7f40: 002e19b8 00000000 002e19b8 00000000 c04316b4
00000003 00000003 c04316b4
[  275.480438] 7f60: 800273e0 411fc082 0000001f 00000000 00000000
c03f7f88 c00420ec c00420f8
[  275.488647] 7f80: 60000053 ffffffff
[  275.492187] [<c0030ac4>] (__irq_svc+0x44/0xa8) from [<c00420f8>]
(omap3_enter_idle+0x124/0x15c)
[  275.500976] [<c00420f8>] (omap3_enter_idle+0x124/0x15c) from
[<c022d93c>] (cpuidle_idle_call+0xa4/0x180)
[  275.510528] [<c022d93c>] (cpuidle_idle_call+0xa4/0x180) from
[<c00324dc>] (cpu_idle+0x48/0x98)
[  275.519195] [<c00324dc>] (cpu_idle+0x48/0x98) from [<c0008934>]
(start_kernel+0x268/0x2c8)
[  275.527526] [<c0008934>] (start_kernel+0x268/0x2c8) from
[<80008034>] (0x80008034)
[  275.535156] Code: c03a8a50 e92d4013 e5903004 e1a04000 (e593c000)
[  275.541381] ---[ end trace f41fd6e0efe3feba ]---
[  275.546020] Kernel panic - not syncing: Fatal exception in interrupt
