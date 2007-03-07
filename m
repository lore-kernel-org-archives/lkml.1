Return-Path: <linux-kernel-owner+w=401wt.eu-S2992484AbXCGT3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992484AbXCGT3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 14:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992493AbXCGT3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 14:29:46 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42918 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992484AbXCGT3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 14:29:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@mellanox.co.il>, Pavel Machek <pavel@ucw.cz>,
       Jens Axboe <jens.axboe@oracle.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-pm@lists.osdl.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: SATA resume slowness, e1000 MSI warning
References: <20070227103021.GA2250@kernel.dk> <20070227103407.GA17819@elte.hu>
	<20070227105922.GD2250@kernel.dk> <20070227111515.GA4271@kernel.dk>
	<20070301093450.GA8508@elte.hu> <20070302100704.GB2293@elf.ucw.cz>
	<20070305084257.GA4464@mellanox.co.il>
	<20070305101120.GA23032@elte.hu> <45ECFC5F.7000102@garzik.org>
	<45ED0BBF.1050000@intel.com> <20070306090444.GA25409@elte.hu>
	<45ED8A12.5040803@intel.com>
	<m1ejo1elj6.fsf@ebiederm.dsl.xmission.com>
	<45EEE8CF.1060803@intel.com> <45EEEC2C.5090609@intel.com>
Date: Wed, 07 Mar 2007 12:28:11 -0700
In-Reply-To: <45EEEC2C.5090609@intel.com> (Auke Kok's message of "Wed, 07 Mar
	2007 08:45:32 -0800")
Message-ID: <m1649cdfas.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"Kok, Auke" <auke-jan.h.kok@intel.com> writes:

> Kok, Auke wrote:
>> Eric W. Biederman wrote:

>>> This leaves with some basic questions.
>>> - Does it make sense for suspend/resume methods to request/free irqs?
>>> - Does it make sense for suspend/resume methods to allocate/free msi irqs?
>>> - Do we want pci_save/restore_cap to save/restore msi state?
>>>
>>> The path of least resistance is to just free the extra state and we
>>> are good.  I'm just not quite certain that is sane and it has been a
>>> long day.
>>
>> we used to have a lengthy e1000_pci_save|restore_state in our code, which is
>> now gone, so I'm all for that. A separate pci_save_pxie|msi(x)_state for every
>> driver seems completely unnecessary. I can't think of a use case where
>> saving+restoring everything hurts. That's what you want I presume.

I just want to understand why we have issues and to see if how we have
organized the suspend/resume path for dealing with msi irqs makes sense.

That is I haven't looked much at the suspend/resume path so I don't know it
well and I am afraid that your problem might be a symptom of a deeper
problem.

>> We currently free all irq's and msi before going into suspend in e1000, and I
>> think that is probably a good thing, somehow I can think of bad things
>> happening if we dont, but I admit that I haven't tried it without
>> alloc/free. We do this in e100 as well and it works.

Currently the irq code supports operation without the
free_irq/request_irq.  Since the numbers given are pure linux
abstractions things should it is really a matter of just
saving/restoring the appropriate state.

>> Another motivation would be to leave this up to the driver: if the driver
>> chooses to free/alloc interrupts because it makes sense, you probably would
>> want to keep that choice available. Devices that don't need this can skip the
>> alloc/free, but leave the choice open for others.
>
> ah, looking at the code in e1000 we do:
>
> _suspend:
> 	pci_save_state();
> 	free_irq()
>
> _resume:
> 	pci_restore_state();
> 	alloc_irq();
>
> I suppose that's not good either, and the major cause of the warning in the
> first place.

Yep. 

> Maybe I can rollback your latest patches and try to fix that mess by postponing
> the pci_save_state until after we free'd the irq's.

Below is an additional set of warnings that should help debug this.
The old code just got lucky that it triggered a warning when this happens.

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 01869b1..5113913 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -613,6 +613,7 @@ int pci_enable_msi(struct pci_dev* dev)
 		return -EINVAL;
 
 	WARN_ON(!!dev->msi_enabled);
+	WARN_ON(!hlist_empty(&dev->saved_cap_space));
 
 	/* Check whether driver already requested for MSI-X irqs */
 	if (dev->msix_enabled) {
@@ -638,6 +639,8 @@ void pci_disable_msi(struct pci_dev* dev)
 	if (!dev->msi_enabled)
 		return;
 
+	WARN_ON(!hlist_empty(&dev->saved_cap_space));
+
 	msi_set_enable(dev, 0);
 	pci_intx(dev, 1);		/* enable intx */
 	dev->msi_enabled = 0;
@@ -739,6 +742,7 @@ int pci_enable_msix(struct pci_dev* dev, struct msix_entry *entries, int nvec)
 		}
 	}
 	WARN_ON(!!dev->msix_enabled);
+	WARN_ON(!hlist_empty(&dev->saved_cap_space));
 
 	/* Check whether driver already requested for MSI irq */
    	if (dev->msi_enabled) {
@@ -763,6 +767,8 @@ void pci_disable_msix(struct pci_dev* dev)
 	if (!dev->msix_enabled)
 		return;
 
+	WARN_ON(!hlist_empty(&dev->saved_cap_space));
+
 	msix_set_enable(dev, 0);
 	pci_intx(dev, 1);		/* enable intx */
 	dev->msix_enabled = 0;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index bd44a48..4418839 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -677,6 +677,7 @@ pci_restore_state(struct pci_dev *dev)
 	}
 	pci_restore_pcix_state(dev);
 	pci_restore_msi_state(dev);
+	WARN_ON(!hlist_empty(&dev->saved_cap_space));
 
 	return 0;
 }
