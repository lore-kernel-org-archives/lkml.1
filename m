Return-Path: <linux-kernel-owner+w=401wt.eu-S1754855AbZHDMAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855AbZHDMAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 08:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754530AbZHDMAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 08:00:20 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:49267 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516AbZHDMAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 08:00:19 -0400
X-Trace: 237173315/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.71.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.71.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuEEANu/d0pPRUfF/2dsb2JhbACBUtNJhBgFgjI
X-IronPort-AV: E=Sophos;i="4.43,321,1246834800"; 
   d="scan'208";a="237173315"
Date: Tue, 4 Aug 2009 13:00:07 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Brice Goglin <Brice.Goglin@inria.fr>
cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: get_user_pages() stores ERR_PTR() in pages[i] on
 failure
In-Reply-To: <4A780FE6.9050704@inria.fr>
Message-ID: <Pine.LNX.4.64.0908041245260.17734@sister.anvils>
References: <c384c5ea0908030823y494ee8bei85aa62c1470fa3ec@mail.gmail.com> 
 <Pine.LNX.4.64.0908031724200.2296@sister.anvils>  <4A77FCFB.9020001@inria.fr>
 <c384c5ea0908040259k4295c986wdd45fe9e1e4315b1@mail.gmail.com>
 <4A780FE6.9050704@inria.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Aug 2009, Brice Goglin wrote:
> 
> >> I wonder if we should change get_user_pages to store ERR_PTR(ret)
> >> in page[i] when it fails to get page #i.
> >>     
> > Yes, I would see that as an improvement in finding out why rc <
> > nr_pages, in case rc > 0.
> >
> > Also I think it does not break existing users.
> >   
> 
> Only compile-tested (and not in the nommu case).
> 
> 
> 
> 
> When get_user_pages() fails to get a non-first page, it returns
> the number of successfully gotten pages. The caller has to call
> get_user_pages() again on the failed page to figure out the
> error code.
> 
> Store the error code with ERR_PTR() in pages[i] when we fail
> to get page #i.
> 
> The arch specific get_user_pages_fast() do not need to be changed
> since they revert to the main get_user_pages() on failure.
> 
> Signed-off-by: Brice Goglin <Brice.Goglin@inria.fr>

This is a nice idea, and it looks like a good patch to implement
it, and I wish get_user_pages() had done that from the start, but...

... some callers of get_user_pages() might expect it not to touch
entries in the page array beyond the fail point: for example, they
might start off with a zeroed array, then when they come to put_page
on the array afterwards, would skip any NULL entries found - without
having to have noted the returned number of pages.  I don't think
that way of working is supported by any guarantee in documentation,
but it's not unreasonable to expect it to behave in that way.

If there were nothing intree which worked that way, then I'd
say let's go ahead with your nice patch.  But I soon reached
drivers/gpu/drm/ttm/ttm_tt.c then drivers/gpu/drm/via/via_dmablit.c
which both appear to work in that way.  I've not looked beyond them,
but I suspect those two cases amount to a NAK on your patch, sadly.
Of course we _could_ fix individual callers to work with it, but
for me they sound a warning that it's too late to change now.

Hugh
