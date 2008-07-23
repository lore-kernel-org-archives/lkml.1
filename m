Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745AbYGWOz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbYGWOz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 10:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYGWOzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 10:55:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbYGWOzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:55:13 -0400
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-cifs-client@lists.samba.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [CIFS] lockdep: annotate cifs in-kernel sockets
Date: Wed, 23 Jul 2008 10:55:06 -0400
Message-Id: <1216824906-1737-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put CIFS sockets in their own class to avoid some lockdep warnings. CIFS
sockets are not exposed to user-space, and so are not subject to the
same deadlock scenarios.

A similar change was made a couple of years ago for RPC sockets in commit
ed07536ed6731775219c1df7fa26a7588753e693.

This patch should prevent lockdep false-positives like this one:

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.18-98.el5.jtltest.38.bz456320.1debug #1
-------------------------------------------------------
test5/2483 is trying to acquire lock:
 (sk_lock-AF_INET){--..}, at: [<ffffffff800270d2>] tcp_sendmsg+0x1c/0xb2f

but task is already holding lock:
 (&inode->i_alloc_sem){--..}, at: [<ffffffff8002e454>] notify_change+0xf5/0x2e0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&inode->i_alloc_sem){--..}:
       [<ffffffff800a817c>] __lock_acquire+0x9a9/0xadf
       [<ffffffff800a8a72>] lock_acquire+0x55/0x70
       [<ffffffff8002e454>] notify_change+0xf5/0x2e0
       [<ffffffff800a4e36>] down_write+0x3c/0x68
       [<ffffffff8002e454>] notify_change+0xf5/0x2e0
       [<ffffffff800e358d>] do_truncate+0x50/0x6b
       [<ffffffff8005197c>] get_write_access+0x40/0x46
       [<ffffffff80012cf1>] may_open+0x1d3/0x22e
       [<ffffffff8001bc81>] open_namei+0x2c6/0x6dd
       [<ffffffff800289c6>] do_filp_open+0x1c/0x38
       [<ffffffff800683ef>] _spin_unlock+0x17/0x20
       [<ffffffff800167a7>] get_unused_fd+0xf9/0x107
       [<ffffffff8001a704>] do_sys_open+0x44/0xbe
       [<ffffffff80060116>] system_call+0x7e/0x83
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #2 (&sysfs_inode_imutex_key){--..}:
       [<ffffffff800a817c>] __lock_acquire+0x9a9/0xadf
       [<ffffffff8010f6df>] create_dir+0x26/0x1d7
       [<ffffffff800a8a72>] lock_acquire+0x55/0x70
       [<ffffffff8010f6df>] create_dir+0x26/0x1d7
       [<ffffffff800671c0>] mutex_lock_nested+0x104/0x29c
       [<ffffffff800a819d>] __lock_acquire+0x9ca/0xadf
       [<ffffffff8010f6df>] create_dir+0x26/0x1d7
       [<ffffffff8010fc67>] sysfs_create_dir+0x58/0x76
       [<ffffffff8015144c>] kobject_add+0xdb/0x198
       [<ffffffff801be765>] class_device_add+0xb2/0x465
       [<ffffffff8005a6ff>] kobject_get+0x12/0x17
       [<ffffffff80225265>] register_netdevice+0x270/0x33e
       [<ffffffff8022538c>] register_netdev+0x59/0x67
       [<ffffffff80464d40>] net_olddevs_init+0xb/0xac
       [<ffffffff80448a79>] init+0x1f9/0x2fc
       [<ffffffff80068885>] _spin_unlock_irq+0x24/0x27
       [<ffffffff80067f86>] trace_hardirqs_on_thunk+0x35/0x37
       [<ffffffff80061079>] child_rip+0xa/0x11
       [<ffffffff80068885>] _spin_unlock_irq+0x24/0x27
       [<ffffffff800606a8>] restore_args+0x0/0x30
       [<ffffffff80179a59>] acpi_ds_init_one_object+0x0/0x80
       [<ffffffff80448880>] init+0x0/0x2fc
       [<ffffffff8006106f>] child_rip+0x0/0x11
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #1 (rtnl_mutex){--..}:
       [<ffffffff800a817c>] __lock_acquire+0x9a9/0xadf
       [<ffffffff8025acf8>] ip_mc_leave_group+0x23/0xb7
       [<ffffffff800a8a72>] lock_acquire+0x55/0x70
       [<ffffffff8025acf8>] ip_mc_leave_group+0x23/0xb7
       [<ffffffff800671c0>] mutex_lock_nested+0x104/0x29c
       [<ffffffff8025acf8>] ip_mc_leave_group+0x23/0xb7
       [<ffffffff802451b0>] do_ip_setsockopt+0x6d1/0x9bf
       [<ffffffff800a575e>] lock_release_holdtime+0x27/0x48
       [<ffffffff800a575e>] lock_release_holdtime+0x27/0x48
       [<ffffffff8006a85e>] do_page_fault+0x503/0x835
       [<ffffffff8012cbf6>] socket_has_perm+0x5b/0x68
       [<ffffffff80245556>] ip_setsockopt+0x22/0x78
       [<ffffffff8021c973>] sys_setsockopt+0x91/0xb7
       [<ffffffff800602a6>] tracesys+0xd5/0xdf
       [<ffffffffffffffff>] 0xffffffffffffffff

-> #0 (sk_lock-AF_INET){--..}:
       [<ffffffff800a5037>] print_stack_trace+0x59/0x68
       [<ffffffff800a8092>] __lock_acquire+0x8bf/0xadf
       [<ffffffff800a8a72>] lock_acquire+0x55/0x70
       [<ffffffff800270d2>] tcp_sendmsg+0x1c/0xb2f
       [<ffffffff80035466>] lock_sock+0xd4/0xe4
       [<ffffffff80096e91>] _local_bh_enable+0xcb/0xe0
       [<ffffffff800606a8>] restore_args+0x0/0x30
       [<ffffffff800270d2>] tcp_sendmsg+0x1c/0xb2f
       [<ffffffff80057540>] sock_sendmsg+0xf3/0x110
       [<ffffffff800a2bb6>] autoremove_wake_function+0x0/0x2e
       [<ffffffff800a10e4>] kernel_text_address+0x1a/0x26
       [<ffffffff8006f4e2>] dump_trace+0x211/0x23a
       [<ffffffff800a6d3d>] find_usage_backwards+0x5f/0x88
       [<ffffffff8840221a>] MD5Final+0xaf/0xc2 [cifs]
       [<ffffffff884032ec>] cifs_calculate_signature+0x55/0x69 [cifs]
       [<ffffffff8021d891>] kernel_sendmsg+0x35/0x47
       [<ffffffff883ff38e>] smb_send+0xa3/0x151 [cifs]
       [<ffffffff883ff5de>] SendReceive+0x1a2/0x448 [cifs]
       [<ffffffff800a812f>] __lock_acquire+0x95c/0xadf
       [<ffffffff883e758a>] CIFSSMBSetEOF+0x20d/0x25b [cifs]
       [<ffffffff883fa430>] cifs_set_file_size+0x110/0x3b7 [cifs]
       [<ffffffff883faa89>] cifs_setattr+0x3b2/0x6f6 [cifs]
       [<ffffffff8002e454>] notify_change+0xf5/0x2e0
       [<ffffffff8002e4a4>] notify_change+0x145/0x2e0
       [<ffffffff800e358d>] do_truncate+0x50/0x6b
       [<ffffffff8005197c>] get_write_access+0x40/0x46
       [<ffffffff80012cf1>] may_open+0x1d3/0x22e
       [<ffffffff8001bc81>] open_namei+0x2c6/0x6dd
       [<ffffffff800289c6>] do_filp_open+0x1c/0x38
       [<ffffffff800683ef>] _spin_unlock+0x17/0x20
       [<ffffffff800167a7>] get_unused_fd+0xf9/0x107
       [<ffffffff8001a704>] do_sys_open+0x44/0xbe
       [<ffffffff800602a6>] tracesys+0xd5/0xdf
       [<ffffffffffffffff>] 0xffffffffffffffff

other info that might help us debug this:

2 locks held by test5/2483:
 #0:  (&inode->i_mutex){--..}, at: [<ffffffff800e3582>] do_truncate+0x45/0x6b
 #1:  (&inode->i_alloc_sem){--..}, at: [<ffffffff8002e454>] notify_change+0xf5/0x2e0

stack backtrace:

Call Trace:
 [<ffffffff800a6a7b>] print_circular_bug_tail+0x65/0x6e
 [<ffffffff800a5037>] print_stack_trace+0x59/0x68
 [<ffffffff800a8092>] __lock_acquire+0x8bf/0xadf
 [<ffffffff800a8a72>] lock_acquire+0x55/0x70
 [<ffffffff800270d2>] tcp_sendmsg+0x1c/0xb2f
 [<ffffffff80035466>] lock_sock+0xd4/0xe4
 [<ffffffff80096e91>] _local_bh_enable+0xcb/0xe0
 [<ffffffff800606a8>] restore_args+0x0/0x30
 [<ffffffff800270d2>] tcp_sendmsg+0x1c/0xb2f
 [<ffffffff80057540>] sock_sendmsg+0xf3/0x110
 [<ffffffff800a2bb6>] autoremove_wake_function+0x0/0x2e
 [<ffffffff800a10e4>] kernel_text_address+0x1a/0x26
 [<ffffffff8006f4e2>] dump_trace+0x211/0x23a
 [<ffffffff800a6d3d>] find_usage_backwards+0x5f/0x88
 [<ffffffff8840221a>] :cifs:MD5Final+0xaf/0xc2
 [<ffffffff884032ec>] :cifs:cifs_calculate_signature+0x55/0x69
 [<ffffffff8021d891>] kernel_sendmsg+0x35/0x47
 [<ffffffff883ff38e>] :cifs:smb_send+0xa3/0x151
 [<ffffffff883ff5de>] :cifs:SendReceive+0x1a2/0x448
 [<ffffffff800a812f>] __lock_acquire+0x95c/0xadf
 [<ffffffff883e758a>] :cifs:CIFSSMBSetEOF+0x20d/0x25b
 [<ffffffff883fa430>] :cifs:cifs_set_file_size+0x110/0x3b7
 [<ffffffff883faa89>] :cifs:cifs_setattr+0x3b2/0x6f6
 [<ffffffff8002e454>] notify_change+0xf5/0x2e0
 [<ffffffff8002e4a4>] notify_change+0x145/0x2e0
 [<ffffffff800e358d>] do_truncate+0x50/0x6b
 [<ffffffff8005197c>] get_write_access+0x40/0x46
 [<ffffffff80012cf1>] may_open+0x1d3/0x22e
 [<ffffffff8001bc81>] open_namei+0x2c6/0x6dd
 [<ffffffff800289c6>] do_filp_open+0x1c/0x38
 [<ffffffff800683ef>] _spin_unlock+0x17/0x20
 [<ffffffff800167a7>] get_unused_fd+0xf9/0x107
 [<ffffffff8001a704>] do_sys_open+0x44/0xbe
 [<ffffffff800602a6>] tracesys+0xd5/0xdf


Signed-off-by: Jeff Layton <jlayton@redhat.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 fs/cifs/connect.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index e8fa46c..6444627 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1461,6 +1461,39 @@ get_dfs_path(int xid, struct cifsSesInfo *pSesInfo, const char *old_path,
 	return rc;
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key cifs_key[2];
+static struct lock_class_key cifs_slock_key[2];
+
+static inline void
+cifs_reclassify_socket4(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	BUG_ON(sock_owned_by_user(sk));
+	sock_lock_init_class_and_name(sk, "slock-AF_INET-CIFS",
+		&cifs_slock_key[0], "sk_lock-AF_INET-CIFS", &cifs_key[0]);
+}
+
+static inline void
+cifs_reclassify_socket6(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+	BUG_ON(sock_owned_by_user(sk));
+	sock_lock_init_class_and_name(sk, "slock-AF_INET6-CIFS",
+		&cifs_slock_key[1], "sk_lock-AF_INET6-CIFS", &cifs_key[1]);
+}
+#else
+static inline void
+cifs_reclassify_socket4(struct socket *sock)
+{
+}
+
+static inline void
+cifs_reclassify_socket6(struct socket *sock)
+{
+}
+#endif
+
 /* See RFC1001 section 14 on representation of Netbios names */
 static void rfc1002mangle(char *target, char *source, unsigned int length)
 {
@@ -1495,6 +1528,7 @@ ipv4_connect(struct sockaddr_in *psin_server, struct socket **csocket,
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
 			cFYI(1, ("Socket created"));
 			(*csocket)->sk->sk_allocation = GFP_NOFS;
+			cifs_reclassify_socket4(*csocket);
 		}
 	}
 
@@ -1627,6 +1661,7 @@ ipv6_connect(struct sockaddr_in6 *psin_server, struct socket **csocket)
 		/* BB other socket options to set KEEPALIVE, NODELAY? */
 			 cFYI(1, ("ipv6 Socket created"));
 			(*csocket)->sk->sk_allocation = GFP_NOFS;
+			cifs_reclassify_socket6(*csocket);
 		}
 	}
 
-- 
1.5.5.1

