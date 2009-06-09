Return-Path: <linux-kernel-owner+w=401wt.eu-S1759094AbZFIIn7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759094AbZFIIn7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 04:43:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbZFIInw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 04:43:52 -0400
Received: from viefep11-int.chello.at ([62.179.121.31]:26778 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757501AbZFIInu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 04:43:50 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [tip:perfcounters/core] perf_counter, x86: Implement
 generalized cache event types, add AMD support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-d3ad70660a0bf6d1a3692093939d238fe8add498@git.kernel.org>
References: <new-submission>
	 <tip-d3ad70660a0bf6d1a3692093939d238fe8add498@git.kernel.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 10:43:52 +0200
Message-Id: <1244537032.13761.10071.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-08 at 20:36 +0000, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  d3ad70660a0bf6d1a3692093939d238fe8add498
> Gitweb:     http://git.kernel.org/tip/d3ad70660a0bf6d1a3692093939d238fe8add498
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Mon, 8 Jun 2009 22:33:10 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Mon, 8 Jun 2009 22:33:10 +0200
> 
> perf_counter, x86: Implement generalized cache event types, add AMD support
> 
> Fill in amd_hw_cache_event_id[] with the AMD CPU specific events,
> for family 0x0f, 0x10 and 0x11.
> 
> There's apparently no distinction between load and store events, so
> we only fill in the load events.

Ah, that's what you did.. :-)

> +static const u64 amd_0f_hw_cache_event_ids
> +				[PERF_COUNT_HW_CACHE_MAX]
> +				[PERF_COUNT_HW_CACHE_OP_MAX]
> +				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
> +{
> + [ C(L1D) ] = {
> +	[ C(OP_READ) ] = {
> +		[ C(RESULT_ACCESS) ] = 0,
> +		[ C(RESULT_MISS)   ] = 0,

0x40 - Data Cache Access
0x41 - Data Cache Misses

> +	},
> +	[ C(OP_WRITE) ] = {
> +		[ C(RESULT_ACCESS) ] = 0,
> +		[ C(RESULT_MISS)   ] = 0,
> +	},
> +	[ C(OP_PREFETCH) ] = {
> +		[ C(RESULT_ACCESS) ] = 0,
> +		[ C(RESULT_MISS)   ] = 0,

0x4B - unit 0x3 (load+store) Prefetch Dispatched

> +	},
> + },
> + [ C(L1I ) ] = {
> +	[ C(OP_READ) ] = {
> +		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction cache fetches  */
> +		[ C(RESULT_MISS)   ] = 0x0081, /* Instruction cache misses   */
> +	},
> +	[ C(OP_WRITE) ] = {
> +		[ C(RESULT_ACCESS) ] = -1,
> +		[ C(RESULT_MISS)   ] = -1,
> +	},
> +	[ C(OP_PREFETCH) ] = {
> +		[ C(RESULT_ACCESS) ] = 0,
> +		[ C(RESULT_MISS)   ] = 0,
> +	},

0x81 L1I Miss
0x82 L1I Miss, L2 Hit
0x83 L1I Miss, L2 Miss

> + },
> + [ C(L2  ) ] = {
> +	[ C(OP_READ) ] = {
> +		[ C(RESULT_ACCESS) ] = 0,
> +		[ C(RESULT_MISS)   ] = 0,
> +	},
> +	[ C(OP_WRITE) ] = {
> +		[ C(RESULT_ACCESS) ] = 0,
> +		[ C(RESULT_MISS)   ] = 0,
> +	},
> +	[ C(OP_PREFETCH) ] = {
> +		[ C(RESULT_ACCESS) ] = 0,
> +		[ C(RESULT_MISS)   ] = 0,
> +	},

0x42 unit 0x1e (shared|exclusive|owned|mod) L1 Miss L2 Hit
0x43 unit 0x1e                              L2 Miss

0x7d unit 0x3 (IC|DC) L2 Hit
0x7e unit 0x3 (IC|DC) L2 Miss

> + },
> + [ C(DTLB) ] = {
> +	[ C(OP_READ) ] = {
> +		[ C(RESULT_ACCESS) ] = 0,
> +		[ C(RESULT_MISS)   ] = 0,
> +	},

0x4D - unit 0x1 4k DTLB L1 Hit
0x45 - unit 0x1 4k DTLB L1 Miss L2 Hit
0x46 - unit 0x1 4k DTLB L1 Miss L2 Miss

> +	[ C(OP_WRITE) ] = {
> +		[ C(RESULT_ACCESS) ] = 0,
> +		[ C(RESULT_MISS)   ] = 0,
> +	},
> +	[ C(OP_PREFETCH) ] = {
> +		[ C(RESULT_ACCESS) ] = 0,
> +		[ C(RESULT_MISS)   ] = 0,
> +	},
> + },
> + [ C(ITLB) ] = {
> +	[ C(OP_READ) ] = {
> +		[ C(RESULT_ACCESS) ] = 0x0080, /* Instruction fecthes        */
> +		[ C(RESULT_MISS)   ] = 0x0085, /* Instr. fetch ITLB misses   */
> +	},
> +	[ C(OP_WRITE) ] = {
> +		[ C(RESULT_ACCESS) ] = -1,
> +		[ C(RESULT_MISS)   ] = -1,
> +	},
> +	[ C(OP_PREFETCH) ] = {
> +		[ C(RESULT_ACCESS) ] = -1,
> +		[ C(RESULT_MISS)   ] = -1,
> +	},

0x84               L1 ITLB Miss, L2 ITLB Hit
0x85 Unit 0x1 (4k) L1 ITLB Miss, L2 Miss

> + },
> + [ C(BPU ) ] = {
> +	[ C(OP_READ) ] = {
> +		[ C(RESULT_ACCESS) ] = 0x00c2, /* Retired Branch Instr.      */
> +		[ C(RESULT_MISS)   ] = 0x00c3, /* Retired Mispredicted BI    */

There's also Retired Taken in C4 and C5

> +	},
> +	[ C(OP_WRITE) ] = {
> +		[ C(RESULT_ACCESS) ] = -1,
> +		[ C(RESULT_MISS)   ] = -1,
> +	},
> +	[ C(OP_PREFETCH) ] = {
> +		[ C(RESULT_ACCESS) ] = -1,
> +		[ C(RESULT_MISS)   ] = -1,
> +	},
> + },
> +};

