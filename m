Return-Path: <linux-kernel-owner+w=401wt.eu-S1752826AbYLSVI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbYLSVI3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 16:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYLSVIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 16:08:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:41800 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYLSVIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 16:08:19 -0500
Message-ID: <494C0D28.6040002@kernel.org>
Date: Fri, 19 Dec 2008 13:07:52 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: Tree for December 19 (new CONFIG_NUMA_MIGRATE_IRQ_DESC
 option)
References: <20081219235757.6b94d9ef.sfr@canb.auug.org.au> <200812192201.28665.bzolnier@gmail.com>
In-Reply-To: <200812192201.28665.bzolnier@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Friday 19 December 2008, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20081218:
>  
> Just few very minor issues w.r.t. "x86, sparseirq: move irq_desc according
> to smp_affinity, v7" (commit 48a1b10aff588833b73994704c47bbd0deb73e9c):
> 
> +config NUMA_MIGRATE_IRQ_DESC
> +	bool "Move irq desc when changing irq smp_affinity"
> +	depends on SPARSE_IRQ && SMP
> +	default n
> +	help
> +	  This enables moving irq_desc to cpu/node that irq will use handled.
> +
> +	  If you don't know what to do here, say N.
> 
> This is a bit confusing (at least I was confused since I don't have NUMA
> set in my config) -- either it should depend on NUMA or the config option
> name should be changed.

should be changed to 
depends on SPARSE_IRQ && NUMA

> 
> @@ -2346,14 +2466,34 @@ static void irq_complete_move(struct irq_desc **descp)
>  	struct irq_cfg *cfg = desc->chip_data;
>  	unsigned vector, me;
>  
> -	if (likely(!cfg->move_in_progress))
> +	if (likely(!cfg->move_in_progress)) {
> +#ifdef CONFIG_NUMA_MIGRATE_IRQ_DESC
> +		if (likely(!cfg->move_desc_pending))
> +			return;
> +
> +		/* domain is not change, but affinity is changed */
> 
> this comment sounds weird

for logical flat mode, domain will be online_cpu_mask.
so need to move irq_desc when smp_affinity is changed.

> 
> perhaps: /* only affinity is changed */ would be better?
> 
> +++ b/kernel/irq/numa_migrate.c
> @@ -0,0 +1,127 @@
> +/*
> + * linux/kernel/irq/handle.c
> + *
> + * Copyright (C) 1992, 1998-2006 Linus Torvalds, Ingo Molnar
> + * Copyright (C) 2005-2006, Thomas Gleixner, Russell King
> + *
> + * This file contains the core interrupt handling code.
> + *
> + * Detailed information is available in Documentation/DocBook/genericirq
> + *
> + */
> 
> hmmm? ;-)

seperated from irq/handle.c

oh, will remove those lines.

YH
