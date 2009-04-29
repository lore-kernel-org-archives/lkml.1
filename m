Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbZD2H63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbZD2H63 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbZD2H6T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:58:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbZD2H6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:58:18 -0400
Date: Wed, 29 Apr 2009 09:57:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH/RFT 0/13] x86: unify vmlinux.lds
Message-ID: <20090429075730.GD22129@elte.hu>
References: <20090429073510.GA26386@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
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

> Following patchset is on top of the x86/kbuild branch of tip. It 
> unifies vmlinux.lds so we end up with a single file.

Cool!

> The patchset has been build tested on 32bit and 64 bit but has not 
> been boot tested. (Lacking time/resources atm).

No problem, we can test it for you.

> The steps were made minimal to make it simpler to track 
> regressions using bisect (if any) and to make review easier.

Thanks, that's really helpful.

> The unified vmlinux.lds shows some questionable differences 
> between 32 bit and 64 bit.
> 
> o  64 bit uses PHDRS more extensively than 32 bit. Could they be the same?

Hm, PHDRS content really matters mostly for the vDSO, so that gdb 
can treat the vsyscall entry page(s) more as a normal DSO.

for the kernel image itself it does not matter much how standard of 
an ELF binary it is: the boot loader does not care about the PHDR 
description of linker segments and we dont execute the binary.

UML and lguest has its own ELF-binary creation methods.

I think the only relevancy it has on the kernel image is on readonly 
symbols: the PHDRS command gives a reasonable default flags value to 
various segments. We _usually_ give all segments their proper 
permission explicitly - but it was not unheard of to have mixups 
there and to see supposedly-readonly sections end up in a rw area or 
for rw sections to end up in the readonly section.

The latter will be found quickly because it triggers a kernel crash 
- the former kind of bug can linger for a long time.

So i think we should generate proper PHDRS (i.e. use the 64-bit 
linker script portion to also include percpu and init-data bits), 
for consistency.

Do you know what the linker does if the PHDRS and the section flags 
collide? Does the local flag override the PHDRS flag? I havent 
checked.

> o  _stext does not cover all text for 32 bit - a bug? For 64b bit it does.
>    It is only the .code16 wakeup stuff that is not covered but anyway.

that's a bug that should be fixed. Harmless - but needs some testing 
- there are tools (profilers, etc.) that might have assumptions 
about _stext so this needs some test-time.

Also, _stext is the start address for the readonly section - so by 
moving it down a bit on 32-bit we extend readonly to that .code16 
suspend code. If it contains any self-modifying code it will crash.

> o  _edata covers much more on 32 bit

32-bit is corret there. We do use _edata in a couple of places, such 
as in resource ranges - so there could be side-effects, but any such 
side effects would likely show some real hidden bug or uncleanliness 
so it's good to fix that.

> o  The nosave stuff differs (but that is due to the PHDRS stuff anyway)

nosavedata is a really ancient construct used almost nowhere. That's 
a question to Rafael and Linus: can we just get rid of it? The only 
user seems to be:

  int in_suspend __nosavedata = 0;

> o  Different alignmnet requirements in several spots

do you have a list of them? There's hpa's fix from yesterday that 
shows that we have real bugs there.

> o  All the stuff added to support relocable kernels

hpa found a bug (well, misfeature) in the relocatable kernel code 
too.

	Ingo
