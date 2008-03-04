Return-Path: <linux-kernel-owner+w=401wt.eu-S933557AbYCDUEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933557AbYCDUEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 15:04:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762304AbYCDUEZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 15:04:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752927AbYCDUEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 15:04:24 -0500
Date: Tue, 4 Mar 2008 11:51:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com, Adam Litke <agl@us.ibm.com>
Subject: Re: [BUG] 2.6.25-rc3-mm1 kernel bug while running libhugetlbfs
Message-Id: <20080304115158.505f33eb.akpm@linux-foundation.org>
In-Reply-To: <47CDA0F1.9030908@linux.vnet.ibm.com>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	<47CDA0F1.9030908@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Mar 2008 00:50:17 +0530
Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> kernel bug is triggered while running libhugetlbfs test with 2.6.25-rc3-mm1 kernel
> over the x86 and power machines.
> 
> ------------[ cut here ]------------
> kernel BUG at mm/hugetlb.c:295!
> invalid opcode: 0000 [#1] SMP 
> last sysfs file: /sys/devices/system/node/possible
> Modules linked in:
> 
> Pid: 5484, comm: counters Not tainted (2.6.25-rc3-mm1-autokern1 #1)
> EIP: 0060:[<c10535cf>] EFLAGS: 00010202 CPU: 0
> EIP is at alloc_buddy_huge_page+0x7a/0xb0
> EAX: c13acd01 EBX: f7d3a000 ECX: 00000000 EDX: 00006363
> ESI: 00000001 EDI: 00000000 EBP: 00000000 ESP: f5539ebc
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process counters (pid: 5484, ti=f5538000 task=f60afa20 task.ti=f5538000)
> Stack: 00000001 c1053669 fffffff4 00000001 f5539ecc f5539ecc 00000001 fffffff4 
>        f55d0e78 00000001 c105480c 00000001 00200000 c1054875 00000000 f54426c0 
>        00200000 00000000 f54426c0 c10b0fb8 fffffff4 00200000 00000000 f55d0e78 
> Call Trace:
>  [<c1053669>] gather_surplus_pages+0x64/0x16d
>  [<c105480c>] hugetlb_acct_memory+0x1e/0x4a
>  [<c1054875>] hugetlb_reserve_pages+0x3d/0x6b
>  [<c10b0fb8>] hugetlbfs_file_mmap+0x9b/0xe1
>  [<c104bf9f>] mmap_region+0x1dc/0x3ae
>  [<c104bd42>] do_mmap_pgoff+0x27f/0x28e
>  [<c1005af2>] sys_mmap2+0x5a/0x78
>  [<c10029fa>] syscall_call+0x7/0xb
>  =======================
> Code: c1 e8 ed 27 1c 00 85 db 74 41 83 7b 04 00 75 10 68 c0 93 27 c1 e8 02 92 fc ff 58 e8 c1 02 fb ff f0 ff 4b 04 0f 94 c0 84 c0 74 04 <0f> 0b eb fe c7 43 38 3e 33 05 c1 8b 03 c1 e8 1c ff 04 85 60 ce 
> EIP: [<c10535cf>] alloc_buddy_huge_page+0x7a/0xb0 SS:ESP 0068:f5539ebc
> ---[ end trace 5a47484f8fe93a33 ]---
> 
> 

Please send Adam a copy of that libhugetlbfs test ;)

hugetlb-correct-page-count-for-surplus-huge-pages.patch adds:

        if (page) {
                /*
                 * This page is now managed by the hugetlb allocator and has
                 * no users -- drop the buddy allocator's reference.
                 */
                int page_count = put_page_testzero(page);
                BUG_ON(page_count != 0);


