Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbZANOiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbZANOiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZANOh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:37:58 -0500
Received: from styx.suse.cz ([82.119.242.94]:53465 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753155AbZANOh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:37:58 -0500
Date: Wed, 14 Jan 2009 15:37:56 +0100
From: Jan Kara <jack@suse.cz>
To: Theodore Tso <tytso@mit.edu>,
       Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090114143756.GF19950@duck.suse.cz>
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu> <20090113143011.GB10064@duck.suse.cz> <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp> <20090114103532.GA18834@duck.suse.cz> <20090114132146.GC6222@mit.edu> <20090114140532.GC19950@duck.suse.cz> <20090114141204.GD6222@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114141204.GD6222@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 14-01-09 09:12:04, Theodore Tso wrote:
> On Wed, Jan 14, 2009 at 03:05:32PM +0100, Jan Kara wrote:
> > On Wed 14-01-09 08:21:46, Theodore Tso wrote:
> > > 
> > > If we optimize out the journal commit when there are no blocks
> > > attached to the transaction, we could change the patch to only force a
> > > flush if inode->i_state did not have I_DIRTY before the call to
> > > sync_inode().  Does that sound sane?
> >   Yes. And also add a flush in case of fdatasync().
> 
> Um, we have that already; the sync_inode() followed by
> blkdev_issue_flush() is the path taken by fdatasync(), I do believe.
  Maybe ext4-patch-queue changes that area but in Linus's tree I see:

  if (datasync && !(inode->i_state & I_DIRTY_DATASYNC))
         goto out;

  So if we just overwrite some data, we send them to disk via fdatawrite()
and then we quickly bail out from ext4_sync_file() without doing
blkdev_issue_flush().

> >   Well, I thought that a barrier, as an abstraction, only guarantees that
> > any IO which happened before the barrier hits the iron before any IO which
> > has been submitted after a barrier. This is actually enough for a
> > journalling to work correctly but it's not enough for fsync() guarantees.
> > But I might be wrong...
> 
> Ah, yes, that's what you're getting at.  True, but for better or for
> worse, we have no other interface other than blkdev_issue_flush().
> This will guarantee that the data has made it to the disk controller,
> but it won't necessarily guarantee that it will have made it onto the
> disk platter, as I understand things; but I don't think we have any
> other interfaces available to us at this point.
  As Jens wrote, it seems barrier guarantees more than I thought so we are
correct.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
