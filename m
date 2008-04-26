Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbYDZRyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbYDZRyD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 13:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYDZRxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 13:53:54 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:44659 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbYDZRxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 13:53:53 -0400
Date: Sat, 26 Apr 2008 19:53:51 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: current git: spinlock lockup while starting init
Message-ID: <20080426175351.GA19032@Chamillionaire.breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit:

|[bigeasy@inhell4 linux-2.6-powerpc]$ git-bisect good
|3b1253880b7a9e6db54b943b2d40bcf2202f58ab is first bad commit
|commit 3b1253880b7a9e6db54b943b2d40bcf2202f58ab
|Author: Al Viro <viro@zeniv.linux.org.uk>
|Date:   Tue Apr 22 05:31:30 2008 -0400
|
|    [PATCH] sanitize unshare_files/reset_files_struct
|    
|    * let unshare_files() give caller the displaced files_struct
|    * don't bother with grabbing reference only to drop it in the
|      caller if it hadn't been shared in the first place
|    * in that form unshare_files() is trivially implemented via
|      unshare_fd(), so we eliminate the duplicate logics in fork.c
|    * reset_files_struct() is not just only called for current;
|      it will break the system if somebody ever calls it for anything
|      else (we can't modify ->files of somebody else).  Lose the
|      task_struct * argument.
|    
|    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
|
|:040000 040000 d5e24911e5862fb24182ed585c1cfdf82815a061 c659b2063e16cc673cb0cd71c93ec8a5db5c0604 M      fs
|:040000 040000 d205319dede1282780fa21e0e848cb194b7b0667 a10c0ce8698645f655709a43eb2e0311aca3bcfe M      include
|:040000 040000 3003d57d938b23b8193ea5cc7b0f74a35bb67ad5 30299861ee7931756c971c18151ca5c008f2342d M      kernel
|

leads to

|[    4.294860] Looking up port of RPC 100003/2 on 192.168.0.71
|[    4.294868] Looking up port of RPC 100005/1 on 192.168.0.71
|[    4.294962] VFS: Mounted root (nfs filesystem) readonly.
|[    4.294962] Freeing unused kernel memory: 120k init
|[    4.294962] BUG: spinlock lockup on CPU#0, swapper/1, df850024
|[    4.294962] Call Trace:
|[    4.294962] [df851d40] [c0006d60] show_stack+0x48/0x184 (unreliable)
|[    4.294962] [df851d60] [c0146a5c] _raw_spin_lock+0xf4/0x118
|[    4.294962] [df851d80] [c0269ec4] _spin_lock+0x20/0x30
|[    4.294962] [df851d90] [c0078774] get_unused_fd_flags+0x24/0x114
|[    4.294962] [df851db0] [c00b0ef8] load_elf_binary+0x10c/0x10bc
|[    4.294962] [df851e20] [c007f710] search_binary_handler+0xdc/0x298
|[    4.294962] [df851e50] [c0080a30] do_execve+0x140/0x1d4
|[    4.294962] [df851e80] [c00074f0] sys_execve+0x58/0x84
|[    4.294962] [df851ea0] [c000dee0] ret_from_syscall+0x0/0x3c
|[    4.294962] [df851f60] [00000000] 0x0
|[    4.294962] [df851f70] [c0001ba0] init_post+0xb0/0xe0
|[    4.294962] [df851f80] [c034b35c] kernel_init+0x25c/0x274
|[    4.294962] [df851ff0] [c000dca0] kernel_thread+0x44/0x60

while booting my cute powerpc. Usually I see

|[    4.294763] Looking up port of RPC 100003/2 on 192.168.0.71
|[    4.294771] Looking up port of RPC 100005/1 on 192.168.0.71
|[    4.294781] VFS: Mounted root (nfs filesystem) readonly.
|[    4.294794] Freeing unused kernel memory: 120k init
|INIT: version 2.86 booting

but not this time. It seems to be the first exec(). A quick git revert
3b125388 allows me to boot again.

Sebastian
