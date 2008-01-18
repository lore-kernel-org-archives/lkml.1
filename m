Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbYARGnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbYARGnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 01:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYARGnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 01:43:23 -0500
Received: from smtp-out.google.com ([216.239.45.13]:53041 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYARGnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 01:43:22 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Do7aG/crVq76J5lKiJPalSV1rsD/HaASBjXJeFkMVot0fhzmO+cyEtDsqEK6Alrto
	XfruKyBBl32jIEJ0k4LtQ==
Message-ID: <532480950801172243i21341a02s983a9e59b182c53e@mail.gmail.com>
Date: Thu, 17 Jan 2008 22:43:15 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: [patch] Converting writeback linked lists to a tree based data structure
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <400632190.14601@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080115080921.70E3810653@localhost> <400562938.07583@ustc.edu.cn>
	 <532480950801171307q4b540ewa3acb6bfbea5dbc8@mail.gmail.com>
	 <400632190.14601@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 17, 2008 8:56 PM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:

Once again thanks for the speedy replies. :-)

> On Thu, Jan 17, 2008 at 01:07:05PM -0800, Michael Rubin wrote:
> Suppose we want to grant longer expiration window for temp files,
> adding a new list named s_dirty_tmpfile would be a handy solution.

When you mean tmp do you mean files that eventually get written to
disk? If not I would just use the WRITEBACK_NEVER. If so I am not sure
if that feature is worth making a special case. It seems like the
location based ideas may be more useful.

> So the question is: should we need more than 3 QoS classes?
>
> > > The most tricky writeback issues could be starvation prevention
> > > between
> >
> >
> > >         - small/large files
> > >         - new/old files
> > >         - superblocks
> >
> > So I have written tests and believe I have covered these issues. If
> > you are concerned in specific on any and have a test case please let
> > me know.
>
> OK.
>
> > > Some kind of limit should be applied for each. They used to be:
> > >         - requeue to s_more_io whenever MAX_WRITEBACK_PAGES is reached
> > >           this preempts big files
> >
> > The patch uses th same limit.
> >
> > >         - refill s_io iif it is drained
> > >           this prevents promotion of big/old files
> >
> > Once a big file gets its first do_writepages it is moved behind the
> > other smaller files via i_flushed_when. And the same in reverse for
> > big vs old.
>
> You mean i_flush_gen?

Yeah sorry. It was once called i_flush_when. (sheepish)

> No, sync_sb_inodes() will abort on every
> MAX_WRITEBACK_PAGES, and s_flush_gen will be updated accordingly.
> Hence the sync will restart from big/old files.

If I understand you correctly I am not sure I agree. Here is what I
think happens in the patch:

1) pull big inode off of flush tree
2) sync big inode
3) Hit MAX_WRITEBACK_PAGES
4) Re-insert big inode (without modifying the dirtied_when)
5) update the i_flush_gen on big inode and re-insert behind small
inodes we have not synced yet.

In a subsequent sync_sb_inode we end up retrieving the small inode we
had not serviced yet.

> > >         - return from sync_sb_inodes() after one go of s_io
> >
> > I am not sure how this limit helps things out. Is this for superblock
> > starvation? Can you elaborate?
>
> We should have a way to go to next superblock even if new dirty inodes
> or pages are emerging fast in this superblock. Fill and drain s_io
> only once and then abort helps.

Got it.

> s_io is a stable and bounded working set in one go of superblock.

Is this necessary with MAX_WRITEBACK_PAGES? It feels like a double limit.

> Basically you make one list_head in each rbtree node.
> That list_head is recycled cyclic, and is an analog to the old
> fashioned s_dirty. We need to know 'where we are' and 'where it ends'.
> So an extra indicator must be introduced - i_flush_gen. It's awkward.
> We are simply repeating the aged list_heads' problem.

To me they both feel a little awkward. I feel like the original
problem in 2.6.23 led to a lot of examination which is bringing new
possibilities to light.

BTW the issue that started me on this whole path (starving large
files) was still present in 2.6.23-rc8 but now looks fixed in
2.6.24-rc3.
Still no idea about your changes in 2.6.24-rc6-mm1. I have given up
trying to get that thing to boot.

mrubin
