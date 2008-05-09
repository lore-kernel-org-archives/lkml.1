Return-Path: <linux-kernel-owner+w=401wt.eu-S933113AbYEISAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933113AbYEISAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 14:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755957AbYEISAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 14:00:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:45411 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755617AbYEISAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 14:00:23 -0400
Date: Fri, 9 May 2008 11:00:22 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Olaf Weber <olaf@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, npiggin@suse.de
Subject: Re: Spinlocks waiting with interrupts disabled / preempt disabled.
In-Reply-To: <1210355814.13978.255.camel@twins>
Message-ID: <Pine.LNX.4.64.0805091059050.19252@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com> 
 <20080507073017.GJ32195@elte.hu>  <bzymymzv3j7.fsf@fransum.emea.sgi.com>
 <1210355814.13978.255.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2008, Peter Zijlstra wrote:

> > A third solution would be to look at this problem on a case-by-case
> > basis.  In the case under discussion, there may be other kernel bugs
> > that aggravate the problem (it is an old kernel after all) and maybe
> > this just means the address_space.tree_lock ought to be replaced with
> > something else (though I wouldn't claim to know what).
> 
> That has been done by Nick Piggin, the lockless pagecache work removes
> the read side of the tree_lock.

When is that going to get merged? find_get_page is still:

struct page * find_get_page(struct address_space *mapping, pgoff_t offset)
{
        struct page *page;

        read_lock_irq(&mapping->tree_lock);
        page = radix_tree_lookup(&mapping->page_tree, offset);
        if (page)
                page_cache_get(page);
        read_unlock_irq(&mapping->tree_lock);
        return page;
}
EXPORT_SYMBOL(find_get_page);

