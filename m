Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbZHHLQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbZHHLQN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 07:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756129AbZHHLQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 07:16:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34850 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbZHHLQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 07:16:11 -0400
Date: Sat, 8 Aug 2009 07:15:56 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, hch@infradead.org, rlove@google.com,
       msb@google.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 3/4] vfs: change sb->s_maxbytes to a loff_t
Message-ID: <20090808071556.593c2fe9@tlielax.poochiereds.net>
In-Reply-To: <20090807225146.GC28019@cmpxchg.org>
References: <1249671461-9071-1-git-send-email-jlayton@redhat.com>
	<1249671461-9071-4-git-send-email-jlayton@redhat.com>
	<20090807225146.GC28019@cmpxchg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Aug 2009 00:51:46 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Fri, Aug 07, 2009 at 02:57:40PM -0400, Jeff Layton wrote:
> > sb->s_maxbytes is supposed to indicate the maximum size of a file that
> > can exist on the filesystem. It's declared as an unsigned long long.
> > 
> > Even if a filesystem has no inherent limit that prevents it from using
> > every bit in that unsigned long long, it's still problematic to set it
> > to anything larger than MAX_LFS_FILESIZE. A lot of places implicitly
> > cast s_maxbytes to a signed value when doing comparisons against it
> > (usually using loff_t on the other side of the comparison). If it's
> > set too large then this cast makes it a negative number and generally
> > breaks the comparison.
> > 
> > Change s_maxbytes to be loff_t instead. That should help eliminate the
> > temptation to set it too large by making it a signed value.
> > 
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  fs/super.c         |   10 ++++++++++
> >  include/linux/fs.h |    2 +-
> >  2 files changed, 11 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/super.c b/fs/super.c
> > index 2761d3e..929d55d 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -889,6 +889,16 @@ vfs_kern_mount(struct file_system_type *type, int flags, const char *name, void
> >   	if (error)
> >   		goto out_sb;
> >  
> > +	/*
> > +	 * filesystems should never set s_maxbytes larger than MAX_LFS_FILESIZE
> > +	 * but s_maxbytes was an unsigned long long for many releases. Throw
> > +	 * this warning for a little while to try and catch filesystems that
> > +	 * violate this rule. This warning can be removed in 2.6.34.
> > +	 */
> > +	WARN(((unsigned long long) mnt->mnt_sb->s_maxbytes > MAX_LFS_FILESIZE),
> > +		"WARNING: %s sets sb->s_maxbytes too large (%llu)", type->name,
> > +		(unsigned long long) mnt->mnt_sb->s_maxbytes);
> 
> Since it's signed now, you could just check for it being < 0, no?
> 

Sure, that works too and is probably a little cleaner. I'll change it
in the next respin to do that.

> I don't like the warning much, though.  It seems to be a random check
> for a bug that has been fixed now.  We don't check other errors from
> ->get_sb() either.

Ordinarily, I'd agree with this, but we're changing the type of
s_maxbytes. It's possible that:

A) I missed something in one of the more complex s_maxbytes calculations.

B) Out of tree filesystems are broken in this way and don't realize it.

I think it makes some sense to burn a couple of CPU cycles in the mount
codepath for a few releases to try and catch both of these cases. If we
don't warn this way, then this change could result in more subtle
breakage.

-- 
Jeff Layton <jlayton@redhat.com>
