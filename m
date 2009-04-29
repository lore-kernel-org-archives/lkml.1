Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZD2Icq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZD2Icq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 04:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZD2Ic2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 04:32:28 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40522 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZD2Ic0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 04:32:26 -0400
Date: Wed, 29 Apr 2009 10:31:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH/RFT 0/13] x86: unify vmlinux.lds
Message-ID: <20090429083134.GA16680@elte.hu>
References: <20090429073510.GA26386@uranus.ravnborg.org> <20090429075730.GD22129@elte.hu> <20090429082341.GA27386@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429082341.GA27386@uranus.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > > 
> > > o  64 bit uses PHDRS more extensively than 32 bit. Could they be the same?
> > 
> > Hm, PHDRS content really matters mostly for the vDSO, so that gdb 
> > can treat the vsyscall entry page(s) more as a normal DSO.
> > 
> > for the kernel image itself it does not matter much how standard of 
> > an ELF binary it is: the boot loader does not care about the PHDR 
> > description of linker segments and we dont execute the binary.
> > 
> > UML and lguest has its own ELF-binary creation methods.
> > 
> > I think the only relevancy it has on the kernel image is on readonly 
> > symbols: the PHDRS command gives a reasonable default flags value to 
> > various segments. We _usually_ give all segments their proper 
> > permission explicitly - but it was not unheard of to have mixups 
> > there and to see supposedly-readonly sections end up in a rw area or 
> > for rw sections to end up in the readonly section.
> > 
> > The latter will be found quickly because it triggers a kernel crash 
> > - the former kind of bug can linger for a long time.
> > 
> > So i think we should generate proper PHDRS (i.e. use the 64-bit 
> > linker script portion to also include percpu and init-data bits), 
> > for consistency.
> > 
> > Do you know what the linker does if the PHDRS and the section flags 
> > collide? Does the local flag override the PHDRS flag? I havent 
> > checked.
> 
> I have not looked much into the linker support of PHDRS.
> Which is also why I did not dare touching this stuff.
> 
> >From 'info ld':
> The linker will normally set the segment flags based on the sections
> which comprise the segment.  You may use the `FLAGS' keyword to
> explicitly specify the segment flags.
> 
> So the PHDRS settings take effect.

ok. So i think we should unify to the union of all PHDRS commands.

> > > o  _stext does not cover all text for 32 bit - a bug? For 64b bit it does.
> > >    It is only the .code16 wakeup stuff that is not covered but anyway.
> > 
> > that's a bug that should be fixed. Harmless - but needs some testing 
> > - there are tools (profilers, etc.) that might have assumptions 
> > about _stext so this needs some test-time.
> > 
> > Also, _stext is the start address for the readonly section - so by 
> > moving it down a bit on 32-bit we extend readonly to that .code16 
> > suspend code. If it contains any self-modifying code it will crash.
> 
> hpa should know about the latter.
> I suggest to give the current patchset some air time before we move _stext.

Yes, of course. I have just processed them, cleaned up the 
changelogs, fixed that minor detail with the attribution, applied 
them to tip:x86/kbuild and started testing them - if initial tests 
look good i'll push them out.

All other changes should be incremental - these patches alone 
contain more than enough side-effects as-is already.

> > > o  _edata covers much more on 32 bit
> > 
> > 32-bit is corret there. We do use _edata in a couple of places, such 
> > as in resource ranges - so there could be side-effects, but any such 
> > side effects would likely show some real hidden bug or uncleanliness 
> > so it's good to fix that.
> 
> OK - again if we could wait a bit with this change it would be good.
> 
> > 
> > > o  The nosave stuff differs (but that is due to the PHDRS stuff anyway)
> > 
> > nosavedata is a really ancient construct used almost nowhere. That's 
> > a question to Rafael and Linus: can we just get rid of it? The only 
> > user seems to be:
> > 
> >   int in_suspend __nosavedata = 0;
> 
> A lot of stuff added just to support a single integer..
> If we could get rid of that it would be great.

yeah.

> > > o  Different alignmnet requirements in several spots
> > 
> > do you have a list of them? There's hpa's fix from yesterday that 
> > shows that we have real bugs there.
> 
> There are two places - pasted below.
> 1)
> #ifdef CONFIG_X86_32
>         . = ALIGN(32);
> #else
>         . = ALIGN(PAGE_SIZE);
>         . = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
> #endif
>         .data.cacheline_aligned :

looks weird. Even on 32-bit we should align to 
CONFIG_X86_L1_CACHE_BYTES - and on 64-bit why do we align to page 
size then to l1-cacheline-size which is always <= PAGE_SIZE?

This should become either:

	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);

or:

	. = ALIGN(PAGE_SIZE);

I'd vote for the first one - assuming the page alignment wasnt due 
to the previous section somehow being special (being mapped to 
user-space or having different pagetable permissions).

> 2)
> #ifdef CONFIG_X86_32
>         . = ALIGN(32);
> #else
>         . = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
> #endif
>         .data.read_mostly :

we should define CONFIG_X86_INTERNODE_CACHE_BYTES on 32-bit too (set 
it to l1 cacheline size) and then use:

	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);

> > > o  All the stuff added to support relocable kernels
> > 
> > hpa found a bug (well, misfeature) in the relocatable kernel code 
> > too.
> 
> If I understood this correct we had an issue that the start 
> address of the section was no aligned because the ALIGN() was 
> located inside the output section.

yeah. And we had that in quite a few places.

> That should not be a problem after applying this patchset as
> they are almost all moved out.
> I left them in the output section where they:
> - are used to align the end address of an output section
> - for .text where the .code16 had special requirments to avoid hurting 64 bit
> - for .data_nosave on 64 bit - because I forgot to delete it
>   The latter is a noop since we have an identical ALING() just above it

ok.

This is a really nice patch-set, just in case i didnt mention it yet 
;-)

	Ingo
