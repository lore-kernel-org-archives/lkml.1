Return-Path: <linux-kernel-owner+w=401wt.eu-S1755142AbYIHRRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbYIHRRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754652AbYIHRQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:16:58 -0400
Received: from gw.goop.org ([64.81.55.164]:58019 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbYIHRQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:16:58 -0400
Message-ID: <48C55E07.5000406@goop.org>
Date: Mon, 08 Sep 2008 10:16:55 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
CC: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-1?Q?Rafa=3F_Mi=3Fecki?= <zajec5@gmail.com>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] x86: check for and defend against BIOS memory corruption
References: <48B701FB.2020905@goop.org> <Pine.LNX.4.64.0808290817190.21494@blonde.site> <48B80C26.2080002@goop.org> <Pine.LNX.4.64.0809081157020.14401@blonde.site>
In-Reply-To: <Pine.LNX.4.64.0809081157020.14401@blonde.site>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins wrote:
> On Fri, 29 Aug 2008, Jeremy Fitzhardinge wrote:
>   
>> Hugh Dickins wrote:
>>
>>     
>>> Is this the right moment for me to mention again that I'm not sure
>>> your reuse of existing pagetables was quite right anyway: NX being
>>> excluded from level2_ident_pgt, but wanted in the direct map?
>>>       
>> We could add NX.  What's the behaviour of setting NX in a
>> non-NX-supporting CPU?  I don't think it would trigger a "reserved bit"
>> exception (the other high pte flags don't).  Or failing that, we could
>> mask out NX once we've worked out the CPU doesn't support it (at the
>> same time it relocates the pagetables to the kernel's load-time address).
>>     
>
> I've no experience of what happens if NX is set to a non-NX-supporting
> CPU, so can't advise on that at all.  But I think you're looking at
> it the wrong way round - or else I am.
>
> Here's the declaration and comment on level2_ident_pgt in head_64.S:
>
> NEXT_PAGE(level2_ident_pgt)
> 	/* Since I easily can, map the first 1G.
> 	 * Don't set NX because code runs from these pages.
> 	 */
> 	PMDS(0, __PAGE_KERNEL_LARGE_EXEC, PTRS_PER_PMD)
>
> (The "Since I easily can" comment is there because it used to map
> only a subset needed for early kernel startup, not the whole 1G.)
>
> So it's very intentionally leaving NX out there.  I believe the
> level2_ident_pgt page appears twice or more in the pagetable layout,
> used to map two or more areas of virtual address space - once to
> provide the direct map at ffff880000000000 and once to provide
> the kernel image virtual mapping at ffffffff80200000.
>   

Hm, yes, I see what you mean.

> I think we don't want NX on Linux kernel text ;-?
>   

Might be problematic.

> Before your 2.6.27-rc changes, init_memory_mapping subsequently
> replaced the direct map usage by a separately constructed pagetable,
> similar to it but with NX set throughout.  After your 2.6.27-rc
> changes, level2_ident_pgt is found there already so left untouched -
> leaving NX out of that first 1G of the direct map forever (when CPA
> splits it up, the smaller pages inherit the lack of NX too).
>   

Well, if we never want the direct map to be non-executable (which I
think would be OK, since all the code is either core kernel or modules
which are mapped elsewhere), then we can set NX on the level4 for the
linear mapping which will make everything below non-executable.

> I'm reluctant to delve in there again at present, and unsure
> what the right fix should be: perhaps the code which checks if
> an entry is already there, should check if it has the desired
> flags?

Well, the specific reason I made these changes was to make sure that
there was never more than one entry mapping any kernel page, so that you
can update the page permissions on a kernel page with just one update. 
This is pretty much a requirement for Xen, and very convenient at other
times.  Native will use either L2 or L3 mappings for the kernel and
linear space, and Xen uses L1 mappings, so if we break the aliasing at
the L2 level I can still keep the L1s aliased, but it seems simpler to
set NX on the linear mapping's L4.

    J
