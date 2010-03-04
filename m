Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab0CDUGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:06:19 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:61247 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab0CDUGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:06:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=xNRF/vlnKNwrnHHvb/d5+tEOovovasI/YXmjZQYhROXjVT3ebhNSx4Qvp9tRYW2WCd
         DssNUlIJH90WN/I7xl0gkaLw1CYBTwKYFb3vGtfmPp6YYN0k8Rj7+ysJixEgxNh1goFu
         WkpENAO80xAdTGRdkSZpZSXWF0/YJlFLjPnsQ=
MIME-Version: 1.0
Date: Thu, 4 Mar 2010 21:06:15 +0100
X-Google-Sender-Auth: db5712f9fbcf2a2a
Message-ID: <520f0cf11003041206n159aca8ao4657835fe87a6898@mail.gmail.com>
Subject: [BUG REPORT] mdadm INFO: possible circular locking dependency 
	detected
From: John Kacur <jkacur@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I spotted the following in my logs. This occurred on a real-time
kernel (2.6.33-rt4), but I suspect that there is nothing rt about it
and that it could just as easily happen on a vanilla kernel.

If anyone would like more information, I am happy to provide it. Thanks

Mar  4 19:30:40 localhost kernel:
=======================================================
Mar  4 19:30:40 localhost kernel: [ INFO: possible circular locking
dependency detected ]
Mar  4 19:30:40 localhost kernel: 2.6.33-rt4 #1
Mar  4 19:30:40 localhost kernel:
-------------------------------------------------------
Mar  4 19:30:40 localhost kernel: mdadm/689 is trying to acquire lock:
Mar  4 19:30:40 localhost kernel: (&bdev->bd_mutex){+.+.+.}, at:
[<ffffffff8113d933>] bd_claim_by_disk+0xef/0x272
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel: but task is already holding lock:
Mar  4 19:30:40 localhost kernel: (&new->reconfig_mutex){+.+.+.}, at:
[<ffffffff81366490>] mddev_lock+0x15/0x17
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel: which lock already depends on the new lock.
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel: the existing dependency chain (in
reverse order) is:
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel: -> #3 (&new->reconfig_mutex){+.+.+.}:
Mar  4 19:30:40 localhost kernel:       [<ffffffff8107d132>]
__lock_acquire+0xb66/0xd1e
Mar  4 19:30:40 localhost kernel:       [<ffffffff8107d3cb>]
lock_acquire+0xe1/0x105
Mar  4 19:30:40 localhost kernel:       [<ffffffff81457f33>]
_mutex_lock_interruptible+0x39/0x67
Mar  4 19:30:40 localhost kernel:       [<ffffffff81366490>]
mddev_lock+0x15/0x17
Mar  4 19:30:40 localhost kernel:       [<ffffffff81366e20>]
md_attr_show+0x32/0x5d
Mar  4 19:30:40 localhost kernel:       [<ffffffff8116ed8c>]
sysfs_read_file+0xbb/0x17d
Mar  4 19:30:40 localhost kernel:       [<ffffffff8111748c>] vfs_read+0xae/0x10b
Mar  4 19:30:40 localhost kernel:       [<ffffffff811175af>] sys_read+0x4d/0x74
Mar  4 19:30:40 localhost kernel:       [<ffffffff81009d72>]
system_call_fastpath+0x16/0x1b
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel: -> #2 (s_active){++++.+}:
Mar  4 19:30:40 localhost kernel:       [<ffffffff8107d132>]
__lock_acquire+0xb66/0xd1e
Mar  4 19:30:40 localhost kernel:       [<ffffffff8107d3cb>]
lock_acquire+0xe1/0x105
Mar  4 19:30:40 localhost kernel:       [<ffffffff8116f989>]
sysfs_deactivate+0x91/0xce
Mar  4 19:30:40 localhost kernel:       [<ffffffff81170074>]
sysfs_addrm_finish+0x36/0x55
Mar  4 19:30:40 localhost kernel:       [<ffffffff811700c9>]
remove_dir+0x36/0x3e
Mar  4 19:30:40 localhost kernel:       [<ffffffff8117017e>]
sysfs_remove_dir+0x9d/0xbe
Mar  4 19:30:40 localhost kernel:       [<ffffffff8121fe9b>]
kobject_del+0x16/0x37
Mar  4 19:30:40 localhost kernel:       [<ffffffff8121ff83>]
kobject_release+0xc7/0x1d9
Mar  4 19:30:40 localhost kernel:       [<ffffffff812210bd>] kref_put+0x43/0x4d
Mar  4 19:30:40 localhost kernel:       [<ffffffff8121fe10>]
kobject_put+0x47/0x4b
Mar  4 19:30:40 localhost kernel:       [<ffffffff8116b501>]
delete_partition+0x55/0x79
Mar  4 19:30:40 localhost kernel:       [<ffffffff81213f49>]
blkpg_ioctl+0x231/0x27f
Mar  4 19:30:40 localhost kernel:       [<ffffffff812144f1>]
blkdev_ioctl+0x55a/0x6b1
Mar  4 19:30:40 localhost kernel:       [<ffffffff8113d34b>]
block_ioctl+0x3d/0x41
Mar  4 19:30:40 localhost kernel:       [<ffffffff81123cf8>] vfs_ioctl+0x32/0xa9
Mar  4 19:30:40 localhost kernel:       [<ffffffff8112429f>]
do_vfs_ioctl+0x4ae/0x4f4
Mar  4 19:30:40 localhost kernel:       [<ffffffff8112433b>] sys_ioctl+0x56/0x79
Mar  4 19:30:40 localhost kernel:       [<ffffffff81009d72>]
system_call_fastpath+0x16/0x1b
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel: -> #1 (&bdev->bd_mutex/1){+.+.+.}:
Mar  4 19:30:40 localhost kernel:       [<ffffffff8107d132>]
__lock_acquire+0xb66/0xd1e
Mar  4 19:30:40 localhost kernel:       [<ffffffff8107d3cb>]
lock_acquire+0xe1/0x105
Mar  4 19:30:40 localhost kernel:       [<ffffffff81457ad4>]
_mutex_lock_nested+0x32/0x41
Mar  4 19:30:40 localhost kernel:       [<ffffffff81213f3e>]
blkpg_ioctl+0x226/0x27f
Mar  4 19:30:40 localhost kernel:       [<ffffffff812144f1>]
blkdev_ioctl+0x55a/0x6b1
Mar  4 19:30:40 localhost kernel:       [<ffffffff8113d34b>]
block_ioctl+0x3d/0x41
Mar  4 19:30:40 localhost kernel:       [<ffffffff81123cf8>] vfs_ioctl+0x32/0xa9
Mar  4 19:30:40 localhost kernel:       [<ffffffff8112429f>]
do_vfs_ioctl+0x4ae/0x4f4
Mar  4 19:30:40 localhost kernel:       [<ffffffff8112433b>] sys_ioctl+0x56/0x79
Mar  4 19:30:40 localhost kernel:       [<ffffffff81009d72>]
system_call_fastpath+0x16/0x1b
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel: -> #0 (&bdev->bd_mutex){+.+.+.}:
Mar  4 19:30:40 localhost kernel:       [<ffffffff8107cfdc>]
__lock_acquire+0xa10/0xd1e
Mar  4 19:30:40 localhost kernel:       [<ffffffff8107d3cb>]
lock_acquire+0xe1/0x105
Mar  4 19:30:40 localhost kernel:       [<ffffffff81457b17>]
_mutex_lock+0x34/0x43
Mar  4 19:30:40 localhost kernel:       [<ffffffff8113d933>]
bd_claim_by_disk+0xef/0x272
Mar  4 19:30:40 localhost kernel:       [<ffffffff81367a77>]
bind_rdev_to_array+0x268/0x2c2
Mar  4 19:30:40 localhost kernel:       [<ffffffff8136d1c7>]
new_dev_store+0x13a/0x173
Mar  4 19:30:40 localhost kernel:       [<ffffffff8136770e>]
md_attr_store+0x7b/0x98
Mar  4 19:30:40 localhost kernel:       [<ffffffff8116ec75>]
sysfs_write_file+0x107/0x143
Mar  4 19:30:40 localhost kernel:       [<ffffffff81117294>]
vfs_write+0xb1/0x10e
Mar  4 19:30:40 localhost kernel:       [<ffffffff811173b7>] sys_write+0x4d/0x74
Mar  4 19:30:40 localhost kernel:       [<ffffffff81009d72>]
system_call_fastpath+0x16/0x1b
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel: other info that might help us debug this:
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel: 4 locks held by mdadm/689:
Mar  4 19:30:40 localhost kernel: #0:  (&buffer->mutex){+.+.+.}, at:
[<ffffffff8116eba8>] sysfs_write_file+0x3a/0x143
Mar  4 19:30:40 localhost kernel: #1:  (s_active){++++.+}, at:
[<ffffffff81170329>] sysfs_get_active_two+0x24/0x4b
Mar  4 19:30:40 localhost kernel: #2:  (s_active){++++.+}, at:
[<ffffffff81170336>] sysfs_get_active_two+0x31/0x4b
Mar  4 19:30:40 localhost kernel: #3:  (&new->reconfig_mutex){+.+.+.},
at: [<ffffffff81366490>] mddev_lock+0x15/0x17
Mar  4 19:30:40 localhost kernel:
Mar  4 19:30:40 localhost kernel: stack backtrace:
Mar  4 19:30:40 localhost kernel: Pid: 689, comm: mdadm Not tainted
2.6.33-rt4 #1
Mar  4 19:30:40 localhost kernel: Call Trace:
Mar  4 19:30:40 localhost kernel: [<ffffffff8107c19b>]
print_circular_bug+0xa8/0xb7
Mar  4 19:30:40 localhost kernel: [<ffffffff8107cfdc>]
__lock_acquire+0xa10/0xd1e
Mar  4 19:30:40 localhost kernel: [<ffffffff8113d933>] ?
bd_claim_by_disk+0xef/0x272
Mar  4 19:30:40 localhost kernel: [<ffffffff8107d3cb>] lock_acquire+0xe1/0x105
Mar  4 19:30:40 localhost kernel: [<ffffffff8113d933>] ?
bd_claim_by_disk+0xef/0x272
Mar  4 19:30:40 localhost kernel: [<ffffffff81457b17>] _mutex_lock+0x34/0x43
Mar  4 19:30:40 localhost kernel: [<ffffffff8113d933>] ?
bd_claim_by_disk+0xef/0x272
Mar  4 19:30:40 localhost kernel: [<ffffffff8113d933>]
bd_claim_by_disk+0xef/0x272
Mar  4 19:30:40 localhost kernel: [<ffffffff8136772b>] ? lock_rdev+0x0/0xe4
Mar  4 19:30:40 localhost kernel: [<ffffffff81367a77>]
bind_rdev_to_array+0x268/0x2c2
Mar  4 19:30:40 localhost kernel: [<ffffffff8136d019>] ?
md_import_device+0x207/0x27b
Mar  4 19:30:40 localhost kernel: [<ffffffff8136d1c7>] new_dev_store+0x13a/0x173
Mar  4 19:30:40 localhost kernel: [<ffffffff81457f3d>] ?
_mutex_lock_interruptible+0x43/0x67
Mar  4 19:30:40 localhost kernel: [<ffffffff81366490>] ? mddev_lock+0x15/0x17
Mar  4 19:30:40 localhost kernel: [<ffffffff8136770e>] md_attr_store+0x7b/0x98
Mar  4 19:30:40 localhost kernel: [<ffffffff8116ec75>]
sysfs_write_file+0x107/0x143
Mar  4 19:30:40 localhost kernel: [<ffffffff81117294>] vfs_write+0xb1/0x10e
Mar  4 19:30:40 localhost kernel: [<ffffffff8107bae9>] ?
trace_hardirqs_on_caller+0x125/0x150
Mar  4 19:30:40 localhost kernel: [<ffffffff811173b7>] sys_write+0x4d/0x74
Mar  4 19:30:40 localhost kernel: [<ffffffff81009d72>]
system_call_fastpath+0x16/0x1b
Mar  4 19:30:40 localhost kernel: md: bind<sdb>
Mar  4 19:30:40 localhost kernel: dracut: mdadm: Container /dev/md0
has been assembled with 2 drives
Mar  4 19:30:40 localhost kernel: md: md127 stopped.
Mar  4 19:30:40 localhost kernel: md: bind<sdb>
Mar  4 19:30:40 localhost kernel: md: bind<sda>
Mar  4 19:30:40 localhost kernel: md: raid0 personality registered for level 0
Mar  4 19:30:40 localhost kernel: raid0: looking at sda
Mar  4 19:30:40 localhost kernel: raid0:   comparing sda(1953517824)
Mar  4 19:30:40 localhost kernel: with sda(1953517824)
Mar  4 19:30:40 localhost kernel: raid0:   END
Mar  4 19:30:40 localhost kernel: raid0:   ==> UNIQUE
Mar  4 19:30:40 localhost kernel: raid0: 1 zones
Mar  4 19:30:40 localhost kernel: raid0: looking at sdb
Mar  4 19:30:40 localhost kernel: raid0:   comparing sdb(1953517824)
Mar  4 19:30:40 localhost kernel: with sda(1953517824)
Mar  4 19:30:40 localhost kernel: raid0:   EQUAL
Mar  4 19:30:40 localhost kernel: raid0: FINAL 1 zones
Mar  4 19:30:40 localhost kernel: raid0: done.
Mar  4 19:30:40 localhost kernel: raid0 : md_size is 3907035136 sectors.
Mar  4 19:30:40 localhost kernel: ******* md127 configuration *********
Mar  4 19:30:40 localhost kernel: zone0=[sda/sdb/]
Mar  4 19:30:40 localhost kernel:        zone offset=0kb device
offset=0kb size=1953517824kb
Mar  4 19:30:40 localhost kernel: **********************************
