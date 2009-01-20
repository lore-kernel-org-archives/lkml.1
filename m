Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbZATHzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbZATHzQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 02:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbZATHzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 02:55:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50799 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbZATHzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 02:55:00 -0500
Date: Tue, 20 Jan 2009 08:54:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Nick Piggin <npiggin@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Mike Travis <travis@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] kernel BUG at arch/x86/kernel/tlb_32.c:130!
Message-ID: <20090120075440.GA29426@elte.hu>
References: <49756F44.6040801@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49756F44.6040801@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0011]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> I was using mmotm 2009-01-16-16-18, and I ran into this BUG,
> the line is:
> 	BUG_ON(cpumask_empty(cpumask));
> 
> I suspect it is caused by:
> 
> commit 4595f9620cda8a1e973588e743cf5f8436dd20c6
> Author: Rusty Russell <rusty@rustcorp.com.au>
> Date:   Sat Jan 10 21:58:09 2009 -0800
> 
>     x86: change flush_tlb_others to take a const struct cpumask
> 
>     Impact: reduce stack usage, use new cpumask API.

Jaswinder reported a similar crash.

Mike, Rusty, what's going on with this commit? Why does this code:

+       if (cpumask_any_but(&mm->cpu_vm_mask, smp_processor_id()) < nr_cpu_ids)
+               flush_tlb_others(&mm->cpu_vm_mask, mm, TLB_FLUSH_ALL);

Assume that mm->cpu_vm_mask wont change? TLB flushes go async and the MM's 
schedulability is not locked during that. I.e. mm->cpu_vm_mask can change 
under you while the TLB flush IPIs are flying around - while when the 
cpumask was passed on-stack this wouldnt happen.

	Ingo
