Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbYGGQR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbYGGQR3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYGGQRQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:17:16 -0400
Received: from colo.lackof.org ([198.49.126.79]:59400 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbYGGQRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:17:15 -0400
Date: Mon, 7 Jul 2008 10:17:03 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org, Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: Multiple MSI
Message-ID: <20080707161703.GB7521@colo.lackof.org>
References: <20080703024445.GA14894@parisc-linux.org> <1215055469.21182.70.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215055469.21182.70.camel@pasglop>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 01:24:29PM +1000, Benjamin Herrenschmidt wrote:
...
> > Next, MSI requires that you assign a block of interrupts that is a power
> > of two in size (between 2^0 and 2^5), and aligned to at least that power
> > of two.
...
> > One thing I do want to be clear in the API is that the driver can ask
> > for any number of irqs, the pci layer will round up to the next power of
> > two if necessary.
> 
> Well, that's where I'm not happy. The API shouldn't expose the
> "power-of-two" thing. The numbers shown to drivers aren't in the same
> space as the source numbers as seen by the HW on many architectures and
> thus don't need to have the same constraints.

The drivers have to deal with the limitations of the HW spec.
In this case it means they have to know they are getting power of 2
number of interrupts. I think exposing this in the API is a requirement
and not optional.

> > I don't quite understand how IRQ affinity will work yet.  Is it feasible
> > to redirect one interrupt from a block to a different CPU?  I don't even
> > understand this on x86-64, let alone the other four architectures.  I'm
> > OK with forcing all MSIs in the same block to move with the one that was
> > assigned a new affinity if that's the way it has to be done.
> 
> It's very implementation specific. IE. On most powerpc implementations,
> MSI just route via a decoder to sources of the existing interrupt
> controller so we can control per-source affinity at that level.
> Some x86 seem to require different base addresses which makes it mostly
> impossible to spread them I believe (maybe that's why people came up
> with MSI-X ?)

Correct. MSI only has one address for multiple vectors and thus will
only target one CPU. MSI-X has address/vector pairs (1:1).

If the Local-APICs are able to redirect interrupts, then multiple CPUs
can process the interrupts. I expect this "HW Interrupt redirection" is
what the PCI committee expected to be used...however HP (and perhaps others)
have HW which didn't implement "XTP" register (IIRC, that's the register
required to redirect interrupts by the Local-APIC) since one gets
better performance by "targeting" interrupts at specific CPUs.

hth,
grant
