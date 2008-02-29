Return-Path: <linux-kernel-owner+w=401wt.eu-S1756850AbYB2TNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850AbYB2TNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 14:13:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751236AbYB2TNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 14:13:05 -0500
Received: from host36-195-149-62.serverdedicati.aruba.it ([62.149.195.36]:44536
	"EHLO mx.cpushare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbYB2TMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 14:12:54 -0500
Date: Fri, 29 Feb 2008 20:12:48 +0100
From: Andrea Arcangeli <andrea@qumranet.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Nick Piggin <npiggin@suse.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] reserve RAM below PHYSICAL_START
Message-ID: <20080229191248.GA8091@v2.random>
References: <20080227003325.GS28483@v2.random> <20080228183604.GA19901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228183604.GA19901@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Thu, Feb 28, 2008 at 01:36:04PM -0500, Vivek Goyal wrote:
> I don't know much about pci passthrough thing, but in a nutshell it
> looks like you just want a way to reserve memory in host which is not
> used by host and then also reserve a virtual range in host where you
> can create another set of mapping for that reserved memory?

I described the potential usage in the email to hpa (I'm currently
implementing the kvm-userland bits that with a -reserved-ram parameter
will force qemu to open /dev/iomem and map direct ram from /dev/mem in
the linux ptes, and add a special memslot to kvm so that it uses the
pfn number directly if the !pfn_valid or get_page(pfn_to_page) to
refcount the dummy reserved pages in case the mem_map exist for that
pfn, this same logic can also be used to direct map the pci busaddress).

> Can't you just provide a command line parameter to reserve a section
> of memory, the way crashkernel=X@Y parameter does?

My requirement to specify at compile time the ram that the
qemu-system-x86_64 -reserved-ram guest will take, already sounds
complicated enough without having to skip the 640k region and all the
reserved pages like trampoline that are only known at compile time
anyway (so one couldn't use a memmap=x@y without checking all the
kernel source first to see if anybody changed the early_reserved
array...). To be safe I would need to check kernel source and host
e820 map by hand first for every different system out there!

> What prevents you from doing this for RELOCATABLE kernels?

I already tried that before falling back to the compile-time
solution. That requires duplicating all the memparse/strlout C code in
arch/x86/kernel and to recompile it 32bit so the 32bit part of
head_64.S can call it. Keep in mind this is a solution that is
required because VT-d wasn't shipped in all hardware out there, so I
didn't want to do an overwork and an hugly big patch that duplicates
code around just so I can pass reserved-ram=512M on the boot command
line, instead of specifying it at compile time.

Furthermore it won't just be the issue of parsing the command line
params in 32bit mode from head_64.S but all other code like the setup
of the initial pagetables, and vmalloc start, would also require
changes to become dynamic (the latter would slowdown vmalloc a bit too
at runtime).

> [..]
> >  #ifndef __ASSEMBLY__
> >  struct e820entry {
> > diff --git a/include/asm-x86/page_64.h b/include/asm-x86/page_64.h
> > --- a/include/asm-x86/page_64.h
> > +++ b/include/asm-x86/page_64.h
> > @@ -29,6 +29,7 @@
> >  #define __PAGE_OFFSET           _AC(0xffff810000000000, UL)
> >  
> >  #define __PHYSICAL_START	CONFIG_PHYSICAL_START
> > +#define __PHYSICAL_OFFSET	(__PHYSICAL_START-0x200000)
> >  #define __KERNEL_ALIGN		0x200000
> >  
> >  /*
> > @@ -47,7 +48,7 @@
> >  #define __PHYSICAL_MASK_SHIFT	46
> >  #define __VIRTUAL_MASK_SHIFT	48
> >  
> > -#define KERNEL_TEXT_SIZE  (40*1024*1024)
> > +#define KERNEL_TEXT_SIZE  (40*1024*1024+__PHYSICAL_OFFSET)
> 
> Why are you changing this? What is __PHYSICAL_OFFSET? Are you expanding

The __PHYSICAL_OFFSET part is just a bugfix and I can split it and
submit it separately if this patch isnt' merged. If you compile the
kernel with kdump at a phsical offset that is just a bit higher than
40M it will simply crash and fail to boot.

> the kernel text/data region so that you can additionally map this
> reserved area? 
> If yes, I think probably we should have a separate area altoghether to
> map this reserved area than expanding existing kernel text/data region.

I'm not expanding anything, I'm just relocating the kernel a bit above
40M, I guess kdump is happy enough with lower addresses or it could
never work. So this is just a mainline bugfix so the relocation
address can be higher than 40M without crashing at boot. There is zero
overhead even if you use the feature, and it's a noop for default config.
