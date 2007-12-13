Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbXLMD5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbXLMD5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 22:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751492AbXLMD47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 22:56:59 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:50811 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002AbXLMD46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 22:56:58 -0500
Date: Wed, 12 Dec 2007 22:56:12 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       benh@kernel.crashing.org, dino@in.ibm.com, tytso@us.ibm.com,
       dvhltc@us.ibm.com, antonb@us.ibm.com
Subject: Re: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
In-Reply-To: <20071029185044.GA23413@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.58.0712122253390.19475@gandalf.stny.rr.com>
References: <20071029185044.GA23413@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 29 Oct 2007, Paul E. McKenney wrote:
> diff -urpNa -X dontdiff linux-2.6.23.1-rt4/mm/memory.c linux-2.6.23.1-rt4-fix/mm/memory.c
> --- linux-2.6.23.1-rt4/mm/memory.c	2007-10-27 22:20:57.000000000 -0700
> +++ linux-2.6.23.1-rt4-fix/mm/memory.c	2007-10-28 15:40:36.000000000 -0700
> @@ -664,6 +664,7 @@ static unsigned long zap_pte_range(struc
>  	int anon_rss = 0;
>
>  	pte = pte_offset_map_lock(mm, pmd, addr, &ptl);
> +	preempt_disable();
>  	arch_enter_lazy_mmu_mode();
>  	do {
>  		pte_t ptent = *pte;
> @@ -732,6 +733,7 @@ static unsigned long zap_pte_range(struc
>
>  	add_mm_rss(mm, file_rss, anon_rss);
>  	arch_leave_lazy_mmu_mode();
> +	preempt_enable();
>  	pte_unmap_unlock(pte - 1, ptl);
>
>  	return addr;

I'm pulling your patch for the above added code. Took me a few hours to
find the culprit, but I was getting scheduling in atomic bugs. Turns out
that this code you put "preempt_disable" in calls sleeping spinlocks.

Might want to run with DEBUG_PREEMPT.

Thanks,

-- Steve

