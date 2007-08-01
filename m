Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbXHAUwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbXHAUwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 16:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbXHAUwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 16:52:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:4927 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbXHAUwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 16:52:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rlenGX7ItbYZmTKv85W7V1V6py+X2y7i6/kahFV5/67FpUbgs2t8kuxQ/2Yr+NZ7WSe3RSNfIZQBhRBYXd/IK0gcwkJU8zSjEMRelh26q7iJRBxPwrLRbs1GT/8EQbsG9VB0ekWfRtdoitxFGrQA5sfINl/J5tB+Z/1NTpz+ch4=
Message-ID: <64bb37e0708011352q33053acdxa753cd198fb4233c@mail.gmail.com>
Date: Wed, 1 Aug 2007 22:52:44 +0200
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc1-mm2
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
In-Reply-To: <20070801134055.7862b95e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070731230932.a9459617.akpm@linux-foundation.org>
	 <12639.1186000208@turing-police.cc.vt.edu>
	 <20070801134055.7862b95e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 01 Aug 2007 16:30:08 -0400
> Valdis.Kletnieks@vt.edu wrote:
>
> > As an aside, it looks like bits&pieces of dynticks-for-x86_64 are in there.
> > In particular, x86_64-enable-high-resolution-timers-and-dynticks.patch is in
> > there, adding a menu that depends on GENERIC_CLOCKEVENTS, but then nothing
> > in the x86_64 tree actually *sets* it.  There's a few other dynticks-related
> > prep patches in there as well.  Does this mean it's back to "coming soon to
> > a CPU near you" status? :)
>
> I've lost the plot on that stuff: I'm just leaving things as-is for now,
> wait for Thomas to return from vacation so we can have another run at it.

For what its worth: 2.6.22-rc6-mm1 with NO_HZ works for me on an AMD
SMP system without trouble.

Next try with 2.6.23-rc1-mm2 and SPARSEMEM:
Probably the same exception, but this time with Call Trace:
[    0.000000] Bootmem setup node 0 0000000000000000-0000000080000000
[    0.000000] Bootmem setup node 1 0000000080000000-0000000120000000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1179648
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   524288
[    0.000000]     1:   524288 ->   917488
[    0.000000]     1:  1048576 ->  1179648
PANIC: early exception rip ffffffff807cddb5 error 2 cr2 ffffe20003000010
[    0.000000]
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff807cddb5>] memmap_init_zone+0xb5/0x130
[    0.000000]  [<ffffffff807ce874>] init_currently_empty_zone+0x84/0x110
[    0.000000]  [<ffffffff807cec93>] free_area_init_node+0x393/0x3e0
[    0.000000]  [<ffffffff807cefea>] free_area_init_nodes+0x2da/0x320
[    0.000000]  [<ffffffff807c9c97>] paging_init+0x87/0x90
[    0.000000]  [<ffffffff807c0f85>] setup_arch+0x355/0x470
[    0.000000]  [<ffffffff807bc967>] start_kernel+0x57/0x330
[    0.000000]  [<ffffffff807bc12d>] _sinittext+0x12d/0x140
[    0.000000]
[    0.000000] RIP memmap_init_zone+0xb5/0x130

(gdb) list *0xffffffff807cddb5
0xffffffff807cddb5 is in memmap_init_zone (include/linux/list.h:32).
27      #define LIST_HEAD(name) \
28              struct list_head name = LIST_HEAD_INIT(name)
29
30      static inline void INIT_LIST_HEAD(struct list_head *list)
31      {
32              list->next = list;
33              list->prev = list;
34      }
35
36      /*

I will test more tomorrow...

Torsten
