Return-Path: <linux-kernel-owner+w=401wt.eu-S1762566AbXJENVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762566AbXJENVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:21:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXJENU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:20:56 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:23394 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755052AbXJENU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ETZ5QlALR7V+C2hjWcC3L9+nHdGqkSpiWBwFql8OkaEf4XTyyqRjhA4KJjgNDz5bkDChYPix/eRCBHkNdyINB0NkimL/eYAvq0c1+7Y5FmNXXG3X3Beb8waPbqzdUgReyj3mbofGfYH06Nahv9K89vIQBfENgjZfCYzFmF8ulyE=
Message-ID: <961aa3350710050620q42eb6192wdacce1510cc76a4b@mail.gmail.com>
Date: Fri, 5 Oct 2007 22:20:55 +0900
From: "Akinobu Mita" <akinobu.mita@gmail.com>
To: "Christoph Hellwig" <hch@lst.de>
Subject: Re: [PATCH] update sb->s_frozen when freezing read-only mounted device, too
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       "Tim Shimmin" <xfs-masters@oss.sgi.com>, "David Chinner" <dgc@sgi.com>
In-Reply-To: <20071004202004.GA13316@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070929100912.GB4121@APFDCB5C> <20071004202004.GA13316@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/10/5, Christoph Hellwig <hch@lst.de>:
> On Sat, Sep 29, 2007 at 07:09:12PM +0900, Akinobu Mita wrote:
> > freeze_bdev() with the device which is mounted as read only
> > does not change sb->s_frozen from SB_UNFROZEN to SB_FREEZE_TRANS.
> >
> > Because of this behavior, xfs_freeze can break read-only XFS filesystem.
> >
> > Because xfs_thaw does nothing for the filesystem whose sb->s_frozen is
> > SB_UNFROZEN. So freezed readonly XFS filesystem will never be unfreezed.
> > Then we cannot do any unmount/remount operations for that filesystem.
> >
> > This patch updates sb->s_frozen when freeze_bdev() is called for read-only
> > mounted device, too.
>
> I think this fix is valid, but it might be a tad cleaner to just
> set s_frozen to SB_FREEZE_TRANS directly in a separate branch, ala:

It looks cleaner than mine. I'll resubmit it.

> struct super_block *freeze_bdev(struct block_device *bdev)
> {
>         struct super_block *sb;
>
>         down(&bdev->bd_mount_sem);
>         sb = get_super(bdev);
>         if (!sb)
>                 goto out;
>
>         if (sb->s_flags & MS_RDONLY) {
>                 sb->s_frozen = SB_FREEZE_TRANS;
>                 smp_wmb();
>                 goto out;
>         }
>
>         sb->s_frozen = SB_FREEZE_WRITE;
>         smp_wmb();
>
>         __fsync_super(sb);
>
>         sb->s_frozen = SB_FREEZE_TRANS
>         smp_wmb();
>
>         sync_blockdev(sb->s_bdev);
>
>         if (sb->s_op->write_super_lockfs)
>                 sb->s_op->write_super_lockfs(sb);
>
>  out:
>         sync_blockdev(bdev);
>         return sb;      /* thaw_bdev releases s->s_umount and bd_mount_sem */
> }
>
