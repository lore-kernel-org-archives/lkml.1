Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbYLJHM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbYLJHM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 02:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYLJHMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 02:12:47 -0500
Received: from viefep11-int.chello.at ([62.179.121.31]:54718 "EHLO
	viefep11-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607AbYLJHMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 02:12:47 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [PATCH] percpu_counter: Fix __percpu_counter_sum()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>, Mingming Cao <cmm@us.ibm.com>,
       linux-ext4@vger.kernel.org
In-Reply-To: <493F4EF4.4080205@cosmosbay.com>
References: <4936D287.6090206@cosmosbay.com>
	 <4936EB04.8000609@cosmosbay.com>
	 <20081206202233.3b74febc.akpm@linux-foundation.org>
	 <493BCF60.1080409@cosmosbay.com>
	 <20081207092854.f6bcbfae.akpm@linux-foundation.org>
	 <493C0F40.7040304@cosmosbay.com>
	 <20081207205250.dbb7fe4b.akpm@linux-foundation.org>
	 <20081208221241.GA2501@mit.edu>
	 <1228774836.16244.22.camel@lappy.programming.kicks-ass.net>
	 <20081208230047.GC2501@mit.edu> <1228777500.12729.4.camel@twins>
	 <493E2884.6010600@cosmosbay.com> <1228811653.6809.26.camel@twins>
	 <493F4EF4.4080205@cosmosbay.com>
Content-Type: text/plain
Date: Wed, 10 Dec 2008 08:12:42 +0100
Message-Id: <1228893162.6978.25.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-10 at 06:09 +0100, Eric Dumazet wrote:
> Now percpu_counter_sum() is 'fixed', what about "percpu_counter_add()" ?
> 
> void __percpu_counter_add(struct percpu_counter *fbc, s64 amount, s32 batch)
> {
>         s64 count;
>         s32 *pcount;
>         int cpu = get_cpu();
> 
>         pcount = per_cpu_ptr(fbc->counters, cpu);
>         count = *pcount + amount;
>         if (count >= batch || count <= -batch) {
>                 spin_lock(&fbc->lock);
>                 fbc->count += count;
>                 *pcount = 0;
>                 spin_unlock(&fbc->lock);
>         } else {
>                 *pcount = count;
>         }
>         put_cpu();
> }
> 
> 
> If I read this well, this is not IRQ safe.
> 
> get_cpu() only disables preemption IMHO
> 
> For nr_files, nr_dentry, nr_inodes, it should not be a problem.
> 
> But for network counters (only in net-next-2.6) 
> and lib/proportions.c, we have a problem ?

Non of percpu_counter if irqsafe, for lib/proportions I disabled irqs by
hand when needed - I don't think we ought to bother with local_t, esp as
it basically sucks chunks on anything !x86.


