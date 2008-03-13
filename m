Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbYCMVd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbYCMVd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 17:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754845AbYCMVdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 17:33:51 -0400
Received: from fmmailgate02.web.de ([217.72.192.227]:42675 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbYCMVdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:33:50 -0400
From: Chr <chunkeey@web.de>
To: Christian Kujau <lists@nerdbynature.de>,
       Christian Kujau <lists@nerdbynature.de>
Subject: Re: INFO: task mount:11202 blocked for more than 120 seconds
Date: Thu, 13 Mar 2008 22:33:47 +0100
User-Agent: KMail/1.9.9
Cc: Samuel Tardieu <sam@rfc1149.net>,
       device-mapper development <dm-devel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <alpine.DEB.1.00.0803072116420.7723@sheep.housecafe.de> <alpine.DEB.1.00.0803130003110.5593@sheep.housecafe.de> <alpine.DEB.1.00.0803131444480.7433@sheep.housecafe.de>
In-Reply-To: <alpine.DEB.1.00.0803131444480.7433@sheep.housecafe.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200803132233.47516.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX181dsTmq0R2lCUYYrzadQu9vAWLkRfD1VH8NRm+
	63KR6/SxXJ3twsgnF2DXigykaatjSQe/ogD+WGKngZbKrC8La+
	T04BqBu/M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 14:45:39 Christian Kujau wrote:
> and so does -git8 and -git9...sigh :(

hmm, I can boot any of these -rcX-gitY kernels (but not without some stuck 
tasks after about a hour or so...)

but back: I tried lockdep and ran into this: (debug blocker)

pktcdvd: writer pktcdvd0 mapped to sr0

=============================================
[ INFO: possible recursive locking detected ]
2.6.25-rc5-git3 #2
---------------------------------------------
scsi_id/8262 is trying to acquire lock:
 (&bdev->bd_mutex){--..}, at: [<ffffffff802a8e51>] do_open+0x7b/0x2c0

but task is already holding lock:
 (&bdev->bd_mutex){--..}, at: [<ffffffff802a8e51>] do_open+0x7b/0x2c0

other info that might help us debug this:
2 locks held by scsi_id/8262:
 #0:  (&bdev->bd_mutex){--..}, at: [<ffffffff802a8e51>] do_open+0x7b/0x2c0
 #1:  (&ctl_mutex#2){--..}, at: [<ffffffff88231af2>] pkt_open+0x26/0x516 
[pktcdvd]

stack backtrace:
Pid: 8262, comm: scsi_id Not tainted 2.6.25-rc5-git3 #2

Call Trace:
 [<ffffffff8024ffe4>] __lock_acquire+0x8c9/0xc72
 [<ffffffff804bb23e>] ? __mutex_unlock_slowpath+0xf9/0x105
 [<ffffffff8025079f>] lock_acquire+0x5e/0x77
 [<ffffffff802a8e51>] ? do_open+0x7b/0x2c0
 [<ffffffff804bb336>] mutex_lock_nested+0xe1/0x270
 [<ffffffff802a8e51>] ? do_open+0x7b/0x2c0
 [<ffffffff802a8e51>] do_open+0x7b/0x2c0
 [<ffffffff802a9116>] __blkdev_get+0x80/0x92
 [<ffffffff802a9133>] blkdev_get+0xb/0xd
 [<ffffffff88231b6b>] :pktcdvd:pkt_open+0x9f/0x516
 [<ffffffff802a8e84>] do_open+0xae/0x2c0
 [<ffffffff802a92a4>] ? blkdev_open+0x0/0x6a
 [<ffffffff804bcbab>] ? _spin_unlock+0x26/0x2a
 [<ffffffff802a92a4>] ? blkdev_open+0x0/0x6a
 [<ffffffff802a92db>] blkdev_open+0x37/0x6a
 [<ffffffff80282571>] __dentry_open+0xe6/0x1c0
 [<ffffffff802826e4>] nameidata_to_filp+0x2e/0x40
 [<ffffffff8028272f>] do_filp_open+0x39/0x4b
 [<ffffffff804bcbab>] ? _spin_unlock+0x26/0x2a
 [<ffffffff8028246f>] ? get_unused_fd_flags+0x10d/0x11c
 [<ffffffff80282792>] do_sys_open+0x51/0xd9
 [<ffffffff80282843>] sys_open+0x1b/0x1d
 [<ffffffff8020b22b>] system_call_after_swapgs+0x7b/0x80

soooo.....?

scsi_id/8262 is trying to acquire lock:
 (&bdev->bd_mutex){--..}, at: [<ffffffff802a8e51>] do_open+0x7b/0x2c0

but task is already holding lock:
 (&bdev->bd_mutex){--..}, at: [<ffffffff802a8e51>] do_open+0x7b/0x2c0

sounds a bit strange? Is this a SMP related problem after all?
(*disabled pktcddvd for now... to see if still locks)

Regards,
	Chr...
