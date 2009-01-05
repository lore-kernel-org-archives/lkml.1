Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbZAEDYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbZAEDYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 22:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbZAEDYa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 22:24:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59150 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZAEDY2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 22:24:28 -0500
Message-ID: <49617D2E.8050502@cn.fujitsu.com>
Date: Mon, 05 Jan 2009 11:23:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [cgroup or VFS ?] INFO: possible recursive locking detected
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thread 1:
  for ((; ;))
  {
      mount -t cpuset xxx /mnt > /dev/null 2>&1
      cat /mnt/cpus > /dev/null 2>&1
      umount /mnt > /dev/null 2>&1
  }

Thread 2:
  for ((; ;))
  {
      mount -t cpuset xxx /mnt > /dev/null 2>&1
      umount /mnt > /dev/null 2>&1
  }

(Note: It is irrelevant which cgroup subsys is used.)

After a while a lockdep warning showed up:

=============================================
[ INFO: possible recursive locking detected ]
2.6.28 #479
---------------------------------------------
mount/13554 is trying to acquire lock:
 (&type->s_umount_key#19){--..}, at: [<c049d888>] sget+0x5e/0x321

but task is already holding lock:
 (&type->s_umount_key#19){--..}, at: [<c049da0c>] sget+0x1e2/0x321

other info that might help us debug this:
1 lock held by mount/13554:
 #0:  (&type->s_umount_key#19){--..}, at: [<c049da0c>] sget+0x1e2/0x321

stack backtrace:
Pid: 13554, comm: mount Not tainted 2.6.28-mc #479
Call Trace:
 [<c044ad2e>] validate_chain+0x4c6/0xbbd
 [<c044ba9b>] __lock_acquire+0x676/0x700
 [<c044bb82>] lock_acquire+0x5d/0x7a
 [<c049d888>] ? sget+0x5e/0x321
 [<c061b9b8>] down_write+0x34/0x50
 [<c049d888>] ? sget+0x5e/0x321
 [<c049d888>] sget+0x5e/0x321
 [<c045a2e7>] ? cgroup_set_super+0x0/0x3e
 [<c045959f>] ? cgroup_test_super+0x0/0x2f
 [<c045bcea>] cgroup_get_sb+0x98/0x2e7
 [<c045cfb6>] cpuset_get_sb+0x4a/0x5f
 [<c049dfa4>] vfs_kern_mount+0x40/0x7b
 [<c049e02d>] do_kern_mount+0x37/0xbf
 [<c04af4a0>] do_mount+0x5c3/0x61a
 [<c04addd2>] ? copy_mount_options+0x2c/0x111
 [<c04af560>] sys_mount+0x69/0xa0
 [<c0403251>] sysenter_do_call+0x12/0x31

The cause is after alloc_super() and then retry, an old entry in list
fs_supers is found, so grab_super(old) is called, but both functions
hold s_umount lock:

struct super_block *sget(...)
{
	...
retry:
	spin_lock(&sb_lock);
	if (test) {
		list_for_each_entry(old, &type->fs_supers, s_instances) {
			if (!test(old, data))
				continue;
			if (!grab_super(old))  <--- 2nd: down_write(&old->s_umount);
				goto retry;
			if (s)
				destroy_super(s);
			return old;
		}
	}
	if (!s) {
		spin_unlock(&sb_lock);
		s = alloc_super(type);   <--- 1th: down_write(&s->s_umount)
		if (!s)
			return ERR_PTR(-ENOMEM);
		goto retry;
	}
	...
}

It seems like a false positive, and seems like VFS but not cgroup needs
to be fixed ?

And I noticed this commit:

commit 897c6ff9568bcb102ffc6b465ebe1def0cba829d
Author: Arjan van de Ven <arjan@infradead.org>
Date:   Mon Jul 3 00:25:28 2006 -0700

    [PATCH] lockdep: annotate sb ->s_umount

    The s_umount rwsem needs to be classified as per-superblock since it's
    perfectly legit to keep multiple of those recursively in the VFS locking
    rules.

    Has no effect on non-lockdep kernels.

The changelog said s_umount needs to be classified as per-sb, but actually
it made it as per-filesystem. And there is no way to mark all instances
of a given lock as distinct.
