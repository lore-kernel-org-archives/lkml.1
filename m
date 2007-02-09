Return-Path: <linux-kernel-owner+w=401wt.eu-S1946173AbXBIHQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946173AbXBIHQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 02:16:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946170AbXBIHQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 02:16:56 -0500
Received: from styx.suse.cz ([82.119.242.94]:57551 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946173AbXBIHQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 02:16:55 -0500
Date: Fri, 9 Feb 2007 08:19:55 +0100
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Direct IO for fat
Message-ID: <20070209071955.GB5433@duck.suse.cz>
References: <20070208112808.GA3767@duck.suse.cz> <87k5ysfyd5.fsf@duaron.myhome.or.jp> <20070208161001.GB3767@duck.suse.cz> <87wt2sd2m8.fsf@duaron.myhome.or.jp> <20070208173515.GB3780@duck.suse.cz> <20070208184104.GA24986@atrey.karlin.mff.cuni.cz> <873b5g2zq9.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873b5g2zq9.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 09-02-07 04:53:02, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> >> > -> blockdev_direct_IO()
> >> >   -> direct_io_worker()
> >> >     -> do_direct_IO()
> >> >       -> get_more_blocks()
> >> > 
> >> > 		create = dio->rw & WRITE;
> >>   Here, create == 1.
> >> 
> >> > 		if (dio->lock_type == DIO_LOCKING) {
> >> > 			if (dio->block_in_file < (i_size_read(dio->inode) >>
> >> > 							dio->blkbits))
> >> > 				create = 0;
> >>   But here create was reset back to 0 - exactly because
> >> dio->block_in_file > i_size...
> >   Obviously, I'm blind and you're right ;) This test is not satisfied
> > and so create == 1.
> >   But still it would seem better to me to return 0 from fat_direct_IO()
> > instead of EINVAL so that write falls back to a buffered one, instead
> > returning the error...
> 
> I see. When I wrote this, I thought kernel should use DIO to write if
> user sets O_DIRECT. Because the wrong alignment request isn't fallback
> to buffered-write, and it's also returns EINVAL.
  I understand. It's just that I've got some surprised users who could not
track why the hell does write() return EINVAL to them when they have
everything alligned and the same code works for EXT3 :). Of course, nothing
guarantees that FAT should behave the same way as EXT3 but I can understand
they were surprised (I had to look in the code too).
  I also don't have a strong opinion whether we should fallback to buffered
write automagically or whether we should return EINVAL and let the user fall
back to the buffered write himself. But I'd slightly prefer the first
option.

									Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
