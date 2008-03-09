Return-Path: <linux-kernel-owner+w=401wt.eu-S1753289AbYCIR22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbYCIR22 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYCIR2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:28:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59539 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751424AbYCIR2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:28:19 -0400
Date: Sun, 9 Mar 2008 10:27:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Arjan van de Ven <arjan@linux.intel.com>, hans.rosenfeld@amd.com,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
In-Reply-To: <20080309115603.GA951@elte.hu>
Message-ID: <alpine.LFD.1.00.0803091007560.5896@woody.linux-foundation.org>
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com>
 <alpine.LFD.1.00.0803031042230.17889@woody.linux-foundation.org> <20080309115603.GA951@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 9 Mar 2008, Ingo Molnar wrote:
> 
> The best fix is the one below (it should solve Arjan's regression with 
> that now-reverted patch redone), as it is the right thing to do [that 
> way sign auto-extend trickles over into PAGE_MASK as well].

This *really* makes me worry.

I do agree that there are good reasons that "PAGE_MASK" should be signed 
(since we do want the top bit to extend), but changing "PAGE_SIZE" to 
signed seems to be a rather big change, considering that it's used 
*everywhere*.

In particular, it's quite possibly used for things like

	offset = something % PAGE_SIZE;

etc, where a signed divide is positively wrong.

But even for PAGE_MASK, we literally have code like this:

	if ((size_avail & PAGE_MASK) < rg.size) {

where it so _happens_ that "size_avail" is unsigned, but what if it 
wasn't? It could turn a unsigned comparison into a signed one, and 
introduce any number of security bugs etc.

Sam goes even more for PAGE_SIZE. At least there are only about a thousand 
users of PAGE_MASK in the kernel, PAGE_SIZE is used about six times as 
many times, and just a _trivial_ grep like

	git grep 'PAGE_SIZE.* [<>][= ]'

finds a lot of cases where I'm not at all sure that it's safe to change 
PAGE_SIZE to a signed value.

In other words, there are lots of things like

	if (x < PAGE_SIZE)
		...

where we currently get a unsigned comparison, and where for all I know a 
signed PAGE_SIZE means that we should use 

	if (x >= 0 && x < PAGE_SIZE)

instead.

In short, I refuse to apply this patch after an -rc1 release. I suspect 
that I shouldn't apply something like this even *before* an -rc1, because 
I think it's just a really bad idea to make these types signed even if it 
were to give you magically easier sign extensions to "unsigned long long".

So I would *very* strongly instead argue:

 - "unsigned long" is the native kernel type for all address manipulation, 
   and thus "PAGE_SIZE" and "PAGE_MASK" should continue to have that type.

 - anything that uses any other type without explicitly making sure it's 
   safe is mis-using those macros. IOW, PAGE_MASk was *never* a type that 
   had anything what-so-ever to do with page table entry bits, and this is 
   purely a page table entry issue!

So my suggested patch would:

 - make the page table code use a specific mask that it builds up itself, 
   and makes sure it's of the right type and has the rigth value in 
   whatever type "struct pte_entry" is. The fact that "pte_val()" is 
   larger than "unsigned long" on x86-32 is very clearly a PTE issue, 
   *not* an issue for PAGE_SIZE or PAGE_MASK.

Btw, just one look at your other patch should have convinced you of that 
anyway. Do you really think this is a readable patch or that the result is 
clean:

	+#define pmd_bad_v1(x)  ((pmd_val(x) & (~PAGE_MASK & ~_PAGE_USER)) != _KERNPG_TABLE)
	+#define        pmd_bad_v2(x)   ((pmd_val(x) \
	                          & ~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)) \
	                         != _KERNPG_TABLE)

when the real problem is that the mask you build up here isn't safe o 
pretty to begin with!

So make that whole "~(PAGE_MASK | _PAGE_USER | _PAGE_PSE | _PAGE_NX)" 
expression a nice *clean* expression that is about page table entries 
instead, and make *that* one be the right type and have the right bits. 
And suddenly the problem just goes away.

In fact, if you look at that expression, you suddenly realize that 
PAGE_MASK was *totally* the wrong value to use in the first place, whether 
sign-extended o not! Notice how

	PAGE_MASK | _PAGE_NX

is already a totally senseless operation if PAGE_MASK has all high bits 
set! 

So I think your whole argument and the patch is UTTER AND UNBELIEVABLE 
CRAP!

Blaming it on PAGE_MASK was totally incorrect. It has nothing to do with 
PAGE_MASK, and everything to do with the fact that the page table checking 
patch was utterly failed and pure shit.

		Linus
