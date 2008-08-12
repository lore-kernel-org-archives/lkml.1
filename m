Return-Path: <linux-kernel-owner+w=401wt.eu-S1753784AbYHLJdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbYHLJdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 05:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbYHLJda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 05:33:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:60623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbYHLJd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 05:33:29 -0400
From: Neil Brown <neilb@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 12 Aug 2008 19:33:16 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18593.22748.791219.689521@notabene.brown>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 02/30] mm: gfp_to_alloc_flags()
In-Reply-To: message from Peter Zijlstra on Tuesday August 12
References: <20080724140042.408642539@chello.nl>
	<20080724141529.408041430@chello.nl>
	<18593.6448.132048.150818@notabene.brown>
	<1218526385.10800.165.camel@twins>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday August 12, a.p.zijlstra@chello.nl wrote:
> On Tue, 2008-08-12 at 15:01 +1000, Neil Brown wrote:
> > Did I miss something?
> > If I did, maybe more text in the changelog entry (or the comment)
> > would help.
> 
> Ok, so the old code did:
> 
>   if (((p->flags & PF_MEMALLOC) || ...) && !in_interrupt) {
>     ....
>     goto nopage;
>   }
> 
> which avoid anything that has PF_MEMALLOC set from entering into direct
> reclaim, right?
> 
> Now, the new code reads:
> 
>   if (alloc_flags & ALLOC_NO_WATERMARK) {
>   }
> 
> Which might be false, even though we have PF_MEMALLOC set -
> __GFP_NOMEMALLOC comes to mind.
> 
> So we have to stop that recursion from happening.
> 
> so we add:
> 
>   if (p->flags & PF_MEMALLOC)
>     goto nopage;
> 
> Now, if it were done before the !wait check, we'd have to consider
> atomic contexts, but as those are - as you rightly pointed out - handled
> by the !wait case, we can plainly do this check.
> 
> 

Oh yes, obvious when you explain it, thanks.

cat << END >> Changelog

As the test
-	if (((p->flags & PF_MEMALLOC) || unlikely(test_thread_flag(TIF_MEMDIE)))
-			&& !in_interrupt()) {
-		if (!(gfp_mask & __GFP_NOMEMALLOC)) {
has been replaced with a slightly strong
+	if (alloc_flags & ALLOC_NO_WATERMARKS) {

we need to ensure we don't recurse when PF_MEMALLOC is set

END

??

Thanks,
NeilBrown
