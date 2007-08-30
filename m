Return-Path: <linux-kernel-owner+w=401wt.eu-S964984AbXH3TGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964984AbXH3TGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 15:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932865AbXH3TFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 15:05:53 -0400
Received: from li6-103.members.linode.com ([66.160.141.103]:4405 "EHLO
	smtp.falooley.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932657AbXH3TFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 15:05:52 -0400
X-Greylist: delayed 2497 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 15:05:52 EDT
Date: Thu, 30 Aug 2007 11:23:55 -0700
From: Jason Lunz <lunz@falooley.org>
To: jffs-dev@axis.com
Cc: David Woodhouse <dwmw2@infradead.org>, stable@kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: jffs2 deadlock introduced in linux 2.6.22.5
Message-ID: <20070830182354.GA25077@falooley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


commit 1d8715b388c978b0f1b1bf4812fcee0e73b023d7 was added between
2.6.22.4 and 2.6.22.5 to cure a locking problem, but it seems to have
introduced another (worse?) one.

With a jffs2 filesystem (on block2mtd) on a 2.6.22.5 kernel, if I do
anything that appends to a file with many small writes, I get what looks
like a deadlock between the writer and the jffs2 gc thread. For example:

	# while true; do echo >> /some/file/on/jffs2; done

will result in the bash hanging in D state, with these kernel stacks in
dmesg after "echo t > /proc/sysrq-trigger":

jffs2_gcd_mtd S DFD1EEA8     0  1086      2 (L-TLB)
       dfd1eebc 00000046 00000002 dfd1eea8 dfd1eea4 00000000 00000000 c0334a00 
       c0334a00 00000000 0000000a dfcb8550 2ee3df10 0000001a 00002280 dfcb8670 
       c1407a00 00000000 00000286 df9fa600 dfe20900 ffff414a c1407ec4 0000ffff 
Call Trace:
 [<c026b84c>] __down_interruptible+0xb2/0x10b
 [<c0269e4b>] __sched_text_start+0x14b/0x8a4
 [<c0115380>] default_wake_function+0x0/0xc
 [<c026b727>] __down_failed_interruptible+0x7/0xc
 [<e09425bd>] jffs2_garbage_collect_pass+0x20/0x597 [jffs2]
 [<c0120cd0>] __dequeue_signal+0xd7/0x11c
 [<c01209ed>] recalc_sigpending+0xb/0x1d
 [<c01221e5>] dequeue_signal+0x9d/0x117
 [<e09439e7>] jffs2_garbage_collect_thread+0x11b/0x15a [jffs2]
 [<c0103bf6>] ret_from_fork+0x6/0x1c
 [<e09438cc>] jffs2_garbage_collect_thread+0x0/0x15a [jffs2]
 [<e09438cc>] jffs2_garbage_collect_thread+0x0/0x15a [jffs2]
 [<c01048fb>] kernel_thread_helper+0x7/0x10

bash          D CE2C85E0     0  2223   2219 (NOTLB)
       d834bb2c 00000086 00000000 ce2c85e0 ce2c85e0 ce8004c0 00000003 c0334a00 
       c0334a00 00000000 00000009 df93ca70 2ee3bc90 0000001a 0002ff74 df93cb90 
       c1407a00 00000000 00000000 00000000 dfe20900 00000000 c1407ec4 00000000 
Call Trace:
 [<c026aa96>] io_schedule+0x1e/0x28
 [<c0139f4f>] sync_page+0x38/0x3b
 [<c026ad57>] __wait_on_bit+0x33/0x58
 [<c0139f17>] sync_page+0x0/0x3b
 [<c013a09d>] wait_on_page_bit+0x63/0x69
 [<c01286d4>] wake_bit_function+0x0/0x3c
 [<c013bce8>] read_cache_page+0x28/0x3f
 [<e0943b18>] jffs2_gc_fetch_page+0x26/0x3b [jffs2]
 [<e0941fa8>] jffs2_garbage_collect_live+0x992/0xf87 [jffs2]
 [<e08ee60e>] block2mtd_write+0x18f/0x1a6 [block2mtd]
 [<e08cd000>] default_mtd_writev+0x0/0x9e [mtdcore]
 [<e09449e2>] jffs2_flash_direct_writev+0x62/0xd0 [jffs2]
 [<e0942a9c>] jffs2_garbage_collect_pass+0x4ff/0x597 [jffs2]
 [<e0a02c82>] aufs_read_unlock+0x17/0x5f [aufs]
 [<e0a1d546>] ibend+0x39/0x3f [aufs]
 [<e093d3ba>] jffs2_reserve_space+0xb5/0x15b [jffs2]
 [<c0121e28>] send_sig_info+0x55/0x65
 [<e093f845>] jffs2_write_inode_range+0x5a/0x278 [jffs2]
 [<e093b696>] jffs2_commit_write+0xec/0x1be [jffs2]
 [<c013b494>] generic_file_buffered_write+0x3f1/0x5af
 [<c016135e>] dput+0x15/0xda
 [<c015b4d4>] __link_path_walk+0xb2d/0xc0e
 [<c011d750>] current_fs_time+0x41/0x46
 [<c013bacb>] __generic_file_aio_write_nolock+0x479/0x4c8
 [<c015b65e>] link_path_walk+0xa9/0xb3
 [<c013bb7b>] generic_file_aio_write+0x61/0xc2
 [<c0159936>] permission+0xc8/0xdb
 [<c0153384>] do_sync_write+0x0/0x10a
 [<c015344b>] do_sync_write+0xc7/0x10a
 [<c015c56e>] open_namei+0x254/0x571
 [<c01286a1>] autoremove_wake_function+0x0/0x33
 [<c0153384>] do_sync_write+0x0/0x10a
 [<c0153c2a>] vfs_write+0xa8/0x130
 [<c015419f>] sys_write+0x41/0x67
 [<c0103d12>] syscall_call+0x7/0xb

Given that I never saw any jffs2 deadlocks in other 2.6.22 kernels,
maybe that commit should be reverted until a better solution is found?

Jason
