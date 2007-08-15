Return-Path: <linux-kernel-owner+w=401wt.eu-S964858AbXHOUvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964858AbXHOUvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 16:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935855AbXHOUul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 16:50:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:44166 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934954AbXHOUui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 16:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=PJomoEB43bRL0pI33+0w7SKi+vtOKsoVfSZjTB15Il3V15ILVXjQu08fzkFmL7xC4fBbRQq4keDt9r6SgWABOmUqbDAmJBUvPyAkohTZwfFBQdX/OjmQt/DOffWYheAd8aHk9XcI6VS7Mim+uwm/ng8jE9w/yTc8tNps7KnqCFM=
Date: Thu, 16 Aug 2007 00:49:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org, trond.myklebust@fys.uio.no
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] nfs: fix oops re sysctls and V4 support
Message-ID: <20070815204958.GA20995@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NFS unregisters sysctls only if V4 support is compiled in. However, sysctl
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
---

 fs/nfs/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -345,8 +345,8 @@ void __exit unregister_nfs_fs(void)
 	unregister_shrinker(&acl_shrinker);
 #ifdef CONFIG_NFS_V4
 	unregister_filesystem(&nfs4_fs_type);
-	nfs_unregister_sysctl();
 #endif
+	nfs_unregister_sysctl();
 	unregister_filesystem(&nfs_fs_type);
 }
 

