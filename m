Return-Path: <linux-kernel-owner+w=401wt.eu-S1754789AbXHGGbv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbXHGGbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 02:31:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXHGGbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 02:31:43 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:50584 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbXHGGbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 02:31:42 -0400
Date: Tue, 7 Aug 2007 11:56:00 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: menage@google.com
Cc: akpm@linux-foundation.com, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Circular Locking Dependency Chain detected in containers code
Message-ID: <20070807062600.GH31148@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I have hit upon a circular locking dependency while doing an rmdir on a
directory inside the containers code. I believe that it is safe as no one 
should be able to rmdir when a container is getting mounted.

To reproduce it, just do a rmdir inside the container.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.23-rc1-mm2-container #1
-------------------------------------------------------
rmdir/4321 is trying to acquire lock:
 (container_mutex){--..}, at: [<c03f3fe0>] mutex_lock+0x21/0x24

but task is already holding lock:
 (&inode->i_mutex){--..}, at: [<c03f3fe0>] mutex_lock+0x21/0x24

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&inode->i_mutex){--..}:
       [<c013bae1>] check_prev_add+0xae/0x18f
       [<c013bc1c>] check_prevs_add+0x5a/0xc5
       [<c013bee5>] validate_chain+0x25e/0x2cd
       [<c013d892>] __lock_acquire+0x629/0x691
       [<c013ddef>] lock_acquire+0x61/0x7e
       [<c03f40b5>] __mutex_lock_slowpath+0xc8/0x230
       [<c03f3fe0>] mutex_lock+0x21/0x24
       [<c014749f>] container_get_sb+0x22c/0x283
       [<c0174f02>] vfs_kern_mount+0x3a/0x73
       [<c0186743>] do_new_mount+0x7e/0xdc
       [<c0186d8b>] do_mount+0x178/0x191
       [<c0186ff3>] sys_mount+0x66/0x9d
       [<c0104cc2>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

-> #0 (container_mutex){--..}:
       [<c013ba5e>] check_prev_add+0x2b/0x18f
       [<c013bc1c>] check_prevs_add+0x5a/0xc5
       [<c013bee5>] validate_chain+0x25e/0x2cd
       [<c013d892>] __lock_acquire+0x629/0x691
       [<c013ddef>] lock_acquire+0x61/0x7e
       [<c03f40b5>] __mutex_lock_slowpath+0xc8/0x230
       [<c03f3fe0>] mutex_lock+0x21/0x24
       [<c01484f3>] container_rmdir+0x15/0x163
       [<c017b711>] vfs_rmdir+0x59/0x8f
       [<c017b7d3>] do_rmdir+0x8c/0xbe
       [<c017b815>] sys_rmdir+0x10/0x12
       [<c0104cc2>] sysenter_past_esp+0x5f/0x99
       [<ffffffff>] 0xffffffff

other info that might help us debug this:

2 locks held by rmdir/4321:
 #0:  (&inode->i_mutex/1){--..}, at: [<c017b7b3>] do_rmdir+0x6c/0xbe
 #1:  (&inode->i_mutex){--..}, at: [<c03f3fe0>] mutex_lock+0x21/0x24

stack backtrace:
 [<c0105ad0>] show_trace_log_lvl+0x12/0x22
 [<c0105aed>] show_trace+0xd/0xf
 [<c0105bc3>] dump_stack+0x14/0x16
 [<c013b401>] print_circular_bug_tail+0x5b/0x64
 [<c013ba5e>] check_prev_add+0x2b/0x18f
 [<c013bc1c>] check_prevs_add+0x5a/0xc5
 [<c013bee5>] validate_chain+0x25e/0x2cd
 [<c013d892>] __lock_acquire+0x629/0x691
 [<c013ddef>] lock_acquire+0x61/0x7e
 [<c03f40b5>] __mutex_lock_slowpath+0xc8/0x230
 [<c03f3fe0>] mutex_lock+0x21/0x24
 [<c01484f3>] container_rmdir+0x15/0x163
 [<c017b711>] vfs_rmdir+0x59/0x8f
 [<c017b7d3>] do_rmdir+0x8c/0xbe
 [<c017b815>] sys_rmdir+0x10/0x12
 [<c0104cc2>] sysenter_past_esp+0x5f/0x99
 =======================
-- 
regards,
Dhaval

I would like to change the world but they don't give me the source code!
