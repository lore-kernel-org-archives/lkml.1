Return-Path: <linux-kernel-owner+w=401wt.eu-S1752428AbZIQXGN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752428AbZIQXGN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 19:06:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750937AbZIQXGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 19:06:10 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:39961 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZIQXGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 19:06:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mk2pq6rrzXhkff5CyeBr6RFIFFj25X3fV3QjKB1BlFv5qrhGbuCHu7oAi1AQXEk3Fq
         zE2GRT5mCUdMLZc+RLteJcLMq6ohkGKvGXM8pBuPXUsJeDgFtCc3iyLVoKIfpXoh9HGh
         TUOCnAG++lhziRgMQ7IgbtfHfnO2zISWhKpi8=
Date: Fri, 18 Sep 2009 01:05:55 +0200
From: Karol Lewandowski <karol.k.lewandowski@gmail.com>
To: "Graham, David" <david.graham@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
Message-ID: <20090917230555.GA10737@bizet.domek.prywatny>
References: <20090915120538.GA26806@bizet.domek.prywatny> <200909170118.53965.rjw@sisk.pl> <4AB29F4A.3030102@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB29F4A.3030102@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 01:42:50PM -0700, Graham, David wrote:
> Yes, we free a 70KB block (0x80 by 0x230 bytes) on suspend and  
> reallocate on resume, and so that's an Order 5 request. It looks  
> symmetric, and hasn't changed for years. I don't think we are leaking  
> memory, which points back to that the memory is too fragmented to  
> satisfy the request.
>
> I also concur that Rafael's commit 6905b1f1 shouldn't change the logic  
> in the driver for systems with e100 (like yours Karol) that could  
> already sleep, and I don't see anything else in the driver that looks to  
> be relevant. I'm expecting that your test result without commit 6905b1f1  
> will still show the problem.

I've just hit this problem on 2.6.31 with 6905b1f1 reverted.  This
time it failed after second resume cycle, memory shouldn't be that
fragmented but it was rather full.

ifconfig: page allocation failure. order:5, mode:0x8020
Pid: 9438, comm: ifconfig Not tainted 2.6.31 #14
Call Trace:
 [<c015c1cc>] ? __alloc_pages_nodemask+0x402/0x444
 [<c0104de7>] ? dma_generic_alloc_coherent+0x4a/0xab
 [<c0104d9d>] ? dma_generic_alloc_coherent+0x0/0xab
 [<c0298fa7>] ? e100_alloc_cbs+0xc7/0x174
 [<c029a036>] ? e100_up+0x1b/0xf5
 [<c029a127>] ? e100_open+0x17/0x41
 [<c02fb0ff>] ? dev_open+0x8f/0xc5
 [<c02fa8b9>] ? dev_change_flags+0xa2/0x155
 [<c03305f6>] ? devinet_ioctl+0x22a/0x51c
 [<c02ee49e>] ? sock_ioctl+0x0/0x1e4
 [<c02ee65e>] ? sock_ioctl+0x1c0/0x1e4
 [<c02ee49e>] ? sock_ioctl+0x0/0x1e4
 [<c017ef0a>] ? vfs_ioctl+0x16/0x4a
 [<c017f7d1>] ? do_vfs_ioctl+0x48a/0x4c1
 [<c0167e07>] ? handle_mm_fault+0x1e0/0x42c
 [<c034bddc>] ? do_page_fault+0x2ce/0x2e4
 [<c017f834>] ? sys_ioctl+0x2c/0x42
 [<c0102748>] ? sysenter_do_call+0x12/0x26
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:   90, btch:  15 usd:  36
Active_anon:20142 active_file:9569 inactive_anon:20734
 inactive_file:8765 unevictable:0 dirty:8 writeback:0 unstable:0
 free:1012 slab:2098 mapped:9829 pagetables:470 bounce:0
DMA free:1108kB min:124kB low:152kB high:184kB active_anon:1616kB inactive_anon:1780kB active_file:3484kB inactive_file:3424kB unevictable:0kB present:15868kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 238 238
Normal free:2940kB min:1908kB low:2384kB high:2860kB active_anon:78952kB inactive_anon:81156kB active_file:34792kB inactive_file:31636kB unevictable:0kB present:243776kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 21*4kB 10*8kB 1*16kB 1*32kB 2*64kB 0*128kB 1*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1108kB
Normal: 635*4kB 18*8kB 16*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 2940kB
21940 total pagecache pages
2809 pages in swap cache
Swap cache stats: add 5953, delete 3144, find 3606/3810
Free swap  = 498564kB
Total swap = 514040kB
65520 pages RAM
1667 pages reserved
24981 pages shared
48551 pages non-shared
e100 0000:00:03.0: firmware: using built-in firmware e100/d101s_ucode.bin
ADDRCONF(NETDEV_UP): eth0: link is not ready
e100: eth0 NIC Link is Up 100 Mbps Full Duplex
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
eth0: no IPv6 routers present


Despite that error interface was brought up after all. I could ping
computers in local network, just gateway wasn't set properly.

I've checked logs and found that I've first hit this problem with
2.6.31-rc3 - before that I've used 2.6.30 without problems.
With 2.6.31-rc3 I got 4 subsequent OOPSes, all from e100.

Actually I must say that since 2.6.30+ I've ecountered few hard
lockups after resume - thing, that haven't happened to me for a long
time.  Sadly, I've no idea if it's related and how to make it
reproductible/testable.


> So I wonder if this new issue may be triggered by some other change in  
> the memory subsystem ?
>
> Karol, how much physical RAM do you have in this system ? I'd expect  
> that the fragmentation would be less of an issue if there's simply more  
> memory in total.

This machine has 256MB RAM, I'm always running with few MBs in swap.
I'm unable to add more - this is ancient laptop with ancient RAM.

Thanks.
