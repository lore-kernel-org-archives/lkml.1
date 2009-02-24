Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbZBXL0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbZBXL0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 06:26:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbZBXL0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 06:26:04 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55004 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbZBXL0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 06:26:03 -0500
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Kyle McMartin <kyle@infradead.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, kyle@redhat.com, roland@redhat.com
Subject: Re: [PATCH/RFC] powerpc: avoid generating .eh_frame sections with gcc-4.4
References: <20090224065112.GA6690@bombadil.infradead.org>
	<20090224084034.GA11847@uranus.ravnborg.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Free thinker, does not speak for Red Hat
		or its Operating System Tools Group
Date: Tue, 24 Feb 2009 08:25:35 -0300
In-Reply-To: <20090224084034.GA11847@uranus.ravnborg.org> (Sam Ravnborg's message of "Tue\, 24 Feb 2009 09\:40\:34 +0100")
Message-ID: <orprh8oz4g.fsf@livre.oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 24, 2009, Sam Ravnborg <sam@ravnborg.org> wrote:

> On Tue, Feb 24, 2009 at 01:51:12AM -0500, Kyle McMartin wrote:
>> From: Kyle McMartin <kyle@redhat.com>
>> 
>> On ppc64 (at least) gcc-4.4 is defaulting to generating .eh_frame
>> sections, which are, for the kernel, fairly pointless. Additionally, on
>> ppc64 this generates a relocation format which the kernel module loader
>> does not currently support (R_PPC64_REL32.)
>> 
>> Alexandre Oliva verifies that -fno-dwarf2-cfi-asm prevents this
>> .eh_frame section from being generated.
>> 
>> These seem to be used for unwinding, but it doesn't look like we
>> currently use them anywhere. (In fact, we explicitly dump them in the
>> x86_64 linker script.)

> A grep for "eh_frame" shows too many hits in the kernel to convince
> me this is true.

I don't know whether .eh_frame is used for anything in the kernel.  It
doesn't matter, as far as the patch is concerned.

What the flag above does is to restore the .eh_frame behavior from GCC
4.3, in which, when compiling with -g, rather than using .cfi assembler
directives, GCC emitted .debug_frame and (when needed) .eh_frame itself.

The "when needed" is key.  The assembler doesn't know which of these to
emit, so it emits both in response to .cfi directives.  It's also
possible that the assembler selects more efficient relocations than GCC.
Regardless, it's precisely the presence of new relocations in .eh_frame
that caused the reported problem.

This flag will just restore the .eh_frame that you had with earlier
versions of GCC, so that you don't have to cope with the enlarged and
possibly modified one that the combination of new GCC and new binutils
generates when compiling with -g.  It will thus still serve whatever
purpose it did before.

I hope this helps,

-- 
Alexandre Oliva           http://www.lsd.ic.unicamp.br/~oliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
