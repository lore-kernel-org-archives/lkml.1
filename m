Return-Path: <linux-kernel-owner+w=401wt.eu-S933280AbXA2JEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280AbXA2JEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 04:04:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933283AbXA2JEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 04:04:50 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49738 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933280AbXA2JEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 04:04:48 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, greg@kroah.com,
       tony.luck@intel.com, grundler@parisc-linux.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, kyle@parisc-linux.org,
       linuxppc-dev@ozlabs.org, brice@myri.com, shaohua.li@intel.com,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH 0/6] MSI portability cleanups
References: <m1hcuaohqj.fsf@ebiederm.dsl.xmission.com>
	<20070128.153707.30184351.davem@davemloft.net>
	<m1tzyammv0.fsf@ebiederm.dsl.xmission.com>
	<20070128.212554.23015561.davem@davemloft.net>
	<1170050737.26655.233.camel@localhost.localdomain>
Date: Mon, 29 Jan 2007 02:03:21 -0700
In-Reply-To: <1170050737.26655.233.camel@localhost.localdomain> (Benjamin
	Herrenschmidt's message of "Mon, 29 Jan 2007 17:05:37 +1100")
Message-ID: <m1sldukxwm.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:

> On Sun, 2007-01-28 at 21:25 -0800, David Miller wrote:
>> From: ebiederm@xmission.com (Eric W. Biederman)
>> Date: Sun, 28 Jan 2007 22:18:59 -0700
>> 
>> > Regardless of my opinion on the sanity of the hypervisor architects.
>> > I have not seen anything that indicates it will be hard to support
>> > the hypervisor doing everything or most of everything for us, so
>> > I see no valid technical objection to it.  Nor have I ever.
>> > 
>> > So I have no problem with additional patches in that direction.
>> 
>> Ok, that's great to hear.
>> 
>> I know your bi-directional approach isn't exactly what Ben
>> wants but he can support his machines with it.  Maybe after
>> some time we can agree to move from that more towards the
>> totally abstracted scheme.
>
> It can support my machines without HV with trivial changes I reckon: I
> need an ops struct to indirect eric's 2 remaining arch hooks
> (setup/teardown) but that can be done inline within asm-powerpc. I need
> to double check of course and probably actually port the MPIC backend
> and possibly go write the Cell Axon one while at it to verify everything
> is allright, but the base design seems sound enough.
>
> For the ones with HV (RTAS stuff), we still need to agree on how to
> approach it. We can either:
>
> Option 1
> --------
>
> Do a hook -above- Eric stuff, by having the toplevel APIs themselves be
> arch hooks that can either go toward the RTAS implementation or toward
> Eric's code. That is, eric code would define those (pick better names if
> you are good at it):
>
> 	pci_generic_enable_msi
> 	pci_generic_disable_msi
> 	pci_generic_enable_msix
> 	pci_generic_disable_msix
> 	pci_generic_save_msi_state
> 	pci_generic_restore_msi_state
>
> Then we can have asm-i386/msi.h & friends do something like
>
> #define pci_enable_msi	pci_generic_enable_msi
> #define pci_disable_msi	pci_generic_disable_msi
>    etc...
>
> And we can have asm-powerpc/msi.h hook then via ppc_md:
>
> static inline int pci_enable_msi(xxx...)
> {
> 	return ppc_md.pci_enable_msi(xxx...);
> }
> etc...
>
> (ppc_md is our per-platform global hook structure filled at boot when we
> discover on what machine type we are running on) so that pSeries can use
> it's own RTAS callbacks, and others can just re-hook those to Eric's
> code.

This is the most straight forward and handles machines with really
weird msi setups, so I lean in this direction.

The question is there anything at all we can do generically?

I can't see a case where ppc_md would not wind up with the hooks
that decide if it is a hypervisor or not.  Even if we came up
with a better set of functions you need to hook.

> Option 2
> --------
>
> That is to make Eric's code itself cope with the HV case. I'm a bit at
> loss right now as how precisely to do it. I need to spend more time
> staring at the code after Eric latest patches rather than the patches
> themselves I suppose :-) (Eric, they don't apply out of the box on
> current git, they are against -mm ?).
>
> Some of the main issues here, more/less following the order in which
> Eric code calls things:
>
>  - The number of vectors for MSI-X is obtained from config space (at
> least for sanity checking the requested argument). On RTAS, it should
> come from an OF property (we are really not supposed to go read the
> config space even if we can). I -suppose- we can survive for now with
> just reading it, but we might well run into trouble with some "special"
> devices shared accross partitions or if the IBM magic bridges themselves
> ever start sending MSI-X on their own (unlikely but who knows...).
> Michael's code handled that by having a callback ->check() do the sanity
> checking of the nvec, and then just use the nvec passed in as an
> argument once it's sane.

Ok. I think I get the point of check.  I believe I need to look at your
code a little more and see what you are doing to see if there is anything
generic worth doing, that we can always do outside of architecture code
no matter how much of the job the Hypervisor wants to do for us.

I'd hate to hit a different Hypervisor that did something close but
not quite the same and have the code fail then.  So definitely
avoiding touching pci config space at all in the calls seems to make a
lot of sense.  This includes avoiding pci_find_capability right?

Off the top of my head the only things we can do generically are
some data structure things and flags like dev->msi_enabled or
dev->msix_enabled.

Anyway have a nice night and more in the morning.


Eric
