Return-Path: <linux-kernel-owner+w=401wt.eu-S1759196AbZEFMkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196AbZEFMkU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 08:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbZEFMkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 08:40:06 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:58836 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZEFMkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 08:40:05 -0400
Date: Wed, 6 May 2009 14:42:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Beulich <jbeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       hpa@zytor.com
Subject: Re: [PATCH] x86-64: fix build with older binutils
Message-ID: <20090506124214.GA26100@uranus.ravnborg.org>
References: <4A0055B3.76EA.0078.0@novell.com> <20090505163930.GA18579@uranus.ravnborg.org> <4A015158.76EA.0078.0@novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A015158.76EA.0078.0@novell.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan.

On Wed, May 06, 2009 at 07:59:04AM +0100, Jan Beulich wrote:
> >>> Sam Ravnborg <sam@ravnborg.org> 05.05.09 18:39 >>>
> >I like the way your patch simplies the linker scrip for x86.
> >We have recently merged the linker scripts for 32 and 64 bit,
> >and I tried to apply your patch on top of the unified version.
> >(Applied manually obviously).
> >
> >With a 64 bit defconfig build I got:
> >/home/sam/x-tools/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-ld: section .vsyscall_0 [00000000016c6000 -> >00000000016c60e7] overlaps section .init.rodata [00000000016c5a00 -> 00000000016c6348]
> >make[1]: *** [.tmp_vmlinux1] Error 1
> >
> >I did not try to build a kernel with your original patch.
> >
> >Can you spot anything obvious wrong in my patch.
> >It is on top of x86/kbuild in -tip.
> 
> Yeah, the placement of .init.start appears to be wrong - it should the
> SMP/x86-64 case of the per-CPU segment, and it should also be the
> one getting the :init attached. Hopefully that won't get us back to the
> binutils problem I was originally encountering - what is the extra .init.start
> section good for anyway?

.init.start is there so __init_begin is not an absolute symbol to support
a relocable kernel.
I named the section .init.stat because we have the

    PERCPU_VADDR(0, :percpu)

stuff inbetween this and .init.text



> And why does __init_end continue to live
> outside of any section (this sort of thing causes problems with
> CONFIG_RELOCATABLE and older binutils afair, as such symbols get
> marked absolute by the latter)?

Talking about this snippet where __init_end is inside
a .init.end output section.

        /* freed after init ends here */
        .init.end : AT(ADDR(.init.end) - LOAD_OFFSET) {
                __init_end = .;
        }

This was copied from 32 bit verbatim.

I would love to stick it inside one of the already defined sections.
But to minimize chrunch when we merged I kept the 32 bit layout.

> Btw., why is .data.nosave being placed differently for 32- and 64-bit?

A merge artifact - again to try to minimize changes - plus the fact that
on 64 we added it to a specific segment whereas we did not do so in 32 bit.

And I'm yet to fully understand the use of segments so I am reluctant
to touch it for now.

If you feel inclined it would be great if you could give the merged
linker script an overhaul. There is obviously stuff to be simplified and
I have limited time to do so atm.

	Sam
