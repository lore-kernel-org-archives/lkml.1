Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbZGNM0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbZGNM0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 08:26:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbZGNM0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 08:26:43 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36402 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbZGNM0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 08:26:42 -0400
Subject: ext4 memory leak (was Re: [PATCH] x86: _edata should include all
	.data.* sections on X86_64)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       linux-ext4@vger.kernel.org
In-Reply-To: <4A5C5FD0.3020204@fisher-privat.net>
References: <4A5C20E5.6010203@fisher-privat.net>
	 <84144f020907140019g511723dctb541f6333d1a082b@mail.gmail.com>
	 <4A5C41C8.7040904@fisher-privat.net>
	 <1247564356.28240.30.camel@pc1117.cambridge.arm.com>
	 <1247565175.28240.37.camel@pc1117.cambridge.arm.com>
	 <4A5C5A59.5080304@fisher-privat.net>
	 <1247567499.28240.48.camel@pc1117.cambridge.arm.com>
	 <4A5C5FD0.3020204@fisher-privat.net>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 14 Jul 2009 13:26:30 +0100
Message-Id: <1247574390.28240.67.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2009 12:26:31.0228 (UTC) FILETIME=[5171BFC0:01CA047E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(I cc'ed linux-ext4@vger.kernel.org as well)

On Tue, 2009-07-14 at 12:37 +0200, Alexey Fisher wrote:
> this is complete trace from debug/kmemleak .
[...]
> i will compile now latest linux-arm.org/linux-2.6.git
> unreferenced object 0xffff880132c48890 (size 1024):
>    comm "exe", pid 1612, jiffies 4294894130
>    backtrace:
>      [<ffffffff810fbaca>] create_object+0x13a/0x2c0
>      [<ffffffff810fbd75>] kmemleak_alloc+0x25/0x60
>      [<ffffffff810f596b>] __kmalloc+0x11b/0x210
>      [<ffffffff811ae061>] ext4_mb_init+0x1b1/0x5c0
>      [<ffffffff8119f1e9>] ext4_fill_super+0x1e29/0x2720
>      [<ffffffff8110111f>] get_sb_bdev+0x16f/0x1b0
>      [<ffffffff81195413>] ext4_get_sb+0x13/0x20
>      [<ffffffff81100bf6>] vfs_kern_mount+0x76/0x180
>      [<ffffffff81100d6d>] do_kern_mount+0x4d/0x120
>      [<ffffffff81118ee7>] do_mount+0x307/0x8b0
>      [<ffffffff8111951f>] sys_mount+0x8f/0xe0
>      [<ffffffff8100b66b>] system_call_fastpath+0x16/0x1b
>      [<ffffffffffffffff>] 0xffffffffffffffff

After some investigation, this looks to me like a real leak.

I managed to reproduce something similar (though the size may differ, I
think depending on filesystem size - only tried with a 64MB loop
device):

unreferenced object 0xde468300 (size 32):
  comm "mount", pid 1445, jiffies 4294950074
  backtrace:
    [<c006d473>] __save_stack_trace+0x17/0x1c
    [<c006d545>] create_object+0xcd/0x188
    [<c01efe43>] kmemleak_alloc+0x1b/0x3c
    [<c006c013>] __kmalloc+0xd7/0xe4
    [<c00c1029>] ext4_mb_init+0x14d/0x374
    [<c00b7d7d>] ext4_fill_super+0x1385/0x16b4
    [<c0070891>] get_sb_bdev+0xa9/0xe4
    [<c00b574b>] ext4_get_sb+0xf/0x14
    [<c006fd3f>] vfs_kern_mount+0x33/0x64
    [<c006fda5>] do_kern_mount+0x25/0x8c
    [<c007e11f>] do_mount+0x47f/0x4c4
    [<c007e1b5>] sys_mount+0x51/0x80
    [<c0027c01>] ret_fast_syscall+0x1/0x40
    [<ffffffff>] 0xffffffff

The above block is the meta_group_info allocated in
ext4_mb_init_backend() and stored in sbi->s_group_info[i] (i = 0 in my
case). Adding printk's and and inspecting the memory at
sbi->s_group_info[] shows different value stored, not the pointer
reported as leak.

About the new pointer at sbi->s_group_info[0], kmemleak has this
information (via the dump= option in my branch; it isn't a leak report):

kmemleak: Object 0xdfebfa80 (size 128):
kmemleak:   comm "mount", pid 1445, jiffies 4294950075
kmemleak:   min_count = 1
kmemleak:   count = 1
kmemleak:   flags = 0x1
kmemleak:   backtrace:
     [<c006d473>] __save_stack_trace+0x17/0x1c
     [<c006d545>] create_object+0xcd/0x188
     [<c01efe43>] kmemleak_alloc+0x1b/0x3c
     [<c006c013>] __kmalloc+0xd7/0xe4
     [<c00c0df1>] ext4_mb_add_groupinfo+0x29/0x114
     [<c00c107f>] ext4_mb_init+0x1a3/0x374
     [<c00b7d7d>] ext4_fill_super+0x1385/0x16b4
     [<c0070891>] get_sb_bdev+0xa9/0xe4
     [<c00b574b>] ext4_get_sb+0xf/0x14
     [<c006fd3f>] vfs_kern_mount+0x33/0x64
     [<c006fda5>] do_kern_mount+0x25/0x8c
     [<c007e11f>] do_mount+0x47f/0x4c4
     [<c007e1b5>] sys_mount+0x51/0x80
     [<c0027c01>] ret_fast_syscall+0x1/0x40
     [<ffffffff>] 0xffffffff

So, ext4_mb_add_groupinfo() is overriding the pointers stored in
sbi->s_group_info[] by the ext4_mb_init_backend() function without
freeing them first.

Maybe the ext4 people could clarify what is happening here as I'm not
familiar with the code.

-- 
Catalin

