Return-Path: <linux-kernel-owner+w=401wt.eu-S932152AbZALWvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152AbZALWvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 17:51:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758986AbZALWef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 17:34:35 -0500
Received: from byss.tchmachines.com ([208.76.80.75]:43873 "EHLO
	byss.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760258AbZALWed (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 17:34:33 -0500
Date: Mon, 12 Jan 2009 14:34:21 -0800
From: Ravikiran G Thirumalai <kiran@scalex86.org>
To: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
Cc: mingo@elte.hu, andi@firstfloor.org, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] tlb flush_data: replace per_cpu with an array
Message-ID: <20090112223421.GA20594@localdomain>
References: <20090112213539.GA10720@gambetta>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112213539.GA10720@gambetta>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - byss.tchmachines.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - scalex86.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederik,

On Mon, Jan 12, 2009 at 10:35:42PM +0100, Frederik Deweerdt wrote:
>
>Signed-off-by: Frederik Deweerdt <frederik.deweerdt@xprog.eu>
>
>diff --git a/arch/x86/kernel/tlb_64.c b/arch/x86/kernel/tlb_64.c
>index f8be6f1..c177a1f 100644
>--- a/arch/x86/kernel/tlb_64.c
>+++ b/arch/x86/kernel/tlb_64.c
>@@ -33,7 +33,7 @@
>  *	To avoid global state use 8 different call vectors.
>  *	Each CPU uses a specific vector to trigger flushes on other
>  *	CPUs. Depending on the received vector the target CPUs look into
>- *	the right per cpu variable for the flush data.
>+ *	the right array slot for the flush data.
>  *
>  *	With more than 8 CPUs they are hashed to the 8 available
>  *	vectors. The limited global vector space forces us to this right now.
>@@ -54,7 +54,7 @@ union smp_flush_state {
> /* State is put into the per CPU data section, but padded
>    to a full cache line because other CPUs can access it and we don't
>    want false sharing in the per cpu data segment. */
>-static DEFINE_PER_CPU(union smp_flush_state, flush_state);
>+static union smp_flush_state flush_state[NUM_INVALIDATE_TLB_VECTORS];

Since flush_state has a spinlock, an array of flush_states would end up
having multiples spinlocks on the same L1 cacheline.  However, I see that
the union smp_flush_state is already padded to SMP_CACHE_BYTES.

With per-cpu areas,  locks belonging to different array elements did
not end up on the same internode cacheline due to per-node allocation of
per-cpu areas, but with a simple array, two locks could end up on the same
internode cacheline.

Hence, can you please change the padding in smp_flush_state to
INTERNODE_CACHE_BYTES (you have to derive this off INTERNODE_CACHE_SHIFT)
and align it using ____cacheline_internodealigned_in_smp?
