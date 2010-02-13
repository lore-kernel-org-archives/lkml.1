Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234Ab0BMDgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 22:36:13 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:57665 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943Ab0BMDgL (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 12 Feb 2010 22:36:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, hpa@zytor.com, suresh.b.siddha@intel.com,
       rostedt@goodmis.org, jeremy@goop.org
Subject: [PATCH] fix BUG: unable to handle kernel .. in free_init_pages called from mark_rodata_ro
Date: Fri, 12 Feb 2010 22:15:27 -0500
Message-Id: <1266030928-2126-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.6.2.5
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4B761E25.00CE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running under Xen as PV guest, with CONFIG_DEBUG_RODATA set we get this ugly BUG:

[    0.262514] BUG: unable to handle kernel paging request at ffff8800013f4000
[    0.262526] IP: [<ffffffff8102bb0b>] free_init_pages+0xa3/0xcc
[    0.262538] PGD 1611067 PUD 1615067 PMD 556b067 PTE 100000013f4025
[    0.262554] Oops: 0003 [#1] SMP 
[    0.262564] last sysfs file: 
[    0.262569] CPU 0 
[    0.262578] Pid: 1, comm: swapper Not tainted 2.6.33-rc7NEB #67 /
[    0.262585] RIP: e030:[<ffffffff8102bb0b>]  [<ffffffff8102bb0b>] free_init_pages+0xa3/0xcc
[    0.262597] RSP: e02b:ffff88001fcfbe40  EFLAGS: 00010286
[    0.262603] RAX: 00000000cccccccc RBX: ffff880001400000 RCX: 0000000000000400
[    0.262610] RDX: ffff8800013f4000 RSI: 0000000000000000 RDI: ffff8800013f4000
[    0.262617] RBP: ffff88001fcfbe70 R08: 0000000000000000 R09: ffff88001fc02200
[    0.262624] R10: ffff88001fc02200 R11: ffff88001fcfbd00 R12: ffff8800013f4000
[    0.262631] R13: 0000000000000400 R14: ffffea0000000000 R15: 00000000cccccccc
[    0.262641] FS:  0000000000000000(0000) GS:ffff880005598000(0000) knlGS:0000000000000000
[    0.262649] CS:  e033 DS: 0000 ES: 0000 CR0: 000000008005003b
[    0.262655] CR2: ffff8800013f4000 CR3: 0000000001610000 CR4: 0000000000000660
[    0.262663] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.262671] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.262678] Process swapper (pid: 1, threadinfo ffff88001fcfa000, task ffff88001fd00000)
[    0.262685] Stack:
[    0.262690]  0000000000000000 0000000001400000 ffffffff813f4000 ffffffff81000000
[    0.262704] <0> ffffffff815c7000 ffffffff81600000 ffff88001fcfbf00 ffffffff8102c2cb
[    0.262721] <0> 00000000000001c7 ffffffff813f4000 ffffffff81600000 0000000000000039
[    0.262740] Call Trace:
[    0.262749]  [<ffffffff8102c2cb>] mark_rodata_ro+0x4a2/0x527
[    0.262759]  [<ffffffff810021a5>] init_post+0x2b/0x10e
[    0.262769]  [<ffffffff8169a703>] kernel_init+0x1b1/0x1bc
[    0.262777]  [<ffffffff8100a7e4>] kernel_thread_helper+0x4/0x10
[    0.262894]  [<ffffffff81009be1>] ? int_ret_from_sys_call+0x7/0x1b
[    0.262904]  [<ffffffff813e961d>] ? retint_restore_args+0x5/0x6
[    0.262912]  [<ffffffff8100a7e0>] ? kernel_thread_helper+0x0/0x10


I traced it down to the mark_rodata_ which sets the .text through .sdata to PAGE_RO.
Then it sets PAGE_NX whenever it can, and for two selective sections:
a) .__stop___ex_table -> .__start_rodata and b).__end_rodata -> ._sdata sets
them to _PAGE_RW. Both a) and b) are recycled by free_init_pages which tries to
write to the sections POISON_FREE_INITMEM and it hits the BUG().

The reason for this is that 'set_memory_rw' eventually ends up calling
'static_projections' which checks certain ranges of addresses and forbids certain
page  flags depending on the nature of the region. One of checks is to forbid _PAGE_RW
to the region from .text to ._sdata. The a) and b) section fall in that, and
the _PAGE_RW page attribute does not get set. If you are looking at the code
please note that at that stage the 'kernel_set_to_readonly' has been set.

Now this BUG() only shows up on Xen. The one big difference between baremetal
and paravirtualized is that on Xen all pages are 4KB in size. On baremetal
those two regions are marked as 2MB page.

When running this on bare-metal those sections get split from 2MB to 4KB chunks
and the _PAGE_RW is set without any trouble (even though the sections do fall in the
.text and .sdata).  I am at loss to explain why this works on bare-metal even
thought it looks to be doing the wrong thing there too. I sprinkled dump_stack()
to figure this out but got address that don't vibe with the reality, any ideas?

In summary, the patch allows the two sections a) and b) to have _PAGE_RW set
so that they can be written to and re-used. 

