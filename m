Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbZD1FBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbZD1FBM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 01:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752432AbZD1FA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 01:00:57 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:42130 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072AbZD1FA4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 01:00:56 -0400
Date: Tue, 28 Apr 2009 14:10:28 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: John Williams <john.williams@petalogix.com>
Cc: linuxppc-dev@ozlabs.org, Linux Kernel list <linux-kernel@vger.kernel.org>,
       Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
       John Linn <John.Linn@xilinx.com>, microblaze-uclinux@itee.uq.edu.au,
       Michal Simek <michal.simek@petalogix.com>,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: microblaze: Statically linking device tree blobs into the
	kernel
Message-ID: <20090428041028.GB11265@yookeroo.seuss>
Mail-Followup-To: John Williams <john.williams@petalogix.com>,
	linuxppc-dev@ozlabs.org,
	Linux Kernel list <linux-kernel@vger.kernel.org>,
	Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>,
	John Linn <John.Linn@xilinx.com>, microblaze-uclinux@itee.uq.edu.au,
	Michal Simek <michal.simek@petalogix.com>,
	Grant Likely <grant.likely@secretlab.ca>
References: <1d3f23370904262124l444bc30dmf4178930f4a2b82f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d3f23370904262124l444bc30dmf4178930f4a2b82f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 02:24:42PM +1000, John Williams wrote:
> To MicroBlazers and other interested parties:
> 
> Currently the MicroBlaze kernel boot-time ABI requires r7 to point to
> a valid DTB, whereupon in early kernel setup the DTB is copied to a
> statically allocated 16k memory region inside the kernel. From there
> it is later queried by the platform startup code.
> 
> For simple boot scenarios the ability to statically bind a DTB into
> the kernel image would clearly be useful.  In PPC land, this is
> achieved through the simpleboot bootloader that lives in
> arch/powerpc/boot.  The DTB becomes part of the simpleboot payload,
> and is passed to the kernel through the normal means.
> 
> I'm not convinced duplicating this for MicroBlaze is a good idea, I
> think it would be overkill.  However, the make syntax that PPC uses to
> achieve DTB binding is quite nice:
> 
> $ make simpleImage.<board>
> 
> which binds arch/powerpc/boot/dts/<board>.dts into the boot payload.
> 
> My feeling is that we should make use of the fact that the DTB region
> is statically allocated in the MicroBlaze kernel anyway.  From
> arch/microblaze/kernel/vmlinux.lds.S:
> 
>         . = ALIGN (4) ;
>        _fdt_start = . ; /* place for fdt blob */
>        . = . + 0x4000;
>        _fdt_end = . ;
> 
> and in head.S, the DTB at r7 is copied into place at _fdt_start
> 
> /* save fdt to kernel location */
> /* r7 stores pointer to fdt blob */
>         beqi    r7, no_fdt_arg
>         or      r11, r0, r0 /* incremment */
>         ori     r4, r0, TOPHYS(_fdt_start) /* save bram context */
>         ori     r3, r0, (0x4000 - 4)
> _copy_fdt:
>        <simple copy loop>
> no_fdt_arg:
> 
> Since this memory is already allocated in the kernel image but is
> normally just zeros, to bind a DTB to the kernel we could just store
> it in-situ.  This way, if a non-zero r7 is passed in at boot time,
> head.S will naturally overwrite (and thus override) the "default" DTB
> that was inside the kernel image.
> 
> What I'm not so sure about is how best to achieve this in the kbuild
> sequence.  I see two options:
> 
>  (a) use .incbin in a .S file, similar to how the initramfs gets
> linked in in /usr/Makefile etc, or

Or you could build the .dts directly into a .S file (which dtc
supports) and #include or link that in.  It's possible the dtc asm
output mode would need some work, but that's easily enough done.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
