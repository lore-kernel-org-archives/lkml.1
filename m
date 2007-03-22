Return-Path: <linux-kernel-owner+w=401wt.eu-S1752048AbXCVN0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbXCVN0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:26:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbXCVN0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:26:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:48607 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbXCVN0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:26:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>, <linux-kernel@vger.kernel.org>,
       Thomas Meyer <thomas@m3y3r.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       <linux-pci@atrey.karlin.mff.cuni.cz>, Jeff Garzik <jeff@garzik.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Fw: Re: Bug in pci_restore_msi_state
References: <20070321235313.3b39b424.akpm@linux-foundation.org>
Date: Thu, 22 Mar 2007 07:24:12 -0600
In-Reply-To: <20070321235313.3b39b424.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 21 Mar 2007 23:53:13 -0800")
Message-ID: <m11wjh9zsz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I couldn't find the original thread so I am restarting one adding I hope
the appropriate people to the cc list.

Andrew thanks for forwarding this one. I finally see enough of this to
see what is going on.

The question is about the following sequence from libata.

   pci_enable_msi();
   pci_save_state(pdev);
   pci_disable_device(pdev);
   
   pci_restore_state(pdev);
   pci_enable_device(pdev);

Should this be allowed?

Specifically should pci_disable_device() be allowed when we have
device resources requested and potentially in use.

Specifically should pci_enable_device() be expected to cope with the
case where we are already using some a pci devices resources?

....

If this sequence is sane pci_enable_device needs to not reset dev->irq
In this case I guess it is acpi_pci_irq_enable doing that.

If this sequence is not sane we can just put outlaw calling
pci_disable_device when msi is enabled and fix it that way.

The suggestion below of setting msi_enabled to 0.  While it will avoid
the immediate problem, leaves us still having requested the msi
irq (which won't work now) and so we won't be in a state where we can
do useful things after resume, plus we would wind up leaking the
msi state.

I think fixing pci_enable_device to cope when a device is already in
use is likely to be the path of least resistance.

If suspend to disk needs to cope with any pci resource assignment
changes then we need to free all irqs and all pci bars before the
suspend and reallocate them after the resume, and we should outlaw
pci_disable_device with pci device resources in use.

Eric


Andrew Morton <akpm@linux-foundation.org> writes:

> Begin forwarded message:
>
> Date: Tue, 20 Mar 2007 22:07:59 +0100
> From: Thomas Meyer <thomas@m3y3r.de>
> To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Subject: Re: Bug in pci_restore_msi_state
>
>
> Pekka Enberg schrieb:
>> On 3/17/07, Thomas Meyer <thomas@m3y3r.de> wrote:
>>> Hello everybody.
>>>
>>> I get this bug after suspending to disk twice:
>>>
>>> http://m3y3r.de/bilder/Bug-pci_restore_msi_state.png
>>>
>>> This happens with current git head
>>> cd05a1f818073a623455a58e756c5b419fc98db9.
>>
>> If you know a kernel that works, please consider doing git bisect:
>>
>>
> http://www.kernel.org/pub/software/scm/git/docs/howto/isolate-bugs-with-bisect.txt
>>
>>
>
> Ok. The error happens in the call of pcibios_enable_device in the
> function do_pci_enable_device (drivers/pci/pci.c):
>
> Before the call of pcibios_enable_device:
>
> do_pci_enable_device: pci_dev= c1a40000
> do_pci_enable_device: irq= 218
> do_pci_enable_device: msi_enabled= 1
>
> after the call:
> ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
>
> do_pci_enable_device: pci_dev= c1a40000
> do_pci_enable_device: irq= 19
> do_pci_enable_device: msi_enabled= 1
>
>
> So the function acpi_pci_irq_enable in drivers/acpi/pci_irq.c  needs to
> be fixed:
>
> a.) acpi_pci_irq_enable should care about msi setups and set the flag
> msi_enabled to 0 or
> b.) acpi_pci_irq_enable should care about msi setups and should touch
> the dev->irq field.
>
> Please comment on this.
>
> with kind regards
> thomas
>
