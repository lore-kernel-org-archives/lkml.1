Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbYDOISB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbYDOISB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 04:18:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbYDOIRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 04:17:46 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:20177 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754635AbYDOIRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 04:17:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=csk664PuOs6zHscnZBDZUypN2SauMkOObnvLyiY8igCOqVHPuUbtyz9JU8AOMco24Tjqw5xCPQIdCxx59Er0NMUYSTylgA2ZtI10nZKm4RSClBpNPFq9xveLgie2EaxxOq4DnIOwzJCX1V+192dFxfO+X0AMeKhBetzuJDIA/4s=
Message-ID: <86802c440804150117w7093dc1era71bf7f5ea7426f7@mail.gmail.com>
Date: Tue, 15 Apr 2008 01:17:44 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86_64: restore mask_bits in msi shutdown
Cc: "Yinghai Lu" <yhlu.kernel.send@gmail.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Jeff Garzik" <jeff@garzik.org>, "Ayaz Abdulla" <aabdulla@nvidia.com>,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080415011247.4b6020e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200804111626.11232.yhlu.kernel@gmail.com>
	 <20080415011247.4b6020e7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 1:12 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> On Fri, 11 Apr 2008 16:26:11 -0700 Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
>
>  > I can not kexec RHEL 5.1 from 2.6.25-rc3 later
>  >
>  > caused by:
>  > commit 89d694b9dbe769ca1004e01db0ca43964806a611
>  > Author: Thomas Gleixner <tglx@linutronix.de>
>  > Date:   Mon Feb 18 18:25:17 2008 +0100
>  >
>  >     genirq: do not leave interupts enabled on free_irq
>  >
>  >     The default_disable() function was changed in commit:
>  >
>  >      76d2160147f43f982dfe881404cfde9fd0a9da21
>  >      genirq: do not mask interrupts by default
>  >
>  >     It removed the mask function in favour of the default delayed
>  >     interrupt disabling. Unfortunately this also broke the shutdown in
>  >     free_irq() when the last handler is removed from the interrupt for
>  >     those architectures which rely on the default implementations. Now we
>  >     can end up with a enabled interrupt line after the last handler was
>  >     removed, which can result in spurious interrupts.
>  >
>  >     Fix this by adding a default_shutdown function, which is only
>  >     installed, when the irqchip implementation does provide neither a
>  >     shutdown nor a disable function.
>  >
>  >     [@stable: affected versions: .21 - .24 ]
>  >
>  >
>  >
>  > for MSI, default_shutdown will call mask_bit for msi device. so all mask bits will
>  > left disabled after free_irq.
>  > then if kexec next kernel that only can use msi_enable bit.
>  > all device's MSI can not be used.
>  >
>  > So try to restore MSI mask bits that is saved before using msi in first kernel.
>  >
>  > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>  >
>  > Index: linux-2.6/arch/x86/kernel/io_apic_64.c
>  > ===================================================================
>  > --- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
>  > +++ linux-2.6/arch/x86/kernel/io_apic_64.c
>  > @@ -2003,6 +2003,14 @@ static void set_msi_irq_affinity(unsigne
>  >  }
>  >  #endif /* CONFIG_SMP */
>  >
>  > +static void msi_shutdown(unsigned int irq)
>  > +{
>  > +     struct irq_desc *desc = irq_desc + irq;
>  > +
>  > +     msi_restore_mask_bits(irq);
>  > +     desc->status |= IRQ_MASKED;
>  > +}
>
>  I wonder if only x86_64 needs this treatment.
>
>
>  > Index: linux-2.6/drivers/pci/msi.c
>  > ===================================================================
>  > --- linux-2.6.orig/drivers/pci/msi.c
>  > +++ linux-2.6/drivers/pci/msi.c
>  > @@ -123,6 +123,31 @@ static void msix_flush_writes(unsigned i
>  >       }
>  >  }
>  >
>  > +void msi_restore_mask_bits(unsigned int irq)
>  > +{
>  > +     struct msi_desc *entry;
>  > +
>  > +     entry = get_irq_msi(irq);
>  > +     BUG_ON(!entry || !entry->dev);
>  > +     switch (entry->msi_attrib.type) {
>  > +     case PCI_CAP_ID_MSI:
>  > +             if (entry->msi_attrib.maskbit) {
>  > +                     int pos;
>  > +                     u32 mask_bits;
>  > +
>  > +                     pos = (long)entry->mask_base;
>  > +                     mask_bits = entry->orig_mask_bits;
>  > +                     pci_write_config_dword(entry->dev, pos, mask_bits);
>  > +             }
>  > +             break;
>  > +     case PCI_CAP_ID_MSIX:
>  > +             break;
>  > +     default:
>  > +             BUG();
>  > +             break;
>  > +     }
>  > +}
>
>  If no other architectures will ever need this, perhaps it is in the wrong
>  file.

need someone has powerpc (64?) etc platform with RHEL 5.1 with PCIe
NIC that is using MSI
to test if they have the same problem with kexec.

YH
