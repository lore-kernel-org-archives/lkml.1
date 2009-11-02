Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbZKBVVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbZKBVVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 16:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755388AbZKBVVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 16:21:19 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45295 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755266AbZKBVVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 16:21:19 -0500
Date: Mon, 2 Nov 2009 16:21:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: linux-pcmcia@lists.infradead.org
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Lockdep violation in pcmcia
Message-ID: <Pine.LNX.4.44L0.0911021610030.28727-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been getting these warnings for a long, long time, and finally 
decided to report them:

[ 1893.033051] =============================================
[ 1893.036023] [ INFO: possible recursive locking detected ]
[ 1893.036023] 2.6.31 #2
[ 1893.036023] ---------------------------------------------
[ 1893.036023] cardmgr/1457 is trying to acquire lock:
[ 1893.036023]  (pcmcia_socket_list_rwsem){++++.+}, at: [<c8874867>] adjust_memory+0x71/0xbd [rsrc_nonstatic]
[ 1893.036023]
[ 1893.036023] but task is already holding lock:
[ 1893.036023]  (pcmcia_socket_list_rwsem){++++.+}, at: [<c8972e5b>] ds_ioctl+0x282/0xa6b [pcmcia]
[ 1893.036023]
[ 1893.036023] other info that might help us debug this:
[ 1893.036023] 2 locks held by cardmgr/1457:
[ 1893.036023]  #0:  (pcmcia_socket_list_rwsem){++++.+}, at: [<c8972e5b>] ds_ioctl+0x282/0xa6b [pcmcia]
[ 1893.036023]  #1:  (rsrc_mutex){+.+.+.}, at: [<c887482f>] adjust_memory+0x39/0xbd [rsrc_nonstatic]
[ 1893.036023]
[ 1893.036023] stack backtrace:
[ 1893.036023] Pid: 1457, comm: cardmgr Not tainted 2.6.31 #2
[ 1893.036023] Call Trace:
[ 1893.036023]  [<c1040143>] __lock_acquire+0x741/0xa61
[ 1893.036023]  [<c103ed06>] ? mark_held_locks+0x3b/0x56
[ 1893.036023]  [<c10404bb>] lock_acquire+0x58/0x7a
[ 1893.036023]  [<c8874867>] ? adjust_memory+0x71/0xbd [rsrc_nonstatic]
[ 1893.036023]  [<c11c1f28>] down_read+0x2a/0x3e
[ 1893.036023]  [<c8874867>] ? adjust_memory+0x71/0xbd [rsrc_nonstatic]
[ 1893.036023]  [<c8874867>] adjust_memory+0x71/0xbd [rsrc_nonstatic]
[ 1893.036023]  [<c88747f6>] ? adjust_memory+0x0/0xbd [rsrc_nonstatic]
[ 1893.036023]  [<c8972f05>] ds_ioctl+0x32c/0xa6b [pcmcia]
[ 1893.036023]  [<c10efa65>] ? _raw_spin_trylock+0x2b/0x30
[ 1893.036023]  [<c107c077>] vfs_ioctl+0x4c/0x65
[ 1893.036023]  [<c107c58a>] do_vfs_ioctl+0x451/0x478
[ 1893.036023]  [<c1040987>] ? lock_release+0x12c/0x133
[ 1893.036023]  [<c107c5db>] sys_ioctl+0x2a/0x43
[ 1893.036023]  [<c1002a48>] sysenter_do_call+0x12/0x36

Is this problem already well known?

The cause is easy enough to track down.  In pcmcia_ioctl.c,
pcmcia_adjust_resource_info() does a down_read() on
pcmcia_socket_list_rwsem.  While holding the rwsem, one of the pathways
calls the s->resource_ops->add_mem method.  On my system this method is
realized by adjust_memory() in rsrc_nonstatic.c, which does its own
down_read() on the same rwsem -- i.e., a recursive locking attempt.

The reason lockdep warns about this behavior is that it can lead to
deadlock in the wrong circumstances, namely, if another thread were to
do a down_write() in between the two down_read() calls.

Would it be correct simply to omit the down_read() in adjust_memory()?

Alan Stern

