Return-Path: <linux-kernel-owner+w=401wt.eu-S1764228AbZD3QIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764228AbZD3QIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759819AbZD3QH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:07:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41060 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377AbZD3QH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:07:57 -0400
Date: Thu, 30 Apr 2009 18:06:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, thomas.pi@arcor.dea,
       Yuriy Lalym <ylalym@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ltt-dev@lists.casi.polymtl.ca, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Fix dirty page accounting in
	redirty_page_for_writepage()
Message-ID: <20090430160606.GA5913@elte.hu>
References: <20090430133859.GB8329@elte.hu> <alpine.DEB.1.10.0904300938220.22262@qirst.com> <20090430141446.GD14696@elte.hu> <alpine.DEB.1.10.0904301013110.14178@qirst.com> <20090430143819.GF14696@elte.hu> <alpine.DEB.1.10.0904301042170.4028@qirst.com> <20090430150142.GC20580@elte.hu> <alpine.DEB.1.10.0904301114440.4028@qirst.com> <20090430154255.GA3714@elte.hu> <alpine.DEB.1.10.0904301142140.4028@qirst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904301142140.4028@qirst.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Christoph Lameter <cl@linux.com> wrote:

> On Thu, 30 Apr 2009, Ingo Molnar wrote:
> 
> > nice. Do these all get called with irqs off, all the time?
> 
> In most cases yes. The VMstat patch includes an example were we 
> may not care too much about a event counter missing a beat once in 
> a while for platforms not supporting atomic per cpu ops. I know 
> this affects IA64. The cost of an atomic operations for an event 
> counter update (which would have avoided the potential of a 
> concurrent update) was not justifiable.

when you say "atomics", do you mean the classic meaning of atomics? 
Because there are no classic atomics involved. This is the 
before/after disassembly from Eric's commit 4e69489a0:

before:

c0436274:       b8 01 00 00 00          mov    $0x1,%eax
c0436279:       e8 42 40 df ff          call   c022a2c0 <add_preempt_count>
c043627e:       bb 20 4f 6a c0          mov    $0xc06a4f20,%ebx
c0436283:       e8 18 ca f0 ff          call   c0342ca0 <debug_smp_processor_id>
c0436288:       03 1c 85 60 4a 65 c0    add    -0x3f9ab5a0(,%eax,4),%ebx
c043628f:       ff 03                   incl   (%ebx)
c0436291:       b8 01 00 00 00          mov    $0x1,%eax
c0436296:       e8 75 3f df ff          call   c022a210 <sub_preempt_count>
c043629b:       89 e0                   mov    %esp,%eax
c043629d:       25 00 e0 ff ff          and    $0xffffe000,%eax
c04362a2:       f6 40 08 08             testb  $0x8,0x8(%eax)
c04362a6:       75 07                   jne    c04362af <sock_alloc+0x7f>
c04362a8:       8d 46 d8                lea    -0x28(%esi),%eax
c04362ab:       5b                      pop    %ebx
c04362ac:       5e                      pop    %esi
c04362ad:       c9                      leave
c04362ae:       c3                      ret
c04362af:       e8 cc 5d 09 00          call   c04cc080 <preempt_schedule>
c04362b4:       8d 74 26 00             lea    0x0(%esi,%eiz,1),%esi
c04362b8:       eb ee                   jmp    c04362a8 <sock_alloc+0x78>

after:

c0436275:   64 83 05 20 5f 6a c0    addl   $0x1,%fs:0xc06a5f20

There's no atomic instructions at all - the counters here are only 
accessed locally. They are local-irq-atomic, but not 
cacheline-atomic.

	Ingo
