Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYIEKwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYIEKwS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 06:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYIEKwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 06:52:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59585 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbYIEKwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 06:52:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for September 4
Date: Fri, 5 Sep 2008 12:56:35 +0200
User-Agent: KMail/1.9.9
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20080904193606.573f2cb3.sfr@canb.auug.org.au> <20080904214437.c53f02d9.akpm@linux-foundation.org>
In-Reply-To: <20080904214437.c53f02d9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809051256.36257.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 5 of September 2008, Andrew Morton wrote:
> On Thu, 4 Sep 2008 19:36:06 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > I have created today's linux-next tree at
> > git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
> 
> The infamous Vaio hasn't finished catching up with you guys yet. 
> Something in linux-next broke suspend-to-RAM.
> 
> An `echo mem > /sys/power/state' causes "Freezing of tasks failed after
> 20.00 seconds (1 tasks refusing to freeze):"
> 
> dmesg: http://userweb.kernel.org/~akpm/dmesg-sony-suspend.txt
> config: http://userweb.kernel.org/~akpm/config-sony.txt
> 
> This only happens after the X server has been started.
> 
> Mainline is OK.

According to your dmesg the process that refused to freeze was

hald-addon-stor

which got stuck in ... getnstimeofday (???) (can you check what
source code corresponds to getnstimeofday+0x37/0xbc pls?):

hald-addon-st D 00000046     0  2322   2282
       f4de5b74 00000046 f4de5b54 00000046 f4de5b5c c0135f56 f6b96e44 f4deaf40 
       f4deb0bc f5580948 f4de5bb0 f4de5b6c c013336e f6aa77c8 f6aa77c8 f6aa77a0 
       f4de5bb0 f4de5b7c c0331f09 f4de5bd0 c01f4205 00000000 00000000 00000000 
Call Trace:
 [<c0135f56>] ? getnstimeofday+0x37/0xbc
 [<c013336e>] ? ktime_get_ts+0x40/0x44
 [<c0331f09>] io_schedule+0x39/0x6c
 [<c01f4205>] get_request_wait+0x80/0xcd
 [<c0130615>] ? autoremove_wake_function+0x0/0x33
 [<c01f4285>] blk_get_request+0x33/0x5f
 [<c027a2a5>] scsi_execute+0x1f/0x10a
 [<c027a40a>] scsi_execute_req+0x7a/0x97
 [<f862c0f9>] sr_test_unit_ready+0x39/0x95 [sr_mod]
 [<f862ccbf>] sr_media_change+0x3c/0x1f9 [sr_mod]
 [<c0331d2f>] ? schedule+0x438/0x451
 [<f85c1073>] media_changed+0x43/0x71 [cdrom]
 [<f85c10cd>] cdrom_media_changed+0x2c/0x32 [cdrom]
 [<f862c19e>] sr_block_media_changed+0x11/0x13 [sr_mod]
 [<c019eee0>] check_disk_change+0x1c/0x79
 [<f85c4c72>] cdrom_open+0x7ec/0x85a [cdrom]
 [<c01d8499>] ? avc_has_perm_noaudit+0x38c/0x42e
 [<c01d84c0>] ? avc_has_perm_noaudit+0x3b3/0x42e
 [<c01f62e4>] ? blk_execute_rq_nowait+0x74/0x7c
 [<c01d8129>] ? avc_has_perm_noaudit+0x1c/0x42e
 [<c01d84c0>] ? avc_has_perm_noaudit+0x3b3/0x42e
 [<c033264f>] ? mutex_unlock+0x8/0xa
 [<c013d4c5>] ? trace_hardirqs_on+0xb/0xd
 [<f862c25d>] sr_block_open+0x83/0x91 [sr_mod]
 [<c019f48a>] do_open+0xa9/0x2b5
 [<c019f94b>] blkdev_open+0x28/0x51
 [<c017df80>] __dentry_open+0x181/0x29f
 [<c017edc5>] nameidata_to_filp+0x2b/0x42
 [<c019f923>] ? blkdev_open+0x0/0x51
 [<c0189251>] do_filp_open+0x391/0x662
 [<c013d4c5>] ? trace_hardirqs_on+0xb/0xd
 [<c018ffe9>] ? alloc_fd+0xbf/0xc9
 [<c018ffe9>] ? alloc_fd+0xbf/0xc9
 [<c017f0a8>] do_sys_open+0x44/0xb9
 [<c017f15f>] sys_open+0x1e/0x26
 [<c0103925>] sysenter_do_call+0x12/0x31
