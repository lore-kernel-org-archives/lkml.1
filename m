Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbZHFL5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbZHFL5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 07:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZHFL5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 07:57:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54944 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbZHFL5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 07:57:12 -0400
Date: Thu, 6 Aug 2009 13:57:05 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH 2/2 2.6.31-rc5 REPOST] percpu, sparc64: fix sparse
	possible cpu map handling
Message-ID: <20090806115705.GB10734@elte.hu>
References: <4A7AA368.8080606@kernel.org> <4A7AA416.9070901@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A7AA416.9070901@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> percpu code has been assuming num_possible_cpus() == nr_cpu_ids which
> is incorrect if cpu_possible_map contains holes.  This causes percpu
> code to access beyond allocated memories and vmalloc areas.  On a
> sparc64 machine with cpus 0 and 2 (u60), this triggers the following
> warning or fails boot.
> 
>  WARNING: at /devel/tj/os/work/mm/vmalloc.c:106 vmap_page_range_noflush+0x1f0/0x240()
>  Modules linked in:
>  Call Trace:
>   [00000000004b17d0] vmap_page_range_noflush+0x1f0/0x240
>   [00000000004b1840] map_vm_area+0x20/0x60
>   [00000000004b1950] __vmalloc_area_node+0xd0/0x160
>   [0000000000593434] deflate_init+0x14/0xe0
>   [0000000000583b94] __crypto_alloc_tfm+0xd4/0x1e0
>   [00000000005844f0] crypto_alloc_base+0x50/0xa0
>   [000000000058b898] alg_test_comp+0x18/0x80
>   [000000000058dad4] alg_test+0x54/0x180
>   [000000000058af00] cryptomgr_test+0x40/0x60
>   [0000000000473098] kthread+0x58/0x80
>   [000000000042b590] kernel_thread+0x30/0x60
>   [0000000000472fd0] kthreadd+0xf0/0x160
>  ---[ end trace 429b268a213317ba ]---
> 
> This patch fixes generic percpu functions and sparc64
> setup_per_cpu_areas() so that they handle sparse cpu_possible_map
> properly.
> 
> Please note that on x86, cpu_possible_map() doesn't contain holes and
> thus num_possible_cpus() == nr_cpu_ids and this patch doesn't cause
> any behavior difference.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
> As written in the previous mail, this fixes rather critical boot
> problem on sparc64.  Upon ack, I can get it through the percpu tree.
> Not really sure who could ack this one other than David tho.  Anyone?
> 
> Thanks.
> 
>  arch/sparc/kernel/smp_64.c     |    4 ++--
>  arch/x86/kernel/setup_percpu.c |   14 +++++++-------
>  mm/percpu.c                    |   31 +++++++++++++++++++------------
>  3 files changed, 28 insertions(+), 21 deletions(-)

for the x86 bits:

 Acked-by: Ingo Molnar <mingo@elte.hu>

Once Dave acks it i suspect you can send it to Linus directly?

	Ingo
