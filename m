Return-Path: <linux-kernel-owner+w=401wt.eu-S1423005AbXBHQHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423005AbXBHQHI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 11:07:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423111AbXBHQHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 11:07:08 -0500
Received: from styx.suse.cz ([82.119.242.94]:45165 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423005AbXBHQHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 11:07:06 -0500
Date: Thu, 8 Feb 2007 17:10:01 +0100
From: Jan Kara <jack@suse.cz>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Direct IO for fat
Message-ID: <20070208161001.GB3767@duck.suse.cz>
References: <20070208112808.GA3767@duck.suse.cz> <87k5ysfyd5.fsf@duaron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k5ysfyd5.fsf@duaron.myhome.or.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 09-02-07 00:44:06, OGAWA Hirofumi wrote:
> Jan Kara <jack@suse.cz> writes:
  Hello,

> >   I've noticed that extending a file using direct IO fails for FAT with
> > EINVAL. It's basically because of the following code in fat_direct_IO():
> >
> > if (rw == WRITE) {
> >         /*
> >          * FIXME: blockdev_direct_IO() doesn't use
> >          * ->prepare_write(),
> >          * so we need to update the ->mmu_private to block
> >          * boundary.
> >          *
> >          * But we must fill the remaining area or hole by nul for
> >          * updating ->mmu_private.
> >          */
> >         loff_t size = offset + iov_length(iov, nr_segs);
> >         if (MSDOS_I(inode)->mmu_private < size)
> >                 return -EINVAL;
> > }
> >
> >   But isn't this check bogus? blockdev_direct_IO writes only to space that
> > is already allocated and stops as soon as it needs to extend the file
> > (further extension is then handled by buffered writes). So it should
> > already do what it needed for FAT. Thanks for an answer in advance.
> 
> FAT has to fill the hole completely, but DIO doesn't seems to do.
> 
> e.g.
>         fd = open("file", O_WRONLY | O_CREAT | O_TRUNC);
>         write(fd, buf, 512);
>         lseek(fd, 10000, SEEK_SET);
>         write(fd, buf, 512);
> 
> We need to allocate the blocks on 512 ~ 10000, and fill it with zero.
> However, I think DIO doesn't fill it. If I'm missing something, please
> let me know, I'll kill that check.
  I know. DIO doesn't do it. But the point is that if blockdev_direct_IO
finds out it should allocate new blocks, it exits without allocating them.
Then in __generic_file_aio_write_nolock() if we find out that we did not
write everything in generic_file_direct_write(), we just call
generic_file_buffered_write() to write the unwritten part.
  Hence, in case you describe above, the second write() finds out that
block is not allocated and eventually everything falls back to calling
generic_file_buffered_write() which calls prepare_write() and everything is
happy.

								Honza
> 
> Thanks.
> -- 
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
