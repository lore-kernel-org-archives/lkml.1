Return-Path: <linux-kernel-owner+w=401wt.eu-S1753219AbZJKWvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219AbZJKWvx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 18:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbZJKWvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 18:51:50 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:50819 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbZJKWvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 18:51:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19154.24916.895215.289514@pilspetsen.it.uu.se>
Date: Mon, 12 Oct 2009 00:51:00 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Nick Piggin <npiggin@suse.de>, hpa@zytor.com, greg@kroah.com,
       Mikael Pettersson <mikpe@it.uu.se>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Patch "USB: Work around BIOS bugs by quiescing USB controllers
 earlier" causes MCEs
In-Reply-To: <1254804819.14541.101.camel@macbook.infradead.org>
References: <20091002073400.GV6327@wotan.suse.de>
	<19141.54587.207559.849751@pilspetsen.it.uu.se>
	<19142.21600.475756.10647@pilspetsen.it.uu.se>
	<20091006044401.GA30316@wotan.suse.de>
	<1254804819.14541.101.camel@macbook.infradead.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse writes:
 > On Tue, 2009-10-06 at 06:44 +0200, Nick Piggin wrote:
 > > > Changing this quirk back to a FIXUP_FINAL allows the platform's PCI
 > > > init to complete. Later on the generic pci_init() calls the quirk,
 > > > which now gets the correct I/O base address, and the outw()s in
 > > > uhci_reset_hc() don't fail.
 > > 
 > > Thanks for this, I guess we await David's response.
 > 
 > The problem is that FIXUP_FINAL is too late. If the USB controllers are
 > still active at the time the IOMMU is initialised, then DMA for their
 > 'legacy keyboard/mouse emulation' will go AWOL -- because the BIOS
 > authors are too incompetent to tell the OS about it correctly.
 > 
 > And then the whole system goes down, locked up in SMM mode because the
 > BIOS authors are too incompetent to write code which can _cope_ with the
 > DMA going AWOL. Or do any testing.
 > 
 > One option is to add a new quirk somewhere in the middle, or to invoke
 > the USB fixups manually rather than by the quirk mechanism.
 > 
 > Another might be to move the initialisation of the IOMMU to later in the
 > boot, so it happens just after the final PCI fixups.
 > 
 > But I distinctly remember a conversation, probably with hpa, in which he
 > (or whoever) said that he wants to kill the USB controllers even
 > _earlier_ in the boot process, because of other problems. So I was kind
 > of hoping that whoever it was would pipe up. And then we'd take that
 > option.

I've done a more detailed analysis of this patch now.

On my arm/iop/n2100 box which crashes when quirk_usb_early_handoff()
is a FIXUP_HEADER, the concrete reason is that a bogus base address is
returned by pci_resource_start() and passed on to outw() which oopses.
When the quirk is a FIXUP_FINAL the base address is correct and outw() works.

So I hacked the kernel to trace all reads and writes to any resource's
".start" field to see how the base address correction was done.

On the n2100 with the quirk as a FIXUP_FINAL, this happens on the 1st UHCI device:
1. drivers/pci/probe.c:__pci_read_base() sets start to 0xfce0 based primarily
   on pci_read_config_word()
2. arch/arm/kernel/bios32.c:pdev_fixup_device_resources() runs but leaves it alone
3. kernel/resource.c:allocate_resource() inserts the resource which immediately
   resets it from the root resource (0x90000000), and after taking care of
   alignment and sibling resources it becomes 0x90000800 and never changes again.
4. quirk_usb_handoff_uhci() sees base 0x90000800 and the outw() works.

The 2nd UHCI device goes through the exact same steps, start is initially
0xfce0 but gets changed to 0x90000820 before quirk_usb_handoff_uhci().

When the quirk is a FIXUP_HEADER, this happens:
1. drivers/pci/probe.c:__pci_read_base() sets start to 0xfce0.
2. quirk_usb_handoff_uhci() sees pio_enabled() [from pci_read_config_word()],
   gets base = 0xfce0, passes that to outw(), which dies.

On a different arm box (arm/mach-ixp4xx/) which this patch doesn't kill,
the same bogus start address 0xfce0 is detected by __pci_read_base().
But on that box !pio_enabled() is true so quirk_usb_handoff_uhci() bails
and doesn't try to do any I/O accesses. Later on this UHCI's base is
changed to 0x1000 by allocate_resource().

Finally I tested on an old PentiumIII PC. On that one __pci_read_base()
assigned 0xb400 as the start address, that address never changes afterwards,
and the quirk runs without oopsing regardless of whether it's HEADER or FINAL.

So the basic problem with the patch is that it moves PCI resource using code
to before PCI resources have been fixed up, and that may work on x86 PCs but
doesn't work in general.
