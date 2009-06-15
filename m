Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbZFOU0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbZFOU0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757027AbZFOU0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:26:39 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57355 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755642AbZFOU0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:26:38 -0400
Date: Mon, 15 Jun 2009 22:25:56 +0200
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
Message-ID: <20090615202556.GA20574@elte.hu>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <alpine.LFD.2.01.0906151125320.6276@localhost.localdomain> <20090615183649.GA16999@elte.hu> <alpine.LFD.2.01.0906151152170.6276@localhost.localdomain> <20090615194344.GA12554@elte.hu> <20090615195514.GA18436@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615195514.GA18436@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> Which gave these overall stats:
> 
>  Performance counter stats for './prctl 0 0':
> 
>    28414.696319  task-clock-msecs     #      0.997 CPUs 
>               3  context-switches     #      0.000 M/sec
>               1  CPU-migrations       #      0.000 M/sec
>             149  page-faults          #      0.000 M/sec
>     87254432334  cycles               #   3070.750 M/sec
>      5078691161  instructions         #      0.058 IPC  
>          304144  cache-references     #      0.011 M/sec
>           28760  cache-misses         #      0.001 M/sec
> 
>    28.501962853  seconds time elapsed.
> 
> 87254432334/1000000000 ~== 87, so we have 87 cycles cost per 
> iteration.

I also measured the GUP based copy_from_user_nmi(), on 64-bit (so 
there's not even any real atomic-kmap/invlpg overhead):

 Performance counter stats for './prctl 0 0':

   55580.513882  task-clock-msecs     #      0.997 CPUs 
              3  context-switches     #      0.000 M/sec
              1  CPU-migrations       #      0.000 M/sec
            149  page-faults          #      0.000 M/sec
   176375680192  cycles               #   3173.337 M/sec
   299353138289  instructions         #      1.697 IPC  
        3388060  cache-references     #      0.061 M/sec
        1318977  cache-misses         #      0.024 M/sec

   55.748468367  seconds time elapsed.

This shows the overhead of looking up pagetables - 176 cycles per 
iteration. A cr2 save/restore pair is twice as fast.

Here's the profile btw:

 aldebaran:~> perf report -s s

#
# (1813480 samples)
#
# Overhead  Symbol
# ........  ......
#
    23.99%  [k] __get_user_pages_fast
    19.89%  [k] gup_pte_range
    18.98%  [k] gup_pud_range
    16.95%  [k] copy_from_user_nmi
    16.04%  [k] put_page
     3.17%  [k] sys_prctl
     0.02%  [k] _spin_lock
     0.02%  [k] copy_user_generic_string
     0.02%  [k] get_page_from_freelist

taking a look at 'perf annotate __get_user_pages_fast' suggests 
these two hot-spots:

    0.04 :      ffffffff810310cc:       9c                      pushfq 
    9.24 :      ffffffff810310cd:       41 5d                   pop    %r13
    1.43 :      ffffffff810310cf:       fa                      cli    
    3.44 :      ffffffff810310d0:       48 89 fb                mov    %rdi,%rbx
    0.00 :      ffffffff810310d3:       4d 8d 7e ff             lea    -0x1(%r14),%r15
    0.00 :      ffffffff810310d7:       48 c1 eb 24             shr    $0x24,%rbx
    0.00 :      ffffffff810310db:       81 e3 f8 0f 00 00       and    $0xff8,%ebx

15% of its overhead is here, 50% is here:

    0.71 :      ffffffff81031141:       41 55                   push   %r13
    0.05 :      ffffffff81031143:       9d                      popfq  
   30.07 :      ffffffff81031144:       8b 55 d4                mov    -0x2c(%rbp),%edx
    2.78 :      ffffffff81031147:       48 83 c4 20             add    $0x20,%rsp
    0.00 :      ffffffff8103114b:       89 d0                   mov    %edx,%eax
   10.93 :      ffffffff8103114d:       5b                      pop    %rbx
    0.02 :      ffffffff8103114e:       41 5c                   pop    %r12
    1.28 :      ffffffff81031150:       41 5d                   pop    %r13
    0.51 :      ffffffff81031152:       41 5e                   pop    %r14

So either pushfq+cli...popfq sequences are a lot more expensive on 
Nehalem as i imagined, or instruction skidding is tricking us here.

gup_pte_range has a clear hotspot with a locked instruction:

    2.46 :      ffffffff81030d88:       48 8d 41 08             lea    0x8(%rcx),%rax
    0.00 :      ffffffff81030d8c:       f0 ff 41 08             lock incl 0x8(%rcx)
   53.52 :      ffffffff81030d90:       49 63 01                movslq (%r9),%rax
    0.00 :      ffffffff81030d93:       48 81 c6 00 10 00 00    add    $0x1000,%rsi

11% of the total overhead - or about 19 cycles.

So it seems cr2+direct-access is distinctly faster than fast-gup. 

And fast-gup overhead is _per frame entry_ - which makes 
cr2+direct-access (which is per NMI) _far_ more performant - a dozen 
or more call-chain entries are the norm.

	Ingo
