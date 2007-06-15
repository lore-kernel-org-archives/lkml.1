Return-Path: <linux-kernel-owner+w=401wt.eu-S1755727AbXFOOta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727AbXFOOta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 10:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbXFOOtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 10:49:03 -0400
Received: from gw.goop.org ([64.81.55.164]:34331 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbXFOOtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 10:49:00 -0400
Message-Id: <20070615004818.424726597@goop.org>
User-Agent: quilt/0.46-1
Date: Thu, 14 Jun 2007 17:48:18 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Andi Kleen <ak@suse.de>,
       v12n <virtualization@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Xen-Devel <xen-devel@lists.xensource.com>
Subject: [PATCH 00/10] paravirt/subarchitecture boot protocol
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This series updates the boot protocol to 2.07 and uses it to implement
paravirtual booting.  This allows the bootloader to tell the kernel
what kind of hardware/pseudo-hardware environment it's coming up under,
and the kernel can use the appropriate boot sequence code.

Specifically:

- Update the boot protocol to 2.07, which adds fields to specify the
  hardware subarchitecture and some subarchitecture-specific data.
  It also specifies a flag to tell the boot code to avoid reloading
  segment registers and playing with interrupt state, since it may not
  have a visible gdt and/or may not be running in ring 0.
  (Note: the segment reload and interrupt flags are conflated into one
   flag, but they are not really related.  We could have two flags, but
   the "cli" is probably completely redundant anyway, since the bootloader
   would have to be completely mad to start the kernel with interrupts
   enabled.)

- Change the format of bzImage to contain an ELF file.  The initial part of
  the bzImage is still the boot_params header followed by the 16-bit
  setup code needed for booting from BIOS.  But rather than having
  the self-decompressing kernel follow as a naked blob of code+data,
  its actually wrapped in a page-aligned ELF file.  This allows the
  bootloader to extract it and parse it, and use that to know what
  memory the booting kernel will need initially.  Xen and lguest need
  this because they start the kernel with paging enabled, and so need
  to know what initial mappings to create.

- Modify the kernel boot sequence to:
  1. avoid reloading the segment state (gdt and segment registers) if the
     bootloader asks it to
  2. jump to a subarchitecture-specific entrypoint in kernel/head.S.

- Add Xen-specific starup code, which mainly remaps the kernel from
  its P=V identity mapping to the normal PAGE_OFFSET mapping.

  One open issue is that I haven't made the normal head.S initial
  pagetable construction code generally reusable.  The default
  boot-on-normal x86 hardware still uses it of course, but other
  subarchitectures like Voyager and lguest could probably use it as-is,
  while still needing to do other specialized things.

  The obvious fix is to make it a callable function, but we don't
  generally assume there's a stack available at this early stage.
  It looks like it would be easy to set one up though.

As a pre-requisite for all the above, I've also cleaned up the process
to generate the bzImage.  I've eliminated the need for the tools/build
program, and instead use the linker to do more heavy lifting.  I've also
removed some somewhat obscure uses of ld and objcopy wrap binary files
in ELF .o wrappers, and replaced with with .S files containing .incbin.

The downside is that its making a bit more complex use of linker scripts,
which always opens scope for finding more binutils bugs.  Only one way
to find out...

Tested to check the generated kernels boot under qemu's internal bootload
and grub, as well as booting under Xen (with an appropriate update to
the Xen domain builder).

TODO:
 - poke Rusty into implementing the lguest bits
 - clean up all the ELF headers to make them easier to reuse in the
   boot-code compile environment, in order to
 - remove all the .S files specifying ELF structures, and use .c instead
   (which would be a general cleanup; I don't think we need to specify
    ELF notes in .S files at all.)

	J
-- 

