Return-Path: <linux-kernel-owner+w=401wt.eu-S1762626AbZANNYi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762626AbZANNYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 08:24:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757666AbZANNY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 08:24:29 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:39896 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757581AbZANNY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 08:24:28 -0500
Date: Wed, 14 Jan 2009 08:21:46 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Jan Kara <jack@suse.cz>
Cc: Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090114132146.GC6222@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	Fernando Luis =?iso-8859-1?Q?V=E1zquez?= Cao <fernando@oss.ntt.co.jp>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>, sandeen@redhat.com
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu> <20090113143011.GB10064@duck.suse.cz> <1231904239.11640.38.camel@sebastian.kern.oss.ntt.co.jp> <20090114103532.GA18834@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114103532.GA18834@duck.suse.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 11:35:33AM +0100, Jan Kara wrote:
>   Yes, I noticed that yesterday as well. But then I was puzzled why ext4
> would need the flush where it has it... sync_inode() has started and
> committed a transaction which issued a barrier when the commit was done.

You're right; I'm not convinced we need the flush in ext4 (or ext3) at
all.  We write the data blocks, *then* we call ext4_write_inode(),
which will force a commit.  Now, if we apply that patch which
optimizes out commits if there are no dirty blocks, then we'll be
trouble, because we won't know for sure whether or not
ext4_write_inode() will have forced a journal commit.

If we optimize out the journal commit when there are no blocks
attached to the transaction, we could change the patch to only force a
flush if inode->i_state did not have I_DIRTY before the call to
sync_inode().  Does that sound sane?

> The only reason I could imagine is that barrier (although it is usually
> translated to flushing writeback caches) actually means just an ordering
> requirement and hence does not necessarily mean that the caches are
> properly flushed. Is that so Eric?

I'm not sure what you mean; if the barrier operation isn't flushing
all of the caches all the way out to the iron oxide, it's not going to
be working properly no matter where it is being called, whether it's
in ext4_sync_file() or in jbd2's journal_submit_commit_record().

						- Ted
