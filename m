Return-Path: <linux-kernel-owner+w=401wt.eu-S1423041AbXBHPoP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423041AbXBHPoP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 10:44:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423081AbXBHPoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 10:44:15 -0500
Received: from mail.parknet.jp ([210.171.160.80]:3962 "EHLO parknet.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423041AbXBHPoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 10:44:15 -0500
X-AuthUser: hirofumi@parknet.jp
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Direct IO for fat
References: <20070208112808.GA3767@duck.suse.cz>
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Date: Fri, 09 Feb 2007 00:44:06 +0900
In-Reply-To: <20070208112808.GA3767@duck.suse.cz> (Jan Kara's message of "Thu\, 8 Feb 2007 12\:28\:08 +0100")
Message-ID: <87k5ysfyd5.fsf@duaron.myhome.or.jp>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

>   Hello,

Hello,

>   I've noticed that extending a file using direct IO fails for FAT with
> EINVAL. It's basically because of the following code in fat_direct_IO():
>
> if (rw == WRITE) {
>         /*
>          * FIXME: blockdev_direct_IO() doesn't use
>          * ->prepare_write(),
>          * so we need to update the ->mmu_private to block
>          * boundary.
>          *
>          * But we must fill the remaining area or hole by nul for
>          * updating ->mmu_private.
>          */
>         loff_t size = offset + iov_length(iov, nr_segs);
>         if (MSDOS_I(inode)->mmu_private < size)
>                 return -EINVAL;
> }
>
>   But isn't this check bogus? blockdev_direct_IO writes only to space that
> is already allocated and stops as soon as it needs to extend the file
> (further extension is then handled by buffered writes). So it should
> already do what it needed for FAT. Thanks for an answer in advance.

FAT has to fill the hole completely, but DIO doesn't seems to do.

e.g.
        fd = open("file", O_WRONLY | O_CREAT | O_TRUNC);
        write(fd, buf, 512);
        lseek(fd, 10000, SEEK_SET);
        write(fd, buf, 512);

We need to allocate the blocks on 512 ~ 10000, and fill it with zero.
However, I think DIO doesn't fill it. If I'm missing something, please
let me know, I'll kill that check.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
