Return-Path: <linux-kernel-owner+w=401wt.eu-S1423226AbXBHQki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423226AbXBHQki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 11:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423168AbXBHQki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 11:40:38 -0500
Received: from mail.parknet.jp ([210.171.160.80]:3979 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423226AbXBHQkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 11:40:37 -0500
X-AuthUser: hirofumi@parknet.jp
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Direct IO for fat
References: <20070208112808.GA3767@duck.suse.cz>
	<87k5ysfyd5.fsf@duaron.myhome.or.jp>
	<20070208161001.GB3767@duck.suse.cz>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Fri, 09 Feb 2007 01:40:31 +0900
In-Reply-To: <20070208161001.GB3767@duck.suse.cz> (Jan Kara's message of "Thu\, 8 Feb 2007 17\:10\:01 +0100")
Message-ID: <87wt2sd2m8.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>> FAT has to fill the hole completely, but DIO doesn't seems to do.
>> 
>> e.g.
>>         fd = open("file", O_WRONLY | O_CREAT | O_TRUNC);
>>         write(fd, buf, 512);
>>         lseek(fd, 10000, SEEK_SET);
>>         write(fd, buf, 512);
>> 
>> We need to allocate the blocks on 512 ~ 10000, and fill it with zero.
>> However, I think DIO doesn't fill it. If I'm missing something, please
>> let me know, I'll kill that check.
>   I know. DIO doesn't do it. But the point is that if blockdev_direct_IO
> finds out it should allocate new blocks, it exits without allocating them.
> Then in __generic_file_aio_write_nolock() if we find out that we did not
> write everything in generic_file_direct_write(), we just call
> generic_file_buffered_write() to write the unwritten part.
>   Hence, in case you describe above, the second write() finds out that
> block is not allocated and eventually everything falls back to calling
> generic_file_buffered_write() which calls prepare_write() and everything is
> happy.

I see. But sorry, I can't see where is preventing it... Finally, I
think we do the following on second write(2).

This is write, so create == 1, and ->lock_type == DIO_LOCKING,
and dio->block_in_file > ->i_size, so DIO callback fat_get_block() with
create == 1.

Then fat_get_block() seems to allocate block without fill hole,
because it can't know caller is prepre_write or not...
Well, anyway I'll test it on weekend. Thanks.

-> blockdev_direct_IO()
  -> direct_io_worker()
    -> do_direct_IO()
      -> get_more_blocks()

		create = dio->rw & WRITE;
		if (dio->lock_type == DIO_LOCKING) {
			if (dio->block_in_file < (i_size_read(dio->inode) >>
							dio->blkbits))
				create = 0;
		} else if (dio->lock_type == DIO_NO_LOCKING) {
			create = 0;
		}

		/*
		 * For writes inside i_size we forbid block creations: only
		 * overwrites are permitted.  We fall back to buffered writes
		 * at a higher level for inside-i_size block-instantiating
		 * writes.
		 */
		ret = (*dio->get_block)(dio->inode, fs_startblk,
						map_bh, create);
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
