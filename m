Return-Path: <linux-kernel-owner+w=401wt.eu-S1759085AbZFOI0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759085AbZFOI0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758267AbZFOI0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:26:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58092 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758274AbZFOI0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:26:40 -0400
Date: Mon, 15 Jun 2009 10:26:36 +0200
From: Nick Piggin <npiggin@suse.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
       lizf@cn.fujitsu.com, mingo@elte.hu, yinghai@kernel.org,
       benh@kernel.crashing.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090615082636.GA30964@wotan.suse.de>
References: <Pine.LNX.4.64.0906121624280.2937@melkki.cs.Helsinki.FI> <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615081831.GA5411@osiris.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 10:18:31AM +0200, Heiko Carstens wrote:
> On Fri, Jun 12, 2009 at 07:16:30PM +0300, Pekka J Enberg wrote:
> > Hi Linus,
> > 
> > I dropped the GFP_WAIT conversion patch and added the gfp masking patch 
> > you liked. I tested this on x86-64 with both SLAB and SLUB.
> 
> Hi Pekka,
> 
> I tried to convert some of the early allocations on s390. Some callsites
> however need to have the GFP_DMA flag, since we need to allocate memory below
> 2GB. Passing GFP_DMA causes this crash:
> 
>     <1>Unable to handle kernel pointer dereference at virtual kernel address fffffffffffff000
>     <4>Oops: 0038 [#1] PREEMPT SMP 
>     <4>Modules linked in:
>     <4>CPU: 0 Not tainted 2.6.30-03984-g45e3e19-dirty #233
>     <4>Process swapper (pid: 0, task: 00000000006a2ef0, ksp: 0000000000718000)
>     <4>Krnl PSW : 0700100180000000 00000000000808ee (queue_work_on+0x8e/0xe0)
>     <4>           R:0 T:1 IO:1 EX:1 Key:0 M:0 W:0 P:0 AS:0 CC:1 PM:0 EA:3
>     <4>Krnl GPRS: 0000000000000000 ffffffffffffffff 0000000000000000 00000000006b8b88
>     <4>           00000000006b8b88 0000000000000001 0000000000000008 0000000000000200
>     <4>           000000003fe28000 0000000000008001 00000000011da730 0000000000717ca0
>     <4>           00000000006b8b88 0000000000488650 0000000000717cd0 0000000000717ca0
>     <4>Krnl Code: 00000000000808de: e310d0000082        xg      %r1,0(%r13)
>     <4>           00000000000808e4: eb220003000d        sllg    %r2,%r2,3
>     <4>           00000000000808ea: b9040034            lgr     %r3,%r4
>     <4>          >00000000000808ee: e32210000004        lg      %r2,0(%r2,%r1)
>     <4>           00000000000808f4: c0e5ffffff28        brasl   %r14,80744
>     <4>           00000000000808fa: a7280001            lhi     %r2,1
>     <4>           00000000000808fe: e340b0b80004        lg      %r4,184(%r11)
>     <4>           0000000000080904: b9140022            lgfr    %r2,%r2
>     <4>Call Trace:
>     <4>([<000000003fe28000>] 0x3fe28000)
>     <4> [<0000000000080e96>] queue_work+0x62/0xa4
>     <4> [<0000000000080f26>] schedule_work+0x4e/0x60
>     <4> [<0000000000132f7e>] dma_kmalloc_cache+0x1ca/0x1d0
>     <4> [<00000000001330ae>] get_slab+0x12a/0x130
>     <4> [<00000000001337b6>] __kmalloc+0x5e/0x364
>     <4> [<0000000000739132>] con3215_init+0x1c2/0x2e4
>     <4> [<00000000007333ea>] console_init+0x42/0x5c
>     <4> [<0000000000718e50>] start_kernel+0x53c/0x6b8
>     <4> [<0000000000012020>] _ehead+0x20/0x80
> 
> I didn't look any deeper into this, but looks to me like doing something like
> schedule_work() this early isn't ok.
> 
> This is the conversion that leads to the crash:
> 
> -               alloc_bootmem_low(sizeof(struct raw3215_info));
> +               kzalloc(sizeof(struct raw3215_info), GFP_NOWAIT | GFP_DMA);
> 
> Might be that I missed something. Maybe some special flag?

No, just a bug in the conversion.

If you predicate the schedule_work call on slab_state == SYSFS, then
it should work (when sysfs comes up later in init, previously added
slabs will be registered with sysfs).

Oh, and you'd need to also not pass __SYSFS_ADD_DEFERRED into
kmem_cache_create in that case too.

