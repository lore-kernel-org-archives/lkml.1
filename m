Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbYHODOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbYHODOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 23:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbYHODN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 23:13:56 -0400
Received: from mail.deathmatch.net ([70.167.247.36]:3764 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYHODNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 23:13:55 -0400
From: Bob Copeland <me@bobcopeland.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       snakebyte@gmx.de, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/2] omfs: fix potential oops when directory size is corrupted
Date: Thu, 14 Aug 2008 23:13:41 -0400
Message-Id: <1218770022-31956-1-git-send-email-me@bobcopeland.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing with a modified fsfuzzer reveals a couple of locations in omfs
where filesystem variables are ultimately used as loop counters with
insufficient sanity checking.  In this case, dir->i_size is used to
compute the number of buckets in the directory hash.  If too large,
readdir will overrun a buffer.

Since it's an invariant that dir->i_size is equal to the sysblock
size, and we already sanity check that, just use that value instead.
This fixes the following oops:

BUG: unable to handle kernel paging request at c978e004
IP: [<c032298e>] omfs_readdir+0x18e/0x32f
Oops: 0000 [#1] PREEMPT DEBUG_PAGEALLOC
Modules linked in:

Pid: 4796, comm: ls Not tainted (2.6.27-rc2 #12)
EIP: 0060:[<c032298e>] EFLAGS: 00010287 CPU: 0
EIP is at omfs_readdir+0x18e/0x32f
EAX: c978d000 EBX: 00000000 ECX: cbfcfaf8 EDX: cb2cf100
ESI: 00001000 EDI: 00000800 EBP: cb2d3f68 ESP: cb2d3f0c
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process ls (pid: 4796, ti=cb2d3000 task=cb175f40 task.ti=cb2d3000)
Stack: 00000002 00000000 00000000 c018a820 cb2d3f94 cb2cf100 cbfb0000 ffffff10
       cbfb3b80 cbfcfaf8 000001c9 00000a09 00000000 00000000 00000000 cbfcfbc8
       c9697000 cbfb3b80 22222222 00001000 c08e6cd0 cb2cf100 cbfb3b80 cb2d3f88
Call Trace:
 [<c018a820>] ? filldir64+0x0/0xcd
 [<c018a9f2>] ? vfs_readdir+0x56/0x82
 [<c018a820>] ? filldir64+0x0/0xcd
 [<c018aa7c>] ? sys_getdents64+0x5e/0xa0
 [<c01038bd>] ? sysenter_do_call+0x12/0x31
 =======================
Code: 00 89 f0 89 f3 0f ac f8 14 81 e3 ff ff 0f 00 48 8d
14 c5 b8 01 00 00 89 45 cc 89 55 f0 e9 8c 01 00 00 8b 4d c8 8b 75 f0 8b
41 18 <8b> 54 30 04 8b 04 30 31 f6 89 5d dc 89 d1 8b 55 b8 0f c8 0f c9

Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 fs/omfs/inode.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/omfs/inode.c b/fs/omfs/inode.c
index a95fe59..d29047b 100644
--- a/fs/omfs/inode.c
+++ b/fs/omfs/inode.c
@@ -232,8 +232,7 @@ struct inode *omfs_iget(struct super_block *sb, ino_t ino)
 		inode->i_mode = S_IFDIR | (S_IRWXUGO & ~sbi->s_dmask);
 		inode->i_op = &omfs_dir_inops;
 		inode->i_fop = &omfs_dir_operations;
-		inode->i_size = be32_to_cpu(oi->i_head.h_body_size) +
-			sizeof(struct omfs_header);
+		inode->i_size = sbi->s_sys_blocksize;
 		inc_nlink(inode);
 		break;
 	case OMFS_FILE:
-- 
1.5.4.2.182.gb3092


