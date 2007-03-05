Return-Path: <linux-kernel-owner+w=401wt.eu-S932914AbXCEPfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914AbXCEPfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 10:35:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933090AbXCEPfg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 10:35:36 -0500
Received: from rtr.ca ([64.26.128.89]:4218 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932914AbXCEPff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 10:35:35 -0500
Message-ID: <45EC38C5.1060600@rtr.ca>
Date: Mon, 05 Mar 2007 10:35:33 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: sdhci-devel@list.drzeus.cx, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] sdhci regression in 2.6.21-rc2
References: <Pine.LNX.4.64.0702272105220.12485@woody.linux-foundation.org> <20070305015031.GF3441@stusta.de> <45EB9DC6.8010403@rtr.ca> <45EB9E72.6040107@rtr.ca> <45EBAC73.7010600@drzeus.cx> <45EC2851.7020905@rtr.ca> <45EC352C.4070508@drzeus.cx> <45EC3609.4030809@drzeus.cx>
In-Reply-To: <45EC3609.4030809@drzeus.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Pierre Ossman wrote:
>> I'd say it's the kernel calling the interrupt handler of a
>> currently sleeping device. Since we're seeing this problem I assume the
>> kernel's interrupt code isn't aware of PM states?
>
> Hmm... I guess it can't be as the interrupt handler isn't associated with a
> device, just a random pointer.
> 
> So either release the interrupt (which seems a bit unsafe as then we might not
> get it back), or handle states at the start of the isr.

>From linux/Documentation/power/pci.txt:

> A reference implementation
> -------------------------
> .suspend()
> {
>         /* driver specific operations */
> 
>         /* Disable IRQ */
>         free_irq();
>         /* If using MSI */
>         pci_disable_msi();
> 
>         pci_save_state();
>         pci_enable_wake();
>         /* Disable IO/bus master/irq router */
>         pci_disable_device();
>         pci_set_power_state(pci_choose_state());
> }
> 
> .resume()
> {
>         pci_set_power_state(PCI_D0);
>         pci_restore_state();
>         /* device's irq possibly is changed, driver should take care */
>         pci_enable_device();
>         pci_set_master();
> 
>         /* if using MSI, device's vector possibly is changed */
>         pci_enable_msi();
> 
>         request_irq();
>         /* driver specific operations; */
> }
