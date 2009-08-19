Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbZHSS2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbZHSS2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 14:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbZHSS2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 14:28:43 -0400
Received: from newpeace.netnation.com ([204.174.223.7]:47030 "EHLO
	peace.netnation.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751491AbZHSS2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 14:28:42 -0400
X-Greylist: delayed 1249 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2009 14:28:42 EDT
Date: Wed, 19 Aug 2009 11:07:54 -0700
From: Simon Kirby <sim@hostway.ca>
To: linux-kernel@vger.kernel.org
Subject: Processes hanging under heavy write loads
Message-ID: <20090819180754.GB7068@hostway.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On an storage head box running 2.6.30, it's easy to see even sshd hang
when allocating memory to send a packet (eg: while watching "top"),
sometimes for several seconds.  The hung process detector, with the
timeout lowered a bit, spits out a backtrace such as:

INFO: task sshd:31015 blocked for more than 4 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
sshd          D ffffffff8087b144     0 31015   3378
 ffff8801c5afd918 0000000000000086 0000000000000000 ffff880100b3e070
 ffff880100b3ddc0 ffff880183757080 ffff880100b3e070 ffffe2000dd81780
 ffff8801c5afd8f8 ffffffff8028c235 ffffe2000e578bd0 ffffffffffffffff
Call Trace:
 [<ffffffff8028c235>] ? determine_dirtyable_memory+0x15/0x30
 [<ffffffff806cf451>] __mutex_lock_slowpath+0xd1/0x150
 [<ffffffff806cf2be>] mutex_lock+0x1e/0x40
 [<ffffffff802c77dd>] shrink_icache_memory+0x7d/0x2b0
 [<ffffffff80291445>] shrink_slab+0x125/0x180
 [<ffffffff8029170a>] try_to_free_pages+0x26a/0x3e0
 [<ffffffff8028f5a0>] ? isolate_pages_global+0x0/0x290
 [<ffffffff8028af0f>] __alloc_pages_internal+0x19f/0x440
 [<ffffffff802c3a90>] ? pollwake+0x0/0x60
 [<ffffffff802ae061>] __slab_alloc+0x151/0x570
 [<ffffffff80617006>] ? __alloc_skb+0x46/0x170
 [<ffffffff802ae5b9>] kmem_cache_alloc+0xb9/0x110
 [<ffffffff80617006>] __alloc_skb+0x46/0x170
 [<ffffffff8064b041>] sk_stream_alloc_skb+0x41/0x110
 [<ffffffff8064c550>] tcp_sendmsg+0x2f0/0xad0
 [<ffffffff8060e920>] sock_aio_write+0xf0/0x100
 [<ffffffff802b3b61>] do_sync_write+0xf1/0x130
 [<ffffffff80256660>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff802453e2>] ? current_fs_time+0x22/0x30
 [<ffffffff80494028>] ? tty_ldisc_deref+0x58/0x70
 [<ffffffff802b4455>] vfs_write+0x175/0x180
 [<ffffffff802b4a30>] sys_write+0x50/0x90
 [<ffffffff8020be02>] system_call_fastpath+0x16/0x1b

...This mutex appears to be iprune_mutex, called from prune_icache in
fs/inode.c.  I watched this for a while, and all of the backtraces seem
to be the same.

Would it be a reasonable idea to convert this to a mutex_trylock since a
holder of it is trying to do the same work anyway?  I'm not sure what is
taking so long during heavy write sessions, but it has to be either
invalidate_inodes() or prune_icache().

The current behaviour is horrible to work with when non-guilty processes,
such as sshd, happen to get stuck on it...

Simon-
