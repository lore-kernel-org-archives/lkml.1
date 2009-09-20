Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbZITRzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbZITRzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 13:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755018AbZITRzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 13:55:25 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47626 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197AbZITRzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 13:55:24 -0400
Date: Sun, 20 Sep 2009 20:55:20 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, hugh.dickins@tiscali.co.uk
Subject: Re: shmem_fill_super(): WARNING: kmemcheck: Caught 32-bit read from
 	uninitialized memory
In-Reply-To: <19f34abd0909201035t3157948amee532a3a5e96dbab@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0909202046460.7394@melkki.cs.helsinki.fi>
References: <20090915080953.GA24958@elte.hu> <20090920072210.GA23787@elte.hu> <19f34abd0909201035t3157948amee532a3a5e96dbab@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009, Vegard Nossum wrote:
> Thanks for the report.
>
> AFAICT it's this line of mm/shmem.c:
>
> 2356         inode = shmem_get_inode(sb, S_IFDIR | sbinfo->mode, 0,
> VM_NORESERVE     );
>
> and the loading of sbinfo->mode. It fits with the offset 0x3c(%esi) ==
> the address reported by kmemcheck and the offset of ->mode:
>
> (gdb) p &((struct shmem_sb_info *) 0).mode
> $1 = (mode_t *) 0x3c
>
> Looking for the definition of mode_t, it seems to be defined in x86
> sources as unsigned short:
>
> arch/x86/include/asm/posix_types_32.h:11:typedef unsigned short __kernel_mode_t;
> include/linux/types.h:typedef __kernel_mode_t           mode_t;
>
> And the load was clearly 32-bit (kmemcheck said so) and in my assembly
> dump it is also so.
>
> As I said before, I really don't like the solution of sprinkling the
> kmemcheck annotations all over the place to cover up field padding
> inside structs, not in the least because they confuse more than they
> help, and they are not maintainable -- when somebody changes the
> struct definitions, anything may happen to the field layout, and then
> the annotation may have to change too. And it's not exactly obvious.
>
> I still vote for patching gcc as the long-term solution. There is
> -fmudflap, there is -fstack-protector, why not a -fsacred-padding? Of
> course it has to be implemented too...

As Ingo already explained, we would need to wait for a year or so for 
"-fscared-padding" to appear in a GCC release and probably one year more 
for it to be picked up by distributions.

So while we wait for such a thing to appear, how about something like 
this?

 			Pekka

>From a7cb569beb2d2fe769d558d1a017b6f5aa05d7eb Mon Sep 17 00:00:00 2001
From: Pekka Enberg <penberg@cs.helsinki.fi>
Date: Sun, 20 Sep 2009 20:43:35 +0300
Subject: [PATCH] shmem: initialize struct shmem_sb_info to zero

Fixes the following kmemcheck false positive:

[    0.337000] Total of 1 processors activated (3088.38 BogoMIPS).
[    0.352000] CPU0 attaching NULL sched-domain.
[    0.360000] WARNING: kmemcheck: Caught 32-bit read from uninitialized memory (9f8020fc)
[    0.361000] a44240820000000041f6998100000000000000000000000000000000ff030000
[    0.368000]  i i i i i i i i i i i i i i i i u u u u i i i i i i i i i i u u
[    0.375000]                                                          ^
[    0.376000]
[    0.377000] Pid: 9, comm: khelper Not tainted (2.6.31-tip #206) P4DC6
[    0.378000] EIP: 0060:[<810a3a95>] EFLAGS: 00010246 CPU: 0
[    0.379000] EIP is at shmem_fill_super+0xb5/0x120
[    0.380000] EAX: 00000000 EBX: 9f845400 ECX: 824042a4 EDX: 8199f641
[    0.381000] ESI: 9f8020c0 EDI: 9f845400 EBP: 9f81af68 ESP: 81cd6eec
[    0.382000]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[    0.383000] CR0: 8005003b CR2: 9f806200 CR3: 01ccd000 CR4: 000006d0
[    0.384000] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[    0.385000] DR6: ffff4ff0 DR7: 00000400
[    0.386000]  [<810c25fc>] get_sb_nodev+0x3c/0x80
[    0.388000]  [<810a3514>] shmem_get_sb+0x14/0x20
[    0.390000]  [<810c207f>] vfs_kern_mount+0x4f/0x120
[    0.392000]  [<81b2849e>] init_tmpfs+0x7e/0xb0
[    0.394000]  [<81b11597>] do_basic_setup+0x17/0x30
[    0.396000]  [<81b11907>] kernel_init+0x57/0xa0
[    0.398000]  [<810039b7>] kernel_thread_helper+0x7/0x10
[    0.400000]  [<ffffffff>] 0xffffffff
[    0.402000] khelper used greatest stack depth: 2820 bytes left
[    0.407000] calling  init_mmap_min_addr+0x0/0x10 @ 1
[    0.408000] initcall init_mmap_min_addr+0x0/0x10 returned 0 after 0 usecs

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
  mm/shmem.c |    5 +----
  1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index d713239..a8f54f3 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2307,17 +2307,14 @@ static int shmem_fill_super(struct super_block *sb,
  	int err = -ENOMEM;

  	/* Round up to L1_CACHE_BYTES to resist false sharing */
-	sbinfo = kmalloc(max((int)sizeof(struct shmem_sb_info),
+	sbinfo = kzalloc(max((int)sizeof(struct shmem_sb_info),
  				L1_CACHE_BYTES), GFP_KERNEL);
  	if (!sbinfo)
  		return -ENOMEM;

-	sbinfo->max_blocks = 0;
-	sbinfo->max_inodes = 0;
  	sbinfo->mode = S_IRWXUGO | S_ISVTX;
  	sbinfo->uid = current_fsuid();
  	sbinfo->gid = current_fsgid();
-	sbinfo->mpol = NULL;
  	sb->s_fs_info = sbinfo;

  #ifdef CONFIG_TMPFS
-- 
1.5.6.4

