Return-Path: <linux-kernel-owner+w=401wt.eu-S1757135AbYFSQ1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135AbYFSQ1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 12:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750922AbYFSQ1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 12:27:40 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45521 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbYFSQ1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 12:27:39 -0400
Message-ID: <485A8903.9030808@linux.vnet.ibm.com>
Date: Thu, 19 Jun 2008 11:27:47 -0500
From: Jon Tollefson <kniht@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       linux-mm@kvack.org, Nick Piggin <npiggin@suse.de>,
       Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@linux.vnet.ibm.com>
Subject: Re: 2.6.26-rc5-mm3: BUG large value for HugePages_Rsvd
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
In-Reply-To: <20080611225945.4da7bb7f.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After running some of the libhugetlbfs tests the value for
/proc/meminfo/HugePages_Rsvd becomes really large.  It looks like it has
wrapped backwards from zero.
Below is the sequence I used to run one of the tests that causes this;
the tests passes for what it is intended to test but leaves a large
value for reserved pages and that seemed strange to me.
test run on ppc64 with 16M huge pages

cat /proc/meminfo
....
HugePages_Total:    25
HugePages_Free:     25
HugePages_Rsvd:      0
HugePages_Surp:      0
Hugepagesize:    16384 kB

mount -t hugetlbfs hugetlbfs /mnt

tundro4:~/libhugetlbfs-dev-20080516/tests # HUGETLBFS_VERBOSE=99 HUGETLBFS_DEBUG=y PATH="obj64:$PATH" LD_LIBRARY_PATH="$LD_LIBRARY_PATH:../obj64:obj64" truncate_above_4GB
Starting testcase "truncate_above_4GB", pid 3145
Mapping 3 hpages at offset 0x100000000...mapped at 0x3fffd000000
Replacing map at 0x3ffff000000 with map from offset 0x1000000...done
Truncating at 0x100000000...done
PASS

cat /proc/meminfo
....
HugePages_Total:    25
HugePages_Free:     25
HugePages_Rsvd:  18446744073709551614
HugePages_Surp:      0
Hugepagesize:    16384 kB


I put in some printks and see that the rsvd value goes mad in
'return_unused_surplus_pages'.

Debug output:

tundro4 kernel: mm/hugetlb.c:gather_surplus_pages:527; resv_huge_pages=0 delta=3
tundro4 kernel: Call Trace:
tundro4 kernel: [c000000287dff9a0] [c000000000010978] .show_stack+0x7c/0x1c4 (unreliable)
tundro4 kernel: [c000000287dffa50] [c0000000000d7c8c] .hugetlb_acct_memory+0xa4/0x448
tundro4 kernel: [c000000287dffb20] [c0000000000d85ec] .hugetlb_reserve_pages+0xec/0x16c
tundro4 kernel: [c000000287dffbc0] [c0000000001be7fc] .hugetlbfs_file_mmap+0xe0/0x154
tundro4 kernel: [c000000287dffc70] [c0000000000cbc78] .mmap_region+0x280/0x52c
tundro4 kernel: [c000000287dffd80] [c00000000000bfa0] .sys_mmap+0xa8/0x108
tundro4 kernel: [c000000287dffe30] [c0000000000086ac] syscall_exit+0x0/0x40
tundro4 kernel: mm/hugetlb.c:gather_surplus_pages:530; resv_huge_pages=3 delta=3
tundro4 kernel: mm/hugetlb.c:decrement_hugepage_resv_vma:147; resv_huge_pages=3
tundro4 kernel: mm/hugetlb.c:decrement_hugepage_resv_vma:149; resv_huge_pages=2
tundro4 kernel: mm/hugetlb.c:return_unused_surplus_pages:630; resv_huge_pages=2 unused_resv_pages=2
tundro4 kernel: Call Trace:
tundro4 kernel: [c000000287dff900] [c000000000010978] .show_stack+0x7c/0x1c4 (unreliable)
tundro4 kernel: [c000000287dff9b0] [c0000000000d7a10] .return_unused_surplus_pages+0x70/0x248
tundro4 kernel: [c000000287dffa50] [c0000000000d7fb8] .hugetlb_acct_memory+0x3d0/0x448
tundro4 kernel: [c000000287dffb20] [c0000000000c98fc] .remove_vma+0x64/0xe0
tundro4 kernel: [c000000287dffbb0] [c0000000000cb058] .do_munmap+0x30c/0x354
tundro4 kernel: [c000000287dffc70] [c0000000000cbad0] .mmap_region+0xd8/0x52c
tundro4 kernel: [c000000287dffd80] [c00000000000bfa0] .sys_mmap+0xa8/0x108
tundro4 kernel: [c000000287dffe30] [c0000000000086ac] syscall_exit+0x0/0x40
tundro4 kernel: mm/hugetlb.c:return_unused_surplus_pages:633; resv_huge_pages=0 unused_resv_pages=2
tundro4 kernel: mm/hugetlb.c:gather_surplus_pages:527; resv_huge_pages=0 delta=1
tundro4 kernel: Call Trace:
tundro4 kernel: [c000000287dff9a0] [c000000000010978] .show_stack+0x7c/0x1c4 (unreliable)
tundro4 kernel: [c000000287dffa50] [c0000000000d7c8c] .hugetlb_acct_memory+0xa4/0x448
tundro4 kernel: [c000000287dffb20] [c0000000000d85ec] .hugetlb_reserve_pages+0xec/0x16c
tundro4 kernel: [c000000287dffbc0] [c0000000001be7fc] .hugetlbfs_file_mmap+0xe0/0x154
tundro4 kernel: [c000000287dffc70] [c0000000000cbc78] .mmap_region+0x280/0x52c
tundro4 kernel: [c000000287dffd80] [c00000000000bfa0] .sys_mmap+0xa8/0x108
tundro4 kernel: [c000000287dffe30] [c0000000000086ac] syscall_exit+0x0/0x40
tundro4 kernel: mm/hugetlb.c:gather_surplus_pages:530; resv_huge_pages=1 delta=1
tundro4 kernel: mm/hugetlb.c:decrement_hugepage_resv_vma:147; resv_huge_pages=1
tundro4 kernel: mm/hugetlb.c:decrement_hugepage_resv_vma:149; resv_huge_pages=0
tundro4 kernel: mm/hugetlb.c:return_unused_surplus_pages:630; resv_huge_pages=0 unused_resv_pages=2
tundro4 kernel: Call Trace:
tundro4 kernel: [c000000287dff860] [c000000000010978] .show_stack+0x7c/0x1c4 (unreliable)
tundro4 kernel: [c000000287dff910] [c0000000000d7a10] .return_unused_surplus_pages+0x70/0x248
tundro4 kernel: [c000000287dff9b0] [c0000000000d7fb8] .hugetlb_acct_memory+0x3d0/0x448
tundro4 kernel: [c000000287dffa80] [c0000000000c98fc] .remove_vma+0x64/0xe0
tundro4 kernel: [c000000287dffb10] [c0000000000c9af0] .exit_mmap+0x178/0x1b8
tundro4 kernel: [c000000287dffbc0] [c000000000055ef0] .mmput+0x60/0x178
tundro4 kernel: [c000000287dffc50] [c00000000005add8] .exit_mm+0x130/0x154
tundro4 kernel: [c000000287dffce0] [c00000000005d598] .do_exit+0x2bc/0x778
tundro4 kernel: [c000000287dffda0] [c00000000005db38] .sys_exit_group+0x0/0x8
tundro4 kernel: [c000000287dffe30] [c0000000000086ac] syscall_exit+0x0/0x40
tundro4 kernel: mm/hugetlb.c:return_unused_surplus_pages:633; resv_huge_pages=18446744073709551614 unused_resv_pages=2

============the end===============


