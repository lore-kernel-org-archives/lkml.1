Return-Path: <linux-kernel-owner+w=401wt.eu-S1030190AbXDJAyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030190AbXDJAyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030178AbXDJAyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:54:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49951 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030190AbXDJAys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:54:48 -0400
Date: Mon, 9 Apr 2007 17:50:54 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: clameter@sgi.com, linux-kernel@vger.kernel.org, drfickle@us.ibm.com
Subject: Re: 2.6.21-rc6-mm1
Message-ID: <20070410005054.GA4027@us.ibm.com>
References: <20070408143559.f5014629.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070408143559.f5014629.akpm@linux-foundation.org>
X-Operating-System: Linux 2.6.21-rc5-g59117d3f (x86_64)
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.04.2007 [14:35:59 -0700], Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc6/2.6.21-rc6-mm1/

Get this Oops:

Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP: 
 [<ffffffff802f9320>] hugetlbfs_set_page_dirty+0x4/0xc
PGD 414e067 PUD 4198067 PMD 0 
Oops: 0002 [1] SMP 
last sysfs file: devices/system/node/node0/cpumap
CPU 1 
Modules linked in: ipv6 hidp rfcomm l2cap bluetooth sunrpc video button battery asus_acpi ac lp parport_pc parport nvram amd_rng rng_core i2c_amd756 i2c_core
Pid: 6053, comm: readback Not tainted 2.6.21-rc6-mm1-autokern1 #1
RIP: 0010:[<ffffffff802f9320>]  [<ffffffff802f9320>] hugetlbfs_set_page_dirty+0x4/0xc
RSP: 0018:ffff810004145d90  EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff81003f1ad000 RCX: 000000000000003f
RDX: ffff810004771dc0 RSI: ffff810004145db0 RDI: ffff81003f1ad000
RBP: 8000000007800040 R08: 0000000001258020 R09: ffff81000160ad84
R10: 0000000000000282 R11: ffffffff802f931c R12: ffff8100035db7c0
R13: ffff810003675c38 R14: 00002aaaaae00000 R15: ffff810001022820
FS:  00002ac8d0bd6590(0000) GS:ffff81000160acc0(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 00000000047b7000 CR4: 00000000000006e0
Process readback (pid: 6053, threadinfo ffff810004144000, task ffff81000177b140)
Stack:  ffffffff80283f95 ffff810004145d98 ffff810004145d98 ffff810000000000
 00002aaaaac00000 ffff810003675c38 00002aaaaae00000 00002aaaaac00000
 ffff8100047b68b8 00000036d5f18000 ffffffff80284060 ffff81003fc066c0
Call Trace:
 [<ffffffff80283f95>] __unmap_hugepage_range+0xcf/0x163
 [<ffffffff80284060>] unmap_hugepage_range+0x37/0x57
 [<ffffffff802761e4>] unmap_vmas+0xf6/0x744
 [<ffffffff8027a197>] exit_mmap+0x78/0xed
 [<ffffffff802313bc>] mmput+0x45/0xb7
 [<ffffffff80236636>] do_exit+0x23d/0x811
 [<ffffffff80236c86>] sys_exit_group+0x0/0xe
 [<ffffffff80209b6e>] system_call+0x7e/0x83


Code: f0 0f ba 28 04 31 c0 c3 48 89 c8 48 c7 c1 5f 9b 2f 80 48 89 
RIP  [<ffffffff802f9320>] hugetlbfs_set_page_dirty+0x4/0xc
 RSP <ffff810004145d90>
CR2: 0000000000000000
Fixing recursive fault but reboot is needed!

<snip>

Steve Fox narrowed it down to between
mm-clean-up-and-kernelify-shrinker-registration.patch (good) and
file-capabilities-accomodate-future-64-bit-caps.patch (bad). Without
testing yet, I'm betting it is:

> +make-page-pprivate-usable-in-compound-pages-v1.patch

I am not sure if there are other users of page_private() that were
missed that are also compound pages, but probably the attached will fix
this case?

Thanks,
Nish

Christoph Lameter's rework of the use of private member of struct page
missed the hugetlbfs dirtying function.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>

---
Only compile-tested so far (on x86_64).

diff -urpN 2.6.21-rc6-mm1/fs/hugetlbfs/inode.c 2.6.21-rc6-mm1-dev/fs/hugetlbfs/inode.c
--- 2.6.21-rc6-mm1/fs/hugetlbfs/inode.c	2007-04-09 17:17:16.000000000 -0700
+++ 2.6.21-rc6-mm1-dev/fs/hugetlbfs/inode.c	2007-04-09 17:42:41.000000000 -0700
@@ -450,7 +450,7 @@ static int hugetlbfs_symlink(struct inod
  */
 static int hugetlbfs_set_page_dirty(struct page *page)
 {
-	struct page *head = (struct page *)page_private(page);
+	struct page *head = compound_head(page);
 
 	SetPageDirty(head);
 	return 0;

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
