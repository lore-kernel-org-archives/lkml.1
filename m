Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbZANONs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbZANONs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:13:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758643AbZANONh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:13:37 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:51849 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753272AbZANONg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:13:36 -0500
Date: Wed, 14 Jan 2009 09:12:04 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Jan Kara <jack@suse.cz>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090114141204.GD6222@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu> <20090113143011.GB10064@duck.suse.cz> <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp> <20090114103532.GA18834@duck.suse.cz> <20090114132146.GC6222@mit.edu> <20090114140532.GC19950@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114140532.GC19950@duck.suse.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 03:05:32PM +0100, Jan Kara wrote:
> On Wed 14-01-09 08:21:46, Theodore Tso wrote:
> > 
> > If we optimize out the journal commit when there are no blocks
> > attached to the transaction, we could change the patch to only force a
> > flush if inode->i_state did not have I_DIRTY before the call to
> > sync_inode().  Does that sound sane?
>   Yes. And also add a flush in case of fdatasync().

Um, we have that already; the sync_inode() followed by
blkdev_issue_flush() is the path taken by fdatasync(), I do believe.

>   Well, I thought that a barrier, as an abstraction, only guarantees that
> any IO which happened before the barrier hits the iron before any IO which
> has been submitted after a barrier. This is actually enough for a
> journalling to work correctly but it's not enough for fsync() guarantees.
> But I might be wrong...

Ah, yes, that's what you're getting at.  True, but for better or for
worse, we have no other interface other than blkdev_issue_flush().
This will guarantee that the data has made it to the disk controller,
but it won't necessarily guarantee that it will have made it onto the
disk platter, as I understand things; but I don't think we have any
other interfaces available to us at this point.

						- Ted
