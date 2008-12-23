Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbYLWOww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbYLWOww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2008 09:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYLWOwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Dec 2008 09:52:44 -0500
Received: from ocean.emcraft.com ([213.221.7.182]:41459 "EHLO
	ocean.emcraft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbYLWOwn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2008 09:52:43 -0500
Date: Tue, 23 Dec 2008 17:52:40 +0300
From: Yuri Tikhonov <yur@emcraft.com>
Organization: EmCraft
X-Priority: 3 (Normal)
Message-ID: <1810068989.20081223175240@emcraft.com>
To: Hugh Dickins <hugh@veritas.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       <akpm@linux-foundation.org>, <paulus@samba.org>, <wd@denx.de>,
       <dzu@denx.de>, <yanok@emcraft.com>, <miltonm@bga.com>,
       <viro@zeniv.linux.org.uk>, <Geert.Uytterhoeven@sonycom.com>
Subject: Re[2]: [PATCH] mm/shmem.c: fix division by zero
In-Reply-To: <Pine.LNX.4.64.0812230016510.13610@blonde.anvils>
References: <200812190844.57996.yur@emcraft.com> <Pine.LNX.4.64.0812230016510.13610@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 Hello Hugh,

On Tuesday, December 23, 2008 you wrote:

> On Fri, 19 Dec 2008, Yuri Tikhonov wrote:
>> 
>> The following patch fixes division by zero, which we have in
>> shmem_truncate_range() and shmem_unuse_inode(), if use big
>> PAGE_SIZE values (e.g. 256KB on ppc44x).
>> 
>> With 256KB PAGE_SIZE the ENTRIES_PER_PAGEPAGE constant becomes
>> too large (0x1.0000.0000), so this patch just changes the types
>> from 'ulong' to 'ullong' where it's necessary.
>> 
>> Signed-off-by: Yuri Tikhonov <yur@emcraft.com>

> Sorry for the slow reply, but I'm afraid I don't like spattering
> around an increasing number of unsigned long longs to fix that division
> by zero on an unusual configuration: I doubt that's the right solution.

> It's ridiculous for shmem.c to be trying to support a wider address
> range than the page cache itself can support, and it's wasteful for
> it to be using 256KB pages for its index blocks (not to mention its
> data blocks! but we'll agree to differ on that).

> Maybe it should be doing a kmalloc(4096) instead of using alloc_pages();
> though admittedly that's not a straightforward change, since we do make
> use of highmem and page->private.  Maybe I should use this as stimulus
> to switch shmem over to storing its swap entries in the pagecache radix
> tree.  Maybe we should simply disable its use of swap in such an
> extreme configuration.

> But I need to understand more about your ppc44x target to make
> the right decision.  What's very strange to me is this: since
> unsigned long long is the same size as unsigned long on 64-bit,
> this change appears to be for a 32-bit machine with 256KB pages.
> I wonder what market segment that is targeted at?

 Right, sizeof(unsigned long long)==8 on our ppc44x target.

 The main processor here is a PPC440SPe from AMCC, which is a 32-bit 
RISC machine with 36-bit physical addressing. 

 The market segment for this are RAID applications. The Linux s/w RAID 
driver had been significantly reworked over the last years, and now it
allows efficiently offload the RAID-related operations (as well as 
the data copy) from CPU to the dedicated engines via  ASYN_TX/ADMA 
API. The 440SPe controller has a reach RAID-related peripheral 
integrated on chip: XOR engine and two DMA engines with different 
capabilities including XOR calculations/checks for RAID5/6, PQ 
parities calculations/checks for RAID6, memory copy, and so on. All 
these make 440SPe to be a good choice for developing RAID storage 
applications.

 By increasing the PAGE_SIZE we improve the performance of RAID 
operations, because the RAID stripes (on which basic the Linux RAID 
driver operates) have a PAGE_SIZE width: so, the bigger the strip is, 
then the less CPU cycles are necessary to process the same chunk of 
data. The value of improvement differs from case to case, and has the 
maximum number in such cases like sequential writes.

 For example, on the ppc440spe-base Katmai board we observe the 
following performance distribution of sequential writes to RAID-5 
built on 16 drives (actually, we can achieve higher performance if 
skipping RAID caching of the data; the following figures are measured 
involving the RAID caching):

  4K PAGE_SIZE:   s/w:  84 MBps;  h/w accelerated: 172 MBps
 16K PAGE_SIZE:   s/w: 123 MBps;  h/w accelerated: 361 MBps
 64K PAGE_SIZE:   s/w: 125 MBps;  h/w accelerated: 409 MBps
256K PAGE_SIZE:   s/w: 132 MBps;  h/w accelerated: 473 MBps

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

