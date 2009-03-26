Return-Path: <linux-kernel-owner+w=401wt.eu-S1761955AbZCZXUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761955AbZCZXUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 19:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755103AbZCZXUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 19:20:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56605 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773AbZCZXUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 19:20:31 -0400
Message-ID: <49CC0D9D.8030000@redhat.com>
Date: Fri, 27 Mar 2009 07:19:57 +0800
From: Eugene Teo <eugene@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Dave Anderson <anderson@redhat.com>
CC: linux-kernel@vger.kernel.org, zippel@linux-m68k.org
Subject: Re: [PATCH] HFS: fix memory leak when unmounting
References: <49CBE513.80205@redhat.com>
In-Reply-To: <49CBE513.80205@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Anderson wrote:
> When an HFS filesystem is unmounted, it leaks a 2-page
> bitmap.  Also, under extreme memory pressure, it's possible
> that hfs_releasepage() may use a tree pointer that has not
> been initialized, and if so, the release request should
> just be rejected.
> 
> Signed-off-by: Dave Anderson <anderson@redhat.com>

Tested-by: Eugene Teo <eugeneteo@kernel.sg>

After applying the patch, I no longer see these:

hfs: bad catalog namelength
hfs: get root inode failed.
init invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
Pid: 1, comm: init Not tainted 2.6.29 #3
Call Trace:
  [<c045b1f6>] oom_kill_process+0x6e/0x1e5
  [<c045b5e9>] __out_of_memory+0xfe/0x111
  [<c045b656>] out_of_memory+0x5a/0x7c
  [<c045d57e>] __alloc_pages_internal+0x2b6/0x34c
  [<c04704ba>] read_swap_cache_async+0x36/0xa9
  [<c0470596>] swapin_readahead+0x69/0x71
  [<c04689fd>] handle_mm_fault+0x2d9/0x587
  [<c063fbe3>] do_page_fault+0x2a2/0x579
  [<c063f941>] do_page_fault+0x0/0x579
  [<c063e282>] error_code+0x72/0x78
  [<c04d007b>] security_fixup_ops+0x40a/0xc3d
  [<c04fc014>] __copy_to_user_ll+0xc8/0xcf
  [<c04861bb>] core_sys_select+0x19b/0x2c2
  [<c048b57a>] mntput_no_expire+0x13/0xe1
  [<c0482b3d>] path_walk+0x67/0x70
  [<c04d72cb>] selinux_inode_getattr+0x52/0x5a
  [<c04fc429>] copy_to_user+0x25/0x39
  [<c047cea1>] cp_new_stat64+0xfc/0x10e
  [<c043a13a>] getnstimeofday+0x51/0xdb
  [<c0429354>] timespec_add_safe+0x1f/0x3e
  [<c0486350>] sys_select+0x6e/0x8f
  [<c040307a>] syscall_call+0x7/0xb
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  61
Active_anon:33 active_file:50 inactive_anon:52
  inactive_file:250 unevictable:1070 dirty:0 writeback:0 unstable:0
  free:1188 slab:2028 mapped:1060 pagetables:129 bounce:0
DMA free:2052kB min:84kB low:104kB high:124kB active_anon:0kB 
inactive_anon:0kB
active_file:8kB inactive_file:48kB unevictable:144kB present:15868kB
pages_scanned:0 all_unreclaimable? yes
lowmem_reserve[]: 0 492 492 492
Normal free:2700kB min:2792kB low:3488kB high:4188kB active_anon:132kB
inactive_anon:208kB active_file:192kB inactive_file:952kB unevictable:4136kB
present:503872kB pages_scanned:842 all_unreclaimable? yes
lowmem_reserve[]: 0 0 0 0
DMA: 1*4kB 22*8kB 1*16kB 0*32kB 1*64kB 0*128kB 1*256kB 1*512kB 1*1024kB
0*2048kB 0*4096kB = 2052kB
Normal: 117*4kB 5*8kB 31*16kB 1*32kB 0*64kB 1*128kB 0*256kB 1*512kB 1*1024kB
0*2048kB 0*4096kB = 2700kB
1322 total pagecache pages
38 pages in swap cache
Swap cache stats: add 10936, delete 10898, find 10973/12683
Free swap  = 1041020kB
Total swap = 1048568kB
Out of memory: kill process 2092 (hald) score 1788 or a child
Killed process 2093 (hald-runner)
init invoked oom-killer: gfp_mask=0x1200d2, order=0, oomkilladj=0
Pid: 1, comm: init Not tainted 2.6.29 #3
Call Trace:
  [<c045b1f6>] oom_kill_process+0x6e/0x1e5
  [<c045b5e9>] __out_of_memory+0xfe/0x111
  [<c045b656>] out_of_memory+0x5a/0x7c
  [<c045d57e>] __alloc_pages_internal+0x2b6/0x34c
  [<c04704ba>] read_swap_cache_async+0x36/0xa9
  [<c0470596>] swapin_readahead+0x69/0x71
  [<c04689fd>] handle_mm_fault+0x2d9/0x587
  [<c063fbe3>] do_page_fault+0x2a2/0x579
  [<c063f941>] do_page_fault+0x0/0x579
  [<c063e282>] error_code+0x72/0x78
  [<c04d007b>] security_fixup_ops+0x40a/0xc3d
  [<c04fc014>] __copy_to_user_ll+0xc8/0xcf
  [<c04861bb>] core_sys_select+0x19b/0x2c2
  [<c048b57a>] mntput_no_expire+0x13/0xe1
  [<c0482b3d>] path_walk+0x67/0x70
  [<c04d72cb>] selinux_inode_getattr+0x52/0x5a
  [<c04fc429>] copy_to_user+0x25/0x39
  [<c047cea1>] cp_new_stat64+0xfc/0x10e
  [<c043a13a>] getnstimeofday+0x51/0xdb
  [<c0429354>] timespec_add_safe+0x1f/0x3e
  [<c0486350>] sys_select+0x6e/0x8f
  [<c040307a>] syscall_call+0x7/0xb
