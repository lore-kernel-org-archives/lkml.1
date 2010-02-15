Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932103Ab0BOT5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 14:57:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58866 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab0BOT5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:57:04 -0500
Date: Mon, 15 Feb 2010 20:57:13 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@suse.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, fengguang.wu@intel.com
Subject: Re: [PATCH 2/3] mm: Implement writeback livelock avoidance using
 page tagging
Message-ID: <20100215195713.GI3434@quack.suse.cz>
References: <1265929584-5080-1-git-send-email-jack@suse.cz>
 <1265929584-5080-3-git-send-email-jack@suse.cz>
 <20100212113955.4c023130.akpm@linux-foundation.org>
 <20100215154751.GG3434@quack.suse.cz>
 <20100215162127.GU5723@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100215162127.GU5723@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16-02-10 03:21:27, Nick Piggin wrote:
> On Mon, Feb 15, 2010 at 04:47:51PM +0100, Jan Kara wrote:
> > On Fri 12-02-10 11:39:55, Andrew Morton wrote:
> > > On Fri, 12 Feb 2010 00:06:23 +0100
> > > Jan Kara <jack@suse.cz> wrote:
> > > 
> > > > The idea is simple: Tag all pages that should be written back
> > > > with a special tag (TOWRITE) in the radix tree. This can be done
> > > > rather quickly and thus livelocks should not happen in practice.
> > > > Then we start doing the hard work of locking pages and sending
> > > > them to disk only for those pages that have TOWRITE tag set.
> > > 
> > > Adding a second pass across all the pages sounds expensive?
> >   Strictly speaking it's just through the radix tree and only through
> > branches with DIRTY_TAG set. But yes, there is some additional CPU cost.
> > I just thought that given the total cost of submitting a page it is
> > an acceptable increase and the simplification is worth it.
> >   Would some numbers make you happier? Any suggestion for measurements?
> > Because I think that even for writes to tmpfs the change will be lost
> > in the noise...
> 
> Although hmm, if it is a very large file with *lots* of dirty pages
> then it might become a noticable proportion of the cost.
> 
> Dave Chinner would probably tell you he's seen files with many
> gigabytes dirty, and what is nr_to_write set to? 1024 is it? So you
> might be tagging hundreds or thousands of radix tree entries per
> page you write.
  Hmm, this is a good point. My final aim is to remove the nr_to_write
logic so then the only case when we break out of the loop in
write_cache_pages early would be when ->writepage returns an error.
But until then what you describe can happen quite regularly.
  An obvious workaround is to limit the amount of tags transferred but that
might have to repeat retagging and it just gets ugly. Another solution
would be to remove the DIRTY tag as we set the TOWRITE tag. That might
actually work quite nicely what do you think?
  Finally, I could complement this series with patches substituting
nr_to_write logic but that would make the series considerably more
complicated and controverse so I rather wanted to do it in small steps...

> Also, I wonder what you think about leaving the tags dangling when
> the loop bails out early? I have a *slight* concern about this
> because previously we never have a tag set when radix_tree_delete
> is called. I actually had a bug in that code in earlier versions
> of rcu radix tree that only got found by the user test harness.
> And another slight concern that it is just a bit ugly to leave the
> tag. But I can accept that lower CPU overhead trumps ugliness :)
  I specifically checked __remove_from_page_cache -> radix_tree_delete
path to verify what happens and everything seems to handle that just
fine. BTW, note that cancel_dirty_page does not clear the radix tree
dirty tag either so during truncation radix_tree_delete will be called
with tagged pages as well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
