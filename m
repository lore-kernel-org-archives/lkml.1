Return-Path: <linux-kernel-owner+w=401wt.eu-S1753280AbXJASIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbXJASIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 14:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXJASIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 14:08:12 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:42692
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbXJASIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 14:08:11 -0400
Date: Mon, 1 Oct 2007 11:09:22 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: OOM killer invoked on 2.6.20.3, need help understanding why
In-Reply-To: <1191257772.8354.3.camel@lappy>
Message-ID: <Pine.LNX.4.64.0710011106520.20712@asgard.lang.hm>
References: <Pine.LNX.4.64.0710010810170.20712@asgard.lang.hm>
 <1191257772.8354.3.camel@lappy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2007, Peter Zijlstra wrote:

> On Mon, 2007-10-01 at 08:57 -0700, david@lang.hm wrote:
>> I have a dual dual-core Opteron box running a 32 bit 2.6.20.3 kernel with
>> 4G himem (16G in the box) serving as a iptables firewall. I's got E1000
>> network cards and a LSI raid controller.
>
> OOh, 64bit machine. Seems like a good idea to run a 64bit kernel on
> it :-)

expecially with 16G of ram in it ;-)

unfortunantly the last time I tried a mixed 64/32 system I ran into 
mysterious lockups (that I now think were the iptables interface bugs), 
and haven't convinced management to let me try again, and I haven't 
migrated everything to 64 bit machines to convert the standard system 
image to 64 bit (I'm close, half a dozen machines out of a few hundred, 
but not _quite_ there)

>> this morning it died with the message 'kernel panic, out of memory and no
>> process to kill'
>>
>> gong back through it's syslogs I've got quite a few logs, but I need help
>> in understanding what went wrong (and if it's preventable)
>>
>> the process that was running and triggered the OOM is a script
>>
>> #!/bin/bash
>>
>> PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
>>
>> while :
>> do
>>    logger -t maxconns `cat /proc/sys/net/ipv4/netfilter/ip_conntrack_count`
>>    logger -t afdslog `cat /proc/sys/fs/file-nr |awk '{print $1}'`
>>
>>    sleep 5
>> done
>>
>> since the box is a dedicated firewall there is very little running on it
>> (a few other monitoring scripts like this)
>>
>> the conntrack count that was being reported was relativly low (around
>> 34k, the max is set at 1m)
>>
>> if I'm reading the logs correctly it looks like it ran out of lowmem, but
>> had a lot of himem still available. but I don't know what would have eaten
>> up the lowmem.
>>
>> now the logs and other info
>>
>> Oct  1 06:01:04 g1a-c maxconns: 34317
>> Oct  1 06:01:05 g1a-c kernel: printk: 1887 messages suppressed.
>> Oct  1 06:01:05 g1a-c kernel: maxconns invoked oom-killer: gfp_mask=0x84d0, order=0, oomkilladj=0
>> Oct  1 06:01:05 g1a-c kernel:  [<c0147850>] out_of_memory+0x100/0x130
>> Oct  1 06:01:05 g1a-c kernel:  [<c0148b2b>] __alloc_pages+0x22b/0x2d0
>> Oct  1 06:01:05 g1a-c kernel:  [<c01135b1>] pte_alloc_one+0x11/0x20
>> Oct  1 06:01:05 g1a-c kernel:  [<c014feaa>] __pte_alloc+0x1a/0xb0
>> Oct  1 06:01:05 g1a-c kernel:  [<c0150369>] copy_pte_range+0x289/0x2b0
>> Oct  1 06:01:05 g1a-c kernel:  [<c01504b9>] copy_page_range+0x129/0x170
>> Oct  1 06:01:05 g1a-c kernel:  [<c011e024>] dup_mm+0x214/0x2e0
>> Oct  1 06:01:05 g1a-c kernel:  [<c011e179>] copy_mm+0x89/0xa0
>> Oct  1 06:01:05 g1a-c kernel:  [<c011e91a>] copy_process+0x33a/0xc60
>> Oct  1 06:01:05 g1a-c kernel:  [<c011f2a5>] do_fork+0x65/0x1f0
>> Oct  1 06:01:05 g1a-c kernel:  [<c027e2c2>] copy_to_user+0x32/0x50
>> Oct  1 06:01:05 g1a-c kernel:  [<c0101722>] sys_clone+0x32/0x40
>> Oct  1 06:01:05 g1a-c kernel:  [<c0102a8e>] syscall_call+0x7/0xb
>> Oct  1 06:01:05 g1a-c kernel:  =======================
>> Oct  1 06:01:05 g1a-c kernel: Mem-info:
>> Oct  1 06:01:05 g1a-c kernel: DMA per-cpu:
>> Oct  1 06:01:05 g1a-c kernel: CPU    0: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
>> Oct  1 06:01:05 g1a-c kernel: CPU    1: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
>> Oct  1 06:01:05 g1a-c kernel: CPU    2: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
>> Oct  1 06:01:05 g1a-c kernel: CPU    3: Hot: hi:    0, btch:   1 usd:   0   Cold: hi:    0, btch:   1 usd:   0
>> Oct  1 06:01:05 g1a-c kernel: Normal per-cpu:
>> Oct  1 06:01:05 g1a-c kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 104   Cold: hi:   62, btch:  15 usd:  58
>> Oct  1 06:01:05 g1a-c kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  22   Cold: hi:   62, btch:  15 usd:  52
>> Oct  1 06:01:05 g1a-c kernel: CPU    2: Hot: hi:  186, btch:  31 usd:  30   Cold: hi:   62, btch:  15 usd:  58
>> Oct  1 06:01:05 g1a-c kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  15   Cold: hi:   62, btch:  15 usd:  60
>> Oct  1 06:01:05 g1a-c kernel: HighMem per-cpu:
>> Oct  1 06:01:05 g1a-c kernel: CPU    0: Hot: hi:  186, btch:  31 usd: 105   Cold: hi:   62, btch:  15 usd:   8
>> Oct  1 06:01:05 g1a-c kernel: CPU    1: Hot: hi:  186, btch:  31 usd:  51   Cold: hi:   62, btch:  15 usd:   3
>> Oct  1 06:01:05 g1a-c kernel: CPU    2: Hot: hi:  186, btch:  31 usd: 122   Cold: hi:   62, btch:  15 usd:   0
>> Oct  1 06:01:05 g1a-c kernel: CPU    3: Hot: hi:  186, btch:  31 usd:  42   Cold: hi:   62, btch:  15 usd:   0
>> Oct  1 06:01:05 g1a-c kernel: Active:3496 inactive:616 dirty:16 writeback:0 unstable:0
>> Oct  1 06:01:05 g1a-c kernel:  free:3941515 slab:6779 mapped:843 pagetables:48 bounce:0
>> Oct  1 06:01:05 g1a-c kernel: DMA free:3548kB min:68kB low:84kB high:100kB active:16kB inactive:0kB present:16256kB pages_scanned:56 all_unreclaimable? yes
>> Oct  1 06:01:05 g1a-c kernel: lowmem_reserve[]: 0 873 16240
>> Oct  1 06:01:05 g1a-c kernel: Normal free:3640kB min:3744kB low:4680kB high:5616kB active:148kB inactive:0kB present:894080kB pages_scanned:7196 all_unreclaimable? yes
>> Oct  1 06:01:05 g1a-c kernel: lowmem_reserve[]: 0 0 122936
>> Oct  1 06:01:05 g1a-c kernel: HighMem free:15758872kB min:512kB low:17000kB high:33492kB active:13820kB inactive:2464kB present:15735808kB pages_scanned:0 all_unreclaimable? no
>> Oct  1 06:01:05 g1a-c kernel: lowmem_reserve[]: 0 0 0
>> Oct  1 06:01:05 g1a-c kernel: DMA: 3*4kB 2*8kB 1*16kB 1*32kB 0*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3532kB
>> Oct  1 06:01:05 g1a-c kernel: Normal: 0*4kB 23*8kB 6*16kB 1*32kB 0*64kB 0*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 0*4096kB = 3640kB
>> Oct  1 06:01:05 g1a-c kernel: HighMem: 122*4kB 658*8kB 622*16kB 464*32kB 391*64kB 336*128kB 277*256kB 226*512kB 169*1024kB 135*2048kB 3668*4096kB = 15758872kB
>> Oct  1 06:01:05 g1a-c kernel: Swap cache: add 0, delete 0, find 0/0, race 0+0
>> Oct  1 06:01:05 g1a-c kernel: Free swap  = 2048276kB
>> Oct  1 06:01:05 g1a-c kernel: Total swap = 2048276kB
>> Oct  1 06:01:05 g1a-c kernel: Free swap:       2048276kB
>
> Seems like it ran out of memory in zone normal. Looks like it all went to SLAB.
> Could you run your regular workload, and append /proc/slabinfo onto a file every 5 minutes or so?
>
> That should tell us who is using all this memory. (assuming it reproduces...)

will do.

David Lang

