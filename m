Return-Path: <linux-kernel-owner+w=401wt.eu-S1765902AbYA2Q26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765902AbYA2Q26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 11:28:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbYA2Q2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 11:28:46 -0500
Received: from relay2.sgi.com ([192.48.171.30]:53659 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751495AbYA2Q2p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 11:28:45 -0500
Date: Tue, 29 Jan 2008 10:28:41 -0600
From: Robin Holt <holt@sgi.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       Nick Piggin <npiggin@suse.de>, kvm-devel@lists.sourceforge.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, steiner@sgi.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 3/6] mmu_notifier: invalidate_page callbacks for
	subsystems with rmap
Message-ID: <20080129162841.GW3058@sgi.com>
References: <20080128202840.974253868@sgi.com> <20080128202924.095881796@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128202924.095881796@sgi.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't understand how this is intended to work.  I think the page flag
needs to be maintained by the mmu_notifier subsystem.

Let's assume we have a mapping that has a grant from xpmem and an
additional grant from kvm.  The exporters are not important, the fact
that there may be two is.

Assume that the user revokes the grant from xpmem (we call that
xpmem_remove).  As far as xpmem is concerned, there are no longer any
exports of that page so the page should no longer have its exported
flag set.  Note: This is not a process exit, but a function of xpmem.

In that case, at the remove time, we have no idea whether the flag should
be cleared.

For the invalidate_page side, I think we should have:
> @@ -473,6 +474,10 @@ int page_mkclean(struct page *page)
>  		struct address_space *mapping = page_mapping(page);
>  		if (mapping) {
>  			ret = page_mkclean_file(mapping, page);
> +			if (unlikely(PageExternalRmap(page))) {
> +				mmu_rmap_notifier(invalidate_page, page);
> +				ClearPageExternalRmap(page);
> +			}
>  			if (page_test_dirty(page)) {
>  				page_clear_dirty(page);
>  				ret = 1;

I would assume we would then want a function which sets the page flag.

Additionally, I would think we would want some intervention in the
freeing of the page side to ensure the page flag is cleared as well.

Thanks,
Robin
