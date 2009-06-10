Return-Path: <linux-kernel-owner+w=401wt.eu-S1760301AbZFJWWd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301AbZFJWWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:22:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZFJWWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:22:24 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:47049 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbZFJWWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=PHLpwj2cGlKEnO/snEpuzYMVw5Gg24tB5NRkJ3CoBaYG2ChPUgD16VztFapERi+z7s
         eO4SlAkNapxPvq3qmwGiblXOc4wjXXncMfMwLbtrJh4sf+gQXlMMiJ5I/azOy1G+AawB
         bS+73t3+lbRi0w1H549ATZuhZspRsw8tNuclU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: linux-next: Tree for June 10
Date: Thu, 11 Jun 2009 00:27:37 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-rc8-next-20090610-08093-g6597e49-dirty; KDE/4.2.3; i686; ; )
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20090610194309.4f7a0e54.sfr@canb.auug.org.au>
In-Reply-To: <20090610194309.4f7a0e54.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906110027.38348.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 June 2009 11:43:09 Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090609:

commit 9df1bb9b516daeece159ab7fb262d01a0359247c
Author: Jens Axboe <jens.axboe@oracle.com>
Date:   Tue Jun 9 06:22:57 2009 +0200

    Revert "block: Fix bounce limit setting in DM"

    This reverts commit a05c0205ba031c01bba33a21bf0a35920eb64833.

    DM doesn't need to access the bounce_pfn directly.

    Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

and the following warning is back:

BUG: sleeping function called from invalid context at mm/page_alloc.c:1493
in_atomic(): 1, irqs_disabled(): 0, pid: 21882, name: cryptsetup
INFO: lockdep is turned off.
Pid: 21882, comm: cryptsetup Tainted: G   M       2.6.30-rc8-next-20090610-08093-g6597e49-dirty #19
Call Trace:
 [<c0122ca6>] __might_sleep+0xfb/0x102
 [<c0162e4c>] __alloc_pages_internal+0x62/0x388
 [<c014689d>] ? lockdep_init_map+0x8a/0x3fb
 [<c015fced>] mempool_alloc_pages+0x1b/0x21
 [<c0176d47>] mempool_alloc_pages_isa+0xb/0x10
 [<c01600ed>] mempool_create_node+0x92/0xcc
 [<c015fcc8>] ? mempool_free_pages+0x0/0xa
 [<c0176d3c>] ? mempool_alloc_pages_isa+0x0/0x10
 [<c0160134>] mempool_create+0xd/0x11
 [<c0176d1c>] init_emergency_isa_pool+0x22/0x42
 [<c0223749>] blk_queue_bounce_limit+0x2c/0x41
 [<c030b3a7>] dm_table_set_restrictions+0x76/0x9b
 [<c03094b0>] dm_swap_table+0x117/0x132
 [<c030d9ce>] dev_suspend+0xf4/0x16f
 [<c030e246>] dm_ctl_ioctl+0x18e/0x1cc
 [<c030d8da>] ? dev_suspend+0x0/0x16f
 [<c030e0b8>] ? dm_ctl_ioctl+0x0/0x1cc
 [<c018b81f>] vfs_ioctl+0x22/0x69
 [<c018bce9>] do_vfs_ioctl+0x483/0x4bd
 [<c0193606>] ? mntput_no_expire+0x19/0xb4
 [<c0181ee2>] ? __fput+0x185/0x18d
 [<c0181f03>] ? fput+0x19/0x1b
 [<c017f6c2>] ? filp_close+0x51/0x5b
 [<c018bd4f>] sys_ioctl+0x2c/0x45
 [<c0102988>] sysenter_do_call+0x12/0x36

[ The problem is in init_emergency_isa_pool() being called for DM. ]

The fix was probably lost because the original commit missed information
about the warning and also cc: to the reporter (me in this particular case).
