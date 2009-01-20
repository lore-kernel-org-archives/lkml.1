Return-Path: <linux-kernel-owner+w=401wt.eu-S1761909AbZATRpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761909AbZATRpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:45:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbZATRpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:45:21 -0500
Received: from smtp-out.google.com ([216.239.45.13]:43087 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbZATRpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:45:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:
	x-gmailtapped-by:x-gmailtapped;
	b=Gijg1vyVWNl5XyKkpwN2/iYEJGtI6DeXDhHtVyeXu5+wBaw2d/vyeYvxtJQoceRqP
	QMcjBRE+FcCWFR2N5S8RQ==
MIME-Version: 1.0
In-Reply-To: <4975F5C1.8090107@rtr.ca>
References: <4975F5C1.8090107@rtr.ca>
Date: Tue, 20 Jan 2009 09:44:39 -0800
Message-ID: <da824cf30901200944x545431b2va0233abc14e81f9b@mail.gmail.com>
Subject: Re: libata, devm_*, and MSI ?
From: Grant Grundler <grundler@google.com>
To: Mark Lord <liml@rtr.ca>
Cc: "IDE/ATA development list" <linux-ide@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
       linux-pci@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-GMailtapped-By: 172.28.16.142
X-GMailtapped: grundler
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2009 at 8:03 AM, Mark Lord <liml@rtr.ca> wrote:
> Tejun / Jeff,
>
> I am working on MSI support for sata_mv, and am trying to puzzle out
> exactly what the kernel expects for this.  Looking at other drivers,
> both libata and otherwise, yields a variety of conflicting implementations.
>
> For starters, the MSI HOW-TO suggests that drivers must be careful
> to invoke pci_disable_msi() on module unload, but I don't see that
> happening anywhere in libata.

I don't think that's necessary if free_irq() or disable_irq() are called.
However, I'm not seeing those get called either.

>
> Unless, Tejun, the devm_* routines automatically do this.. do they?
>
> Next, there's no mention of a need for invoking pci_intx() in the HOW-TO,
> yet some device drivers call it, and others do not.

In general, I don't think drivers need to call pci_intx().
I'm really not sure why it's exported even.

>
> Eg. from ahci.c, we have this:
>
>       if ((hpriv->flags & AHCI_HFLAG_NO_MSI) || pci_enable_msi(pdev))
>               pci_intx(pdev, 1);
>
> Which agrees with the existing code in sata_mv:
>
>       if (msi && hi jiqi(pdev))
>               pci_intx(pdev, 1);

Combined with the fact that we can't find where MSI is disabled,
this bit of code in pci_enable_msi() might cause MSI reload to fail:

        /* Check whether driver already requested for MSI-X irqs */
        if (dev->msix_enabled) {
                dev_info(&dev->dev, "can't enable MSI "
                         "(MSI-X already enabled)\n");
                return -EINVAL;
        }


> Which seems to call pci_intx() only when MSI is *not* used.  Fine.
> But then in sata_vsc.c, we do sort of the opposite:
>
>       if (pci_enable_msi(pdev) == 0)
>               pci_intx(pdev, 0);
>
> Either that one is wrong, or pci_intx() is unnecessary in all cases.

Neither. Code in sata_vsc.c is redundant and can be removed.

pci_intx() is necessary in some broken cases where INTX
has to be _enabled_ for MSI to work:
    http://lkml.indiana.edu/hypermail/linux/kernel/0710.3/0772.html

> Again, the MSI HOW-TO doesn't even mention this routine.
>
> Looking through the network drivers, it seems that some of them
> do the pci_intx(pdev,1) call for the cases where pci_enable_msi() fails,
> similar to ahci.c and sata_mv.c.
>
> But not all of them do that.

Jeff Garzik seems to like that construct:

>
> Perhaps somebody from the PCI side of things might enlighten us all.

    http://lists.linuxcoding.com/kernel/2005-q3/msg11296.html

Shows when pci_intx() was added. linux-pci was NOT cc'd on that email.
And no one asked for Documentation/ update. C'est la vie.

BTW, gregkh is very good about posting patches when sending a pull request
to linus. But that just means it was likely buried in a pile of 50+ patches.

grant
