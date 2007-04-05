Return-Path: <linux-kernel-owner+w=401wt.eu-S1766961AbXDEMnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766961AbXDEMnY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 08:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766964AbXDEMnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 08:43:24 -0400
Received: from cantor.suse.de ([195.135.220.2]:49533 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766961AbXDEMnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 08:43:23 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] change_page_attr() and global_flush_tlb()
Date: Thu, 5 Apr 2007 14:43:12 +0200
User-Agent: KMail/1.9.6
Cc: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org
References: <4614DE61.76E4.0078.0@novell.com>
In-Reply-To: <4614DE61.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704051443.12505.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007 11:32:49 Jan Beulich wrote:
> Looking at both the i386 and x86-64 implementations I fail to understand why
> there is an explicit requirement on calling global_flush_tlb() after
> change_page_attr(), yet actual TLB flushing will not normally happen (on i386
> it will happen if the CPU doesn't support clflush, but if it does, or on x86-64,
> the flushing depends on the list of deferred pages being non-empty, which
> can only happen when a large page gets re-combined). Is it assumed that
> the callers additionally call tlb_flush_all() (I think none of them do)?

Not sure I understand the question? global_flush_tlb is perhaps a little
misnamed, but it only flushes the pages changed in change_page_attr.
This works because it uses INVLPG which should ignore the G bits,
so not additional global flush is needed.

Linus wanted it done this two step way because he was worried about too 
many IPIs. I guess it doesn't make too much difference though because near all
callers only change single pages. The flush could be probably folded
back into c_p_a().

BTW we know the sequence for doing this is not quite as recommended
by Intel (TODO item) but afaik the TLB flushing works. 

> Further, change_page_attr()'s reference counting in a split large page's
> page table appears to imply that attributes are only changed from or back to
> the reference attributes, but not from one kind of non-default ones to the
> same or another set of non-default ones (otherwise the reference count
> will never again drop to zero), > and also not from default to default (i.e. the 
> caller trying to revert attributes to normal not knowing what state they are
> currently in) - this would BUG() if the large page was already reverted, or
> screw the reference count otherwise. Is all of this intentional? I think it
> will need to be changed as a prerequisite to supporting on-the-fly attribute
> changes in the SMP alternatives code, which was requested as a follow-up
> to the tightening of the CONFIG_DEBUG_RODATA effects.

The reference count is just to count pages that have a non default attribute
in the PMD range so that we know when to revert to a large page.

Originally attribute was only the caching attribute, but later changed
to include NX and RW for slab (but that area was always a bit hackish
and might have some bugs)

For non default to another non default changes the count should not change.

If it doesn't work this way that would be a bug.

> Finally, at least for the kernel image range it would seem to me that it might
> be beneficial to recombine mappings into large ones even when the
> attributes are not at their default anymore, but consistent across an entire
> 2Mb/4Mb range (i.e. after write-protecting .text). At the same time I wonder,
> though, whether it wouldn't be safer to remove execute permission from
> anything but .text along with write-protecting read-only regions under
> CONFIG_DEBUG_RODATA.

Yes I guess that would be a useful optimization.  Just getting
the reference counting right with that might be tricky.

At least the i386 code will probably change significantly soon as I clean 
up the GB page patches, which require some restructuring in c_p_a().

-Andi
