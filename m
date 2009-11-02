Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbZKBIEv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbZKBIEv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 03:04:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754012AbZKBIEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 03:04:50 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60601 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753918AbZKBIEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 03:04:49 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Nov 2009 17:02:25 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Juan Miscaro <jmiscaro@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to immunize a process from the OOM Killer
Message-Id: <20091102170225.c852c71a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <d0626390910301026j8ec7355te8d94f5c180fc112@mail.gmail.com>
References: <d0626390910291201m6e8121abq831867715f5d7d5@mail.gmail.com>
	<20091030092829.2597646d.kamezawa.hiroyu@jp.fujitsu.com>
	<d0626390910301026j8ec7355te8d94f5c180fc112@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009 13:26:56 -0400
Juan Miscaro <jmiscaro@gmail.com> wrote:

> 2009/10/29 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> > On Thu, 29 Oct 2009 15:01:22 -0400
> > Juan Miscaro <jmiscaro@gmail.com> wrote:
> >
> >> Hi, I'm running 2.6.24 on Ubuntu.
> >>
> >> I've got a OOM Killer gone wild.  I have plenty of free memory (over
> >> 40 GB) and lots of processes are being murdered.  Anyway, I would like
> >> to first prevent a few processes from being killed in the hopes of
> >> buying me time (users can work) to discover why the killer is being
> >> invoked in the first place.
> >
> > Could you show us your message log of OOM-Killer ?
> 
> Hi, by message log I guess you mean parts of the kern.log?  I've
> attached a snippet of that log file that covers one process being
> killed.  I have many others like this.
> 
Thank for log.
Hmm, from this log. x86-32 ? Then, normal (memory for kernel) area is too small.
Highmem area (39GB+) cannot be used for this socket's memory allocation.

It seems this is caused by 2 reasons.
  - normal area is small and fragmented.
  - unix domain socket allocates order=2(16KB) continuous area.

For avoid killing, using oom_adj is an idea (as David pointed out)

But considering the situation, if you want to avoid this temporaly,
reducing size of socket buffer is another idea.(for avoiding 16KB allocation)
(But yes, that will make throuput worse and another program may hit this
 fragmentation problem in other reason.)
It seems your system is not robust against fragmentation problem, now.

40GB is not good for x86-32 system, in general.

Thanks,
-Kame
==

Oct 15 12:36:05 host kernel: [2695651.038987] Active:4175196 inactive:867151 dirty:15 writeback:10 unstable:0
Oct 15 12:36:05 host kernel: [2695651.038988]  free:9400621 slab:69457 mapped:182830 pagetables:21155 bounce:0
Oct 15 12:36:05 host kernel: [2695651.038994] DMA free:940kB min:68kB low:84kB high:100kB active:0kB inactive:0kB present:16256kB pages_scanned:0 all_unreclaimable? no
Oct 15 12:36:05 host kernel: [2695651.038998] lowmem_reserve[]: 0 873 57642 57642
Oct 15 12:36:05 host kernel: [2695651.039010] Normal free:85688kB min:3744kB low:4680kB high:5616kB active:0kB inactive:280kB present:894080kB pages_scanned:0 all_unreclaimable? no
Oct 15 12:36:05 host kernel: [2695651.039014] lowmem_reserve[]: 0 0 454152 454152
Oct 15 12:36:05 host kernel: [2695651.039028] HighMem free:37515856kB min:512kB low:61428kB high:122348kB active:16701060kB inactive:3468324kB present:58131456kB pages_scanned:0 all_unreclaimable? no
Oct 15 12:36:05 host kernel: [2695651.039033] lowmem_reserve[]: 0 0 0 0
Oct 15 12:36:05 host kernel: [2695651.039043] DMA: 1*4kB 1*8kB 2*16kB 4*32kB 4*64kB 2*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 940kB
Oct 15 12:36:05 host kernel: [2695651.039071] Normal: 20427*4kB 409*8kB 4*16kB 21*32kB 7*64kB 0*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 86420kB
Oct 15 12:36:05 host kernel: [2695651.039099] HighMem: 31689*4kB 507549*8kB 176346*16kB 57445*32kB 16385*64kB 4522*128kB 1214*256kB 428*512kB 305*1024kB 185*2048kB 6304*4096kB = 37516684kB
Oct 15 12:36:05 host kernel: [2695651.039128] Swap cache: add 0, delete 0, find 0/0, race 0+0
Oct 15 12:36:05 host kernel: [2695651.039132] Free swap  = 29294516kB
Oct 15 12:36:05 host kernel: [2695651.039136] Total swap = 29294516kB
Oct 15 12:36:05 host kernel: [2695651.039140] Free swap:       29294516kB
Oct 15 12:36:05 host kernel: [2695651.249865] 14876671 pages of RAM
Oct 15 12:36:05 host kernel: [2695651.249875] 14647295 pages of HIGHMEM
Oct 15 12:36:05 host kernel: [2695651.249876] 314941 reserved pages
Oct 15 12:36:05 host kernel: [2695651.249879] 2921946 pages shared
Oct 15 12:36:05 host kernel: [2695651.249883] 0 pages swap cached
Oct 15 12:36:05 host kernel: [2695651.249885] 20 pages dirty
Oct 15 12:36:05 host kernel: [2695651.249886] 10 pages writeback
Oct 15 12:36:05 host kernel: [2695651.249888] 183270 pages mapped
Oct 15 12:36:05 host kernel: [2695651.249889] 69454 pages slab
Oct 15 12:36:05 host kernel: [2695651.249891] 21174 pages pagetables


