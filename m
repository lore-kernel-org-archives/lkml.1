Return-Path: <linux-kernel-owner+w=401wt.eu-S933169AbXA2GHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933169AbXA2GHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 01:07:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933171AbXA2GHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 01:07:04 -0500
Received: from gate.crashing.org ([63.228.1.57]:35750 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933169AbXA2GHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 01:07:02 -0500
Subject: Re: [PATCH 0/6] MSI portability cleanups
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, jeff@garzik.org, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <20070128.212554.23015561.davem@davemloft.net>
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	 <20070128.153707.30184351.davem@davemloft.net>
	 <m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
	 <20070128.212554.23015561.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 29 Jan 2007 17:05:37 +1100
Message-Id: <1170050737.26655.233.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-01-28 at 21:25 -0800, David Miller wrote:
> From: ebiederm@xmission.com (Eric W. Biederman)
> Date: Sun, 28 Jan 2007 22:18:59 -0700
> 
> > Regardless of my opinion on the sanity of the hypervisor architects.
> > I have not seen anything that indicates it will be hard to support
> > the hypervisor doing everything or most of everything for us, so
> > I see no valid technical objection to it.  Nor have I ever.
> > 
> > So I have no problem with additional patches in that direction.
> 
> Ok, that's great to hear.
> 
> I know your bi-directional approach isn't exactly what Ben
> wants but he can support his machines with it.  Maybe after
> some time we can agree to move from that more towards the
> totally abstracted scheme.

It can support my machines without HV with trivial changes I reckon: I
need an ops struct to indirect eric's 2 remaining arch hooks
(setup/teardown) but that can be done inline within asm-powerpc. I need
to double check of course and probably actually port the MPIC backend
and possibly go write the Cell Axon one while at it to verify everything
is allright, but the base design seems sound enough.

For the ones with HV (RTAS stuff), we still need to agree on how to
approach it. We can either:

Option 1
--------

Do a hook -above- Eric stuff, by having the toplevel APIs themselves be
arch hooks that can either go toward the RTAS implementation or toward
Eric's code. That is, eric code would define those (pick better names if
you are good at it):

	pci_generic_enable_msi
	pci_generic_disable_msi
	pci_generic_enable_msix
	pci_generic_disable_msix
	pci_generic_save_msi_state
	pci_generic_restore_msi_state

Then we can have asm-i386/msi.h & friends do something like

#define pci_enable_msi	pci_generic_enable_msi
#define pci_disable_msi	pci_generic_disable_msi
   etc...

And we can have asm-powerpc/msi.h hook then via ppc_md:

static inline int pci_enable_msi(xxx...)
{
	return ppc_md.pci_enable_msi(xxx...);
}
etc...

(ppc_md is our per-platform global hook structure filled at boot when we
discover on what machine type we are running on) so that pSeries can use
it's own RTAS callbacks, and others can just re-hook those to Eric's
code.


Option 2
--------

That is to make Eric's code itself cope with the HV case. I'm a bit at
loss right now as how precisely to do it. I need to spend more time
staring at the code after Eric latest patches rather than the patches
themselves I suppose :-) (Eric, they don't apply out of the box on
current git, they are against -mm ?).

Some of the main issues here, more/less following the order in which
Eric code calls things:

 - The number of vectors for MSI-X is obtained from config space (at
least for sanity checking the requested argument). On RTAS, it should
come from an OF property (we are really not supposed to go read the
config space even if we can). I -suppose- we can survive for now with
just reading it, but we might well run into trouble with some "special"
devices shared accross partitions or if the IBM magic bridges themselves
ever start sending MSI-X on their own (unlikely but who knows...).
Michael's code handled that by having a callback ->check() do the sanity
checking of the nvec, and then just use the nvec passed in as an
argument once it's sane.

So for that I would propose adding an arch_check_msi(pdev, type, nvec)
or something like that. Note the biggest issue at this point anyway.

 - The real big one: For MSI-X, Eric's code tries to "hide" the fact
that those are MSI-X by allocating the msi-x entry array, then iterating
through them calling arch_setup_msi_irq() for each of them.

For that to work for us, it would need to be different, possibly
pre-allocating the array, and having -one- call taking an array and a
nvec. That's one of the reasons why I liked Michael's approach as
instead of making MSI-X look like MSI, it made MSI look like MSI-X by
passing a 1 entry array in the MSI case. Both approaches can probably be
made to handle multiple MSIs if we ever want to handle them.

The same issue is present for teardown of course.

 - We need HV hooks for suspend/resume at one point. Nothing urgent
there as our HV machines don't do suspend/resume just yet :-) But if we
ever implement something like suspend-to-disk, they'll definitely need
something as we are likely to get different vectors back from the
firmware so we need to re-map them to the same linux IRQ numbers.

I need to have a second look at Eric's code after I manage to find the
right combination of kernel for his patches to apply to check if I
missed anything important.

Cheers,
Ben.


