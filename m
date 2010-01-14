Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825Ab0ANCHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab0ANCHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 21:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192Ab0ANCHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 21:07:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:33285 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab0ANCHi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 21:07:38 -0500
Subject: Re: xilinx-pci driver and pci in general
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: michal.simek@petalogix.com
Cc: Grant Likely <grant.likely@secretlab.ca>, linuxppc-dev@ozlabs.org,
       thunderbird2k@gmx.net, John Williams <john.williams@petalogix.com>,
       Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B4DE58D.10008@petalogix.com>
References: <4B4DE58D.10008@petalogix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 14 Jan 2010 13:07:16 +1100
Message-ID: <1263434836.724.317.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-13 at 16:23 +0100, Michal Simek wrote:

> The main problems are:
> ppc use ppc_md struct which we don't have it on Microblaze.
> xilinx-pci driver uses exclude_device function. This function is used in 
> indirect_pci.c too. There could be a way to move that function directly 
> to pci_controller structure which could be useful for other controllers 
> too. What do you think?
> 
> Then there are some other ppc_md. calling like pcibios_after_init which
> if I see correctly not used for ppc too.

We may not be using after_init() anymore in which case you are welcome
to send a patch to remove it :-)

As for the others, well ... maybe you can do wrappers for these that
call into ppc_md. on powerpc and into some kind of arch_pci_ops. that
the platform provides on microblaze ?

I'm not sure moving them into the pci_controller is the best way to go
there.

> The next thing is that some files contains asm/machdep.h which could be 
> added to asm/pci-bridge.h and the same is for asm/ppc-pci.h

Yeah, moving includes like that is ok.

> Files contains CONFIG_PPC_OF and we would like to use only CONFIG_OF.
> I remember any discuss around but not sure what was the conclusion on 
> powerpc.

I think that should be allright, Grant, any objection there ?

> Part of headers are the same that's why there will be a space to move 
> them to asm-generic.

If you can convince other archs that it makes sense to do so ? :-)

> Anyway: I look at your dma-mapping.h and you can use 
> asm-generic/dma-mapping-common.h as I am using.

Not just quite yet, there's still some stuff we need to cleanup with
the !coherent cases.

> Then I have some question about EARLY_PCI_OP in ppc_32.c. Is there any 
> reason to use early_##rw##_config_##size fucntions instead of proper 
> pci_bus_##rw##_config_##size functions?
> There is one comment that these functions are used before PCI scanning 
> is done but there are used the same function as are in driver/pci/access.c.
> Is there any "secret" reason to do it in this way?

Well, first of all, those aren't ppc32 only anymore, they are in
pci-common.c now. Then, if you look at them you'll notice that
they are just a wrapper on top of pci_bus_* which uses a fake
pci_bus structure. IE. They are meant to be used in very early
arch fixup code at a time when we may not even have the struct
pci_bus at hand. Their use is pretty rare though, maybe we -could-
get rid of them at some stage by moving some of that fixup code.

> Thanks for this early discuss. I would like to hear your opinion and 
> then I will choose solution how to add our pci support to mainline.

Cheers,
Ben.



