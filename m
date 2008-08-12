Return-Path: <linux-kernel-owner+w=401wt.eu-S1752024AbYHLFCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbYHLFCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYHLFBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:01:53 -0400
Received: from ns1.suse.de ([195.135.220.2]:52352 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbYHLFBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:01:52 -0400
From: Neil Brown <neilb@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 12 Aug 2008 15:01:36 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18593.6448.132048.150818@notabene.brown>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 02/30] mm: gfp_to_alloc_flags()
In-Reply-To: message from Peter Zijlstra on Thursday July 24
References: <20080724140042.408642539@chello.nl>
	<20080724141529.408041430@chello.nl>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday July 24, a.p.zijlstra@chello.nl wrote:
> Factor out the gfp to alloc_flags mapping so it can be used in other places.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  mm/internal.h   |   10 +++++
>  mm/page_alloc.c |   95 +++++++++++++++++++++++++++++++-------------------------
>  2 files changed, 64 insertions(+), 41 deletions(-)

This patch all looks "obviously correct" and a nice factorisation of
code, except the last little bit:

> @@ -1618,6 +1627,10 @@ nofail_alloc:
>  	if (!wait)
>  		goto nopage;
>  
> +	/* Avoid recursion of direct reclaim */
> +	if (p->flags & PF_MEMALLOC)
> +		goto nopage;
> +
>  	cond_resched();
>  
>  	/* We now go into synchronous reclaim */
> 
> -- 

I don't remember seeing it before (though my memory is imperfect) and
it doesn't seem to fit with the rest of the patch (except spatially).

There is a test above for PF_MEMALLOC which will result in a "goto"
somewhere else unless "in_interrupt()".
There is immediately above a test for "!wait".
So the only way this test can fire is when in_interrupt and wait.
But if that happens, then the
	might_sleep_if(wait)
at the top should have thrown a warning...  It really shouldn't happen.

So it looks like it is useless code:  there is already protection
against recursion in this case.

Did I miss something?
If I did, maybe more text in the changelog entry (or the comment)
would help.

Thanks,
NeilBrown
