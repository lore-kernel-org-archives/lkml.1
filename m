Return-Path: <linux-kernel-owner+w=401wt.eu-S932259AbZFOTzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbZFOTzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 15:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZFOTzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 15:55:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56956 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZFOTzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 15:55:41 -0400
Date: Mon, 15 Jun 2009 21:55:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615195514.GA18436@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <20090615194344.GA12554@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615194344.GA12554@elte.hu>
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


btw., here's the cost analysis of cr2 reading and writing (in a 
tight loop). I've executed cr2 read+write instructions 1 billion 
times on a Nehalem box:

static long cr2_test(void)
{
	unsigned long tmp = 0;
	int i;

	for (i = 0; i < 1000000000; i++)
		asm("movq %0, %%cr2; movq %%cr2, %0" : : "r" (tmp));

	return 0;
}

Which gave these overall stats:

 Performance counter stats for './prctl 0 0':

   28414.696319  task-clock-msecs     #      0.997 CPUs 
              3  context-switches     #      0.000 M/sec
              1  CPU-migrations       #      0.000 M/sec
            149  page-faults          #      0.000 M/sec
    87254432334  cycles               #   3070.750 M/sec
     5078691161  instructions         #      0.058 IPC  
         304144  cache-references     #      0.011 M/sec
          28760  cache-misses         #      0.001 M/sec

   28.501962853  seconds time elapsed.

87254432334/1000000000 ~== 87, so we have 87 cycles cost per 
iteration.

The annotated output shows:

 aldebaran:~> perf annotate sys_prctl | grep -A 2 cr2

    0.42 :	ffffffff81053131:	0f 22 d1             	mov    %rcx,%cr2
   96.56 :	ffffffff81053134:	0f 20 d1             	mov    %cr2,%rcx
    3.02 :	ffffffff81053137:	ff c0                	inc    %eax
    0.00 :	ffffffff81053139:	39 d0                	cmp    %edx,%eax

the read/write cost ratio is 3%:96.5% (with skidding taken into 
account), that suggests that the reading cost of cr2 is about 2-3 
cycles, the writing cost is about 85 cycles.

Which makes sense - reading cr2 is in the pagefault critical path, 
so that's optimized. Writing it is allowed but not optimized at all. 
(especially in such a tight loop where it could easily have some 
back-to-back additional latency that would not be there in an NMI 
handler save/restore path which has other instructions inbetween.)

	Ingo
