Return-Path: <linux-kernel-owner+w=401wt.eu-S1754452AbYIXSjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbYIXSjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 14:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752112AbYIXSje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 14:39:34 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:23972 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIXSjc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 14:39:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=PnDsdF6Z1H4jJwq5SmfqfZgXqwHTj/asI3shQZ0unhlKIPOVXtf1VVqtvT0O514ZQd
         huHRBMAJGzEcbinKPYyg71JIo3wDcYBVLz4SSy3WUCZhdWbKXQ9xmju3X3nqDOCIEE4w
         26fUCmnWPvwAj1R5jWlKtCBVk/xrPhb4wUpuo=
Message-ID: <4807377b0809241139x18ea8ce4x7dbc66ba680be3e7@mail.gmail.com>
Date: Wed, 24 Sep 2008 11:39:31 -0700
From: "Jesse Brandeburg" <jesse.brandeburg@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       arjan@linux.intel.com, reiserfs-devel@vger.kernel.org,
       peterz@infradead.org
Subject: [LOCKDEP linux-2.6.27-rc7] reiserfs circular locking
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

while debugging another issue and just using git I got:

Sep 23 23:23:25 jbrandeb-bw kernel: [ INFO: possible circular locking
dependency detected ]
Sep 23 23:23:26 jbrandeb-bw syslog-ng[3750]: new configuration initialized
Sep 23 23:23:25 jbrandeb-bw kernel: 2.6.27-rc7-jesse-00036-g146761c #4
Sep 23 23:23:26 jbrandeb-bw syslog-ng[3750]: Changing permissions on
special file /dev/xconsole
Sep 23 23:23:26 jbrandeb-bw syslog-ng[3750]: Changing permissions on
special file /dev/tty10
Sep 23 23:23:26 jbrandeb-bw kernel:·
Sep 23 23:23:26 jbrandeb-bw kernel: -> #2
(&REISERFS_SB(s)->xattr_dir_sem){----}:
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff80256fb4>]
validate_chain+0x946/0xbe6
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802578f9>]
__lock_acquire+0x6a5/0x70e
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802579b7>]
lock_acquire+0x55/0x71
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff804e1544>]
down_read+0x50/0x80
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff8031a3f5>]
reiserfs_listxattr+0x85/0x152
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802cb542>]
vfs_listxattr+0x50/0x82
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802cb5d5>]
listxattr+0x61/0xb9
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802cb673>]
sys_llistxattr+0x46/0x5f
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff8020c0ab>]
system_call_fastpath+0x16/0x1b
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffffffffffff>]
0xffffffffffffffff
Sep 23 23:23:26 jbrandeb-bw kernel:·
Sep 23 23:23:26 jbrandeb-bw kernel: -> #1 (&REISERFS_I(inode)->xattr_sem){----}:
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff80256fb4>]
validate_chain+0x946/0xbe6
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802578f9>]
__lock_acquire+0x6a5/0x70e
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802579b7>]
lock_acquire+0x55/0x71
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff804e1544>]
down_read+0x50/0x80
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff8031bd28>]
reiserfs_cache_default_acl+0x46/0xcd
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802fe700>]
reiserfs_create+0x53/0x1dd
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802b7cba>]
vfs_create+0xa7/0x11d
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802b9f4f>]
do_filp_open+0x219/0x7de
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802ad25e>]
do_sys_open+0x58/0xd8
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802ad311>]
sys_open+0x20/0x22
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff8020c0ab>]
system_call_fastpath+0x16/0x1b
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffffffffffff>]
0xffffffffffffffff
Sep 23 23:23:26 jbrandeb-bw kernel:·
Sep 23 23:23:26 jbrandeb-bw kernel: -> #0 (&type->i_mutex_dir_key#4){--..}:
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff80256c9c>]
validate_chain+0x62e/0xbe6
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802578f9>]
__lock_acquire+0x6a5/0x70e
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802579b7>]
lock_acquire+0x55/0x71
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff804e0ee2>]
mutex_lock_nested+0xfe/0x28b
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802b77b3>]
vfs_rmdir+0x5f/0xe8
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff8031a919>]
reiserfs_delete_xattrs+0x110/0x171
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff80302b2e>]
reiserfs_delete_inode+0x46/0xc9
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802c2bc1>]
generic_delete_inode+0x88/0x108
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802c2c5d>]
generic_drop_inode+0x1c/0x174
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802c2197>] iput+0x66/0x6a
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802b9449>]
do_unlinkat+0xff/0x176
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff802b94d6>]
sys_unlink+0x16/0x18
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffff8020c0ab>]
system_call_fastpath+0x16/0x1b
Sep 23 23:23:26 jbrandeb-bw kernel:        [<ffffffffffffffff>]
0xffffffffffffffff
Sep 23 23:23:26 jbrandeb-bw kernel:·
Sep 23 23:23:26 jbrandeb-bw kernel: other info that might help us debug this:
Sep 23 23:23:26 jbrandeb-bw kernel:·
Sep 23 23:23:26 jbrandeb-bw kernel: 1 lock held by git-merge-recur/5032:
Sep 23 23:23:26 jbrandeb-bw kernel:  #0:
(&REISERFS_SB(s)->xattr_dir_sem){----}, at: [<ffffffff8031a90d>]
reiserfs_delete_xattrs+0x104/0x171
Sep 23 23:23:26 jbrandeb-bw kernel:·
Sep 23 23:23:26 jbrandeb-bw kernel: stack backtrace:
Sep 23 23:23:26 jbrandeb-bw kernel: Pid: 5032, comm: git-merge-recur
Not tainted 2.6.27-rc7-jesse-00036-g146761c #4
Sep 23 23:23:26 jbrandeb-bw kernel:·
Sep 23 23:23:26 jbrandeb-bw kernel: Call Trace:
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff80256663>]
print_circular_bug_tail+0xba/0xc5
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802540cf>] ?
print_circular_bug_entry+0x48/0x4f
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff80256c9c>]
validate_chain+0x62e/0xbe6
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802578f9>]
__lock_acquire+0x6a5/0x70e
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802579b7>] lock_acquire+0x55/0x71
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802b77b3>] ? vfs_rmdir+0x5f/0xe8
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff804e0ee2>]
mutex_lock_nested+0xfe/0x28b
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802b77b3>] ? vfs_rmdir+0x5f/0xe8
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802b77b3>] ? vfs_rmdir+0x5f/0xe8
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802b77b3>] vfs_rmdir+0x5f/0xe8
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff8031a90d>] ?
reiserfs_delete_xattrs+0x104/0x171
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff8031a919>]
reiserfs_delete_xattrs+0x110/0x171
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff80302b2e>]
reiserfs_delete_inode+0x46/0xc9
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff80302ae8>] ?
reiserfs_delete_inode+0x0/0xc9
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802c2bc1>]
generic_delete_inode+0x88/0x108
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802c2c5d>]
generic_drop_inode+0x1c/0x174
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802c2197>] iput+0x66/0x6a
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802b9449>] do_unlinkat+0xff/0x176
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff804e21fa>] ?
trace_hardirqs_on_thunk+0x3a/0x3f
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff80255fd8>] ?
trace_hardirqs_on_caller+0xf1/0x115
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff804e21fa>] ?
trace_hardirqs_on_thunk+0x3a/0x3f
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff802b94d6>] sys_unlink+0x16/0x18
Sep 23 23:23:26 jbrandeb-bw kernel:  [<ffffffff8020c0ab>]
system_call_fastpath+0x16/0x1b
Sep 23 23:23:26 jbrandeb-bw kernel:·

may be related to http://bugzilla.kernel.org/show_bug.cgi?id=9136

.config or other questions gladly answered.
