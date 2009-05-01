Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbZEAScB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbZEAScB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 14:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760906AbZEASbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 14:31:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756028AbZEASbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 14:31:47 -0400
Date: Fri, 1 May 2009 11:26:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <josef@redhat.com>
Cc: Josef Bacik <jbacik@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com, stable@kernel.org
Subject: Re: [PATCH] fiemap: fix problem with setting FIEMAP_EXTENT_LAST
Message-Id: <20090501112630.c6c05dd4.akpm@linux-foundation.org>
In-Reply-To: <20090501133226.GE7076@unused.rdu.redhat.com>
References: <1241113491-9031-1-git-send-email-jbacik@redhat.com>
	<20090430154047.5485759f.akpm@linux-foundation.org>
	<20090501133226.GE7076@unused.rdu.redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 09:32:26 -0400 Josef Bacik <josef@redhat.com> wrote:

> On Thu, Apr 30, 2009 at 03:40:47PM -0700, Andrew Morton wrote:
> > On Thu, 30 Apr 2009 13:44:51 -0400
> > Josef Bacik <jbacik@redhat.com> wrote:
> > 
> > > This patch fixes a problem where the generic block based fiemap stuff would not
> > > properly set FIEMAP_EXTENT_LAST on the last extent.  I've reworked things to
> > > keep track if we go past the EOF, and mark the last extent properly.  The
> > > problem was reported by and tested by Eric Sandeen.
> > > 
> > 
> > bleeearrggh.  __generic_block_fiemap() needs to be dragged out, shot,
> > stabbed and doused in gasoline.
> > 
> > - uses stupid helper macros (blk_to_logical, logical_to_blk), thus
> >   carefully obscuring the types of their incoming args and return value.
> >
> 
> I did this to make it a bit more cleaner, so I didn't have a bunch of 
> 
> (blk << (inode)->i_blkbits)
> 
> type statements everywhere.  Do you have a better suggestion?  Would you like an
> inline function, or do you want me to pepper the function with this stuff?

An inline would be much better - the C type information in this sort of
code can be a big help if well-used.

> > - Uses random and seemingly irrational mixture of u64's and `long
> >   long's, thus carefully confusing readers who would prefer to see
> >   loff_t, sector_t, etc so they have a fighting chance of understanding
> >   what the hell the thing does.
> >
> 
> Hrm well I needed the long long to see if we mapped past where we wanted to, but
> I can do that a different way.  I will fix this as well.

It's useful to choose the appopriate type, if it exists.

What does this long-long actually contain?  A file offset?  If so, use
loff_t.  A block number?  Use sector_t.  etc.

Also, when you have a function which has a large number of locals (and
__generic_block_fiemap has 16!), comment them!  The thing which pips me
of about the

	int a, b, c, d, e;

style is that it leaves no room for comments.  Look:

	loff_t a;	/* offset in file */
	sector_t b;	/* relative block number in extent */

etc.

> > Does this bugfix need to be backported into 2.6.29?  Earlier?  If so, why?
> >
> 
> Yes it does, it will screw anybody up who tries to use fiemap beyond just the
> simple cases.

OK.

> I will send you a updated patch shortly.  Thanks for the review,

I don't believe the patch needed updating, did it?  At this stege we'd
be best off with a minimal fixup for -stable and for 2.6.30.

