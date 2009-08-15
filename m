Return-Path: <linux-kernel-owner+w=401wt.eu-S1751970AbZHOTZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbZHOTZu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 15:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751754AbZHOTZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 15:25:50 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:33815 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbZHOTZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 15:25:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=db2ld0xHMjcVlqXsQyaA/m2Vtw1hSw+1a7HpEBaXURLnOrl/9l43YvNxkraNrhw29e
         QJhzuMVvymbHmQ6VlohOEf8ovzaSGZu8id9bYvu0IGsLdZdEjOJk+SBwCEw+HQmRHZhi
         M29E3lVaKa87+0HSzdlMknoOJGZ2siS6vQ0kM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-mm@kvack.org
Subject: mm/ipw2200 regression (was: Re: linux-next: Tree for August 6)
Date: Sat, 15 Aug 2009 18:56:48 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc6-dirty; KDE/4.2.4; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <20090806192209.513abec7.sfr@canb.auug.org.au> <200908062250.51498.bzolnier@gmail.com> <200908071515.45169.bzolnier@gmail.com>
In-Reply-To: <200908071515.45169.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908151856.48596.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 August 2009 15:15:45 Bartlomiej Zolnierkiewicz wrote:
> On Thursday 06 August 2009 22:50:50 Bartlomiej Zolnierkiewicz wrote:
> > On Thursday 06 August 2009 11:22:09 Stephen Rothwell wrote:
> > > Hi all,
> > > 
> > > Changes since 20090805:
> > 
> > At the moment -next is completely unusable for anything other than
> > detecting merge conflicts..  Running -next was never a completely
> > smooth experience but for a past year it was more-or-less doable.
> > However the last two months have been an absolute horror and I've
> > been hitting issues way faster than I was able to trace/report
> > them properly..
> > 
> > Right now I still have following *outstanding* issues (on just *one*
> > machine/distribution):
> > 
> > - Random (after some long hours) order:6 mode:0x8020 page allocation
> >   failure (when ipw2200 driver reloads firmware on firmware error).
> > 
> >   [ I had first thought that it was caused by SLQB (which got enabled
> >     as default somewhere along the way) but it also happens with SLUB
> >     and I have good reasons to believe that is caused by heavy mm
> >     changes first seen in next-20090618 (I've been testing next-20090617
> >     for many days and it never happened there), the last confirmed
> >     release with the problem is next-20090728. ]
> 
> If anyone is interested in the full log of the problem:
> 
> ipw2200: Firmware error detected.  Restarting.
> ipw2200/0: page allocation failure. order:6, mode:0x8020
> Pid: 1004, comm: ipw2200/0 Not tainted 2.6.31-rc4-next-20090728-04869-gdae50fe-dirty #51

The bug managed to slip into Linus' tree..

ipw2200: Firmware error detected.  Restarting.
ipw2200/0: page allocation failure. order:6, mode:0x8020
Pid: 945, comm: ipw2200/0 Not tainted 2.6.31-rc6-dirty #69
Call Trace:
 [<c039505f>] ? printk+0xf/0x18
 [<c016abc7>] __alloc_pages_nodemask+0x400/0x442
 [<c01068b5>] dma_generic_alloc_coherent+0x53/0xc2
 [<c0106862>] ? dma_generic_alloc_coherent+0x0/0xc2
 [<e12c409b>] ipw_load_firmware+0x8f/0x4fb [ipw2200]
 [<c01029bc>] ? restore_all_notrace+0x0/0x18
 [<e12c0def>] ? ipw_stop_nic+0x2b/0x5d [ipw2200]
 [<e12c88bd>] ipw_load+0x8b2/0xf94 [ipw2200]
 [<e12cc727>] ipw_up+0xe1/0x5c6 [ipw2200]
 [<e12ca7a3>] ? ipw_down+0x1f7/0x1ff [ipw2200]
 [<e12ccc3e>] ipw_adapter_restart+0x32/0x46 [ipw2200]
 [<e12ccc73>] ipw_bg_adapter_restart+0x21/0x2c [ipw2200]
 [<c0139694>] worker_thread+0x15e/0x240
 [<c0139652>] ? worker_thread+0x11c/0x240
 [<e12ccc52>] ? ipw_bg_adapter_restart+0x0/0x2c [ipw2200]
 [<c013ca65>] ? autoremove_wake_function+0x0/0x2f
 [<c0139536>] ? worker_thread+0x0/0x240
 [<c013c828>] kthread+0x6b/0x70
 [<c013c7bd>] ? kthread+0x0/0x70
 [<c01034ab>] kernel_thread_helper+0x7/0x10
Mem-Info:
DMA per-cpu:
CPU    0: hi:    0, btch:   1 usd:   0
Normal per-cpu:
CPU    0: hi:  186, btch:  31 usd:  80
Active_anon:25319 active_file:23485 inactive_anon:25576
 inactive_file:23530 unevictable:2 dirty:1464 writeback:200 unstable:0
 free:11175 slab:6927 mapped:7760 pagetables:930 bounce:0
DMA free:2052kB min:84kB low:104kB high:124kB active_anon:0kB inactive_anon:92kB active_file:1608kB inactive_file:1604kB unevictable:0kB present:15788kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 489 489
Normal free:42648kB min:2788kB low:3484kB high:4180kB active_anon:101276kB inactive_anon:102212kB active_file:92332kB inactive_file:92516kB unevictable:8kB present:501392kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0 0
DMA: 3*4kB 7*8kB 2*16kB 1*32kB 0*64kB 1*128kB 1*256kB 1*512kB 1*1024kB 0*2048kB 0*4096kB = 2052kB
Normal: 1038*4kB 2148*8kB 1200*16kB 56*32kB 1*64kB 0*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 42648kB
52333 total pagecache pages
4675 pages in swap cache
Swap cache stats: add 27030, delete 22355, find 3967/5275
Free swap  = 956380kB
Total swap = 1020116kB
131056 pages RAM
4225 pages reserved
53608 pages shared
86334 pages non-shared
ipw2200: Unable to load firmware: -12
ipw2200: Unable to load firmware: -12
ipw2200: Failed to up device
