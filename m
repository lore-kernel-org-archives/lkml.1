Return-Path: <linux-kernel-owner+w=401wt.eu-S1752717AbXHRFSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbXHRFSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 01:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751033AbXHRFSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 01:18:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36548
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750833AbXHRFR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 01:17:59 -0400
Date: Fri, 17 Aug 2007 22:17:58 -0700 (PDT)
Message-Id: <20070817.221758.116352652.davem@davemloft.net>
To: clameter@sgi.com
CC: linux-kernel@vger.kernel.org
Subject: SLUB bug on sparc64
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Christoph,

When I force SLUB debugging on sparc64, it barfs on early bootup while
making the sysfs nodes.  Removing the BUG()'s on the sysfs error
returns, and adding some tracing I captured the log below.

BTW, I would recommending removing the BUG() calls, they serve only to
force someone hitting them to edit them out and reboot which is
absolutely pointless :-) This code can also often run before the
console is first enabled, making analysis of the error return that
much harder if it BUG()'s instead of trying to continue.

The problem seems to be that both tsb_512KB and tsb_1MB are
unmergeable, and so are the kmalloc caches of those sizes.  But the
"unique name" created for the aliases are identical, always ":%d"
where %d is the cache size, so the kobject_add() fails the second
time around.

[16529.414107] sysfs_slab_add: name[shmem_inode_cache] size[800] unmergeable[1]
[16529.414958] sysfs_slab_add: name[nsproxy] size[120] unmergeable[1]
[16529.415683] sysfs_slab_add: name[posix_timers_cache] size[232] unmergeable[1]
[16529.416459] sysfs_slab_add: name[uid_cache] size[160] unmergeable[1]
[16529.417180] sysfs_slab_add: name[ip_mrt_cache] size[192] unmergeable[1]
[16529.417952] sysfs_slab_add: name[UDP-Lite] size[800] unmergeable[1]
[16529.418674] sysfs_slab_add: name[tcp_bind_bucket] size[128] unmergeable[1]
[16529.419402] sysfs_slab_add: name[inet_peer_cache] size[160] unmergeable[1]
[16529.420179] sysfs_slab_add: name[secpath_cache] size[128] unmergeable[1]
[16529.420913] sysfs_slab_add: name[xfrm_dst_cache] size[416] unmergeable[1]
[16529.421689] sysfs_slab_add: name[ip_fib_alias] size[128] unmergeable[1]
[16529.422417] sysfs_slab_add: name[ip_fib_hash] size[128] unmergeable[1]
[16529.423194] sysfs_slab_add: name[ip_dst_cache] size[384] unmergeable[1]
[16529.423930] sysfs_slab_add: name[arp_cache] size[288] unmergeable[1]
[16529.424723] sysfs_slab_add: name[RAW] size[800] unmergeable[1]
[16529.425445] sysfs_slab_add: name[UDP] size[800] unmergeable[1]
[16529.426234] sysfs_slab_add: name[tw_sock_TCP] size[224] unmergeable[1]
[16529.426968] sysfs_slab_add: name[request_sock_TCP] size[160] unmergeable[1]
[16529.427745] sysfs_slab_add: name[TCP] size[1568] unmergeable[1]
[16529.428467] sysfs_slab_add: name[eventpoll_pwq] size[144] unmergeable[1]
[16529.429244] sysfs_slab_add: name[eventpoll_epi] size[224] unmergeable[1]
[16529.429977] sysfs_slab_add: name[sgpool-128] size[3168] unmergeable[1]
[16529.430753] sysfs_slab_add: name[sgpool-64] size[1632] unmergeable[1]
[16529.431495] sysfs_slab_add: name[sgpool-32] size[864] unmergeable[1]
[16529.432223] sysfs_slab_add: name[sgpool-16] size[480] unmergeable[1]
[16529.432995] sysfs_slab_add: name[sgpool-8] size[288] unmergeable[1]
[16529.433722] sysfs_slab_add: name[scsi_io_context] size[184] unmergeable[1]
[16529.434528] sysfs_slab_add: name[blkdev_ioc] size[136] unmergeable[1]
[16529.435254] sysfs_slab_add: name[blkdev_queue] size[1624] unmergeable[1]
[16529.436028] sysfs_slab_add: name[blkdev_requests] size[360] unmergeable[1]
[16529.436760] sysfs_slab_add: name[biovec-256] size[4192] unmergeable[1]
[16529.437538] sysfs_slab_add: name[biovec-128] size[2144] unmergeable[1]
[16529.438270] sysfs_slab_add: name[biovec-64] size[1120] unmergeable[1]
[16529.439041] sysfs_slab_add: name[biovec-16] size[352] unmergeable[1]
[16529.439768] sysfs_slab_add: name[biovec-4] size[160] unmergeable[1]
[16529.440540] sysfs_slab_add: name[biovec-1] size[88] unmergeable[1]
[16529.441266] sysfs_slab_add: name[bio] size[192] unmergeable[1]
[16529.442035] sysfs_slab_add: name[sock_inode_cache] size[704] unmergeable[1]
[16529.442901] sysfs_slab_add: name[skbuff_fclone_cache] size[480] unmergeable[1]
[16529.443710] sysfs_slab_add: name[skbuff_head_cache] size[288] unmergeable[1]
[16529.444465] sysfs_slab_add: name[file_lock_cache] size[248] unmergeable[1]
[16529.445197] sysfs_slab_add: name[proc_inode_cache] size[640] unmergeable[1]
[16529.445993] sysfs_slab_add: name[sigqueue] size[232] unmergeable[1]
[16529.446730] sysfs_slab_add: name[radix_tree_node] size[624] unmergeable[1]
[16529.447515] sysfs_slab_add: name[bdev_cache] size[832] unmergeable[1]
[16529.448250] sysfs_slab_add: name[sysfs_dir_cache] size[160] unmergeable[1]
[16529.449103] sysfs_slab_add: name[mnt_cache] size[288] unmergeable[1]
[16529.449836] sysfs_slab_add: name[inode_cache] size[608] unmergeable[1]
[16529.450616] sysfs_slab_add: name[dentry] size[280] unmergeable[1]
[16529.451347] sysfs_slab_add: name[filp] size[288] unmergeable[1]
[16529.452127] sysfs_slab_add: name[names_cache] size[4192] unmergeable[1]
[16529.452890] sysfs_slab_add: name[key_jar] size[224] unmergeable[1]
[16529.453670] sysfs_slab_add: name[idr_layer_cache] size[600] unmergeable[1]
[16529.454515] sysfs_slab_add: name[buffer_head] size[176] unmergeable[1]
[16529.455293] sysfs_slab_add: name[mm_struct] size[1056] unmergeable[1]
[16529.456028] sysfs_slab_add: name[vm_area_struct] size[240] unmergeable[1]
[16529.456807] sysfs_slab_add: name[fs_cache] size[160] unmergeable[1]
[16529.457542] sysfs_slab_add: name[files_cache] size[800] unmergeable[1]
[16529.458280] sysfs_slab_add: name[signal_cache] size[800] unmergeable[1]
[16529.459064] sysfs_slab_add: name[sighand_cache] size[2688] unmergeable[1]
[16529.459831] sysfs_slab_add: name[task_struct] size[1376] unmergeable[1]
[16529.460615] sysfs_slab_add: name[anon_vma] size[96] unmergeable[1]
[16529.461346] sysfs_slab_add: name[tsb_1MB] size[1048576] unmergeable[0]
[16529.462161] sysfs_slab_alias: name[tsb_1MB] size[1048576]
[16529.462212] sysfs_slab_add: name[tsb_512KB] size[524288] unmergeable[0]
[16529.462969] sysfs_slab_alias: name[tsb_512KB] size[524288]
[16529.463020] sysfs_slab_add: name[tsb_256KB] size[524288] unmergeable[1]
[16529.463796] sysfs_slab_add: name[tsb_128KB] size[262144] unmergeable[1]
[16529.464573] sysfs_slab_add: name[tsb_64KB] size[131072] unmergeable[1]
[16529.465354] sysfs_slab_add: name[tsb_32KB] size[65536] unmergeable[1]
[16529.466107] sysfs_slab_add: name[tsb_16KB] size[32768] unmergeable[1]
[16529.466888] sysfs_slab_add: name[tsb_8KB] size[16384] unmergeable[1]
[16529.467627] sysfs_slab_add: name[pid] size[136] unmergeable[1]
[16529.468407] sysfs_slab_add: name[kmalloc-8388608] size[8388608] unmergeable[0]
[16529.469144] sysfs_slab_alias: name[kmalloc-8388608] size[8388608]
[16529.469197] sysfs_slab_add: name[kmalloc-4194304] size[4194304] unmergeable[0]
[16529.469976] sysfs_slab_alias: name[kmalloc-4194304] size[4194304]
[16529.470031] sysfs_slab_add: name[kmalloc-2097152] size[2097152] unmergeable[0]
[16529.470764] sysfs_slab_alias: name[kmalloc-2097152] size[2097152]
[16529.470819] sysfs_slab_add: name[kmalloc-1048576] size[1048576] unmergeable[0]
[16529.470876] kobject_add failed for :1048576 with -EEXIST, don't try to register things with the same name in the same directory.
[16529.470907] Call Trace:
[16529.470921]  [00000000004bcf24] sysfs_slab_add+0x168/0x1bc
[16529.470955]  [00000000008313f4] slab_sysfs_init+0x58/0xb8
[16529.470986]  [0000000000820370] kernel_init+0x22c/0x3ac
[16529.471016]  [0000000000427844] kernel_thread+0x38/0x48
[16529.471039]  [00000000006cf278] rest_init+0x18/0x60
[16529.471062] sysfs_slab_add: name[kmalloc-524288] size[524288] unmergeable[0]
[16529.471113] kobject_add failed for :0524288 with -EEXIST, don't try to register things with the same name in the same directory.
[16529.471142] Call Trace:
[16529.471155]  [00000000004bcf24] sysfs_slab_add+0x168/0x1bc
[16529.471180]  [00000000008313f4] slab_sysfs_init+0x58/0xb8
[16529.471204]  [0000000000820370] kernel_init+0x22c/0x3ac
[16529.471227]  [0000000000427844] kernel_thread+0x38/0x48
[16529.471248]  [00000000006cf278] rest_init+0x18/0x60
[16529.471271] sysfs_slab_add: name[kmalloc-262144] size[262216] unmergeable[1]
[16529.472052] sysfs_slab_add: name[kmalloc-131072] size[131144] unmergeable[1]
[16529.472794] sysfs_slab_add: name[kmalloc-65536] size[65608] unmergeable[1]
[16529.473584] sysfs_slab_add: name[kmalloc-32768] size[32840] unmergeable[1]
[16529.474913] sysfs_slab_add: name[kmalloc-16384] size[16456] unmergeable[1]
[16529.475648] sysfs_slab_add: name[kmalloc-8192] size[8264] unmergeable[1]
[16529.476431] sysfs_slab_add: name[kmalloc-4096] size[4168] unmergeable[1]
[16529.477168] sysfs_slab_add: name[kmalloc-2048] size[2120] unmergeable[1]
[16529.477952] sysfs_slab_add: name[kmalloc-1024] size[1096] unmergeable[1]
[16529.478689] sysfs_slab_add: name[kmalloc-512] size[584] unmergeable[1]
[16529.479473] sysfs_slab_add: name[kmalloc-256] size[328] unmergeable[1]
[16529.480211] sysfs_slab_add: name[kmalloc-128] size[200] unmergeable[1]
[16529.480995] sysfs_slab_add: name[kmalloc-64] size[136] unmergeable[1]
[16529.481731] sysfs_slab_add: name[kmalloc-32] size[104] unmergeable[1]
[16529.482527] sysfs_slab_add: name[kmalloc-16] size[88] unmergeable[1]
[16529.483273] sysfs_slab_add: name[kmalloc-8] size[80] unmergeable[1]
[16529.484058] sysfs_slab_add: name[kmalloc-192] size[264] unmergeable[1]
[16529.484830] sysfs_slab_add: name[kmalloc-96] size[168] unmergeable[1]
[16529.485654] sysfs_slab_add: name[fasync_cache] size[96] unmergeable[1]
[16529.486426] sysfs_slab_add: name[kiocb] size[320] unmergeable[1]
[16529.487242] sysfs_slab_add: name[kioctx] size[384] unmergeable[1]
[16529.496786] sysfs_slab_add: name[inotify_watch_cache] size[144] unmergeable[1]
[16529.497582] sysfs_slab_add: name[inotify_event_cache] size[112] unmergeable[1]
[16529.498530] sysfs_slab_add: name[dnotify_cache] size[112] unmergeable[1]
[16529.499424] sysfs_slab_add: name[ext3_xattr] size[160] unmergeable[1]
[16529.500238] sysfs_slab_add: name[ext3_inode_cache] size[808] unmergeable[1]
[16529.501040] sysfs_slab_add: name[revoke_record] size[128] unmergeable[1]
[16529.501861] sysfs_slab_add: name[revoke_table] size[88] unmergeable[1]
[16529.502638] sysfs_slab_add: name[journal_head] size[168] unmergeable[1]
[16529.503459] sysfs_slab_add: name[journal_handle] size[96] unmergeable[1]
[16529.504315] sysfs_slab_add: name[ext2_xattr] size[160] unmergeable[1]
[16529.505127] sysfs_slab_add: name[ext2_inode_cache] size[768] unmergeable[1]
[16529.505904] sysfs_slab_add: name[hugetlbfs_inode_cache] size[608] unmergeable[1]
[16529.506902] sysfs_slab_add: name[mqueue_inode_cache] size[896] unmergeable[1]
[16529.507830] sysfs_slab_add: name[bsg_cmd] size[384] unmergeable[1]

