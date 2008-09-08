Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbYIHRjD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbYIHRjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:39:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbYIHRix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:38:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752008AbYIHRiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:38:52 -0400
Date: Mon, 8 Sep 2008 10:38:08 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Andi Kleen <andi@firstfloor.org>, linux@sandersweb.net,
       linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
       Andi Kleen <andi-suse@firstfloor.org>
Subject: Re: [BUG] x86 kenel won't boot under Virtual PC
In-Reply-To: <48C55C0A.7070203@zytor.com>
Message-ID: <alpine.LFD.1.10.0809081028590.3117@nehalem.linux-foundation.org>
References: <200809071922.32974.linux@sandersweb.net> <48C48467.40703@zytor.com> <200809072249.17280.linux@sandersweb.net> <48C4A46B.90705@zytor.com> <alpine.LFD.1.10.0809080805240.3117@nehalem.linux-foundation.org> <20080908154535.GL26079@one.firstfloor.org>
 <48C54839.8050304@zytor.com> <alpine.LFD.1.10.0809080857450.3117@nehalem.linux-foundation.org> <48C54F1B.8040604@zytor.com> <alpine.LFD.1.10.0809080916550.3117@nehalem.linux-foundation.org> <20080908170029.GP26079@one.firstfloor.org>
 <alpine.LFD.1.10.0809081000490.3117@nehalem.linux-foundation.org> <48C55C0A.7070203@zytor.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Sep 2008, H. Peter Anvin wrote:
> Linus Torvalds wrote:
> > 
> > Peter - does gcc actually use NOPL in _32-bit_ code too? It really seems to
> > be a stupid decision to make a binary not run on other CPU's over something
> > as trivial as that. That's something I'd expect out of an Intel compiler
> > just to mess with AMD, not out of gcc.
> > 
> 
> Yes, it does:
> 
>   /* We need to decide which NOP sequence to use for 32bit and
>      64bit. When -mtune= is used:
> 
>      1. For PROCESSOR_I386, PROCESSOR_I486, PROCESSOR_PENTIUM and
>      PROCESSOR_GENERIC32, f32_patt will be used.
>      2. For PROCESSOR_PENTIUMPRO, PROCESSOR_PENTIUM4, PROCESSOR_NOCONA,
>      PROCESSOR_CORE, PROCESSOR_CORE2, and PROCESSOR_GENERIC64,
>      alt_long_patt will be used.
>      3. For PROCESSOR_ATHLON, PROCESSOR_K6, PROCESSOR_K8 and
>      PROCESSOR_AMDFAM10, alt_short_patt will be used.
> 
>      When -mtune= isn't used, alt_long_patt will be used if
>      cpu_arch_isa_flags has Cpu686. Otherwise, f32_patt will
>      be used.
> 
> "alt_long_patt" uses NOPL and its variants.

That is A TOTAL PIECE OF SH*T, and against gcc's own documentation.

"-mtune=x" is very much defined to be a performance _tuning_ option, not 
an "architectural" option. 

Quite frankly, this is a gcc bug. Plain and simple. 

Look at the gcc man-pages. It very much says:

       -mtune=cpu_type
           Set only the instruction scheduling parameters for machine type
           cpu_type.  The instruction set is not changed.

(in various different formats - it says the same things with different 
words for different architectures. For example, for 386/x86-64 it 
_specifically_ says:

       -mtune=cpu-type
           Tune to cpu-type everything applicable about the generated code,
           except for the ABI and the set of available instructions.  The
           choices for cpu-type are:

note the "except for the ABI and the set of available instructions".

Qutie frankly, I think this is a *much* bigger bug than any possible 
VirtualPC idiocy. It's expressly against the whole idea of "-mtune".

Of course, we do set "-march=i686" too, so maybe the gcc people will claim 
that that means "Intel CPU's only". But quite frankly, if they really 
claim that, then they are lying pond-scum:

           i686
               Same as "generic", but when used as "march" option, PentiumPro
               instruction set will be used, so the code will run on all i686
               family chips.

which any sane x86 person would claim includes all the various clone 
manufacturers too. Saying that NOPL is so important that "i686" should 
suddenly be Intel-only is dishonest and totally stupid.

IOW, somebody who has a gcc bugzilla login should just create a bug-report 
on this. There is no question but that this is a bug, plain and simple.

			Linus
