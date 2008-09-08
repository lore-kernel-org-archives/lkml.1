Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbYIHLgV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbYIHLgV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 07:36:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbYIHLgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 07:36:12 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:55512 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbYIHLgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 07:36:12 -0400
Date: Mon, 8 Sep 2008 12:35:47 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory
 corruption
In-Reply-To: <48B80C26.2080002@goop.org>
Message-ID: <Pine.LNX.4.64.0809081157020.14401@blonde.site>
References: <48B701FB.2020905@goop.org> <Pine.LNX.4.64.0808290817190.21494@blonde.site>
 <48B80C26.2080002@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Jeremy Fitzhardinge wrote:
> Hugh Dickins wrote:
> 
> > Is this the right moment for me to mention again that I'm not sure
> > your reuse of existing pagetables was quite right anyway: NX being
> > excluded from level2_ident_pgt, but wanted in the direct map?
> 
> We could add NX.  What's the behaviour of setting NX in a
> non-NX-supporting CPU?  I don't think it would trigger a "reserved bit"
> exception (the other high pte flags don't).  Or failing that, we could
> mask out NX once we've worked out the CPU doesn't support it (at the
> same time it relocates the pagetables to the kernel's load-time address).

I've no experience of what happens if NX is set to a non-NX-supporting
CPU, so can't advise on that at all.  But I think you're looking at
it the wrong way round - or else I am.

Here's the declaration and comment on level2_ident_pgt in head_64.S:

NEXT_PAGE(level2_ident_pgt)
	/* Since I easily can, map the first 1G.
	 * Don't set NX because code runs from these pages.
	 */
	PMDS(0, __PAGE_KERNEL_LARGE_EXEC, PTRS_PER_PMD)

(The "Since I easily can" comment is there because it used to map
only a subset needed for early kernel startup, not the whole 1G.)

So it's very intentionally leaving NX out there.  I believe the
level2_ident_pgt page appears twice or more in the pagetable layout,
used to map two or more areas of virtual address space - once to
provide the direct map at ffff880000000000 and once to provide
the kernel image virtual mapping at ffffffff80200000.

I think we don't want NX on Linux kernel text ;-?

Before your 2.6.27-rc changes, init_memory_mapping subsequently
replaced the direct map usage by a separately constructed pagetable,
similar to it but with NX set throughout.  After your 2.6.27-rc
changes, level2_ident_pgt is found there already so left untouched -
leaving NX out of that first 1G of the direct map forever (when CPA
splits it up, the smaller pages inherit the lack of NX too).

I noticed when changing /proc/meminfo to show DirectMap in kB,
and tried to fix it, but only gave myself a non-booting system
(I probably shrank my direct map to 0 while implicitly using it).
And at that stage I didn't realize at all that it was a recent
regression arising from your mods.

I'm reluctant to delve in there again at present, and unsure
what the right fix should be: perhaps the code which checks if
an entry is already there, should check if it has the desired
flags?

Hugh
