Return-Path: <linux-kernel-owner+w=401wt.eu-S1759977AbYAKLsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759977AbYAKLsc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 06:48:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757699AbYAKLsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 06:48:24 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:53407 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbYAKLsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 06:48:22 -0500
Date: Fri, 11 Jan 2008 17:17:31 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 00/19] VM pageout scalability improvements
Message-ID: <20080111114731.GB19814@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Rik van Riel <riel@redhat.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20080108205939.323955454@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20080108205939.323955454@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rik van Riel <riel@redhat.com> [2008-01-08 15:59:39]:

> Changelog:
> - merge memcontroller split LRU code into the main split LRU patch,
>   since it is not functionally different (it was split up only to help
>   people who had seen the last version of the patch series review it)

Hi, Rik,

I see a strange behaviour with this patchset. I have a program
(pagetest from Vaidy), that does the following

1. Can allocate different kinds of memory, mapped, malloc'ed or shared
2. Allocates and touches all the memory in a loop (2 times)

I mount the memory controller and limit it to 400M and run pagetest
and ask it to touch 1000M. Without this patchset everything runs fine,
but with this patchset installed, I immediately see

 pagetest invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
 Call Trace:
 [c0000000e5aef400] [c00000000000eb24] .show_stack+0x70/0x1bc (unreliable)
 [c0000000e5aef4b0] [c0000000000bbbbc] .oom_kill_process+0x80/0x260
 [c0000000e5aef570] [c0000000000bc498] .mem_cgroup_out_of_memory+0x6c/0x98
 [c0000000e5aef610] [c0000000000f2574] .mem_cgroup_charge_common+0x1e0/0x414
 [c0000000e5aef6e0] [c0000000000b852c] .add_to_page_cache+0x48/0x164
 [c0000000e5aef780] [c0000000000b8664] .add_to_page_cache_lru+0x1c/0x68
 [c0000000e5aef810] [c00000000012db50] .mpage_readpages+0xbc/0x15c
 [c0000000e5aef940] [c00000000018bdac] .ext3_readpages+0x28/0x40
 [c0000000e5aef9c0] [c0000000000c3978] .__do_page_cache_readahead+0x158/0x260
 [c0000000e5aefa90] [c0000000000bac44] .filemap_fault+0x18c/0x3d4
 [c0000000e5aefb70] [c0000000000cd510] .__do_fault+0xb0/0x588
 [c0000000e5aefc80] [c0000000005653cc] .do_page_fault+0x440/0x620
 [c0000000e5aefe30] [c000000000005408] handle_page_fault+0x20/0x58
 Mem-info:
 Node 0 DMA per-cpu:
 CPU    0: hi:    6, btch:   1 usd:   4
 CPU    1: hi:    6, btch:   1 usd:   0
 CPU    2: hi:    6, btch:   1 usd:   3
 CPU    3: hi:    6, btch:   1 usd:   4
 Active_anon:9099 active_file:1523 inactive_anon0
  inactive_file:2869 noreclaim:0 dirty:20 writeback
:0 unstable:0
  free:44210 slab:639 mapped:1724 pagetables:475 bo
unce:0
 Node 0 DMA free:2829440kB min:7808kB low:9728kB hi
gh:11712kB active_anon:582336kB inactive_anon:0kB active_file:97472kB inactive_f
ile:183616kB noreclaim:0kB present:3813760kB pages_scanned:0 all_unreclaimable?
no
 lowmem_reserve[]: 0 0 0
 Node 0 DMA: 3*64kB 5*128kB 5*256kB 4*512kB 2*1024k
B 4*2048kB 3*4096kB 2*8192kB 170*16384kB = 2828352kB
 Swap cache: add 0, delete 0, find 0/0
 Free swap  = 3148608kB
 Total swap = 3148608kB
 Free swap:       3148608kB
 59648 pages of RAM
 677 reserved pages
 28165 pages shared
 0 pages swap cached
 Memory cgroup out of memory: kill process 6593 (pagetest) score 1003 or a child
 Killed process 6593 (pagetest)

I am using a powerpc box with 64K size pages. I'll try and investigate further,
just a heads up on the failure I am seeing.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
