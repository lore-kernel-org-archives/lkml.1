Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbXBHSlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbXBHSlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 13:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752422AbXBHSlH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 13:41:07 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46183 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbXBHSlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 13:41:06 -0500
Date: Thu, 8 Feb 2007 19:41:04 +0100
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Direct IO for fat
Message-ID: <20070208184104.GA24986@atrey.karlin.mff.cuni.cz>
References: <20070208112808.GA3767@duck.suse.cz> <87k5ysfyd5.fsf@duaron.myhome.or.jp> <20070208161001.GB3767@duck.suse.cz> <87wt2sd2m8.fsf@duaron.myhome.or.jp> <20070208173515.GB3780@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070208173515.GB3780@duck.suse.cz>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri 09-02-07 01:40:31, OGAWA Hirofumi wrote:
> > Jan Kara <jack@suse.cz> writes:
> > 
> > >> FAT has to fill the hole completely, but DIO doesn't seems to do.
> > >> 
> > >> e.g.
> > >>         fd = open("file", O_WRONLY | O_CREAT | O_TRUNC);
> > >>         write(fd, buf, 512);
> > >>         lseek(fd, 10000, SEEK_SET);
> > >>         write(fd, buf, 512);
> > >> 
> > >> We need to allocate the blocks on 512 ~ 10000, and fill it with zero.
> > >> However, I think DIO doesn't fill it. If I'm missing something, please
> > >> let me know, I'll kill that check.
> > >   I know. DIO doesn't do it. But the point is that if blockdev_direct_IO
> > > finds out it should allocate new blocks, it exits without allocating them.
> > > Then in __generic_file_aio_write_nolock() if we find out that we did not
> > > write everything in generic_file_direct_write(), we just call
> > > generic_file_buffered_write() to write the unwritten part.
> > >   Hence, in case you describe above, the second write() finds out that
> > > block is not allocated and eventually everything falls back to calling
> > > generic_file_buffered_write() which calls prepare_write() and everything is
> > > happy.
> > 
> > I see. But sorry, I can't see where is preventing it... Finally, I
> > think we do the following on second write(2).
> > 
> > This is write, so create == 1, and ->lock_type == DIO_LOCKING,
> > and dio->block_in_file > ->i_size, so DIO callback fat_get_block() with
> > create == 1.
>   I think you misread the code - see below.
> 
> > Then fat_get_block() seems to allocate block without fill hole,
> > because it can't know caller is prepre_write or not...
> > Well, anyway I'll test it on weekend. Thanks.
> > 
> > -> blockdev_direct_IO()
> >   -> direct_io_worker()
> >     -> do_direct_IO()
> >       -> get_more_blocks()
> > 
> > 		create = dio->rw & WRITE;
>   Here, create == 1.
> 
> > 		if (dio->lock_type == DIO_LOCKING) {
> > 			if (dio->block_in_file < (i_size_read(dio->inode) >>
> > 							dio->blkbits))
> > 				create = 0;
>   But here create was reset back to 0 - exactly because
> dio->block_in_file > i_size...
  Obviously, I'm blind and you're right ;) This test is not satisfied
and so create == 1.
  But still it would seem better to me to return 0 from fat_direct_IO()
instead of EINVAL so that write falls back to a buffered one, instead
returning the error...

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
