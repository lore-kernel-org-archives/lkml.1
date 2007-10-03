Return-Path: <linux-kernel-owner+w=401wt.eu-S1758409AbXJCVuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409AbXJCVuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755723AbXJCVtz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:49:55 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:56588 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbXJCVtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:49:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Loic Prylli <loic@myri.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: MSI problem since 2.6.21 for devices not providing a mask in their MSI capability
References: <470405BB.2000208@myri.com>
Date: Wed, 03 Oct 2007 15:49:21 -0600
In-Reply-To: <470405BB.2000208@myri.com> (Loic Prylli's message of "Wed, 03
	Oct 2007 17:12:27 -0400")
Message-ID: <m14ph7amxq.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Loic Prylli <loic@myri.com> writes:

> Hi,
>
> We observe a problem with MSI since kernel 2.6.21 where interrupts would
> randomly stop working. We have tracked it down to the new
> msi_set_mask_bit definition in 2.6.21. In the MSI case with a device not
> providing a "native" MSI mask, it was a no-op before, and now it
> disables MSI in the MSI-ctl register which according to the PCI spec is
> interpreted as reverting the device to legacy interrupts. If such a
> device try to generate a new interrupt during the "masked" window, the
> device will try a legacy interrupt which is generally
> ignored/never-acked and cause interrupts to no longer work for the
> device/driver combination (even after the enable bit is restored).

We should also be leaving the INTx irqs disabled.  So no irq
should be generated.

If you have a mask bit implemented you are required to be
able to refire it after the msi is enabled.  I don't recall
the requirements for when both intx and msi irqs are both
disabled.  Intuitively I would expect no irq message to
be generated, and at most the card would need to be polled
manually to recognize a device event happened.

Certainly firing an irq and having it get completely lost is
unfortunate, and a major pain if you are trying to use the
card.

As for the previous no-op behavior that was a bug.

> Is there anything apart from irq migration that strongly requires
> masking? Is is possible to do the irq migration without masking?

enable_irq/disable_irq.  Although we can get away with a software
emulation there and those are only needed if the driver calls them.

The PCI spec requires disabling/masking the msi when reprogramming it.
So as a general rule we can not do better.  Further because we are
writing to multiple pci config registers the only way we can safely
reprogram the message is with the msi disabled/masked on the card in
some fashion.

I suspect what needs to happen is a spec search to verify that the
current linux behavior is at least reasonable within the spec.

Once we have verified that the generic code can not do better.
We can look at work-arounds.   One possibility is for the generic
code to provide some overrides for the methods for masking and
reading/writing to a msi message.

I don't want to break anyones hardware, but at the same time I want us
to be careful and in spec for the default case.

Eric
