Return-Path: <linux-kernel-owner+w=401wt.eu-S934250AbZKYDRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934250AbZKYDRy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758289AbZKYDRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:17:54 -0500
Received: from b.mail.sonic.net ([64.142.19.5]:56053 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758280AbZKYDRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:17:53 -0500
X-Greylist: delayed 803 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2009 22:17:53 EST
Message-ID: <4B0CA171.8040904@animats.com>
Date: Tue, 24 Nov 2009 19:16:01 -0800
From: John Nagle <nagle@animats.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: "Oops" in prune_one_dentry - known problems, but have they been fixed?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    I've had a previously stable production server (up for over a year
until recently) fail twice with an "oops" in prune_one_dentry.  A Google
search for "oops prune_one_dentry" returns over 5000 hits, so there are
known problems in this area.  I'm seeing relevant LKML postings from
2002 to 2007, so this is an area known to be troublesome.  Much of
the discussion revolves around unmounting, though, and nothing
was being mounted or unmounted for these crashes.  The server was
mostly running MySQL with a few databases in the 4-8GB range open,
so there were enough open files to eat up all available memory
as cache.

    It's clear that this class of problem arises when memory is needed,
the kernel tries to free up some space by taking it from the file
cache, and fails to do so.

    The question is, are there still problems in this area,
or has this area been fixed?

    We also had some database corruption (using InnoDB, where
that's not supposed to happen without a hardware failure) which
suggests that the cache system may have been corrupted and
wrote bad data before the "oops" check detected a problem.
That's the main reason I'm posting this.  A bug which can corrupt
an ACID database should be reported.

    Yes, it's an older 2.6 kernel.  It's a production system.

    (Meanwhile, we added 2GB of RAM to the server, which seems
to solve the problem for practical purposes.)

(Please cc on reply; I'll check the LKML archives but don't subscribe
to the list directly.)

					John Nagle

System is: Linux 2.6.18-1.2239.fc5smp

Message from syslogd@69-64-67-33 at Tue Nov 24 10:12:03 2009 ...
69-64-67-33 kernel: Oops: 0000 [#1]
69-64-67-33 kernel: SMP
69-64-67-33 kernel: CPU:    0
69-64-67-33 kernel: EIP is at iput+0x25/0x66
69-64-67-33 kernel: eax: 0000ef53   ebx: f154c7ec   ecx: f154c804   edx: d4877118
69-64-67-33 kernel: esi: d4877240   edi: d4877248   ebp: 00000000   esp: f7f7bee4
69-64-67-33 kernel: ds: 007b   es: 007b   ss: 0068
69-64-67-33 kernel: Process kswapd0 (pid: 171, ti=f7f7b000 task=f7efa720 
task.ti=f7f7b000)
69-64-67-33 kernel: Stack: d4877240 c0483114 c1a6383c d4877240 c04832d3 0000005e 
00003a98 f7ffb480
69-64-67-33 kernel:        00000083 000000d0 c048331e c0459086 c04566ae c067b680 
0000c101 000ea600
69-64-67-33 kernel:        00000000 000ea600 000399ff 00000080 00000000 00000000 
c067b680 c067b680
69-64-67-33 kernel: Call Trace:
69-64-67-33 kernel:  [<c0483114>] prune_one_dentry+0x3f/0x60
69-64-67-33 kernel:  [<c04832d3>] prune_dcache+0xe4/0x119
69-64-67-33 kernel:  [<c048331e>] shrink_dcache_memory+0x16/0x2d
69-64-67-33 kernel:  [<c0459086>] shrink_slab+0xd9/0x142
69-64-67-33 kernel:  [<c045942f>] kswapd+0x2c4/0x3a7
69-64-67-33 kernel:  [<c0436e7f>] kthread+0xc0/0xed
69-64-67-33 kernel:  [<c0404ccb>] kernel_thread_helper+0x7/0x10
69-64-67-33 kernel: DWARF2 unwinder stuck at kernel_thread_helper+0x7/0x10
69-64-67-33 kernel: Leftover inexact backtrace:
69-64-67-33 kernel:  =======================
69-64-67-33 kernel: Code: 00 5b 5e 5f 5d c3 85 c0 53 89 c3 74 5d 8b 80 c0 00 00 
00 83 bb 8c 01 00 00 20 8b 40 20 75 08 0f 0b

73 04 33 86 63 c0 85 c0 74 0b <8b> 50 14 85 d2 74 04 89 d8 ff d2 8d 43 24 ba e8 
0e 68 c0 e8 ed
69-64-67-33 kernel: EIP: [<c0484077>] iput+0x25/0x66 SS:ESP 0068:f7f7bee4
69-64-67-33 kernel: Oops: 0000 [#2]
69-64-67-33 kernel: SMP
69-64-67-33 kernel: CPU:    0
69-64-67-33 kernel: EIP is at _raw_spin_lock+0x8/0xdc
69-64-67-33 kernel: eax: 0000005c   ebx: f154c21c   ecx: e42e6210   edx: f154c21c
69-64-67-33 kernel: esi: 0000005c   edi: 00000059   ebp: 00000059   esp: ed1a1c34
69-64-67-33 kernel: ds: 007b   es: 007b   ss: 0068
69-64-67-33 kernel: Process update.pl (pid: 27343, ti=ed1a1000 task=eb2d4760 
task.ti=ed1a1000)
69-64-67-33 kernel: Stack: 00000001 c15449e0 c16244e0 c1538120 c1538180 c153bb40 
f154c21c 0000005c
69-64-67-33 kernel:        00000059 c04729a9 f154c0e4 00000000 c04849e1 00000080 
f154c344 dbde60ec
69-64-67-33 kernel:        00000d48 f7ffb460 00000080 000201d2 c0459086 c04566ae 
c067db80 0000c101
69-64-67-33 kernel: Call Trace:
69-64-67-33 kernel:  [<c04729a9>] remove_inode_buffers+0x2d/0x60
69-64-67-33 kernel:  [<c04849e1>] shrink_icache_memory+0xbb/0x1a8
69-64-67-33 kernel:  [<c0459086>] shrink_slab+0xd9/0x142
69-64-67-33 kernel:  [<c0459929>] try_to_free_pages+0x162/0x23d
69-64-67-33 kernel:  [<c0455ba1>] __alloc_pages+0x1a8/0x2aa
69-64-67-33 kernel:  [<c0456f3d>] __do_page_cache_readahead+0xc6/0x1c8
69-64-67-33 kernel:  [<c045708b>] blockable_page_cache_readahead+0x4c/0x9f
69-64-67-33 kernel:  [<c045715a>] make_ahead_window+0x7c/0x99
69-64-67-33 kernel:  [<c04572ea>] page_cache_readahead+0x173/0x196
69-64-67-33 kernel:  [<c04518df>] do_generic_mapping_read+0x13d/0x49b
69-64-67-33 kernel:  [<c04524fd>] __generic_file_aio_read+0x186/0x1cb
69-64-67-33 kernel:  [<c0452582>] generic_file_aio_read+0x40/0x47
69-64-67-33 kernel:  [<c046e0aa>] do_sync_read+0xc1/0xfb
69-64-67-33 kernel:  [<c046ea2c>] vfs_read+0xa6/0x157
69-64-67-33 kernel:  [<c046ee99>] sys_read+0x41/0x67
69-64-67-33 kernel:  [<c0403ec9>] sysenter_past_esp+0x56/0x79
69-64-67-33 kernel: DWARF2 unwinder stuck at sysenter_past_esp+0x56/0x79
69-64-67-33 kernel: Leftover inexact backtrace:
69-64-67-33 kernel:  =======================
69-64-67-33 kernel: Code: 08 74 0c ba b9 d3 63 c0 89 d8 e8 a4 fe ff ff c7 43 0c 
ff ff ff ff b0 01 c7 43 08 ff ff ff ff 86 03

5b c3 57 56 89 c6 53 83 ec 18 <81> 78 04 ad 4e ad de 74 0a ba a3 d3 63 c0 e8 75 
fe ff ff 89 e0
69-64-67-33 kernel: EIP: [<c04e7f84>] _raw_spin_lock+0x8/0xdc SS:ESP 0068:ed1a1c34

