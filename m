Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZILTwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZILTwK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 15:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbZILTwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 15:52:10 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44845 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbZILTwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 15:52:09 -0400
Date: Sat, 12 Sep 2009 21:52:12 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: recent bdi changes result in WARN_ON on luksClose / dm
Message-ID: <20090912195212.GF14984@kernel.dk>
References: <20090912111928.GA8013@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090912111928.GA8013@Chamillionaire.breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12 2009, Sebastian Andrzej Siewior wrote:
> | Orion:/# cryptsetup luksClose crypto
> |------------[ cut here ]------------
> |WARNING: at /home/bigeasy/git/cryptodev-2.6/mm/backing-dev.c:637 bdi_destroy+0x44/0x60()
> |Modules linked in: cbc sha256_generic dm_crypt [last unloaded: mv_cesa]
> |[<c0028dd8>] (unwind_backtrace+0x0/0xdc) from [<c003adb0>] (warn_slowpath_common+0x4c/0x80)
> |[<c003adb0>] (warn_slowpath_common+0x4c/0x80) from [<c007f2e0>] (bdi_destroy+0x44/0x60)
> |[<c007f2e0>] (bdi_destroy+0x44/0x60) from [<c012e3a0>] (blk_release_queue+0x3c/0x54)
> |[<c012e3a0>] (blk_release_queue+0x3c/0x54) from [<c01399a8>] (kobject_release+0x5c/0x74)
> |[<c01399a8>] (kobject_release+0x5c/0x74) from [<c013a6ac>] (kref_put+0x68/0x7c)
> |[<c013a6ac>] (kref_put+0x68/0x7c) from [<c01b7098>] (dm_put+0x148/0x178)
> |[<c01b7098>] (dm_put+0x148/0x178) from [<c01bb82c>] (dev_remove+0x98/0xb4)
> |[<c01bb82c>] (dev_remove+0x98/0xb4) from [<c01bbec0>] (dm_ctl_ioctl+0x21c/0x29c)
> |[<c01bbec0>] (dm_ctl_ioctl+0x21c/0x29c) from [<c00a153c>] (vfs_ioctl+0x2c/0x8c)
> |[<c00a153c>] (vfs_ioctl+0x2c/0x8c) from [<c00a1bac>] (do_vfs_ioctl+0x524/0x590)
> |[<c00a1bac>] (do_vfs_ioctl+0x524/0x590) from [<c00a1c50>] (sys_ioctl+0x38/0x5c)
> |[<c00a1c50>] (sys_ioctl+0x38/0x5c) from [<c0023e80>] (ret_fast_syscall+0x0/0x2c)
> |---[ end trace b3c544a14b51605c ]---

So dm is killing the queue and associated backing device, while dirty
inodes still exist. That's not very nice. Perhaps dm_lock_for_deletion()
should ensure that the backing is flushed?

-- 
Jens Axboe

