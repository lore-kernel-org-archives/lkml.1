Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbZD2IVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbZD2IVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbZD2IVe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:21:34 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:57145 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZD2IVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:21:32 -0400
Date: Wed, 29 Apr 2009 10:23:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH/RFT 0/13] x86: unify vmlinux.lds
Message-ID: <20090429082341.GA27386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org> <20090429075730.GD22129@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429075730.GD22129@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > o  64 bit uses PHDRS more extensively than 32 bit. Could they be the same?
> 
> Hm, PHDRS content really matters mostly for the vDSO, so that gdb 
> can treat the vsyscall entry page(s) more as a normal DSO.
> 
> for the kernel image itself it does not matter much how standard of 
> an ELF binary it is: the boot loader does not care about the PHDR 
> description of linker segments and we dont execute the binary.
> 
> UML and lguest has its own ELF-binary creation methods.
> 
> I think the only relevancy it has on the kernel image is on readonly 
> symbols: the PHDRS command gives a reasonable default flags value to 
> various segments. We _usually_ give all segments their proper 
> permission explicitly - but it was not unheard of to have mixups 
> there and to see supposedly-readonly sections end up in a rw area or 
> for rw sections to end up in the readonly section.
> 
> The latter will be found quickly because it triggers a kernel crash 
> - the former kind of bug can linger for a long time.
> 
> So i think we should generate proper PHDRS (i.e. use the 64-bit 
> linker script portion to also include percpu and init-data bits), 
> for consistency.
> 
> Do you know what the linker does if the PHDRS and the section flags 
> collide? Does the local flag override the PHDRS flag? I havent 
> checked.

I have not looked much into the linker support of PHDRS.
Which is also why I did not dare touching this stuff.

>From 'info ld':
The linker will normally set the segment flags based on the sections
which comprise the segment.  You may use the `FLAGS' keyword to
explicitly specify the segment flags.

So the PHDRS settings take effect.

> 
> > o  _stext does not cover all text for 32 bit - a bug? For 64b bit it does.
> >    It is only the .code16 wakeup stuff that is not covered but anyway.
> 
> that's a bug that should be fixed. Harmless - but needs some testing 
> - there are tools (profilers, etc.) that might have assumptions 
> about _stext so this needs some test-time.
> 
> Also, _stext is the start address for the readonly section - so by 
> moving it down a bit on 32-bit we extend readonly to that .code16 
> suspend code. If it contains any self-modifying code it will crash.

hpa should know about the latter.
I suggest to give the current patchset some air time before we move _stext.

> 
> > o  _edata covers much more on 32 bit
> 
> 32-bit is corret there. We do use _edata in a couple of places, such 
> as in resource ranges - so there could be side-effects, but any such 
> side effects would likely show some real hidden bug or uncleanliness 
> so it's good to fix that.

OK - again if we could wait a bit with this change it would be good.

> 
> > o  The nosave stuff differs (but that is due to the PHDRS stuff anyway)
> 
> nosavedata is a really ancient construct used almost nowhere. That's 
> a question to Rafael and Linus: can we just get rid of it? The only 
> user seems to be:
> 
>   int in_suspend __nosavedata = 0;

A lot of stuff added just to support a single integer..
If we could get rid of that it would be great.

> 
> > o  Different alignmnet requirements in several spots
> 
> do you have a list of them? There's hpa's fix from yesterday that 
> shows that we have real bugs there.

There are two places - pasted below.
1)
#ifdef CONFIG_X86_32
        . = ALIGN(32);
#else
        . = ALIGN(PAGE_SIZE);
        . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
#endif
        .data.cacheline_aligned :


2)
#ifdef CONFIG_X86_32
        . = ALIGN(32);
#else
        . = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
#endif
        .data.read_mostly :

> > o  All the stuff added to support relocable kernels
> 
> hpa found a bug (well, misfeature) in the relocatable kernel code 
> too.

If I understood this correct we had an issue that the start address of
the section was no aligned because the ALIGN() was located inside
the output section.

That should not be a problem after applying this patchset as
they are almost all moved out.
I left them in the output section where they:
- are used to align the end address of an output section
- for .text where the .code16 had special requirments to avoid hurting 64 bit
- for .data_nosave on 64 bit - because I forgot to delete it
  The latter is a noop since we have an identical ALING() just above it


	Sam
