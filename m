Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYKUJTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYKUJTe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 04:19:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbYKUJTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 04:19:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43129 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751405AbYKUJTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 04:19:17 -0500
Date: Fri, 21 Nov 2008 10:18:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bug #11308] tbench regression on each kernel release from
	2.6.22 -&gt; 2.6.28
Message-ID: <20081121091851.GA26396@elte.hu>
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera> <20081117090648.GG28786@elte.hu> <Pine.LNX.4.64.0811191341570.23502@quilx.com> <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49267694.1030506@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.3
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Eric Dumazet <dada1@cosmosbay.com> wrote:

> Ingo Molnar a écrit :
>> * Christoph Lameter <cl@linux-foundation.org> wrote:
>>
>>> hmmm... Well we are almost there.
>>>
>>> 2.6.22:
>>>
>>> Throughput 2526.15 MB/sec 8 procs
>>>
>>> 2.6.28-rc5:
>>>
>>> Throughput 2486.2 MB/sec 8 procs
>>>
>>> 8p Dell 1950 and the number of processors specified on the tbench  
>>> command line.
>>
>> And with net-next we might even be able to get past that magic limit?  
>> net-next is linus-latest plus the latest and greatest networking bits:
>>
>>  $ cat .git/config
>>
>>  [remote "net-next"]
>> 	url = git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
>> 	fetch = +refs/heads/*:refs/remotes/net-next/*
>>
>> ... so might be worth a test. Just to satisfy our curiosity and to 
>> possibly close the entry :-)
>>
>
> Well, bits in net-next are new stuff for 2.6.29, not really 
> regression fixes, but yes, they should give nice tbench speedups.

yeah, i know - technically these are lots-of-kernel-releases effects 
so not bona fide latest-cycle regressions anyway. But it doesnt matter 
how we call them, we want improvement in these metrics.

> Now, I wish sockets and pipes not going through dcache, not tbench 
> affair of course but real workloads...
>
> running 8 processes on a 8 way machine doing a 
>
> for (;;)
> 	close(socket(AF_INET, SOCK_STREAM, 0));
>
> is slow as hell, we hit so many contended cache lines ...
>
> ticket spin locks are slower in this case (dcache_lock for example 
> is taken twice when we allocate a socket(), once in d_alloc(), 
> another one in d_instantiate())

hm, weird - since there's no real VFS namespace impact i fail to 
realize the fundamental need that causes us to hit the dcache_lock. 
(perhaps there's none and this is fixable)

The general concept of mapping sockets to fds is a fundamental and 
powerful abstraction. There are APIs that also connect them to the VFS 
namespace (such as unix domain sockets) - but those should be special 
cases, not impacting normal TCP sockets.

	Ingo
