Return-Path: <linux-kernel-owner+w=401wt.eu-S1755832Ab0AWAk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0AWAk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369Ab0AWAk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:40:26 -0500
Received: from smtp-out.google.com ([216.239.44.51]:17004 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab0AWAkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:40:25 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=aRJoCdRURnkItRCr6Ks6T15wl/nJijUgmffgxPGOGPEjuVM8ssiu3hSUkDDV0YAPx
	ZEHj/lZdxLTugR3f0AKAA==
Date: Fri, 22 Jan 2010 16:40:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Roman Jarosz <kedgedev@gmail.com>
cc: linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: OOM-Killer kills too much with 2.6.32.2
In-Reply-To: <op.u6ixswy6asvm2a@kedge>
Message-ID: <alpine.DEB.2.00.1001221623480.12712@chino.kir.corp.google.com>
References: <op.u6ixswy6asvm2a@kedge>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jan 2010, Roman Jarosz wrote:

> Hi,
> 
> since kernel 2.6.32.2 (also tried 2.6.32.3) I get a lot of oom-killer kills
> when I do hard disk intensive tasks (mainly in VirtualBox which is running
> Windows XP) and IMHO it kills processes even if I have a lot of free memory.
> 
> Is this a known bug? I have self compiled kernel so I can try patches.
> 
> Regards
> Roman Jarosz
> 
> PS. Please CC me.
> 
> Jan  7 12:39:27 kedge kernel: X invoked oom-killer: gfp_mask=0x0, order=0,
> oom_adj=0

The gfp_mask of 0x0 and order of 0 indicate these are triggered by 
pagefaults that end up returning VM_FAULT_OOM.  Prior to 2.6.29, the 
current task (X in all cases from your log) would have been SIGKILLed; we 
now call the oom killer instead of kill a memory hogging task so that the 
fault is retried with more success.  If you've upgraded from a 2.6.29 or 
later kernel and are only now experiencing these errors, it may indicate a 
regression in VM that we need to investigate (and, if so, you may want to 
try merging f50de2d38 from 2.6.33 to see if it helps keep more ZONE_NORMAL 
memory available so that such drastic measures aren't necessary).

> Jan  7 12:39:27 kedge kernel: Pid: 1954, comm: X Not tainted 2.6.32.2 #1
> Jan  7 12:39:27 kedge kernel: Call Trace:
> Jan  7 12:39:27 kedge kernel: [<ffffffff8107b17d>] ? 0xffffffff8107b17d
> Jan  7 12:39:27 kedge kernel: [<ffffffff8107b463>] ? 0xffffffff8107b463
> Jan  7 12:39:27 kedge kernel: [<ffffffff8107b5d7>] ? 0xffffffff8107b5d7
> Jan  7 12:39:27 kedge kernel: [<ffffffff815581df>] ? 0xffffffff815581df

Can you find out what these symbols are?

> Jan  7 12:39:27 kedge kernel: Mem-Info:
> Jan  7 12:39:27 kedge kernel: DMA per-cpu:
> Jan  7 12:39:27 kedge kernel: CPU    0: hi:    0, btch:   1 usd:   0
> Jan  7 12:39:27 kedge kernel: CPU    1: hi:    0, btch:   1 usd:   0
> Jan  7 12:39:27 kedge kernel: DMA32 per-cpu:
> Jan  7 12:39:27 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 158
> Jan  7 12:39:27 kedge kernel: CPU    1: hi:  186, btch:  31 usd: 134
> Jan  7 12:39:27 kedge kernel: Normal per-cpu:
> Jan  7 12:39:27 kedge kernel: CPU    0: hi:  186, btch:  31 usd: 200
> Jan  7 12:39:27 kedge kernel: CPU    1: hi:  186, btch:  31 usd:  67
> Jan  7 12:39:27 kedge kernel: active_anon:420176 inactive_anon:150891
> isolated_anon:0
> Jan  7 12:39:27 kedge kernel: active_file:163989 inactive_file:204935
> isolated_file:32
> Jan  7 12:39:27 kedge kernel: unevictable:0 dirty:74867 writeback:5410
> unstable:0
> Jan  7 12:39:27 kedge kernel: free:6848 slab_reclaimable:12678
> slab_unreclaimable:12867
> Jan  7 12:39:27 kedge kernel: mapped:72453 shmem:82598 pagetables:7517
> bounce:0
> Jan  7 12:39:27 kedge kernel: DMA free:15776kB min:28kB low:32kB high:40kB
> active_anon:12kB inactive_anon:52kB active_file:4kB inactive_file:80kB
> unevictable:0kB isolated(anon):0kB isolated(file):0kB present:15344kB
> mlocked:0kB dirty:0kB writeback:0kB mapped:4kB shmem:4kB slab_reclaimable:0kB
> slab_unreclaimable:20kB kernel_stack:0kB pagetables:0kB unstable:0kB
> bounce:0kB writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no
> Jan  7 12:39:27 kedge kernel: lowmem_reserve[]: 0 2990 3937 3937

Although this appears that there is an abundance of memory available, its 
inaccessible because of the lowmem_reserve: 3937 pages are reserved for 
these types of allocations in ZONE_DMA, so assuming 4K page sizes:

	15776kB (free) - (4kB * 3937 lowmem_reserve) <= 28kB (min).

> Jan  7 12:39:27 kedge kernel: DMA32 free:9712kB min:6084kB low:7604kB
> high:9124kB active_anon:1469976kB inactive_anon:370840kB active_file:445776kB
> inactive_file:565080kB unevictable:0kB isolated(anon):0kB isolated(file):128kB
> present:3062688kB mlocked:0kB dirty:212584kB writeback:14288kB mapped:165804kB
> shmem:190264kB slab_reclaimable:30104kB slab_unreclaimable:34300kB
> kernel_stack:840kB pagetables:14756kB unstable:0kB bounce:0kB
> writeback_tmp:0kB pages_scanned:32 all_unreclaimable? no
> Jan  7 12:39:27 kedge kernel: lowmem_reserve[]: 0 0 946 946

Same:

	9712kB - (4kB * 946) <= 6084kB.

> Jan  7 12:39:27 kedge kernel: Normal free:1904kB min:1924kB low:2404kB
> high:2884kB active_anon:210716kB inactive_anon:232672kB active_file:210176kB
> inactive_file:254580kB unevictable:0kB isolated(anon):0kB isolated(file):0kB
> present:969600kB mlocked:0kB dirty:86784kB writeback:7452kB mapped:124004kB
> shmem:140124kB slab_reclaimable:20608kB slab_unreclaimable:17148kB
> kernel_stack:1792kB pagetables:15312kB unstable:0kB bounce:0kB
> writeback_tmp:0kB pages_scanned:0 all_unreclaimable? no

This shows ZONE_NORMAL is depleted, but we'll need to know where the 
regression started since 2.6.29 to find out why indirect reclaim isn't 
keeping a sufficient amount free anymore for your I/O bound task.
