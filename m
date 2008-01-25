Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbYAYMnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbYAYMnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 07:43:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754575AbYAYMnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 07:43:42 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:53821 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754194AbYAYMnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 07:43:41 -0500
Date: Fri, 25 Jan 2008 06:43:38 -0600
From: Robin Holt <holt@sgi.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Christoph Lameter <clameter@sgi.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 0/4] [RFC] MMU Notifiers V1
Message-ID: <20080125124338.GN26420@sgi.com>
References: <20080125055606.102986685@sgi.com> <20080125114229.GA7454@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080125114229.GA7454@v2.random>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 12:42:29PM +0100, Andrea Arcangeli wrote:
> On a technical merit this still partially makes me sick and I think
> it's the last issue to debate.
> 
> @@ -971,6 +974,9 @@ int try_to_unmap(struct page *page, int 
>         else
>                 ret = try_to_unmap_file(page, migration);
> 
> +       if (unlikely(PageExternalRmap(page)))
> +               mmu_rmap_notifier(invalidate_page, page);
> +
>         if (!page_mapped(page))
>                 ret = SWAP_SUCCESS;
>         return ret;
> 
> I find the above hard to accept, because the moment you work with
> physical pages and not "mm+address" I think you couldn't possibly care
> if page_mapped is true or false, and I think the above notifier should
> be called _outside_ try_to_unmap. Infact I'd call
> mmu_rmap_notifier(invalidate_page, page); only if page_unmapped is
> false and the linux pte is gone already (practically just before the
> page_count == 2 check and after try_to_unmap).

How does the called process sleep or how does it coordinate async work
with try_to_unmap?  We need to sleep.

On a seperate note, I think the page flag needs to be set by the process
when it is acquiring the page for export.  But since the same page could
be acquired by multiple export mechanisms, we should not clear it in the
exporting driver, but rather here after all exportors have been called
to invalidate_page.

That lead me to believe we should add a flag to get_user_pages() that
indicates this is an export with external rmap.  We could then set the
page flag in get_user_pages.

Thanks,
Robin
