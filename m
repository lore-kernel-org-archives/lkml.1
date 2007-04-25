Return-Path: <linux-kernel-owner+w=401wt.eu-S2992443AbXDYJRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992443AbXDYJRM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 05:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992438AbXDYJRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 05:17:12 -0400
Received: from wr-out-0506.google.com ([64.233.184.234]:62097 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992443AbXDYJRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 05:17:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=mTIrEu4acJwEBVp21HmqkHckoA75EpWcXHt9CWZDOxgDNXW53Ozsnxm94OtBASTXK2rrMZSKl32mGNjgb4Y7ysFEiXNca1ve42aTJ9l4Sv9JkC4K6J5y5gVS7WBKyanOt0EOZPVXgMVTSUSWS3Nuoxw7klDOmN/tmTCmIgEQLR0=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.20.3 - possible recursive locking detected - in XFS
Date: Wed, 25 Apr 2007 11:16:57 +0200
User-Agent: KMail/1.9.6
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com, viro@zeniv.linux.org.uk,
       jesper.juhl@gmail.com
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704251116.57737.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

For your information : 

Once in a while I see the message below after I've just created a new XFS filesystem, mount it and then start copying data to it.

It doesn't happen every time - if I should try to make a guess at the frequency I'd say about 1 in 30.

What I do is this.

1. boot the server (an IBM x336) via the network
2. log in via ssh
3. load scsi modules
4. create raid1 of two disks
5. fdisk /dev/sda and create partitions
6. mkfs.xfs /dev/sda<some_partition>
7. mount -t xfs /dev/sda<some_partition> /mnt/mountpoint
8. ssh -x root@otherserver.mydomain.tld "tar --create --gzip --one-file-system --file - / 2>/dev/null" | tar --extract --gzip --preserve-permissions --numeric-owner --directory /mnt/mountpoint --file - 

since I do the above via a remote ssh session to the net-booted server, I don't usually notice 
kernel output to the console. But recently I've started looking via dmesg in a second ssh session and 
I can say for sure that most of the time there's no problem, but when there is, it is the same 
"recursive locking" dump I get.

If more info is needed, just let me know.


...
Ending clean XFS mount for filesystem: sda4

=============================================
[ INFO: possible recursive locking detected ]
2.6.20.3generic #1
---------------------------------------------
xfs_fsr/6117 is trying to acquire lock:
 (&(&ip->i_lock)->mr_lock){----}, at: [<f929422d>] xfs_ilock+0x7d/0xa0 [xfs]

but task is already holding lock:
 (&(&ip->i_lock)->mr_lock){----}, at: [<f929422d>] xfs_ilock+0x7d/0xa0 [xfs]

other info that might help us debug this:
2 locks held by xfs_fsr/6117:
 #0:  (&inode->i_mutex/1){--..}, at: [<c016d8b5>] lookup_create+0x25/0x90
 #1:  (&(&ip->i_lock)->mr_lock){----}, at: [<f929422d>] xfs_ilock+0x7d/0xa0 [xfs]

stack backtrace:
 [<c010404a>] show_trace_log_lvl+0x1a/0x30
 [<c0104732>] show_trace+0x12/0x20
 [<c01047e6>] dump_stack+0x16/0x20
 [<c0139311>] __lock_acquire+0xb01/0xdf0
 [<c0139670>] lock_acquire+0x70/0x90
 [<c0133f8b>] down_write+0x3b/0x60
 [<f929422d>] xfs_ilock+0x7d/0xa0 [xfs]
 [<f9294e17>] xfs_iget+0x467/0x7b0 [xfs]
 [<f92aeeb8>] xfs_trans_iget+0x108/0x180 [xfs]
 [<f92997db>] xfs_ialloc+0xab/0x520 [xfs]
 [<f92afadc>] xfs_dir_ialloc+0x6c/0x2b0 [xfs]
 [<f92b82b9>] xfs_mkdir+0x399/0x650 [xfs]
 [<f92c0d99>] xfs_vn_mknod+0x119/0x2d0 [xfs]
 [<f92c0f68>] xfs_vn_mkdir+0x18/0x20 [xfs]
 [<c016ceb8>] vfs_mkdir+0x98/0xe0
 [<c016f57e>] sys_mkdirat+0x8e/0xd0
 [<c016f5e0>] sys_mkdir+0x20/0x30
 [<c0102f7e>] sysenter_past_esp+0x5f/0x99
 =======================
...


-- 
Jesper Juhl <jesper.juhl@gmail.com>


