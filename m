Return-Path: <linux-kernel-owner+w=401wt.eu-S1767002AbXDEOJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767002AbXDEOJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 10:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766999AbXDEOJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 10:09:44 -0400
Received: from ns.suse.de ([195.135.220.2]:55854 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767002AbXDEOJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 10:09:43 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: discuss@x86-64.org
Subject: Re: [discuss] change_page_attr() and global_flush_tlb()
Date: Thu, 5 Apr 2007 16:09:31 +0200
User-Agent: KMail/1.9.6
Cc: "Jan Beulich" <jbeulich@novell.com>, linux-kernel@vger.kernel.org
References: <4614DE61.76E4.0078.0@novell.com> <200704051443.12505.ak@suse.de> <46151B4F.76E4.0078.0@novell.com>
In-Reply-To: <46151B4F.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704051609.31157.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007 15:52:47 Jan Beulich wrote:

> That is the point - I don't see this invlpg. If you look at x86-64's
> global_flush_tlb(), then you will note that it passes the list of pages grabbed
> from deferred_pages. If that list has no entries, no single __flush_tlb_one
> will be called, and the only place entries are added to this list is in
> save_page(), which in turn only gets called if page_private(kpte_page) is
> zero (i.e. the page was just reverted back to a big one).

You're right. This got broken when the code was changed to invlpg 
from global flush at some point. It has to flush in all cases,
but only wbinvd when the caching attributes changed. Will fix.

> >> Further, change_page_attr()'s reference counting in a split large page's
> >> page table appears to imply that attributes are only changed from or back to
> >> the reference attributes, but not from one kind of non-default ones to the
> >> same or another set of non-default ones (otherwise the reference count
> >> will never again drop to zero), > and also not from default to default (i.e. the 
> >> caller trying to revert attributes to normal not knowing what state they are
> >> currently in) - this would BUG() if the large page was already reverted, or
> >> screw the reference count otherwise. Is all of this intentional? I think it
> >> will need to be changed as a prerequisite to supporting on-the-fly attribute
> >> changes in the SMP alternatives code, which was requested as a follow-up
> >> to the tightening of the CONFIG_DEBUG_RODATA effects.
> >
> >The reference count is just to count pages that have a non default attribute
> >in the PMD range so that we know when to revert to a large page.
> >
> >For non default to another non default changes the count should not change.
> 
> That is what it should be, but it also gets bumped when a page already had
> non-default attributes, because the increment just depends on
> pgprot_val(prot) != pgprot_val(ref_prot) (but specifically not on the
> attributes the page had before the change).

I see.

-Andi
