Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbYCKPLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbYCKPLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 11:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753585AbYCKPLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 11:11:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46180 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbYCKPLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 11:11:24 -0400
Date: Tue, 11 Mar 2008 16:11:23 +0100
From: Jan Kara <jack@suse.cz>
To: Andreas Dilger <adilger@sun.com>
Cc: Duane Griffin <duaneg@dghda.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
       sct@redhat.com, akpm@linux-foundation.org
Subject: Re: [RFC, PATCH 6/6] ext3: do not write to the disk when mounting a dirty read-only filesystem
Message-ID: <20080311151122.GD6544@atrey.karlin.mff.cuni.cz>
References: <a047dfbd7855d5f484ae8a3434f6a073302505be.1204685366.git.duaneg@dghda.com> <f4577a0cc4262de0fbff02cae3858d2e2edfaaea.1204685366.git.duaneg@dghda.com> <20080306071734.GN3616@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306071734.GN3616@webber.adilger.int>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mar 06, 2008  01:59 +0000, Duane Griffin wrote:
> > NOTE: For now I'm simply preventing filesystems requiring recovery from being
> > remounted read-write. This breaks booting with an uncleanly mounted root
> > filesystem!
> 
> I was going to ask about this - not being able to remount rw is a serious
> problem because many users have only the root filesystem and this
> limitation basically prevents this patch from being landable.
> 
> I'd suggest if the filesystem is going to be remounted read/write that
> the journal mapping be discarded and the journal replayed.  Depending
> on how you do the mapping it may be necessary to invalidate all of the
> pages in the cache so that they don't reference the blocks in the journal.
  Actually, this is nastier than it looks - currently fs, asks
ext3_sb_getblk() for block 'a' and it gets buffer head with b_blocknr == 'b'
instead. So when remounting you'd have to rewrite these buffers with
original block numbers which is not really possible. So I think
remapping will have to be solved differently, like providing buffer
head with correct b_blocknr but taking care when reading data to it and
reading them from elsewhere. Actually, this has to be done anyway
because JBD escapes data in the journal and you have to do unescaping
when reading data...


								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
