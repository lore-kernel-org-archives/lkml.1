Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbYGKJps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbYGKJps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 05:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYGKJpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 05:45:39 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55222 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbYGKJpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 05:45:38 -0400
Date: Fri, 11 Jul 2008 03:45:20 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       grundler@parisc-linux.org, mingo@elte.hu, tglx@linutronix.de,
       jgarzik@pobox.com, linux-ide@vger.kernel.org, suresh.b.siddha@intel.com,
       benh@kernel.crashing.org, jbarnes@virtuousgeek.org,
       rdunlap@xenotime.net, mtk.manpages@gmail.com,
       Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] PCI: Add support for multiple MSI
Message-ID: <20080711094520.GQ14894@parisc-linux.org>
References: <20080711005719.GO14894@parisc-linux.org> <1215738002-4961-2-git-send-email-matthew@wil.cx> <487719AC.9070609@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487719AC.9070609@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 05:28:28PM +0900, Hidetoshi Seto wrote:
> Hi,
> 
> First of all, it seems that mask/unmask of MSI has problems.
>  - Per-vector masking is optional for MSI, so I think that allocating
>    multiple messages for a function without masking capability would be
>    not good idea, since all vector in the block will be masked/unmasked
>    at once without any agreement.
>  - Even if the function supports per-vector masking, current
>    mask/unmask_msi_irq() functions assume that MSI uses only one vector,
>    therefore they only set/unset the first bit of the maskbits which
>    for the first vector of the block.  The bits for other vectors are
>    initialized as 'masked' but no one unmask them.

Thank you for pointing out the problems with masking.  The device I am
testing with does not support per-vector masking, so I have not paid
attention to this.

To your first point, if the function does not support per-vector
masking, I think it's OK to mask/unmask all vectors at once.  But we
must be careful to manage this correctly in software; if we disable IRQ
496, disable IRQ 497, then enable IRQ 497, we must not enable IRQ 496 at
that time.  I think we can solve this problem, but I must think about it
some more.

The second point is a simple bug that should be easy to fix.  Thank you
for pointing it out.

> Matthew Wilcox wrote:
> > + * Allocate IRQs for a device with the MSI capability.
> > + * This function returns a negative errno if an error occurs.  If it
> > + * is unable to allocate the number of interrupts requested, it returns
> > + * the number of interrupts it might be able to allocate.  If it successfully
> > + * allocates at least the number of interrupts requested, it returns 0 and
> > + * updates the @dev's irq member to the lowest new interrupt number; the
> > + * other interrupt numbers allocated to this device are consecutive.
> > + */
> > +int pci_enable_msi_block(struct pci_dev *dev, unsigned int nvec)
> >  {
> >  	int status;
> >  
> > -	status = pci_msi_check_device(dev, 1, PCI_CAP_ID_MSI);
> > +	/* MSI only supports up to 32 interrupts */
> > +	if (nvec > 32)
> > +		return 32;
> 
> I think we should return -EINVAL here.
> No one guarantee that 32 interrupts is able to be allocate at this time.
> 
> And also I think -EINVAL should be returned if nvec is greater than
> the number of encoded in the function's "Multiple Message Capable", but
> I could not find any mention about handling of such over-capability request
> in PCI Bus Spec. 3.0.

It would be outside the scope of the PCI Bus Specification.  I think
you're right that we should check the MMC bits; but I think we should
tell the driver to request a lower number, not return -EINVAL.

Thanks for your comments.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
