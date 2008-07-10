Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbYGJBoK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbYGJBoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 21:44:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbYGJBn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 21:43:57 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:50334 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbYGJBn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 21:43:56 -0400
Date: Wed, 9 Jul 2008 19:43:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 2/4] PCI: Support multiple MSI
Message-ID: <20080710014339.GN14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-2-git-send-email-matthew@wil.cx> <1215396326.19157.15.camel@localhost> <20080707024525.GV14894@parisc-linux.org> <1215403012.9862.25.camel@localhost> <20080707113105.GY14894@parisc-linux.org> <1215653564.13950.40.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215653564.13950.40.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 11:32:44AM +1000, Michael Ellerman wrote:
> >  int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> >  {
> > +	if (type == PCI_CAP_ID_MSI && nvec > 1)
> > +		return 1;
> 
> This should go in arch_msi_check_device(). We might move it into a
> ppc_md routine eventually.

I'm OK with that, but ...

> >  int __attribute__ ((weak))
> >  arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> >  {
> > -	struct msi_desc *entry;
> > +	struct msi_desc *desc;
> >  	int ret;
> >  
> > -	list_for_each_entry(entry, &dev->msi_list, list) {
> > -		ret = arch_setup_msi_irq(dev, entry);
> > +	if ((type == PCI_CAP_ID_MSI) && (nvec > 1))
> > +		return 1;
> 
> I think the check should be in the generic arch_msi_check_device(), so
> archs can override just the check.

... then x86 has to implement arch_msi_check_device in order to _not_
perform the check, which feels a bit bass-ackwards to me.

> >  
> >  void __attribute__ ((weak))
> > -arch_teardown_msi_irqs(struct pci_dev *dev)
> > +arch_teardown_msi_irqs(struct pci_dev *dev, int nvec)
> >  {
> >  	struct msi_desc *entry;
> >  
> >  	list_for_each_entry(entry, &dev->msi_list, list) {
> > -		if (entry->irq != 0)
> > -			arch_teardown_msi_irq(entry->irq);
> > +		int i;
> > +		if (entry->irq == 0)
> > +			continue;
> > +		for (i = 0; i < nvec; i++)
> > +			arch_teardown_msi_irq(entry->irq + i);
> 
> This looks wrong. You're looping through all MSIs for the device, and
> then for each one you're looping through all MSIs for the device. And
> you're assuming they're contiguous, which they won't be for MSI-X.
> 
> AFAICS this code should work for you as it was.

For MSI-X, nvec will be = 1.  Maybe I should call it something else to
avoid confusion.  The code won't work for me as-was because it won't
call arch_teardown_msi_irq() for all entries.

> > + * Allocate IRQs for a device with the MSI capability.
> > + * This function returns a negative errno if an error occurs.  On success,
> > + * this function returns the number of IRQs actually allocated.  Since
> > + * MSIs are required to be a power of two, the number of IRQs allocated
> > + * may be rounded up to the next power of two (if the number requested is
> > + * not a power of two).  Fewer IRQs than requested may be allocated if the
> > + * system does not have the resources for the full number.
> > + *
> > + * If successful, the @pdev's irq member will be updated to the lowest new
> > + * IRQ allocated; the other IRQs allocated to this device will be consecutive.
> >   **/
> > -int pci_enable_msi(struct pci_dev* dev)
> > +int pci_enable_msi_block(struct pci_dev *pdev, unsigned int nr_irqs)
> >  {
> >  	int status;
> >  
> > -	status = pci_msi_check_device(dev, 1, PCI_CAP_ID_MSI);
> > +	/* MSI only supports up to 32 interrupts */
> > +	if (nr_irqs > 32)
> > +		return 32;
> 
> You don't describe this behaviour in the doco. I'm a bit lukewarm on it,
> ie. returning the number that /could/ be allocated and having drivers
> use that, I think it's likely drivers will be poorly tested in the case
> where they get fewer irqs than they ask for. But I suppose that's a
> separate problem.

Ah, I changed the bahviour (to match msix) and forgot to update the
comment.  Thanks, I'll fix that.  By the way I have an updated version
of MSI-HOWTO available from http://www.parisc-linux.org/~willy/MSI-HOWTO.txt

> > -	WARN_ON(!!dev->msi_enabled);
> > +	WARN_ON(!!pdev->msi_enabled);
> 
> Your patches would be easier to read if you didn't keep renaming to
> entry to desc and dev to pdev :)

True ... I should do those in separate patches.

> >  #else
> > -extern int pci_enable_msi(struct pci_dev *dev);
> > +extern int pci_enable_msi_block(struct pci_dev *dev, unsigned int count);
> 
> Here you have "count", the implementation uses "nr_irqs", and the rest
> of the code uses "nvec".

There's inconsistency between the various implementations too.  I got
confused with where I was.

> >  extern void pci_msi_shutdown(struct pci_dev *dev);
> >  extern void pci_disable_msi(struct pci_dev *dev);
> >  extern int pci_enable_msix(struct pci_dev *dev,
> > @@ -737,6 +737,8 @@ extern void msi_remove_pci_irq_vectors(struct pci_dev *dev);
> >  extern void pci_restore_msi_state(struct pci_dev *dev);
> >  #endif
> >  
> > +#define pci_enable_msi(pdev)	pci_enable_msi_block(pdev, 1)
> 
> Someone will probably say this should be a static inline.

Not quite sure why.  You don't get any better typechecking by making it
a static inline.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
