Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZKSRWx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZKSRWx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 12:22:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZKSRWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 12:22:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753769AbZKSRWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 12:22:47 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/28] CacheFiles: Mark parent directory locks as
	I_MUTEX_PARENT to keep lockdep happy
To: linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Cc: dhowells@redhat.com, steved@redhat.com
Date: Thu, 19 Nov 2009 17:22:42 +0000
Message-ID: <20091119172242.1679.89026.stgit@warthog.procyon.org.uk>
In-Reply-To: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
References: <20091119172033.1679.87046.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark parent directory locks as I_MUTEX_PARENT in the callers of
cachefiles_bury_object() so that lockdep doesn't complain when that invokes
vfs_unlink():

=============================================
[ INFO: possible recursive locking detected ]
2.6.32-rc6-cachefs #47
---------------------------------------------
kslowd002/3089 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#7){+.+.+.}, at: [<ffffffff810bbf72>] vfs_unlink+0x8b/0x128

but task is already holding lock:
 (&sb->s_type->i_mutex_key#7){+.+.+.}, at: [<ffffffffa00e4e61>] cachefiles_walk_to_object+0x1b0/0x831 [cachefiles]

other info that might help us debug this:
1 lock held by kslowd002/3089:
 #0:  (&sb->s_type->i_mutex_key#7){+.+.+.}, at: [<ffffffffa00e4e61>] cachefiles_walk_to_object+0x1b0/0x831 [cachefiles]

stack backtrace:
Pid: 3089, comm: kslowd002 Not tainted 2.6.32-rc6-cachefs #47
Call Trace:
 [<ffffffff8105ad7b>] __lock_acquire+0x1649/0x16e3
 [<ffffffff8118170e>] ? inode_has_perm+0x5f/0x61
 [<ffffffff8105ae6c>] lock_acquire+0x57/0x6d
 [<ffffffff810bbf72>] ? vfs_unlink+0x8b/0x128
 [<ffffffff81353ac3>] mutex_lock_nested+0x54/0x292
 [<ffffffff810bbf72>] ? vfs_unlink+0x8b/0x128
 [<ffffffff8118179e>] ? selinux_inode_permission+0x8e/0x90
 [<ffffffff8117e271>] ? security_inode_permission+0x1c/0x1e
 [<ffffffff810bb4fb>] ? inode_permission+0x99/0xa5
 [<ffffffff810bbf72>] vfs_unlink+0x8b/0x128
 [<ffffffff810adb19>] ? kfree+0xed/0xf9
 [<ffffffffa00e3f00>] cachefiles_bury_object+0xb6/0x420 [cachefiles]
 [<ffffffff81058e21>] ? trace_hardirqs_on+0xd/0xf
 [<ffffffffa00e7e24>] ? cachefiles_check_object_xattr+0x233/0x293 [cachefiles]
 [<ffffffffa00e51b0>] cachefiles_walk_to_object+0x4ff/0x831 [cachefiles]
 [<ffffffff81032238>] ? finish_task_switch+0x0/0xb2
 [<ffffffffa00e3429>] cachefiles_lookup_object+0xac/0x12a [cachefiles]
 [<ffffffffa00741e9>] fscache_lookup_object+0x1c7/0x214 [fscache]
 [<ffffffffa0074fc5>] fscache_object_state_machine+0xa5/0x52d [fscache]
 [<ffffffffa00754ac>] fscache_object_slow_work_execute+0x5f/0xa0 [fscache]
 [<ffffffff81082093>] slow_work_execute+0x18f/0x2d1
 [<ffffffff8108239a>] slow_work_thread+0x1c5/0x308
 [<ffffffff8104c0f1>] ? autoremove_wake_function+0x0/0x34
 [<ffffffff810821d5>] ? slow_work_thread+0x0/0x308
 [<ffffffff8104be91>] kthread+0x7a/0x82
 [<ffffffff8100beda>] child_rip+0xa/0x20
 [<ffffffff8100b87c>] ? restore_args+0x0/0x30
 [<ffffffff8104be17>] ? kthread+0x0/0x82
 [<ffffffff8100bed0>] ? child_rip+0x0/0x20

Signed-off-by: Daivd Howells <dhowells@redhat.com>
---

 fs/cachefiles/namei.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 4ce818a..3df8695 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -254,7 +254,7 @@ int cachefiles_delete_object(struct cachefiles_cache *cache,
 
 	dir = dget_parent(object->dentry);
 
-	mutex_lock(&dir->d_inode->i_mutex);
+	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 	ret = cachefiles_bury_object(cache, dir, object->dentry);
 
 	dput(dir);
@@ -307,7 +307,7 @@ lookup_again:
 	/* search the current directory for the element name */
 	_debug("lookup '%s'", name);
 
-	mutex_lock(&dir->d_inode->i_mutex);
+	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
 
 	start = jiffies;
 	next = lookup_one_len(name, dir, nlen);

