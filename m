Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbXKFEA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbXKFEA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 23:00:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXKFEAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 23:00:46 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:59034 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbXKFEAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:00:45 -0500
Message-Id: <200711060400.lA640fuE078356@www262.sakura.ne.jp>
Subject: Problem with accessing namespace_sem from LSM.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, crispin@crispincowan.com
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Nov 2007 13:00:41 +0900
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I found that accessing namespace_sem from security_inode_create()
causes lockdep warning when compiled with CONFIG_PROVE_LOCKING=y .



=======================================================
[ INFO: possible circular locking dependency detected ]
-------------------------------------------------------
klogd/1798 is trying to acquire lock:
 (&namespace_sem){----}, at: [<e0f133c7>] _aa_perm_dentry+0x80/0x184 [apparmor]

but task is already holding lock:
 (&inode->i_mutex){--..}, at: [<c02a883e>] mutex_lock+0x12/0x15

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&inode->i_mutex){--..}:
       [<c0137c89>] lock_acquire+0x4b/0x6a
       [<c02a86e6>] __mutex_lock_slowpath+0xb0/0x1f6
       [<c02a883e>] mutex_lock+0x12/0x15
       [<c0180b02>] graft_tree+0x5c/0xd4
       [<c0180e98>] do_add_mount+0x84/0x100
       [<c0181b5f>] do_mount+0x602/0x659
       [<c0181c1a>] sys_mount+0x64/0x9b
       [<c0103d9d>] sysenter_past_esp+0x56/0x99

-> #0 (&namespace_sem){----}:
       [<c0137c89>] lock_acquire+0x4b/0x6a
       [<c0134e34>] down_read+0x1e/0x31
       [<e0f133c7>] _aa_perm_dentry+0x80/0x184 [apparmor]
       [<e0f14849>] aa_perm_dentry+0x62/0xa4 [apparmor]
       [<e0f167c7>] apparmor_inode_create+0x40/0x63 [apparmor]
       [<c01749e5>] vfs_create+0x84/0x13e
       [<c01774ec>] open_namei+0x169/0x635
       [<c0166f15>] do_filp_open+0x20/0x36
       [<c0166f6b>] do_sys_open+0x40/0xbb
       [<c0167012>] sys_open+0x16/0x18
       [<c0103d9d>] sysenter_past_esp+0x56/0x99

other info that might help us debug this:

1 lock held by klogd/1798:
 #0:  (&inode->i_mutex){--..}, at: [<c02a883e>] mutex_lock+0x12/0x15

stack backtrace:
 [<c010555d>] show_trace+0xd/0x10
 [<c0105a99>] dump_stack+0x19/0x1b
 [<c0136dc8>] print_circular_bug_tail+0x59/0x64
 [<c01375bd>] __lock_acquire+0x7ea/0x973
 [<c0137c89>] lock_acquire+0x4b/0x6a
 [<c0134e34>] down_read+0x1e/0x31
 [<e0f133c7>] _aa_perm_dentry+0x80/0x184 [apparmor]
 [<e0f14849>] aa_perm_dentry+0x62/0xa4 [apparmor]
 [<e0f167c7>] apparmor_inode_create+0x40/0x63 [apparmor]
 [<c01749e5>] vfs_create+0x84/0x13e
 [<c01774ec>] open_namei+0x169/0x635
 [<c0166f15>] do_filp_open+0x20/0x36
 [<c0166f6b>] do_sys_open+0x40/0xbb
 [<c0167012>] sys_open+0x16/0x18
 [<c0103d9d>] sysenter_past_esp+0x56/0x99



If this warning is true,
AppArmor shipped with OpenSuSE 10.1 and 10.2 is affected.

----- Kernel 2.6.16.53-0.16 for OpenSuSE 10.1 -----

do_add_mount() { /* in fs/namespace.c */
  down_write(&namespace_sem);
  graft_tree() {
    mutex_lock(&nd->dentry->d_inode->i_mutex);
    ...
    mutex_unlock(&nd->dentry->d_inode->i_mutex);
  }
  up_write(&namespace_sem);
}

open_namei() { /* in fs/namei.c */
  mutex_lock(&dir->d_inode->i_mutex);
  vfs_create() {
    security_inode_create() {
      subdomain_inode_create() { /* in security/apparmor/lsm.c */
        sd_perm_dentry() { /* in security/apparmor/main.c */
          _sd_perm_dentry() {
            sd_path_begin() { /* in security/apparmor/inline.h */
              sd_path_begin2() {
                down_read(&namespace_sem);
              }
            }
            ...
            sd_path_end() {
              up_read(&namespace_sem);
            }
          }
        }
      }
    }
  }
  mutex_unlock(&dir->d_inode->i_mutex);
}

----- Kernel 2.6.18.8-0.7 for OpenSuSE 10.2 -----

do_add_mount() { /* in fs/namespace.c */
  down_write(&namespace_sem);
  graft_tree() {
    mutex_lock(&nd->dentry->d_inode->i_mutex);
    ...
    mutex_unlock(&nd->dentry->d_inode->i_mutex);
  }
  up_write(&namespace_sem);
}

open_namei() { /* in fs/namei.c */
  mutex_lock(&dir->d_inode->i_mutex);
  vfs_create() {
    security_inode_create() {
      apparmor_inode_create() { /* in security/apparmor/lsm.c */
        aa_perm_dentry() { /* in security/apparmor/lsm.c */
          _aa_perm_dentry() {
            aa_path_begin() { /* in security/apparmor/inline.h */
              aa_path_begin2() {
                down_read(&namespace_sem);
              }
            }
            ...
            aa_path_end() {
              up_read(&namespace_sem);
            }
          }
        }
      }
    }
  }
  mutex_unlock(&dir->d_inode->i_mutex);
}

AppArmor shipped with OpenSuSE 10.3 and Ubuntu 7.10 will not be affected
since kernel was modified to pass vfsmount parameter
to VFS helper functions and LSM hooks.

TOMOYO Linux 2.x (which is implemented using LSM) is also affected
and I'm looking for solution.
http://lkml.org/lkml/2007/11/5/55

Possible solution would be to pass vfsmount parameter
to VFS helper functions and LSM hooks for all kernels.
I do hope that "Pass struct vfsmount to ..." patches
are merged into mainline kernel.

Regards.
