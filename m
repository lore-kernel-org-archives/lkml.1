Return-Path: <linux-kernel-owner+w=401wt.eu-S1751746AbZFPIkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751746AbZFPIkk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 04:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752741AbZFPIkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 04:40:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZFPIkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 04:40:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Petr Tesarik <ptesarik@suse.cz>
X-Fcc: ~/Mail/linus
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
In-Reply-To: Petr Tesarik's message of  Friday, 12 June 2009 15:40:32 +0200 <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
X-Shopping-List: (1) Precarious destroyers
   (2) Ponderous Budweiser destroyers
   (3) Obedient invasions
Message-Id: <20090616084015.5D2E44B6FD@magilla.sf.frob.com>
Date: Tue, 16 Jun 2009 01:40:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you are going to change the whitespace to match canonical C conventions,
then please do the same with the style of C-like comments.

	/*
	 * Like this.
	 */

Aside from that, the cosmetic changes are all fine by me.

The vDSO is unlike a normal DSO in that it has no writable PT_LOAD segment.
(This is the ELF way of expressing the fact that there is just one
contiguous read-only mapping of the whole vDSO image done by the kernel,
which is not in fact driven by any ELF headers at all.)

If any code in the vDSO uses any writable data sections, it will break at
runtime if nothing else.  So indeed there should not be any such sections
in the input to the vDSO link.

It may well be true that all the non-.got* sections in the script now have
never actually appeared in a vDSO link.  When I first wrote the linker
script to build a vDSO, it was by editting down the default -shared script
built into the ld of the day, not by naming only the sections that would
actually appear in my build at the time.  It does no harm whatsoever to
match more input section names in the script, so I don't really see any
reason to remove any.  (Probably nobody's compiler is emitting useless
1-word ones of them or whatnot, but who knows.)  If you want to move them
all into a checked .broken sort of thing, that is fine.

The output sections (number of them, and cumulative length of their names)
contribute to the overall size of the whole vDSO file (and thus hasten the
day it pushes over another page boundary).  So we should strive never to
add any that we can avoid.

The various ones from the beginning through .dynamic have to be separate
output sections for ld -shared to do the right thing (last we tried).  
All of those names are magic, except for .note (its name doesn't matter,
just that it's a separate output section to have :note).

The reason .rodata is separate from .text is for the alignment of the code
section away from non-code data.

The reason .data is separate from .rodata is IIRC just to avoid its bogus
writable input sections "polluting" the output section with an SHF_WRITE,
which makes some tools or ELF checkers unhappy or something like that.

As I said, the stuff in .data probably doesn't exist except for .got*.
(But we're not really positive that various of the others don't exist with
some old tools or others.)  The .got* sections have to be in some output
section (that is thus a writable section), because ld -shared wants to
generate them and freaks out if they are not in the script or are placed in
/DISCARD/ (or that was the state of ld when I first wrote the linker script).

You probably still can't get a way to make the .got* input sections
disappear entirely even though they are completely useless in the vDSO.
It's best to keep them placed after .rodata as it was (you gave no reason
for the effective reordering in 7/8), so that the useless garbage words are
last and with luck all the cache lines consumed are packed with the real
data that is ever actually read.

You added an output section just so you could use SIZEOF() on it.
I think you can do that same calculation for ASSERT() in a different way:

	__start_got = .;
	*(.got.plt) *(.got)
	__stop_got = .;

There may also be a different way to do that check.
If the GOT were used, there would be dynamic relocs.
So readelf/objdump -r on vdso*.so.dbg should be empty, you can check.
Or it probably works too just to include *(.rel.*) *(.rela.*) in
.broken to ensure there are no reloc sections generated.

OTOH, I guess a non-broken link produces no .broken output section at all
(since it's empty) and so you've just done s/.data/.got/, which saves a
byte.  So that's not so bad.  Hey, about you show us the sizes of vdso*.so
(whole file sizes) before & after the series?

I see no rationale for changing the treatment of .note.* input sections.
Why do you think you should list two we use now and discard all others?
That makes no sense to me.  Any .note.* sections we link into the vDSO, we
want in the vDSO PT_NOTE segment.  What problem does this change solve?


Thanks,
Roland
