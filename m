Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbXJDUU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbXJDUU3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 16:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbXJDUUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 16:20:17 -0400
Received: from verein.lst.de ([213.95.11.210]:57075 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018AbXJDUUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 16:20:16 -0400
Date: Thu, 4 Oct 2007 22:20:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: Akinobu Mita <akinobu.mita@gmail.com>, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com, Tim Shimmin <xfs-masters@oss.sgi.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] update sb->s_frozen when freezing read-only mounted device, too
Message-ID: <20071004202004.GA13316@lst.de>
References: <20070929100912.GB4121@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070929100912.GB4121@APFDCB5C>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 29, 2007 at 07:09:12PM +0900, Akinobu Mita wrote:
> freeze_bdev() with the device which is mounted as read only
> does not change sb->s_frozen from SB_UNFROZEN to SB_FREEZE_TRANS.
> 
> Because of this behavior, xfs_freeze can break read-only XFS filesystem.
> 
> Because xfs_thaw does nothing for the filesystem whose sb->s_frozen is
> SB_UNFROZEN. So freezed readonly XFS filesystem will never be unfreezed.
> Then we cannot do any unmount/remount operations for that filesystem.
> 
> This patch updates sb->s_frozen when freeze_bdev() is called for read-only
> mounted device, too.

I think this fix is valid, but it might be a tad cleaner to just
set s_frozen to SB_FREEZE_TRANS directly in a separate branch, ala:

struct super_block *freeze_bdev(struct block_device *bdev)
{
        struct super_block *sb;

        down(&bdev->bd_mount_sem);
        sb = get_super(bdev);
	if (!sb)
		goto out;

	if (sb->s_flags & MS_RDONLY) {
		sb->s_frozen = SB_FREEZE_TRANS;
		smp_wmb();
		goto out;
	}

	sb->s_frozen = SB_FREEZE_WRITE;
	smp_wmb();

	__fsync_super(sb);

	sb->s_frozen = SB_FREEZE_TRANS
	smp_wmb();

	sync_blockdev(sb->s_bdev);

	if (sb->s_op->write_super_lockfs)
		sb->s_op->write_super_lockfs(sb);

 out:
	sync_blockdev(bdev);
	return sb;      /* thaw_bdev releases s->s_umount and bd_mount_sem */
}
