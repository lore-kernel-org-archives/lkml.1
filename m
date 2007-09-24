Return-Path: <linux-kernel-owner+w=401wt.eu-S1762065AbXIXQfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762065AbXIXQfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760706AbXIXQ0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:26:44 -0400
Received: from canuck.infradead.org ([209.217.80.40]:47525 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759331AbXIXQ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:26:41 -0400
Date: Mon, 24 Sep 2007 09:21:35 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, bfields@fieldses.org,
       trond.myklebust@fys.uio.no, adobriyan@gmail.com
Subject: [28/50] nfs: fix oops re sysctls and V4 support
Message-ID: <20070924162135.GC13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="nfs-fix-oops-re-sysctls-and-v4-support.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alexey Dobriyan <adobriyan@gmail.com>

commit 49af7ee181f4f516ac99eba85d3f70ed42cabe76 in mainline.

NFS unregisters sysctls only if V4 support is compiled in.  However, sysctl
table is not V4 specific, so unregister it always.

Steps to reproduce:

	[build nfs.ko with CONFIG_NFS_V4=n]
	modrobe nfs
	rmmod nfs
	ls /proc/sys

Unable to handle kernel paging request at ffffffff880661c0 RIP:
 [<ffffffff802af8e3>] proc_sys_readdir+0xd3/0x350
PGD 203067 PUD 207063 PMD 7e216067 PTE 0
Oops: 0000 [1] SMP
CPU 1
Modules linked in: lockd nfs_acl sunrpc
Pid: 3335, comm: ls Not tainted 2.6.23-rc3-bloat #2
RIP: 0010:[<ffffffff802af8e3>]  [<ffffffff802af8e3>] proc_sys_readdir+0xd3/0x350
RSP: 0018:ffff81007fd93e78  EFLAGS: 00010286
RAX: ffffffff880661c0 RBX: ffffffff80466370 RCX: ffffffff880661c0
RDX: 00000000000014c0 RSI: ffff81007f3ad020 RDI: ffff81007efd8b40
RBP: 0000000000000018 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: ffffffff802a8570 R12: ffffffff880661c0
R13: ffff81007e219640 R14: ffff81007efd8b40 R15: ffff81007ded7280
FS:  00002ba25ef03060(0000) GS:ffff81007ff81258(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: ffffffff880661c0 CR3: 000000007dfaf000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process ls (pid: 3335, threadinfo ffff81007fd92000, task ffff81007d8a0000)
Stack:  ffff81007f3ad150 ffffffff80283f30 ffff81007fd93f48 ffff81007efd8b40
 ffff81007ee00440 0000000422222222 0000000200035593 ffffffff88037e9a
 2222222222222222 ffffffff80466500 ffff81007e416400 ffff81007e219640
Call Trace:
 [<ffffffff80283f30>] filldir+0x0/0xf0
 [<ffffffff80283f30>] filldir+0x0/0xf0
 [<ffffffff802840c7>] vfs_readdir+0xa7/0xc0
 [<ffffffff80284376>] sys_getdents+0x96/0xe0
 [<ffffffff8020bb3e>] system_call+0x7e/0x83

Code: 41 8b 14 24 85 d2 74 dc 49 8b 44 24 08 48 85 c0 74 e7 49 3b
RIP  [<ffffffff802af8e3>] proc_sys_readdir+0xd3/0x350
 RSP <ffff81007fd93e78>
CR2: ffffffff880661c0
Kernel panic - not syncing: Fatal exception

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 fs/nfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -181,8 +181,8 @@ void __exit unregister_nfs_fs(void)
 		remove_shrinker(acl_shrinker);
 #ifdef CONFIG_NFS_V4
 	unregister_filesystem(&nfs4_fs_type);
-	nfs_unregister_sysctl();
 #endif
+	nfs_unregister_sysctl();
 	unregister_filesystem(&nfs_fs_type);
 }
 

-- 
