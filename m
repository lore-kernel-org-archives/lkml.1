Return-Path: <linux-kernel-owner+w=401wt.eu-S1755856AbZLBWXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755856AbZLBWXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 17:23:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZLBWXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 17:23:17 -0500
Received: from corega.com.ru ([195.178.208.66]:40230 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832AbZLBWXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 17:23:15 -0500
Date: Thu, 3 Dec 2009 01:23:21 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jens.axboe@oracle.com
Subject: Re: 2.6.32-rc8: pohmelfs: NULL pointer dereference
Message-ID: <20091202222321.GB17579@ioremap.net>
References: <a4423d670912011711s584f46d2y8a583618abe4a620@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670912011711s584f46d2y8a583618abe4a620@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander.

Thanks a lot for you report and analysis!

On Wed, Dec 02, 2009 at 04:11:52AM +0300, Alexander Beregalov (a.beregalov@gmail.com) wrote:
> BUG: unable to handle kernel NULL pointer dereference at 000000b8
> IP: [<c10a96f9>] bdi_queue_work+0x9/0xa0
> 
>  [<c10a97e6>] ? sync_inodes_sb+0x46/0x120
>  [<c13cbafd>] ? printk+0x18/0x1b
>  [<f840d8cb>] ? pohmelfs_kill_super+0xb/0x20 [pohmelfs]
>  [<c1090b8a>] ? deactivate_locked_super+0x4a/0x70
>  [<c1090ccf>] ? get_sb_nodev+0x6f/0x80
>  [<f840d8fc>] ? pohmelfs_get_sb+0x1c/0x20 [pohmelfs]
>  [<f840e120>] ? pohmelfs_fill_super+0x0/0x530 [pohmelfs]
>  [<c108fe50>] ? vfs_kern_mount+0x40/0xd0
> 
> 
> The problem is that pohmelfs_fill_super() does not set sb->s_bdi.
> Behavior was changed by
> b6e51316da writeback: separate starting of sync vs opportunistic writeback
> d8a8559cd7 writeback: get rid of generic_sync_sb_inodes() export

Looks like this change broke things:

-long sync_inodes_sb(struct super_block *sb)
+void sync_inodes_sb(struct super_block *sb)
{
-       struct writeback_control wbc = {
-               .sb             = sb,
-               .bdi            = sb->s_bdi,
-               .sync_mode      = WB_SYNC_ALL,
-               .range_start    = 0,
-               .range_end      = LLONG_MAX,
-       };
-       long nr_to_write = LONG_MAX; /* doesn't actually matter */
-
-       wbc.nr_to_write = nr_to_write;
-       bdi_start_writeback(&wbc);
-       wait_sb_inodes(&wbc);
-       return nr_to_write - wbc.nr_to_write;
+       bdi_sync_writeback(sb->s_bdi, sb);
+       wait_sb_inodes(sb);

POHMELFS does not set sb->s_bdi, so it will be dereferenced in
bdi_queue_work() and crash. Jens, should it check whether bdi is NULL in
bdi_sync_writeback()?

-- 
	Evgeniy Polyakov
