Return-Path: <linux-kernel-owner+w=401wt.eu-S1754212AbZGJJiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212AbZGJJiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbZGJJiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:38:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47988 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbZGJJiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:38:03 -0400
Date: Fri, 10 Jul 2009 11:37:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Add alignment-faults and
	emulation-faults sw events
Message-ID: <20090710093757.GG27445@elte.hu>
References: <20090706120815.GC4391@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090706120815.GC4391@kryten>
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


* Anton Blanchard <anton@samba.org> wrote:

> Add two software events that are common to many cpus:
> 
> Alignment faults: When a load or store is not aligned properly and 
> must be performed by the kernel.
> 
> Emulation faults: When an instruction must be emulated by the 
> kernel.
> 
> Both cause a very significant slowdown (potentially 100x or 
> worse), so identifying and fixing them is very important.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> ---
> 
> Index: linux.trees.git/include/linux/perf_counter.h
> ===================================================================
> --- linux.trees.git.orig/include/linux/perf_counter.h	2009-07-06 21:50:53.000000000 +1000
> +++ linux.trees.git/include/linux/perf_counter.h	2009-07-06 21:51:18.000000000 +1000
> @@ -102,6 +102,8 @@
>  	PERF_COUNT_SW_CPU_MIGRATIONS		= 4,
>  	PERF_COUNT_SW_PAGE_FAULTS_MIN		= 5,
>  	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
> +	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
> +	PERF_COUNT_SW_EMULATION_FAULTS		= 8,

Looks useful.

I'm wondering about the enumeration space: in other cases when some 
simple event was further refined we went to add a new perf_type_id 
and a separate enumeration space, with no limits to extensibility. 
We'd have a new 'enum perf_sw_fault_id' space.

Page faults are special anyway, because they carry a 'data' 
(faulting address) sample as well.

So i'm wondering how a good, generic enumeration of all things page 
faults would look like. If we extend perf_sw_ids linearly we might 
lose some structure.

For example major versus minor might be a dimension (bit) in the 
enumeration space, so we'd have:

   { major | minor } x { native, unaligned, emulated }

This provides an advantage already: the current 'all' page faults 
counter would become the 'major|minor' case in the new enumeration.

We could still keep around the old events as well for some time, but 
the tools would use the new enumeration.

Hm?

	Ingo
