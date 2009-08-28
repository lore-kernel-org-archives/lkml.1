Return-Path: <linux-kernel-owner+w=401wt.eu-S1753305AbZH1VnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbZH1VnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbZH1VnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:43:19 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:43604 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZH1VnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:43:18 -0400
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ulrich Drepper <drepper@redhat.com>, Jamie Lokier <jamie@shareable.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
In-Reply-To: <20090828212921.GA13662@infradead.org>
References: <20090827171044.GA5427@infradead.org>
	 <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org>
	 <4A98008B.6050503@redhat.com> <20090828161745.GA8755@infradead.org>
	 <4A9806D9.5050409@redhat.com> <20090828164106.GA9951@infradead.org>
	 <4A984337.7080009@redhat.com> <20090828210838.GA26799@infradead.org>
	 <1251494174.5984.2.camel@heimdal.trondhjem.org>
	 <20090828212921.GA13662@infradead.org>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 17:43:05 -0400
Message-Id: <1251495785.5984.13.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 12 msgs/h 2 sum rcpts/h 13 sum msgs/h 2 total rcpts 1247 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 9778ABE3FDF111B0F479F100E062C229D9E02292
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 196 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-28 at 17:29 -0400, Christoph Hellwig wrote:
> On Fri, Aug 28, 2009 at 05:16:14PM -0400, Trond Myklebust wrote:
> > On Fri, 2009-08-28 at 17:08 -0400, Christoph Hellwig wrote:
> > > #define O_SYNC	(O_FULLSYNC|O_DSYNC)
> > > 
> > >  - during the normal merge window I will add a real implementation for
> > >    for O_FULLSYNC and O_RSYNC
> > > 
> > > P.S. better naming suggestions for O_FULLSYNC welcome
> > 
> > Basically you are just ensuring that the metadata changes are being
> > synced together with the data changes, so how about O_ISYNC (inode
> > sync)?
> 
> Yeah.  Thinking about this a bit more we should define this flag
> much more clearly.  In the obvious implementation it would not actually
> do anything if it's set on it's own.  We would only check it if O_DSYNC
> is already set to decided if we want to set the datasync argument to
> ->fsync to 0 or 1 for the generic filesystems (and similar things for
> filesystems not using the generic helper).
> 
> If we deem that this is too unsafe we could make sure O_DSYNC always
> gets set on this fag in ->open, but if we make sure O_SYNC is defined
> like the one above in the kernel headers and glibc we should be fine.
> 
> Although in that case a name that doesn't suggest that it actually does
> something useful would be better.

If you are going to automatically set O_DSYNC in open(), then
fcntl(F_SETFL) might get a bit nasty.

Imagine using it after the open in order to clear the O_ISYNC flag;
you'll still be left with the O_DSYNC (which you never set in the first
place). That would be confusing...

Cheers
  Trond

