Return-Path: <linux-kernel-owner+w=401wt.eu-S1766984AbXDENv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766984AbXDENv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 09:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766983AbXDENv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 09:51:57 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:14743
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766984AbXDENv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 09:51:56 -0400
Message-Id: <46151B4F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.1 
Date: Thu, 05 Apr 2007 14:52:47 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <ak@suse.de>
Cc: <linux-kernel@vger.kernel.org>, <discuss@x86-64.org>
Subject: Re: [discuss] change_page_attr() and global_flush_tlb()
References: <4614DE61.76E4.0078.0@novell.com>
 <200704051443.12505.ak@suse.de>
In-Reply-To: <200704051443.12505.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <ak@suse.de> 05.04.07 14:43 >>>
>On Thursday 05 April 2007 11:32:49 Jan Beulich wrote:
>> Looking at both the i386 and x86-64 implementations I fail to understand why
>> there is an explicit requirement on calling global_flush_tlb() after
>> change_page_attr(), yet actual TLB flushing will not normally happen (on i386
>> it will happen if the CPU doesn't support clflush, but if it does, or on x86-64,
>> the flushing depends on the list of deferred pages being non-empty, which
>> can only happen when a large page gets re-combined). Is it assumed that
>> the callers additionally call tlb_flush_all() (I think none of them do)?
>
>Not sure I understand the question? global_flush_tlb is perhaps a little
>misnamed, but it only flushes the pages changed in change_page_attr.
>This works because it uses INVLPG which should ignore the G bits,
>so not additional global flush is needed.

That is the point - I don't see this invlpg. If you look at x86-64's
global_flush_tlb(), then you will note that it passes the list of pages grabbed
from deferred_pages. If that list has no entries, no single __flush_tlb_one
will be called, and the only place entries are added to this list is in
save_page(), which in turn only gets called if page_private(kpte_page) is
zero (i.e. the page was just reverted back to a big one).

This is also hardened by the fact that the flushing and the freeing of pages
happens walking the same list, hence only pages being freed get flushed.

Am I missing something here?

>> Further, change_page_attr()'s reference counting in a split large page's
>> page table appears to imply that attributes are only changed from or back to
>> the reference attributes, but not from one kind of non-default ones to the
>> same or another set of non-default ones (otherwise the reference count
>> will never again drop to zero), > and also not from default to default (i.e. the 
>> caller trying to revert attributes to normal not knowing what state they are
>> currently in) - this would BUG() if the large page was already reverted, or
>> screw the reference count otherwise. Is all of this intentional? I think it
>> will need to be changed as a prerequisite to supporting on-the-fly attribute
>> changes in the SMP alternatives code, which was requested as a follow-up
>> to the tightening of the CONFIG_DEBUG_RODATA effects.
>
>The reference count is just to count pages that have a non default attribute
>in the PMD range so that we know when to revert to a large page.
>
>For non default to another non default changes the count should not change.

That is what it should be, but it also gets bumped when a page already had
non-default attributes, because the increment just depends on
pgprot_val(prot) != pgprot_val(ref_prot) (but specifically not on the
attributes the page had before the change).

Jan
