Return-Path: <linux-kernel-owner+w=401wt.eu-S1757878AbYGUG2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757878AbYGUG2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYGUG2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:28:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59965 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYGUG2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:28:00 -0400
Date: Mon, 21 Jul 2008 07:27:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: pjones@redhat.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] breakage in bsg
Message-ID: <20080721062748.GA5744@ZenIV.linux.org.uk>
References: <20080720163406.GW28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080720163406.GW28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 05:34:06PM +0100, Al Viro wrote:

> 	* cmd_filter thing is broken as well (we have no access to
> gendisk in question and there's a lot of obvious issues when you have
> several openers).
> 
> #2 and part of #3 are fixable, but I really don't see what to do with #1.
> If nothing else, it's absolutely incompatible with cmd_filter, even if you
> leave aside the issue with non-IDE/non-SCSI drivers.

Actually, cmd_filter changeset breaks all users of blk_verify_command().
It expects that struct file passed to will be that of a block device:
        inode = file->f_dentry->d_inode;
        if (!inode)
                return -EINVAL;

        disk = inode->i_bdev->bd_disk;

        return blk_cmd_filter_verify_command(&disk->cmd_filter,
                                                 cmd, &file->f_mode);

Unfortunately, all of those can get struct file of *character* device, with
obvious results.

The minimal fix is to pass disk / mode explicitly.  I'll post the patch,
but that still leaves bsg broken.
