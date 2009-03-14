Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbZCNHRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbZCNHRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 03:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbZCNHQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 03:16:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:36862 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbZCNHQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 03:16:57 -0400
Subject: Re: [tip:x86/mtrr] x86: more MTRR debug printouts
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@elte.hu, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <49BAB7FF.4030107@kernel.org>
References: <49B9BA5A.40108@kernel.org>
	 <tip-8ad9790588ee2e69118b2b294ddab6f3f0379ad9@git.kernel.org>
	 <1236958403.2646.1.camel@ht.satnam> <1236959121.2646.3.camel@ht.satnam>
	 <49BAB7FF.4030107@kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 12:45:27 +0530
Message-Id: <1237014927.2578.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 12:46 -0700, Yinghai Lu wrote:
> Jaswinder Singh Rajput wrote:
> > On Fri, 2009-03-13 at 21:03 +0530, Jaswinder Singh Rajput wrote:
> >> On Fri, 2009-03-13 at 02:34 +0000, Yinghai Lu wrote:
> >>> Commit-ID:  8ad9790588ee2e69118b2b294ddab6f3f0379ad9
> >>> Gitweb:     http://git.kernel.org/tip/8ad9790588ee2e69118b2b294ddab6f3f0379ad9
> >>> Author:     Yinghai Lu <yinghai@kernel.org>
> >>> AuthorDate: Thu, 12 Mar 2009 18:43:54 -0700
> >>> Commit:     Ingo Molnar <mingo@elte.hu>
> >>> CommitDate: Fri, 13 Mar 2009 02:52:18 +0100
> >>>
> >>> x86: more MTRR debug printouts
> >>>
> >>> Impact: improve MTRR debugging messages
> >>>
> >>> There's still inefficiencies suspected with the MTRR sanitizing
> >>> code, so make sure we get all the info we need from a dmesg.
> >>>
> >>> - Remove unneeded mtrr_show
> >>>
> >>>  (It will only printout one time by first cpu, so it is no big deal.)
> >>>
> >>> - Also print out directly from get_mtrr, because it doesn't update mtrr_state.
> >>>
> >>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> >>> LKML-Reference: <49B9BA5A.40108@kernel.org>
> >>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> >>>
> >>>
> >>>  		*base = 0;
> >>> @@ -407,6 +410,10 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
> >>>  	*size = -mask_lo;
> >>>  	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
> >>>  	*type = base_lo & 0xff;
> >>> +
> >>> +	printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
> >>> +			smp_processor_id(), reg, *base, *size,
> >>> +			mtrr_attrib_to_str(*type & 0xff));
> >>>  }
> >>>  
> >> This leads to:
> >>
> >> Kernel failure message 1:
> >> BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
> >> caller is generic_get_mtrr+0x12a/0x146
> >> Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar
> >> 13 20:43:36 IST 2009
> >> Call Trace:
> >>  [<c0412cc3>] ? printk+0x14/0x16
> >>  [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
> >>  [<c010f0c3>] generic_get_mtrr+0x12a/0x146
> >>  [<c010e351>] mtrr_add_page+0x154/0x332
> >>  [<c010e7b1>] mtrr_file_add+0x72/0x86
> >>  [<c010e9e0>] mtrr_ioctl+0x21b/0x309
> >>  [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
> >>  [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
> >>  [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
> >>  [<c0194101>] vfs_ioctl+0x27/0x6e
> >>  [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
> >>  [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
> >>  [<c01898b0>] ? fget_light+0x40/0x130
> >>  [<c01946ee>] sys_ioctl+0x34/0x61
> >>  [<c0102c73>] sysenter_do_call+0x12/0x25
> >>
> 
> please check
> 
> [PATCH] x86: fix get_mtrr warning about smp_processor_id with preempt
> 
> Impact: fix warning
> 
> Jaswinder noticed that there is warning about smp_processor_id() in get_mtrr
> 
> try to fix it by use disable/enable to wrap it.
> 
> Reported-by: Jaswinder Singh Rajput <jaswinder@kernel.org>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Thanks, this fix the bug.

But I am still not happy with ruining dmesg, It looks weird on 2 cpu
box, what will be the case for 16 or more cpus.

We are supporting these output in /sys/kernel/x86/cpu/cpu*/mtrr/mtrr
through cpu_debug.c, why do not you use it and only flush this
information on panic:

[    0.000000] last_pfn = 0x3ff2f max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-0FFFF write-back
[    0.000000]   10000-1FFFF write-back
[    0.000000]   20000-2FFFF write-back
[    0.000000]   30000-3FFFF write-back
[    0.000000]   40000-4FFFF write-back
[    0.000000]   50000-5FFFF write-back
[    0.000000]   60000-6FFFF write-back
[    0.000000]   70000-7FFFF write-back
[    0.000000]   80000-83FFF write-back
[    0.000000]   84000-87FFF write-back
[    0.000000]   88000-8BFFF write-back
[    0.000000]   8C000-8FFFF write-back
[    0.000000]   90000-93FFF write-back
[    0.000000]   94000-97FFF write-back
[    0.000000]   98000-9BFFF write-back
[    0.000000]   9C000-9FFFF write-back
[    0.000000]   A0000-A3FFF uncachable
[    0.000000]   A4000-A7FFF uncachable
[    0.000000]   A8000-ABFFF uncachable
[    0.000000]   AC000-AFFFF uncachable
[    0.000000]   B0000-B3FFF uncachable
[    0.000000]   B4000-B7FFF uncachable
[    0.000000]   B8000-BBFFF uncachable
[    0.000000]   BC000-BFFFF uncachable
[    0.000000]   C0000-C0FFF uncachable
[    0.000000]   C1000-C1FFF uncachable
[    0.000000]   C2000-C2FFF uncachable
[    0.000000]   C3000-C3FFF uncachable
[    0.000000]   C4000-C4FFF uncachable
[    0.000000]   C5000-C5FFF uncachable
[    0.000000]   C6000-C6FFF uncachable
[    0.000000]   C7000-C7FFF uncachable
[    0.000000]   C8000-C8FFF uncachable
[    0.000000]   C9000-C9FFF uncachable
[    0.000000]   CA000-CAFFF uncachable
[    0.000000]   CB000-CBFFF uncachable
[    0.000000]   CC000-CCFFF uncachable
[    0.000000]   CD000-CDFFF uncachable
[    0.000000]   CE000-CEFFF uncachable
[    0.000000]   CF000-CFFFF uncachable
[    0.000000]   D0000-D0FFF uncachable
[    0.000000]   D1000-D1FFF uncachable
[    0.000000]   D2000-D2FFF uncachable
[    0.000000]   D3000-D3FFF uncachable
[    0.000000]   D4000-D4FFF uncachable
[    0.000000]   D5000-D5FFF uncachable
[    0.000000]   D6000-D6FFF uncachable
[    0.000000]   D7000-D7FFF uncachable
[    0.000000]   D8000-D8FFF uncachable
[    0.000000]   D9000-D9FFF uncachable
[    0.000000]   DA000-DAFFF uncachable
[    0.000000]   DB000-DBFFF uncachable
[    0.000000]   DC000-DCFFF uncachable
[    0.000000]   DD000-DDFFF uncachable
[    0.000000]   DE000-DEFFF uncachable
[    0.000000]   DF000-DFFFF uncachable
[    0.000000]   E0000-E0FFF uncachable
[    0.000000]   E1000-E1FFF uncachable
[    0.000000]   E2000-E2FFF uncachable
[    0.000000]   E3000-E3FFF uncachable
[    0.000000]   E4000-E4FFF uncachable
[    0.000000]   E5000-E5FFF uncachable
[    0.000000]   E6000-E6FFF uncachable
[    0.000000]   E7000-E7FFF uncachable
[    0.000000]   E8000-E8FFF uncachable
[    0.000000]   E9000-E9FFF uncachable
[    0.000000]   EA000-EAFFF uncachable
[    0.000000]   EB000-EBFFF uncachable
[    0.000000]   EC000-ECFFF uncachable
[    0.000000]   ED000-EDFFF uncachable
[    0.000000]   EE000-EEFFF uncachable
[    0.000000]   EF000-EFFFF uncachable
[    0.000000]   F0000-F0FFF write-protect
[    0.000000]   F1000-F1FFF write-protect
[    0.000000]   F2000-F2FFF write-protect
[    0.000000]   F3000-F3FFF write-protect
[    0.000000]   F4000-F4FFF write-protect
[    0.000000]   F5000-F5FFF write-protect
[    0.000000]   F6000-F6FFF write-protect
[    0.000000]   F7000-F7FFF write-protect
[    0.000000]   F8000-F8FFF write-protect
[    0.000000]   F9000-F9FFF write-protect
[    0.000000]   FA000-FAFFF write-protect
[    0.000000]   FB000-FBFFF write-protect
[    0.000000]   FC000-FCFFF write-protect
[    0.000000]   FD000-FDFFF write-protect
[    0.000000]   FE000-FEFFF write-protect
[    0.000000]   FF000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask FC0000000 write-back
[    0.000000]    1 disabled
[    0.000000]    2 disabled
[    0.000000]    3 disabled
[    0.000000]    4 disabled
[    0.000000]    5 disabled
[    0.000000]    6 disabled
[    0.000000]    7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000]   get_mtrr: cpu0 reg00 base=0000000000 size=0000040000 write-back
..
[   32.112812]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.112822]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.112874]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.112881]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.121742]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.121749]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.138014]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.138021]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.138028]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.138033]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.138660]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   32.139246]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.139284]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.139297]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.139307]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.139996]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   32.306889]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.306899]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.313545]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.313551]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.313558]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.313563]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.317551]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.317559]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.317565]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000008000 write-combining
[   32.389848]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.389856]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.389860]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000008000 write-combining
[   32.390449]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   32.390591]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.390601]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.390610]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   32.390648]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining
[   32.390710]   get_mtrr: cpu1 reg00 base=0000000000 size=0000040000 write-back
[   32.390715]   get_mtrr: cpu1 reg01 base=00000f8000 size=0000004000 write-combining
[   32.390720]   get_mtrr: cpu1 reg02 base=00000e0000 size=0000010000 write-combining


