Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416Ab0AUQQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab0AUQQX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 11:16:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753120Ab0AUQQW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 11:16:22 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48849 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab0AUQQT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 11:16:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qHGzEDUmRqH0FeHdIF62DA6Vu5Xovz6NDxTulwCTvYe6GShJrX7WYwUCp3/Rvkv0/9
         78SVuQ2H+4NXD+vBsTiwytBQOi1r8z46mCf3nxhXeOxVB2n3IzGZ3iFONikZN3j/9znQ
         SEreMrMk6hyx/gVyPUAo5gcJDEoQa7fnN4nYY=
MIME-Version: 1.0
In-Reply-To: <48239d391001210523l5762775dm8382ad82e7b10e4a@mail.gmail.com>
References: <48239d391001210326y25986d59hd10d390ef9c8ddea@mail.gmail.com>
	 <20100121122839.GB26015@nokia.com>
	 <48239d391001210523l5762775dm8382ad82e7b10e4a@mail.gmail.com>
Date: Thu, 21 Jan 2010 19:16:17 +0300
Message-ID: <48239d391001210816n7dd469acr920be41e98129cb4@mail.gmail.com>
Subject: Re: MUSB crash on OMAP3 board with second load of gadget
From: Sergey Lapin <slapinid@gmail.com>
To: felipe.balbi@nokia.com
Cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 21, 2010 at 4:23 PM, Sergey Lapin <slapinid@gmail.com> wrote:
> On Thu, Jan 21, 2010 at 3:28 PM, Felipe Balbi <felipe.balbi@nokia.com> wrote:
>> On Thu, Jan 21, 2010 at 12:26:49PM +0100, ext Sergey Lapin wrote:
>>>
>>> Hi! I have crashes in MUSB code when working with USB gadget drivers.
>>> Kernel version: linux-omap master d8ebff302ff819587377b123e900e501e4135d86
>>> To reproduce: (USB device cable should be attached).
>>>
>>> dd if=/dev/zero of=/tmp/disk bs=1k count=1024
>>> mkdosfs -F 32 /tmp/disk
>>> insmod g_mass_storage  file=/tmp/disk stall=0
>>>
>>> Wait till disk is mounted on host, then
>>>
>>> rmmod g_mass_storage
>>> insmod g_mass_storage  file=/tmp/disk stall=0
>>>
>>> And here we get Oops in include/linux/list.h line 93,
>>
>> I guess it's the list corruption bug, right ?
>>
>> I've seen that, but couldn't get it to reproduce. Now that you said, I'll
>> try to find a fix for it.
If you're interested, this is my Oops dump:

[12034.007812] Unable to handle kernel NULL pointer dereference at
virtual address 00000001
[12034.015960] pgd = c0004000
[12034.018676] [00000001] *pgd=00000000
[12034.022308] Internal error: Oops: 17 [#1] PREEMPT
[12034.027038] last sysfs file:
/sys/devices/platform/leds-gpio/leds/gnome5::red14/brightness
[12034.035339] Modules linked in: g_mass_storage [last unloaded: g_mass_storage]
[12034.042541] CPU: 0    Not tainted  (2.6.33-rc4-07149-ga29cd26-dirty #9)
[12034.049224] PC is at list_del+0xc/0x90
[12034.053009] LR is at musb_g_giveback+0x28/0x130
[12034.057586] pc : [<c01b70d0>]    lr : [<c021d928>]    psr: 400001d3
[12034.057586] sp : c03f7e48  ip : 00029fa5  fp : c7832048
[12034.069122] r10: fa0ab000  r9 : fa0ab100  r8 : fa0ab100
[12034.074371] r7 : 00000001  r6 : c7832064  r5 : 00000000  r4 : c6872718
[12034.080963] r3 : 00000001  r2 : c03f7e4c  r1 : c03b02cb  r0 : c6872718
[12034.087524] Flags: nZcv  IRQs off  FIQs off  Mode SVC_32  ISA ARM
Segment kernel
[12034.095031] Control: 10c5387d  Table: 87024019  DAC: 00000017
[12034.100830] Process swapper (pid: 0, stack limit = 0xc03f62e8)
[12034.106689] Stack: (0xc03f7e48 to 0xc03f8000)
[12034.111083] 7e40:                   c6872718 c03b02cb c6872700
c021d928 c03f7e96 c021b650
[12034.119323] 7e60: c7832048 00000008 c03f7e96 00000000 00000008
c7832000 00000001 c021c230
[12034.127563] 7e80: 00000000 00000000 c0407a40 c0407538 0f2c8be7
0680c278 00000100 00000040
[12034.135803] 7ea0: 0fd51da8 00000000 000000f0 c7832000 00000008
00000099 00000000 00000000
[12034.144042] 7ec0: 00000000 c021b388 c7832000 00000008 fa0ab000
00000000 c7832000 60000153
[12034.152252] 7ee0: 0000005c c03f6000 0000005c c021b4c0 c78b9d00
c78b9d00 0000005c c0090b80
[12034.160491] 7f00: c78b9d00 c04099cc 0000005c 00000002 00000001
c03f6000 0000001f c0092c44
[12034.168731] 7f20: 0000005c 00000000 00000003 c0030070 ffffffff
fa200000 00000003 c0030ac4
[12034.176971] 7f40: 001e449b 00000000 001e449b 00000000 c04316c0
00000003 00000003 c04316c0
[12034.185211] 7f60: 80027478 411fc082 0000001f 00000000 00000000
c03f7f88 c00420d0 c00420dc
[12034.193450] 7f80: 60000053 ffffffff 00000000 001e449b 386d8e77
0fb39696 386d8e77 0f9551fb
[12034.201660] 7fa0: c03fbd50 c03fbe20 c0430cdc c03fbd50 c0476b48
c022d7ac c03f6000 c0430cdc
[12034.209899] 7fc0: c0029014 c03f9c10 80027478 c00324dc c045c9c0
c0008934 c000848c 00000000
[12034.218139] 7fe0: 00000000 c0029018 00000000 10c53c7d c0430df0
80008034 00000000 00000000
[12034.226379] [<c01b70d0>] (list_del+0xc/0x90) from [<c021d928>]
(musb_g_giveback+0x28/0x130)
[12034.234802] [<c021d928>] (musb_g_giveback+0x28/0x130) from
[<c021c230>] (musb_g_ep0_irq+0x32c/0x910)
[12034.244018] [<c021c230>] (musb_g_ep0_irq+0x32c/0x910) from
[<c021b388>] (musb_interrupt+0x2fc/0x3d4)
[12034.253204] [<c021b388>] (musb_interrupt+0x2fc/0x3d4) from
[<c021b4c0>] (generic_interrupt+0x60/0x94)
[12034.262512] [<c021b4c0>] (generic_interrupt+0x60/0x94) from
[<c0090b80>] (handle_IRQ_event+0xa4/0x1e0)
[12034.271881] [<c0090b80>] (handle_IRQ_event+0xa4/0x1e0) from
[<c0092c44>] (handle_level_irq+0xc0/0x150)
[12034.281250] [<c0092c44>] (handle_level_irq+0xc0/0x150) from
[<c0030070>] (asm_do_IRQ+0x70/0x90)
[12034.290008] [<c0030070>] (asm_do_IRQ+0x70/0x90) from [<c0030ac4>]
(__irq_svc+0x44/0xa8)
[12034.298065] Exception stack(0xc03f7f40 to 0xc03f7f88)
[12034.303161] 7f40: 001e449b 00000000 001e449b 00000000 c04316c0
00000003 00000003 c04316c0
[12034.311401] 7f60: 80027478 411fc082 0000001f 00000000 00000000
c03f7f88 c00420d0 c00420dc
[12034.319641] 7f80: 60000053 ffffffff
[12034.323150] [<c0030ac4>] (__irq_svc+0x44/0xa8) from [<c00420dc>]
(omap3_enter_idle+0x124/0x158)
[12034.331939] [<c00420dc>] (omap3_enter_idle+0x124/0x158) from
[<c022d7ac>] (cpuidle_idle_call+0xa4/0x180)
[12034.341491] [<c022d7ac>] (cpuidle_idle_call+0xa4/0x180) from
[<c00324dc>] (cpu_idle+0x48/0x98)
[12034.350189] [<c00324dc>] (cpu_idle+0x48/0x98) from [<c0008934>]
(start_kernel+0x268/0x2c8)
[12034.358489] [<c0008934>] (start_kernel+0x268/0x2c8) from
[<80008034>] (0x80008034)
[12034.366119] Code: c03a882b e92d4013 e5903004 e1a04000 (e593c000)
[12034.372406] ---[ end trace e93a9fc16bcba40b ]---
[12034.377075] Kernel panic - not syncing: Fatal exception in interrupt
