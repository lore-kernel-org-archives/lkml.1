Return-Path: <linux-kernel-owner+w=401wt.eu-S1762950AbXE1REt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762950AbXE1REt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757367AbXE1REl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:04:41 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4939 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757323AbXE1REk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:04:40 -0400
Date: Mon, 28 May 2007 18:04:30 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: ARM: Section mismatch warnings
Message-ID: <20070528170430.GB5737@flint.arm.linux.org.uk>
Mail-Followup-To: Sam Ravnborg <sam@ravnborg.org>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	LKML <linux-kernel@vger.kernel.org>
References: <20070528163253.GA29174@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070528163253.GA29174@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2007 at 06:32:53PM +0200, Sam Ravnborg wrote:
> # These are all almost trivial if one knows the device-model. I did not
> know enough about the devicemodel to fix them.
> # I suspect several symbols should NOT be marked __init since they are
> used in .add assignments and the like
> # or mayby __Devinit since they are used only in HOTPLUG scenarios.

> o-arm-ks8695/log.out:WARNING: arch/arm/mach-ks8695/built-in.o(.data+0x108):
 Section mismatch: reference to .init.text:micrel_pci_map_irq
 (after 'micrel_pci')

If this platform can have PCI stuff hotplugged, then this is a problem.
If it's fixed then it isn't - PCI IRQ routing will only be used at boot
time.  IOW, whether such a thing is a problem is conditional on the
hardware/configuration which I'm not aware of.

Something for Andrew Victor to comment on.

> o-arm-lubbock/log.out:WARNING: drivers/built-in.o(.text+0x39f2c):
 Section mismatch: reference to .init.text:pcmcia_lubbock_init
 (between 'pcmcia_probe' and 'sa1111_pcmcia_socket_suspend')
> o-arm-neponset/log.out:WARNING: drivers/built-in.o(.text+0x4e0a8):
 Section mismatch: reference to .init.text:pcmcia_neponset_init
 (between 'pcmcia_probe' and 'sa1111_pcmcia_socket_suspend')

Don't care about the PCMCIA crappy SA11x0 or PXA drivers anymore since
they never got converted to a reasonable device model.  As long as they
work functionally (which they do.)  Fixing it without breaking stuff is
too big a job for one person, so I'll just ignore this one.

> o-arm-neponset/log.out:WARNING: arch/arm/mach-sa1100/built-in.o(.text+0x1748):
 Section mismatch: reference to .init.text:sa1110_mb_disable
 (between 'neponset_init' and 'neponset_resume')

This one looks quite bogus.  sa1110_mb_disable() is marked __init, and
it's called from neponset_init() which is also marked __init.

> o-arm-neponset/log.out:WARNING: arch/arm/mach-sa1100/built-in.o(.text+0x17ac):
 Section mismatch: reference to .init.data:devices
 (between 'neponset_init' and 'neponset_resume')

No reference to 'devices' (marked __initdata) in neponset_resume but there
is in neponset_init(), which is the only reference to it, and it is marked
__init.  Another false positive?

> o-arm-s3c2410/log.out:WARNING: arch/arm/mach-s3c2410/built-in.o(.text+0x80):
 Section mismatch: reference to .init.data:s3c2410_dma_order
 (between 's3c2410_dma_add' and 's3c2410_pm_add')

Don't know enough about s3c stuff, but this one looks like a false positive
as well - it's registering a sysdev driver at boot time, and the class
and sysdev is only ever also registered at boot time and never unregistered.
Adding __init to s3c2410_dma_add would probably be the right thing to do
but will move the problem to be a reference to s3c2410_dma_add from
s3c2410_dma_driver instead.

Once that's done, might need an annotation of some sort?  Not sure.

> # Assembler stuff. It looked to me like __INIT was used wrongly but then
> I did not feel confident enough to patch it up - and I cannot test it.
> o-arm-realview-smp/log.out:WARNING: arch/arm/vfp/built-in.o(.data+0x0):
 Section mismatch: reference to .init.text:vfp_testing_entry
 (between 'vfp_vector' and 'vfp_notifier_block')

This one is probably a real oops waiting to happen - if VFP hardware
isn't found and userspace tries to issue a VFP instruction, it could
oops the kernel.  Will fix (though the fix is rather more in-depth
than just removing __INIT.)

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
