Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbYGGQju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbYGGQju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbYGGQjh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:39:37 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49134 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbYGGQjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:39:36 -0400
Date: Mon, 7 Jul 2008 10:39:19 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pci@vger.kernel.org,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       David Miller <davem@davemloft.net>,
       Dan Williams <dan.j.williams@intel.com>, Martine.Silbermann@hp.com,
       linux-kernel@vger.kernel.org, Michael Ellerman <michaele@au1.ibm.com>
Subject: Re: Multiple MSI
Message-ID: <20080707163919.GC14894@parisc-linux.org>
References: <20080703024445.GA14894@parisc-linux.org> <1215055469.21182.70.camel@pasglop> <20080707161703.GB7521@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080707161703.GB7521@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 10:17:03AM -0600, Grant Grundler wrote:
> > > I don't quite understand how IRQ affinity will work yet.  Is it feasible
> > > to redirect one interrupt from a block to a different CPU?  I don't even
> > > understand this on x86-64, let alone the other four architectures.  I'm
> > > OK with forcing all MSIs in the same block to move with the one that was
> > > assigned a new affinity if that's the way it has to be done.
> > 
> > It's very implementation specific. IE. On most powerpc implementations,
> > MSI just route via a decoder to sources of the existing interrupt
> > controller so we can control per-source affinity at that level.
> > Some x86 seem to require different base addresses which makes it mostly
> > impossible to spread them I believe (maybe that's why people came up
> > with MSI-X ?)
> 
> Correct. MSI only has one address for multiple vectors and thus will
> only target one CPU. MSI-X has address/vector pairs (1:1).
> 
> If the Local-APICs are able to redirect interrupts, then multiple CPUs
> can process the interrupts.

That's not the only way it can work.  If you have an APIC per root bus,
you can target that with the write.  The APIC could then map the
interrupt request to the appropriate CPU.  In this scenario, programming
affinity would be twiddling some bits in the APIC and not need to write
to the device's MSI register at all.

What I've implemented for x86-64 can target any mask of CPUs that are
in the same interrupt domain.  My machine only has one interrupt domain,
so I can target the MSI to any subset of the CPUs.  They all move
together, so you can't target a different subset of CPUs for different
MSIs on the same device.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
