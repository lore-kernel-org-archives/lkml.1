Return-Path: <linux-kernel-owner+w=401wt.eu-S1752660AbXLRTr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752660AbXLRTr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 14:47:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbXLRTrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 14:47:20 -0500
Received: from gate.crashing.org ([63.228.1.57]:57910 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbXLRTrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 14:47:19 -0500
Subject: Re: [RFC/PATCH 4/4] [POWERPC] pci: Disable IO/Mem on a device when
	resources can't be allocated
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Alan Cox <alan@redhat.com>,
       Greg Kroah-Hartman <greg@kroah.com>, jgarzik@pobox.com,
       wingel@nano-system.com, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       james.smart@emulex.com, linux-driver@qlogic.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071218125643.B7874@jurassic.park.msu.ru>
References: <1197932473.576079.142524077033.qpush@grosgo>
	 <20071217230127.46B3BDDE38@ozlabs.org>
	 <20071218125643.B7874@jurassic.park.msu.ru>
Content-Type: text/plain
Date: Tue, 18 Dec 2007 22:36:09 +1100
Message-Id: <1197977769.13400.42.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-12-18 at 12:56 +0300, Ivan Kokshaysky wrote:
> On Tue, Dec 18, 2007 at 10:01:15AM +1100, Benjamin Herrenschmidt wrote:
> > @@ -1040,7 +1040,10 @@ static inline void __devinit alloc_resou
> >  		r->flags |= IORESOURCE_UNSET;
> >  		r->end -= r->start;
> >  		r->start = 0;
> 
> Perhaps we should use IORESOURCE_UNSET universally... It's a lot better
> than clearing r->start which is in fact architecture dependent thing
> and in the end just destroys information for no purpose.

I'm not totally sure. I was actually tempted to switch powerpc to get
rid of it lately :-)

The problem is that a resource is never "unset" on PCI... the BAR always
contains something... the question is whether that something is going to
be problematic or not, or rather, whether that something can be
"allocated" (ie. fitted into the resource tree in a free spot or not).

And we have a way of knowing that already which is ... resource->parent
being NULL or not. That also happens to be what
pci_assign_unassigned_resources() uses and I think the various arch
pcibios_enable_device() should use (in fact I have a fix to make PowerPC
use that) instead of testing res->start or even IORESOURCE_UNSET. 

Anything that isn't in the resource tree is potentially stale and thus
mustn't be enabled (ie. IO/MEM decoding must not be enabled on a device
that has a BAR whose res->parent is NULL).

The reason why we introduced use of IORESOURCE_UNSET on powerpc goes
back from when we had our own resource assignment code there that was
somewhat a half-assed version of what pci_assign_unassigned_resources().
We decided to introduce IORESOURCE_UNSET rather than testing res->start
because it could cope with a value of 0 being valid, and on machines
with no legacy ISA stuff at all, 0 is a valid BAR value for some things,
and we weren't smart enough to reassign those things in all
circumstances.

Nowadays, that doesn't seem necessary anymore, and in fact, I think we
can still support those valid 0 BARs -and- not have IORESOURCE_UNSET by
standardizing on the idea that res->parent is the only indicator of a
resource validity... unless I'm missing something which is quite
possible :-)

Cheers,
Ben.


