Return-Path: <linux-kernel-owner+w=401wt.eu-S1031294AbXD2Tle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031294AbXD2Tle (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 15:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031320AbXD2Tle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 15:41:34 -0400
Received: from dtp.xs4all.nl ([80.126.206.180]:64971 "HELO abra2.bitwizard.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1031294AbXD2Tlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 15:41:32 -0400
Date: Sun, 29 Apr 2007 21:41:30 +0200
From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Florin Iucha <florin@iucha.net>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070429194129.GA747@bitwizard.nl>
References: <20070418011946.11679.34920.stgit@heimdal.trondhjem.org> <20070417195823.943f9472.akpm@linux-foundation.org> <1176865565.6796.16.camel@heimdal.trondhjem.org> <20070418033055.GA24044@iucha.net> <1176868485.6796.42.camel@heimdal.trondhjem.org> <20070418040730.GC24044@iucha.net> <20070417211350.ebba1493.akpm@linux-foundation.org> <20070418043040.GD24044@iucha.net> <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org> <20070417223738.8f49a39f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417223738.8f49a39f.akpm@linux-foundation.org>
Organization: BitWizard.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 10:37:38PM -0700, Andrew Morton wrote:
> Florin, can we please see /proc/meminfo as well?
> 
> Also the result of `echo m > /proc/sysrq-trigger'

Hi,

It's been a while since this thread died out, but maybe I'm 
having the same problem. Networking, large part of memory is 
buffering writes..... 

In my case I'm using NBD. 

Oh, 

/sys/block/nbd0/stat gives:
     636       88     5353     1700      991    19554   162272    63156       43  1452000 61802352
I put some debugging stuff in nbd, and it DOES NOT KNOW about the
43 requests that the io scheduler claims are in flight at the
driver.... 

Those requests start a couple of seconds AFTER the whole thing
grinds to a halt.

I switched from crashing my 512Mb-ram-workstation to my development
machine, which has only 64M of RAM. (I got the development machine
back up and running after some effort). 

My rsync (and also "sync" if I call it, or reboot without -n) also
gets stuck in D state: 

<4>[  622.364000] rsync         D 0019C170     0  2456   2455 (NOTLB)
<4>[  622.364000]        c04d7c80 00000086 c1f61ba8 0019c170 00000000 00000008 c31048a0 0003382e 
<4>[  622.364000]        00000000 c24c9908 00000286 c1092740 c3e12590 c2330a50 c2330b5c 00061a80 
<4>[  622.364000]        8639a400 00000078 c04d7cd0 00000000 c10801b8 c04d7c88 c03082af c0176c48 
<4>[  622.364000] Call Trace:
<4>[  622.364000]  [<c03082af>] io_schedule+0xe/0x16
<4>[  622.364000]  [<c0176c48>] sync_buffer+0x0/0x2e
<4>[  622.364000]  [<c0176c73>] sync_buffer+0x2b/0x2e
<4>[  622.364000]  [<c03083b9>] __wait_on_bit+0x2c/0x51
<4>[  622.364000]  [<c0176c48>] sync_buffer+0x0/0x2e
<4>[  622.364000]  [<c0308451>] out_of_line_wait_on_bit+0x73/0x7b
<4>[  622.364000]  [<c012970e>] wake_bit_function+0x0/0x3c
<4>[  622.364000]  [<c012970e>] wake_bit_function+0x0/0x3c
<4>[  622.364000]  [<c0176cce>] __wait_on_buffer+0x22/0x25
<4>[  622.364000]  [<c0198cf0>] ext3_find_entry+0x1aa/0x36f
<4>[  622.364000]  [<c01a2324>] journal_dirty_metadata+0x1b6/0x1d3
<4>[  622.364000]  [<c01990e7>] ext3_lookup+0x28/0xc6
<4>[  622.364000]  [<c0161611>] real_lookup+0x53/0xc2
<4>[  622.364000]  [<c0161881>] do_lookup+0x57/0x9d
<4>[  622.364000]  [<c0162075>] __link_path_walk+0x7ae/0xb81
<4>[  622.364000]  [<c011cb77>] __do_softirq+0x57/0x83
<4>[  622.364000]  [<c0162485>] link_path_walk+0x3d/0xa0
<4>[  622.364000]  [<c015a4e7>] sys_lchown+0x3c/0x44
<4>[  622.364000]  [<c015a8c7>] get_unused_fd+0xa0/0xbc
<4>[  622.364000]  [<c0162840>] do_path_lookup+0x1b7/0x200
<4>[  622.364000]  [<c01628e1>] __path_lookup_intent_open+0x42/0x72
<4>[  622.364000]  [<c0162931>] path_lookup_open+0x20/0x25
<4>[  622.364000]  [<c0163026>] open_namei+0x8c/0x532
<4>[  622.364000]  [<c015a328>] sys_fchmodat+0xac/0xb9
<4>[  622.364000]  [<c015a71b>] do_filp_open+0x25/0x39
<4>[  622.364000]  [<c015a4e7>] sys_lchown+0x3c/0x44
<4>[  622.364000]  [<c015a8c7>] get_unused_fd+0xa0/0xbc
<4>[  622.364000]  [<c015a9d5>] do_sys_open+0x42/0xbe
<4>[  622.364000]  [<c015aa6b>] sys_open+0x1a/0x1c
<4>[  622.364000]  [<c0103dbc>] syscall_call+0x7/0xb
<4>[  622.364000]  =======================

----------------------
<6>[  871.520000] SysRq : Show Memory
<6>[  871.520000] Mem-info:
<4>[  871.520000] DMA per-cpu:
<4>[  871.520000] CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
<4>[  871.520000] Normal per-cpu:
<4>[  871.520000] CPU    0: Hot: hi:    6, btch:   1 usd:   0   Cold: hi:    2, btch:   1 usd:   0
<4>[  871.520000] Active:5632 inactive:6764 dirty:0 writeback:302 unstable:0
<4>[  871.520000]  free:717 slab:2024 mapped:926 pagetables:135 bounce:0
<4>[  871.520000] DMA free:1104kB min:252kB low:312kB high:376kB active:3600kB inactive:6820kB present:16256kB pages_scanned:0 all_unreclaimable? no
<4>[  871.520000] lowmem_reserve[]: 0 47
<4>[  871.520000] Normal free:1764kB min:760kB low:948kB high:1140kB active:18928kB inactive:20236kB present:48708kB pages_scanned:0 all_unreclaimable? no
<4>[  871.520000] lowmem_reserve[]: 0 0
<4>[  871.520000] DMA: 118*4kB 19*8kB 2*16kB 2*32kB 0*64kB 1*128kB 1*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 1104kB
<4>[  871.520000] Normal: 171*4kB 23*8kB 0*16kB 0*32kB 4*64kB 1*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB = 1764kB
<4>[  871.520000] Swap cache: add 0, delete 0, find 0/0, race 0+0
<4>[  871.520000] Free swap  = 0kB
<4>[  871.520000] Total swap = 0kB
<6>[  871.520000] Free swap:            0kB
<6>[  871.520000] 16368 pages of RAM
<6>[  871.520000] 0 pages of HIGHMEM
<6>[  871.520000] 1044 reserved pages
<6>[  871.520000] 13456 pages shared
<6>[  871.520000] 0 pages swap cached
<6>[  871.520000] 0 pages dirty
<6>[  871.520000] 302 pages writeback
<6>[  871.520000] 926 pages mapped
<6>[  871.520000] 2024 pages slab
<6>[  871.520000] 135 pages pagetables

----------------------
ozon:/home/wolff# cat /proc/meminfo 
MemTotal:        61296 kB
MemFree:          2752 kB
Buffers:          2228 kB
Cached:          29968 kB
SwapCached:          0 kB
Active:          22632 kB
Inactive:        27056 kB
SwapTotal:           0 kB
SwapFree:            0 kB
Dirty:               0 kB
Writeback:        1208 kB
AnonPages:       17512 kB
Mapped:           3704 kB
Slab:             8088 kB
SReclaimable:     3656 kB
SUnreclaim:       4432 kB
PageTables:        552 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:     30648 kB
Committed_AS:    50092 kB
VmallocTotal:   974548 kB
VmallocUsed:       208 kB
VmallocChunk:   974160 kB



-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2600998 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
Q: It doesn't work. A: Look buddy, doesn't work is an ambiguous statement. 
Does it sit on the couch all day? Is it unemployed? Please be specific! 
Define 'it' and what it isn't doing. --------- Adapted from lxrbot FAQ
