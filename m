Return-Path: <linux-kernel-owner+w=401wt.eu-S1754624AbYKQSYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbYKQSYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 13:24:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYKQSYI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 13:24:08 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47591 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbYKQSYC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 13:24:02 -0500
Date: Mon, 17 Nov 2008 19:23:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, cl@linux-foundation.org, efault@gmx.de,
       a.p.zijlstra@chello.nl, Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081117182320.GA26844@elte.hu>
References: <20081117090648.GG28786@elte.hu> <20081117.011403.06989342.davem@davemloft.net> <20081117110119.GL28786@elte.hu> <4921539B.2000002@cosmosbay.com> <20081117161135.GE12081@elte.hu> <49219D36.5020801@cosmosbay.com> <20081117170844.GJ12081@elte.hu> <20081117172549.GA27974@elte.hu> <4921AAD6.3010603@cosmosbay.com> <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.2.00.0811170937540.3468@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.1 required=5.9 tests=DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	0.1 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, 17 Nov 2008, Eric Dumazet wrote:
> 
> > Ingo Molnar a écrit :
> 
> > > it gives a small speedup of ~1% on my box:
> > > 
> > >    before:      Throughput 3437.65 MB/sec 64 procs
> > >    after:       Throughput 3473.99 MB/sec 64 procs
> > 
> > Strange, I get 2350 MB/sec on my 8 cpus box. "tbench 8"
> 
> I think Ingo may have a Nehalem. Let's just say that those things 
> rock, and have rather good memory throughput.

hm, i'm not sure whether i can post benchmarks from the Nehalem box - 
but i can confirm it in general terms that it's rather nice ;-)

This was run on another testbox (4x4 Barcelona) that rocks similarly 
well in terms of memory subsystem latencies: which seems to be 
tbench's main current critical path.

For the tbench bragging rights i'd probably turn off CONFIG_SECURITY 
and a few other options. Plus i'd run with 16 threads only - in this 
test i ran with 4x overload (64 tbench threads, not 16) to stress the 
scheduler harder.

Although we degrade very gently with overload so the numbers arent all 
that much different:

   16 threads: Throughput 3463.14 MB/sec 16 procs
   64 threads: Throughput 3473.99 MB/sec 64 procs
  256 threads: Throughput 3457.67 MB/sec 256 procs
 1024 threads: Throughput 3448.85 MB/sec 1024 procs

 [ so it's the same within noise range. ]

1024 threads is already a massive 64x overload so beyond any 
reasonable limit of workload sanity.

Which suggests that the main limitation factor is cacheline ping-pong 
that is already in full effect at 16 threads.

Which is supported by the "most expensive instructions" top-10 sorted 
list:

            RIP     #hits
..........................                           

                           [ usercopy ]
ffffffff80350fcd:  1373300 	f3 48 a5             	rep movsq %ds:(%rsi),%es:(%rdi)

ffffffff804a2f33:          <sock_rfree>:
ffffffff804a2f34:   985253 	48 89 e5             	mov    %rsp,%rbp


ffffffff804d2eb7:          <ip_local_deliver>:
ffffffff804d2eb8:   432659 	48 89 e5             	mov    %rsp,%rbp

ffffffff804aa23c:          <constant_test_bit>: [ => napi_disable_pending() ]
ffffffff804aa24c:   374052 	89 d1                	mov    %edx,%ecx

ffffffff804d5076:          <ip_dont_fragment>:
ffffffff804d5076:   310051 	8a 97 56 02 00 00    	mov    0x256(%rdi),%dl

ffffffff804d9b17:          <__inet_lookup_established>:
ffffffff804d9bdf:   247224 	eb ba                	jmp    ffffffff804d9b9b <__inet_lookup_established+0x84>

ffffffff80321529:          <selinux_ip_postroute>:
ffffffff8032152a:   183700 	48 89 e5             	mov    %rsp,%rbp

ffffffff8020c020:          <system_call>:
ffffffff8020c020:   183600 	0f 01 f8             	swapgs 

ffffffff8051884a:          <netlbl_enabled>:
ffffffff8051884a:   179538 	55                   	push   %rbp

The usual profiling caveat applies: it's not _these_ instructions that 
matter, but the surrounding code that calls them. Profiling overhead 
is delayed by a couple of instructions - the more out-of-order a CPU 
is, the larger this delay can be. But even a quick look to the list 
above shows that all of the heavy cachemisses are generated by 
networking.

Beyond the usual suspects of syscall entry and memcpy, it's only 
networking. We dont even have the mov %cr3 TLB flush overhead in this 
list, load_cr3() is a distant #30:

ffffffff8023049f:        0      0f 22 d8                mov    %rax,%cr3
ffffffff802304a2:   126303      c9                      leaveq

The place for the sock_rfree() hit looks a bit weird, and i'll 
investigate it now a bit more to place the real overhead point 
properly. (i already mapped the test-bit overhead: that comes from 
napi_disable_pending())
 
The first entry is 10x the cost of the last entry in the list so 
clearly we've got 1-2 brutal cacheline ping-pongs that dominate the 
overhead of this workload.

	Ingo
