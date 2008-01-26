Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbYAZAP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbYAZAP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 19:15:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYAZAPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 19:15:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43297 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYAZAPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 19:15:09 -0500
Message-ID: <479A7A88.6010505@zytor.com>
Date: Fri, 25 Jan 2008 16:10:48 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
References: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk>
In-Reply-To: <C3C0235A.12D8E%Keir.Fraser@cl.cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keir Fraser wrote:
> On 25/1/08 22:54, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:
> 
>> The only possibly relevant comment I can find in vol3a is:
>>
>>     Older IA-32 processors that implement the PAE mechanism use uncached
>>     accesses when loading page-directory-pointer table entries. This
>>     behavior is
>>     model specific and not architectural. More recent IA-32 processors may
>>     cache page-directory-pointer table entries.
> 
> Go read the Intel application note "TLBs, Paging-Structure Caches, and Their
> Invalidation" at http://www.intel.com/design/processor/applnots/317080.pdf
> 
> Section 8.1 explains about the PDPTR cache in 32-bit PAE mode, which can
> only be refreshed by appropriate tickling of CR0, CR3 or CR4.
> 
> It is also important to note that *any* valid page directory entry at *any*
> level in the page-table hierarchy can become cached at *any* time. Basically
> TLB lookup is performed as a longest-prefix match on the linear address to
> skip as many levels in a page-table walk as possible (where a walk is
> needed, because there is no full-length match on the linear address). So, if
> you modify a directory entry from present to not-present, or change the page
> directory that a valid pde points to, you probably need to flush the pde
> caching structure. One piece of good news is that all pde caches are flushed
> by any arbitrary INVLPG.
> 

Actually, it's trickier than that.  The PDPTR, just like the segments, 
aren't a real cache, and aren't invalidated by INVLPG.  This means you 
can't go from less permissive to more permissive, which is normally 
permitted in the x86.  The PDPTR should really be thought of as an 
extended cr3 with four entries (this is also how it would be typically 
implemented in hardware) rather than as a part of the paging structure 
per se.

We do NOT want to frob %cr4 unless we actually need to clear all the 
global pages.

The stuff in chapter 10 sounds like they're flagging for a revised 
INVLPG instruction or mode which would fit some of the extremely serious 
defects in INVLPG that was introduced by haphazard semantics from the P5 
and early P6 days.

In general, we should assume that INVLPG only flushes the hierarchy 
above it, and not rely on side effects.  In particular, we should only 
assume INVLPG invalidates the hierarchy immediately above it, not on any 
side effects.  That's basically sane design anyway.

Now, all of this reminds me of something somewhat messy: if we share the 
kernel page tables for trampoline page tables, as discussed elsewhere, 
we HAVE to do a complete, all-tlb-including-global-pages flush after 
use, since the kernel pages are global and otherwise will stick around. 
  Unlike the permissions pages, there aren't G enable bits on the higher 
levels, but only for the PTEs themselves.

	-hpa

