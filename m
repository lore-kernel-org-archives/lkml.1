Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZFPJzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZFPJzP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 05:55:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbZFPJzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 05:55:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052AbZFPJzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 05:55:02 -0400
Subject: Re: [PATCH v2 0/8] clean up vdso-layout.lds.S
From: Petr Tesarik <ptesarik@suse.cz>
To: Roland McGrath <roland@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <20090616084015.5D2E44B6FD@magilla.sf.frob.com>
References: <1244814040-5810-1-git-send-email-ptesarik@suse.cz>
	 <20090616084015.5D2E44B6FD@magilla.sf.frob.com>
Content-Type: text/plain; charset="UTF-8"
Organization: SUSE LINUX
Date: Tue, 16 Jun 2009 11:55:01 +0200
Message-Id: <1245146101.17481.202.camel@nathan.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Upfront, thank you very much for reviewing the series, Roland!

Roland McGrath píše v Út 16. 06. 2009 v 01:40 -0700:
> If you are going to change the whitespace to match canonical C conventions,
> then please do the same with the style of C-like comments.
> 
> 	/*
> 	 * Like this.
> 	 */

Ah, the missing first almost empty line. Ok, didn't know the coding
style was that much strict...

> Aside from that, the cosmetic changes are all fine by me.
> 
> The vDSO is unlike a normal DSO in that it has no writable PT_LOAD segment.
> (This is the ELF way of expressing the fact that there is just one
> contiguous read-only mapping of the whole vDSO image done by the kernel,
> which is not in fact driven by any ELF headers at all.)
> 
> If any code in the vDSO uses any writable data sections, it will break at
> runtime if nothing else.  So indeed there should not be any such sections
> in the input to the vDSO link.

And there currently isn't one. But the writability of the vDSO is a bit
more complicated. True, the VMA is initially mapped read-only, but it is
possible to make it writable using mprotect(). You may also set an
INT3-style breakpoint in the vDSO area. So, it's all about policy. If
there were any demand to make the vDSO writable, it could be done with a
trivial patch.

If we do not _WANT_ to make it writable, then we can simply add .data
and .bss to .broken.

> [...]
> The output sections (number of them, and cumulative length of their names)
> contribute to the overall size of the whole vDSO file (and thus hasten the
> day it pushes over another page boundary).  So we should strive never to
> add any that we can avoid.

Fine with me. BTW what do you mean by "another page boundary"? The vDSO
currently fits comfortably into a single page.

> The various ones from the beginning through .dynamic have to be separate
> output sections for ld -shared to do the right thing (last we tried).  
> All of those names are magic, except for .note (its name doesn't matter,
> just that it's a separate output section to have :note).
> 
> The reason .rodata is separate from .text is for the alignment of the code
> section away from non-code data.
> 
> The reason .data is separate from .rodata is IIRC just to avoid its bogus
> writable input sections "polluting" the output section with an SHF_WRITE,
> which makes some tools or ELF checkers unhappy or something like that.
> 
> As I said, the stuff in .data probably doesn't exist except for .got*.
> (But we're not really positive that various of the others don't exist with
> some old tools or others.)  The .got* sections have to be in some output
> section (that is thus a writable section), because ld -shared wants to
> generate them and freaks out if they are not in the script or are placed in
> /DISCARD/ (or that was the state of ld when I first wrote the linker script).
> 
> You probably still can't get a way to make the .got* input sections
> disappear entirely even though they are completely useless in the vDSO.
> It's best to keep them placed after .rodata as it was (you gave no reason
> for the effective reordering in 7/8), so that the useless garbage words are
> last and with luck all the cache lines consumed are packed with the real
> data that is ever actually read.

For a moment I thought about removing them with objcopy -R .got (because
you run objcopy on the vDSO anyway), but for some reason (buggy
binutils?) this attempt produces ridiculous output (>1M file). So you
are right.

> You added an output section just so you could use SIZEOF() on it.
> I think you can do that same calculation for ASSERT() in a different way:
> 
> 	__start_got = .;
> 	*(.got.plt) *(.got)
> 	__stop_got = .;
> 
> There may also be a different way to do that check.
> If the GOT were used, there would be dynamic relocs.
> So readelf/objdump -r on vdso*.so.dbg should be empty, you can check.
> Or it probably works too just to include *(.rel.*) *(.rela.*) in
> .broken to ensure there are no reloc sections generated.

Yes, all .rel* sections should be in .broken, I guess.

> OTOH, I guess a non-broken link produces no .broken output section at all
> (since it's empty) and so you've just done s/.data/.got/, which saves a
> byte.  So that's not so bad.  Hey, about you show us the sizes of vdso*.so
> (whole file sizes) before & after the series?

No change. Before:

ptesarik@nathan:~/linux-2.6> ls -l arch/x86/vdso/vdso.so
-rw-r--r-- 1 ptesarik users 3624 Jun 16 11:51 arch/x86/vdso/vdso.so

After:

ptesarik@nathan:~/linux-2.6> ls -l arch/x86/vdso/vdso.so
-rw-r--r-- 1 ptesarik users 3624 Jun 16 11:52 arch/x86/vdso/vdso.so

> I see no rationale for changing the treatment of .note.* input sections.
> Why do you think you should list two we use now and discard all others?
> That makes no sense to me.  Any .note.* sections we link into the vDSO, we
> want in the vDSO PT_NOTE segment.  What problem does this change solve?

This was an attempt to discard .note.GNU-stack, which is what the
default linker script does, but it appears that all .note.GNU-stack
sections are zero-size, so this change does not make any difference.

Petr Tesarik


