Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbYAYWzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbYAYWzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 17:55:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbYAYWy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 17:54:58 -0500
Received: from gw.goop.org ([64.81.55.164]:46425 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbYAYWy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 17:54:57 -0500
Message-ID: <479A68B8.4050705@goop.org>
Date: Fri, 25 Jan 2008 14:54:48 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Jan Beulich <jbeulich@novell.com>,
       Eduardo Pereira Habkost <ehabkost@redhat.com>,
       Ian Campbell <ijc@hellion.org.uk>, William Irwin <wli@holomorphy.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Keir Fraser <Keir.Fraser@cl.cam.ac.uk>
Subject: Re: [PATCH 11 of 11] x86: defer cr3 reload when doing pud_clear()
References: <c084def0f6afb2b2ef47.1201296200@localhost> <479A5689.80505@zytor.com>
In-Reply-To: <479A5689.80505@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>> PAE mode requires that we reload cr3 in order to guarantee that
>> changes to the pgd will be noticed by the processor.  This means that
>> in principle pud_clear needs to reload cr3 every time.  However,
>> because reloading cr3 implies a tlb flush, we want to avoid it where
>> possible.
>
> It only matters (for a processor which supports PGE) if we actually 
> use the namespace in between.

Yes.  And I don't think there are instances of one place in the kernel 
removing pmd and then replacing it in short order.  It either means 
you're doing a large munmap, or the pagetable is being destroyed (and 
therefore isn't currently in cr3 anyway).

>> In huge_pmd_unshare, it is followed by flush_tlb_range, which always
>> results in a full cr3-reload tlb flush.
>
> This one makes me nervous, as it feels like a side effect of 
> implementation, and not a guarantee by design.

Yes.  Obviously any user of pud_clear must do some kind of tlb flush 
before they can expect the effect of their change to be visible.  We 
just need to make sure that its the right kind of tlb flush that 
satisfies the processor's requirements for updating the pgd.  If someone 
went and changed x86's flush_tlb_range to use invlpg then there'd be a 
problem.

I considered hacks like adding a percpu flag saying "the next tlb flush 
of any kind must be a cr3-reloading tlb flush", but that seems a 
little... ugly.

Hm.  Changing PGE in cr4 is documented as flushing the tlb, but is it 
enough to get new pmds recognized?  (yes: see below)

Where is the requirement to reload cr3 after a pgd update documented 
anyway?  The comment in the source refers to "Pentium-II erratum A13", 
which I think is wrong. The Pentium II specification update document 
#243337-049, Jul 2002, lists A13 as "MCE Due to L2 Parity Error Gives L1 
MCACOD.LL"; the only mention of PAE in that document is a bad 
interaction with PAT in some steppings.

The only possibly relevant comment I can find in vol3a is:

    Older IA-32 processors that implement the PAE mechanism use uncached
    accesses when loading page-directory-pointer table entries. This
    behavior is
    model specific and not architectural. More recent IA-32 processors may
    cache page-directory-pointer table entries.

(I'm not sure if "cache" here is the data cache or the TLB.)

Ah, here it is, in "Pentium® Pro Processor Specification Update", 
January 1999, document 242689-035:

    8.         TLB Flush Necessary After PDPE Change
    As described in Section 3.7, “Translation Lookaside Buffers (TLBs),”
    in the Pentium® Pro Family Developer's Manual, Volume 3: Operating
    System Writer’s Manual, the operating system is required to
    invalidate the corresponding entry in the TLB after any change to a
    page-directory or page-table entry. However, if the physical address
    extension (PAE) feature is enabled to use 36-bit addressing, a new
    table is added to the paging hierarchy, called the page directory
    pointer table (as per Section 3.8, “Physical Address Extension”). If
    an entry is changed in this table (to point to another page
    directory), the TLBs must then be flushed by writing to CR3.

Alright, here's the definitive document: TLBs, Paging-Structure Caches, and
Their Invalidation 
(http://www.intel.com/design/processor/applnots/317080.pdf), in which 
section 8.1 confirms that you need to either reload cr3 or one of the 
other control registers which triggers a cache flush:

    The processor does not maintain a PDP cache as described in Section
    4. The processor always caches information from the four
    page-directory-pointer-table entries. These  entries are not cached
    at the time of address translation. Instead, they are always  cached
    as part of the execution of the following instructions:

        * A MOV to CR3 that occurs with IA32_EFER.LMA = 0 and CR4.PAE = 1.
        * A MOV to CR4 that results in CR4.PAE = 1, that occurs with
          IA32_EFER.LMA = 0 and CR0.PG = 1, and that modifies at least
          one of CR4.PAE, CR4.PGE, and CR4.PSE.
        * A MOV to CR0 that modifies CR0.PG and that occurs with
          IA32_EFER.LMA = 0 and CR4.PAE = 1.

I'll put together a patch with a pointer to the proper documentation...

    J
