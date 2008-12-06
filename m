Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYLFVES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYLFVES (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 16:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYLFVED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 16:04:03 -0500
Received: from main.gmane.org ([80.91.229.2]:54272 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYLFVEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 16:04:01 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: [patch] ohci1394: don't leave interrupts enabled during suspend/resume
Date: Sat, 06 Dec 2008 15:03:47 -0600
Message-ID: <493AE8B3.7090000@shaw.ca>
References: <200812061316.38460.elendil@planet.nl> <200812061536.47894.elendil@planet.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: s0106000c41bb86e1.ss.shawcable.net
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
In-Reply-To: <200812061536.47894.elendil@planet.nl>
Cc: linux1394-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> On my HP 2510p I get the following in dmesg during near the end of most
> resumes from suspend to RAM:
> 
> irq 19: nobody cared (try booting with the "irqpoll" option)
> Pid: 0, comm: swapper Not tainted 2.6.28-rc7 #67
> Call Trace:
>  <IRQ>  [<ffffffffa00ee9e1>] ? ohci_irq_handler+0x60/0x7e9 [ohci1394]
>  [<ffffffff8026aa4d>] __report_bad_irq+0x38/0x87
>  [<ffffffff8026abaa>] note_interrupt+0x10e/0x174
>  [<ffffffff8026b262>] handle_fasteoi_irq+0xa7/0xd1
>  [<ffffffff8020eb87>] do_IRQ+0x73/0xe4
>  [<ffffffff8020c626>] ret_from_intr+0x0/0xa
>  <EOI>  [<ffffffffa0012606>] ? acpi_idle_enter_bm+0x26b/0x2b2 [processor]
>  [<ffffffffa00125fc>] ? acpi_idle_enter_bm+0x261/0x2b2 [processor]
>  [<ffffffff8024f30f>] ? notifier_call_chain+0x33/0x5b
>  [<ffffffff803b9c64>] ? cpuidle_idle_call+0x8c/0xc4
>  [<ffffffff8020b312>] ? cpu_idle+0x4a/0x9a
>  [<ffffffff8042c5c8>] ? rest_init+0x5c/0x5e
> handlers:
> [<ffffffffa00ee981>] (ohci_irq_handler+0x0/0x7e9 [ohci1394])
> Disabling IRQ #19
> 
> There also seems to be an interrupt storm during suspend/resume when this
> happens:
>  19:      99968         33   IO-APIC-fasteoi   ohci1394
> 
> This patch gets rid of both issues and makes the resume as a whole
> significantly faster.
> 
> Signed-off-by: Frans Pop <elendil@planet.nl>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> ---
> New try and this actually _does_ seem to both make sense and work.
> 
> I've verified that the interrupt storm really only happens during the
> suspend/resume process and not at other times.
> 
> I don't actually use firewire, so I cannot test anything other than
> checking dmesg and seeing that there are no changes. With the patch
> I do see a very slow increase of the interrupt count, so the device
> seems active.
> 
> Please review the patch carefully, especially the error handling.
> The patch is essentially only copy-and-paste work, with checks against
> other drivers and the ohci1394_pci_probe function.
> 
> diff --git a/drivers/ieee1394/ohci1394.c b/drivers/ieee1394/ohci1394.c
> index e509e13..d2942e6 100644
> --- a/drivers/ieee1394/ohci1394.c
> +++ b/drivers/ieee1394/ohci1394.c
> @@ -3381,6 +3381,7 @@ static int ohci1394_pci_suspend(struct pci_dev *dev, pm_message_t state)
>  	ohci_devctl(ohci->host, RESET_BUS, LONG_RESET_NO_FORCE_ROOT);
>  	ohci_soft_reset(ohci);
>  
> +	free_irq(dev->irq, ohci);
>  	err = pci_save_state(dev);
>  	if (err) {
>  		PRINT(KERN_ERR, "pci_save_state failed with %d", err);
> @@ -3421,6 +3422,13 @@ static int ohci1394_pci_resume(struct pci_dev *dev)
>  	reg_write(ohci, OHCI1394_IntEventClear, 0xffffffff);
>  	reg_write(ohci, OHCI1394_IntMaskClear, 0xffffffff);
>  	mdelay(50);
> +
> +	if (request_irq(dev->irq, ohci_irq_handler, IRQF_SHARED,
> +			OHCI1394_DRIVER_NAME, ohci)) {
> +		PRINT_G(KERN_ERR, "Failed to allocate interrupt %d", dev->irq);
> +		return -EIO;
> +        }
> +

This doesn't seem like the best solution to me. If free_irq and 
request_irq fix anything, then that indicates that the ohci1394 device 
is generating interrupts at some point during resume, which is likely 
not a good thing. If the device doesn't have a shared interrupt, then 
freeing the IRQ line will disable the IRQ line and prevent the interrupt 
storm, but if the ohci1394 device shared an interrupt with something 
else then the interrupt storm would still occur.

Likely the driver should be setting some register on the device to 
disable it from generating interrupts before suspend and it's not doing 
this.

