Return-Path: <linux-kernel-owner+w=401wt.eu-S1422847AbXCOGMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422847AbXCOGMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 02:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422843AbXCOGMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 02:12:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:21357 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422838AbXCOGMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 02:12:08 -0400
Date: Wed, 14 Mar 2007 23:11:46 -0700
From: Mark Fasheh <mark.fasheh@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 2/5] fs: introduce new aops and infrastructure
Message-ID: <20070315061146.GD21942@ca-server1.us.oracle.com>
Reply-To: Mark Fasheh <mark.fasheh@oracle.com>
References: <20070314112529.13798.35417.sendpatchset@linux.site> <20070314112540.13798.97719.sendpatchset@linux.site> <20070315041329.GB21942@ca-server1.us.oracle.com> <20070315043642.GF15069@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315043642.GF15069@wotan.suse.de>
Organization: Oracle Corporation
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 05:36:42AM +0100, Nick Piggin wrote:
> > Are we going to get rid of the file and intr arguments btw? I'm not sure
> > intr is useful, and mapping is probably enough to get whatever we inside
> > ->write_begin / ->write_end.
> 
> Yeah, I was going to, but I had this version ready to go so decided
> to leave them in at the last minute. We can definitely take them out
> if people agree.
> 
> However a side note about intr -- I wonder if it might be wise to
> include a flags argument, in case we might want to add something like
> that later? (definitely if we do keep intr, then it should be done as
> a flag rather than its own int).

I don't see a problem with having a flags argument. It could give us some
flexibility in the future which would otherwise require a much bigger
update. If we found out that we needed intr, it could just be a flag.


> > One interesting side effect is that we no longer pass AOP_TRUNCATE_PAGE up a
> > level. This gives callers less to deal with. And it means that ocfs2 doesn't
> > have to use the ocfs2_*_lock_with_page() cluster lock variants in
> > ocfs2_block_write_begin() because it can order cluster locks outside of the
> > page lock there.
> 
> OK that's very cool. I was hoping that would be the case. If GFS2 can
> avoid that too, then we might be able to get rid of AOP_TRUNCATE_PAGE
> handling from the legacy prepare/commit_write paths, which will make
> them simpler.

Yeah - so long as we're not taking a page fault between write_begin /
write_end, there's no reason for the cluster locks to be taken and dropped
within the individual callbacks, which means we can just take them in
write_begin (where page lock ordering is possible) and hold them until
write_end is called.


> OK, well I'll add this to my queue for now, and post the full patchset
> after incorporating feedback I've had so far, and doing more testing,
> so people can actually apply them and boot kernels.

Great, thanks - it just occured to me that I should be holding the clusters
locks across the entire copy (as I point out above), so I'll have a slightly
updated version of this patch for you soon :)
	--Mark

--
Mark Fasheh
Senior Software Developer, Oracle
mark.fasheh@oracle.com
