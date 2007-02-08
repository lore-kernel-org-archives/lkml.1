Return-Path: <linux-kernel-owner+w=401wt.eu-S1422790AbXBHLZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422790AbXBHLZP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 06:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423216AbXBHLZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 06:25:15 -0500
Received: from styx.suse.cz ([82.119.242.94]:34053 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1422790AbXBHLZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 06:25:14 -0500
Date: Thu, 8 Feb 2007 12:28:08 +0100
From: Jan Kara <jack@suse.cz>
To: hirofumi@mail.parknet.co.jp
Cc: linux-kernel@vger.kernel.org
Subject: Direct IO for fat
Message-ID: <20070208112808.GA3767@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  I've noticed that extending a file using direct IO fails for FAT with
EINVAL. It's basically because of the following code in fat_direct_IO():

if (rw == WRITE) {
        /*
         * FIXME: blockdev_direct_IO() doesn't use
         * ->prepare_write(),
         * so we need to update the ->mmu_private to block
         * boundary.
         *
         * But we must fill the remaining area or hole by nul for
         * updating ->mmu_private.
         */
        loff_t size = offset + iov_length(iov, nr_segs);
        if (MSDOS_I(inode)->mmu_private < size)
                return -EINVAL;
}

  But isn't this check bogus? blockdev_direct_IO writes only to space that
is already allocated and stops as soon as it needs to extend the file
(further extension is then handled by buffered writes). So it should
already do what it needed for FAT. Thanks for an answer in advance.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
