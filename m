Return-Path: <linux-kernel-owner+w=401wt.eu-S1752816AbYKWVJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbYKWVJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 16:09:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751532AbYKWVJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 16:09:43 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:46189 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178AbYKWVJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 16:09:42 -0500
Message-ID: <4929C68E.6080401@lwfinger.net>
Date: Sun, 23 Nov 2008 15:09:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>, Yuval Hager <yuval@avramzon.net>,
       LKML <linux-kernel@vger.kernel.org>,
       wireless <linux-wireless@vger.kernel.org>, bcm43xx-dev@lists.berlios.de,
       Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: BCM4312 Fails when xdm is started
References: <200811151801.02369.yuval@avramzon.net> <200811221654.09399.mb@bu3sch.de> <200811231350.00207.yuval@avramzon.net> <200811231320.30289.mb@bu3sch.de> <20081123204631.21061.qmail@stuge.se>
In-Reply-To: <20081123204631.21061.qmail@stuge.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Stuge wrote:
> Michael Buesch wrote:
>> On Sunday 23 November 2008 12:49:55 Yuval Hager wrote:
>>> [  182.891400] ****** b43: B43_MMIO_MACCTL 0x840A0503
>>> [  182.891409] ****** b43: SSB_TMSLOW 0x20150000
>>> [  258.299027] irq 10: nobody cared (try booting with the "irqpoll" option)
>> Does the kernel disable the PCI device, if it ignores the IRQ?
> 
> The kernel disables the IRQ at least internally, maybe also by
> deconfiguring the interrupt register in any devices using it, which
> would explain the change in config register 0x3c (but not the changes
> in all the other bytes, could that be a freak chain reaction inside
> the hardware?) but I haven't heard/seen the kernel disable the PCI
> device itself. I don't know if it can.
> 
> Why doesn't b43 care about this interrupt? Without APIC interrupt 10
> is what both device and driver should be using (according to earlier
> lspci -x output).

I think by this point the BCM43xx hardware is disabled.

>>> [  258.299173] handlers:
>>> [  258.299176] [<f7906455>] (b43_interrupt_handler+0x0/0x1b7 [b43])
>>> [  258.299212] Disabling IRQ #10
>>> [  258.315148] b43-phy0: Radio hardware status changed to DISABLED
>>> [  258.315160] b43-phy0: ******** B43_B43_MMIO_RADIO_HWENABLED_HI 0xFFFFFFFF
>>> [  258.342341] kobject: 'rfkill0' (f43b7d78): kobject_uevent_env
>>> [  258.342367] kobject: 'rfkill0' (f43b7d78): fill_kobj_path: path = '/class/rfkill/rfkill0'
>>> [  258.342418] kobject: 'ssb0:0' (f40dfcd8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:02.0/0000:02:00.0/ssb0:0'
> 
> Why does the radio hw status changes here?
> How is the change notified to the driver?

By setting a bit in the appropriate register; however, device is disabled and
all bits are set. This is a false indication.

>>> [  258.391951] 
>>> [  258.391956] =================================
>>> [  258.391964] [ INFO: inconsistent lock state ]
>>> [  258.391971] 2.6.28-rc5 #15
>>> [  258.391975] ---------------------------------
>>> [  258.391980] inconsistent {in-hardirq-W} -> {hardirq-on-W} usage.
>>> [  258.391987] X/3965 [HC0[0]:SC1[1]:HE1:SE0] takes:
>>> [  258.391993]  (&irq_desc_lock_class){++..}, at: [<c0148c60>] try_one_irq+0x15/0xe8
>>> [  258.392016] {in-hardirq-W} state was registered at:
>>> [  258.392021]   [<c013bc07>] __lock_acquire+0x490/0x6bc
>>> [  258.392034]   [<c013be8d>] lock_acquire+0x5a/0x74
>>> [  258.392043]   [<c01496f8>] handle_level_irq+0x12/0xba
>>> [  258.392053]   [<c03c4842>] _spin_lock+0x1c/0x45
>>> [  258.392066]   [<c01496f8>] handle_level_irq+0x12/0xba
>>> [  258.392076]   [<c01496f8>] handle_level_irq+0x12/0xba
>>> [  258.392085]   [<c010564e>] do_IRQ+0x89/0x9f
>>> [  258.392096]   [<c0103ea8>] common_interrupt+0x28/0x30
>>> [  258.392105]   [<c03c4cc2>] _spin_unlock_irqrestore+0x37/0x39
>>> [  258.392115]   [<c01487e6>] __setup_irq+0x17a/0x1f3
>>> [  258.392124]   [<c05ce79d>] start_kernel+0x285/0x2f1
>>> [  258.392140]   [<ffffffff>] 0xffffffff
>>> [  258.392159] irq event stamp: 1844456
>>> [  258.392164] hardirqs last  enabled at (1844456): [<c03c4b6f>] _spin_unlock_irq+0x20/0x23
>>> [  258.392175] hardirqs last disabled at (1844455): [<c03c4ac3>] _spin_lock_irq+0xa/0x4b
>>> [  258.392186] softirqs last  enabled at (1844310): [<c0125406>] do_softirq+0x37/0x4d
>>> [  258.392198] softirqs last disabled at (1844447): [<c0125406>] do_softirq+0x37/0x4d
>>
>> That's a bit weird. Looks like another bug in the IRQ layer.
> 
> Something happens with the hardware that confuses the kernel. It's
> triggered by software but I don't know where.. Like Michael, I'm
> not too convinced that it is in b43. :\

>From a config file posted earlier, the OP is using SLAB. Is there any point in
trying SLUB?

Larry

