Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025AbYL2VKM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025AbYL2VKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 16:10:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752838AbYL2VJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 16:09:43 -0500
Received: from main.gmane.org ([80.91.229.2]:37829 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbYL2VJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 16:09:41 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: System hang in quirk_usb_handoff_ohci
Date: Mon, 29 Dec 2008 15:09:25 -0600
Message-ID: <49593C85.9070502@shaw.ca>
References: <495933D6.1020409@tragetaschen.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <495933D6.1020409@tragetaschen.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kai Ruhnau wrote:
> Hi,
> 
> Some days ago, I reported a reproducible hang during boot. The
> information around was quite vague and so I took the liberty to further
> dig into the the call stack of pci_init and found the exact place where
> the initialization locks.
> But first the symptoms (those are improved as well):
> 
> If I turn on or restart my computer and try to boot without my
> intervention, the system always hangs during boot, the last output being
> the io scheduler registration. However, if I press a key at any time
> after the BIOS (for example manual choosing  the grub entry or during
> the kernel messages) the system happily boots normally.
> 
> After a little printk debugging, it turns out, that
> quirk_usb_handoff_ohci will hang when applied to my first USB OHCI pci
> device. I have marked the offending line in the following snippet (line
> 186 in the original---the second writel)
> 
> ============ (startint at line 182 inn pci-quirks.c)
> [...]
>     u32 control = readl(base + OHCI_CONTROL);
>     if (control & OHCI_CTRL_IR) {
>         int wait_time = 500; /* arbitrary; 5 seconds */
>         writel(OHCI_INTR_OC, base + OHCI_INTRENABLE);
> 
>        // The next line might hang
> 
>         writel(OHCI_OCR, base + OHCI_CMDSTATUS);
>         while (wait_time > 0 &&
>                 readl(base + OHCI_CONTROL) & OHCI_CTRL_IR) {
>             wait_time -= 10;
>             msleep(10);
>         }
> [...]
> =========
> 
> The lspci output for the device is
> 
> 00:13.0 0c03: 1002:4387 (prog-if 10 [OHCI])
>         Subsystem: 1462:7326              
>         Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 16
>         Memory at fdffe000 (32-bit, non-prefetchable) [size=4K]   
>         Kernel driver in use: ohci_hcd                            
>         Kernel modules: ohci-hcd                                  
> 
> My system is a
> 
> Linux  2.6.28-gentoo #12 SMP PREEMPT Mon Dec 29 21:01:04 CET 2008 x86_64
> Intel(R) Core(TM)2 CPU 6300 @ 1.86GHz GenuineIntel GNU/Linux
> 
> Thanks for your time.

It's most likely a BIOS bug, it somehow blows up when we tell it to give 
up control of the USB controller (the BIOS will control it initially to 
handle USB keyboard/mouse support). Is there an update available?

