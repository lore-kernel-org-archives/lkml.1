Return-Path: <linux-kernel-owner+w=401wt.eu-S1754612AbYGZDdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612AbYGZDdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 23:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYGZDc7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 23:32:59 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:39260 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbYGZDc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 23:32:58 -0400
Date: Fri, 25 Jul 2008 20:32:54 -0700
From: Nishanth Aravamudan <nacc@us.ibm.com>
To: gerald.schaefer@de.ibm.com
Cc: schwidefsky@de.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       agl@us.ibm.com
Subject: Re: s390 hugetlb oops with libhugetlbfs test-suite
Message-ID: <20080726033254.GA3810@us.ibm.com>
References: <20080725211035.GA19738@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080725211035.GA19738@us.ibm.com>
X-Operating-System: Linux 2.6.26-rc9-00132-g9df2fe9 (x86_64)
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.07.2008 [14:10:35 -0700], Nishanth Aravamudan wrote:
> Hi Gerald,
> 
> Having noticed that the hugetlbfs code recently got an update to work
> on s390, I decided to port the libhugetlbfs test-suite to work on
> s390. The current development snapshot is available at
> http://libhugetlbfs.ozlabs.org/snapshots/libhugetlbfs-dev-20080724.tar.gz.
> You will need a patch [1] to build on s390, but it should roughly work
> otherwise.  The specific testcase that causes the oops is counters.
> The bit set in the flags is PG_Reserved, I think.

After enabling some debugging options, I got a slightly more precise
stack trace. The last one I posted was for the 32-bit counters test and
this one is for the 64-bit one, but appears to be the same problem
(PG_reserved still being set).

Bad page state in process 'counters'
page:000003e040000000 flags:0x0000000000000400 mapping:0000000000000000 mapcount:0 count:0
Trying to fix it up, but a reboot is needed
Backtrace:
CPU: 1 Tainted: G        W 2.6.26-autokern1 #1
Process counters (pid: 5365, task: 000000003855ab50, ksp: 000000002667bbc0)
0000000000000047 000000002667b7d0 0000000000000002 0000000000000000 
       000000002667b870 000000002667b7e8 000000002667b7e8 0000000000016f22 
       0000000000000000 0000000000000000 000002000000000a 000000000000000a 
       0000000000000000 000000002667b7d0 000000002667b7d0 000000002667b848 
       000000000025cb28 0000000000016f22 000000002667b7d0 000000002667b828 
Call Trace:
([<0000000000016e80>] show_trace+0xd8/0xe8)
 [<0000000000016f40>] show_stack+0xb0/0xc0
 [<000000000001766c>] dump_stack+0xa8/0xb8
 [<000000000007f3da>] bad_page+0x9a/0xd4
 [<00000000000802dc>] free_hot_cold_page+0xa0/0x1f8
 [<00000000000804f6>] free_hot_page+0x22/0x30
 [<000000000008503a>] put_page+0x136/0x144
 [<00000000000a0a68>] __unmap_hugepage_range+0x398/0x3dc
 [<00000000000a0b00>] unmap_hugepage_range+0x54/0x7c
 [<000000000008d6f2>] unmap_vmas+0x152/0xb5c
 [<000000000009284e>] exit_mmap+0x14e/0x2fc
 [<000000000003b128>] mmput+0x64/0x110
 [<000000000004030c>] exit_mm+0xf0/0x100
 [<0000000000041fd8>] do_exit+0x268/0x7f8
 [<00000000000425fe>] do_group_exit+0x96/0xc4
 [<000000000004ddbc>] get_signal_to_deliver+0x350/0x378
 [<000000000001e026>] do_signal+0xe6/0x87c
 [<0000000000024a0a>] sysc_sigpending+0xe/0x22
 [<000000008000163c>] 0x8000163c

I'm not quite sure yet how the hugetlb destructor
(free_huge_page()/update_and_free_page()) can call
free_hot_page()/free_hot_cold_page(), because the comments for both
indicate they should only be used for order-0 pages. Are we somehow
losing the fact that this is a compound page on s390?

If anyone would like a s390-compatible version of libhugetlbfs, just let
me know I can send it off-list.

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center
