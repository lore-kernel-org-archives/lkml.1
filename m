Return-Path: <linux-kernel-owner+w=401wt.eu-S1752065AbZD0EYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbZD0EYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 00:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbZD0EYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 00:24:43 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:35309 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZD0EYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 00:24:43 -0400
MIME-Version: 1.0
Date: Mon, 27 Apr 2009 14:24:42 +1000
Message-ID: <1d3f23370904262124l444bc30dmf4178930f4a2b82f@mail.gmail.com>
Subject: microblaze: Statically linking device tree blobs into the kernel
From: John Williams <john.williams@petalogix.com>
To: linuxppc-dev@ozlabs.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>, microblaze-uclinux@itee.uq.edu.au,
       Michal Simek <michal.simek@petalogix.com>,
       Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To MicroBlazers and other interested parties:

Currently the MicroBlaze kernel boot-time ABI requires r7 to point to
a valid DTB, whereupon in early kernel setup the DTB is copied to a
statically allocated 16k memory region inside the kernel. From there
it is later queried by the platform startup code.

For simple boot scenarios the ability to statically bind a DTB into
the kernel image would clearly be useful.  In PPC land, this is
achieved through the simpleboot bootloader that lives in
arch/powerpc/boot.  The DTB becomes part of the simpleboot payload,
and is passed to the kernel through the normal means.

I'm not convinced duplicating this for MicroBlaze is a good idea, I
think it would be overkill.  However, the make syntax that PPC uses to
achieve DTB binding is quite nice:

$ make simpleImage.<board>

which binds arch/powerpc/boot/dts/<board>.dts into the boot payload.

My feeling is that we should make use of the fact that the DTB region
is statically allocated in the MicroBlaze kernel anyway.  From
arch/microblaze/kernel/vmlinux.lds.S:

        . = ALIGN (4) ;
       _fdt_start = . ; /* place for fdt blob */
       . = . + 0x4000;
       _fdt_end = . ;

and in head.S, the DTB at r7 is copied into place at _fdt_start

/* save fdt to kernel location */
/* r7 stores pointer to fdt blob */
        beqi    r7, no_fdt_arg
        or      r11, r0, r0 /* incremment */
        ori     r4, r0, TOPHYS(_fdt_start) /* save bram context */
        ori     r3, r0, (0x4000 - 4)
_copy_fdt:
       <simple copy loop>
no_fdt_arg:

Since this memory is already allocated in the kernel image but is
normally just zeros, to bind a DTB to the kernel we could just store
it in-situ.  This way, if a non-zero r7 is passed in at boot time,
head.S will naturally overwrite (and thus override) the "default" DTB
that was inside the kernel image.

What I'm not so sure about is how best to achieve this in the kbuild
sequence.  I see two options:

 (a) use .incbin in a .S file, similar to how the initramfs gets
linked in in /usr/Makefile etc, or
 (b) use objcopy to manipulate vmlinux after final link, by directly
inserting the DTB into the appropriate ELF section.

(a) seems nice because it means that our standard make targets, such
as linux.bin etc, would still work unchanged.  (b) seems to go a bit
against the grain of kbuild, but maybe I'm wrong there.

I've hacked around with (a) a bit, part of the problem is that it
seems arch/microblaze/Makefile would need something like

core-y += arch/microblaze/boot

because the DTB "object file" must be ready before final vmlinux link.

Instead of how it's done now (and in PPC), which is:

$(BOOT_TARGETS): vmlinux
        $(Q)$(MAKE) ARCH=ppc64 $(build)=$(boot) $(patsubst %,$(boot)/%,$@)

where vmlinux is a dependency of the whole simpleImage/DTB binding process.

Anyway input on both the approach, and how to achieve it, would be
greatly appreciated before we go working to deeply on the
implementation.

Thanks,

John
-- 
John Williams,
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
