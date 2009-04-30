Return-Path: <linux-kernel-owner+w=401wt.eu-S1756817AbZD3GWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbZD3GWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbZD3GWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:22:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54862 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZD3GWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:22:33 -0400
Date: Thu, 30 Apr 2009 08:21:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430062140.GA9559@elte.hu>
References: <20090429232546.GB15782@Krystal> <alpine.LFD.2.00.0904291701450.22156@localhost.localdomain> <20090430024303.GB19875@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090430024303.GB19875@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> And thanks for the review! This excercise only convinced me that 
> the kernel memory accounting works as expected. All this gave me 
> the chance to have a good look at the memory accounting code. We 
> could probably benefit of Christoph Lameter's cpu ops (using 
> segment registers to address per-cpu variables with atomic 
> inc/dec) in there. Or at least removing interrupt disabling by 
> using preempt disable and local_t variables for the per-cpu 
> counters could bring some benefit.

Note, optimized per cpu ops are already implemented upstream, by 
Tejun Heo's percpu patches in .30:

 #define percpu_read(var)	percpu_from_op("mov", per_cpu__##var)
 #define percpu_write(var, val)	percpu_to_op("mov", per_cpu__##var, val)
 #define percpu_add(var, val)	percpu_to_op("add", per_cpu__##var, val)
 #define percpu_sub(var, val)	percpu_to_op("sub", per_cpu__##var, val)
 #define percpu_and(var, val)	percpu_to_op("and", per_cpu__##var, val)
 #define percpu_or(var, val)	percpu_to_op("or", per_cpu__##var, val)
 #define percpu_xor(var, val)	percpu_to_op("xor", per_cpu__##var, val)

See:

  6dbde35: percpu: add optimized generic percpu accessors

>From the changelog:

    [...]
    The advantage is that for example to read a local percpu variable,
    instead of this sequence:
    
     return __get_cpu_var(var);
    
     ffffffff8102ca2b:  48 8b 14 fd 80 09 74    mov    -0x7e8bf680(,%rdi,8),%rdx
     ffffffff8102ca32:  81
     ffffffff8102ca33:  48 c7 c0 d8 59 00 00    mov    $0x59d8,%rax
     ffffffff8102ca3a:  48 8b 04 10             mov    (%rax,%rdx,1),%rax
    
    We can get a single instruction by using the optimized variants:
    
     return percpu_read(var);
    
     ffffffff8102ca3f:  65 48 8b 05 91 8f fd    mov    %gs:0x7efd8f91(%rip),%rax
    [...]

So if you want to make use of it, percpu_add()/percpu_sub() would be 
the place to start.

	Ingo
