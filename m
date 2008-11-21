Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbYKUIx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbYKUIx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 03:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYKUIwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 03:52:40 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:55217 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbYKUIwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 03:52:38 -0500
Message-ID: <49267694.1030506@cosmosbay.com>
Date: Fri, 21 Nov 2008 09:51:32 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Christoph Lameter <cl@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [Bug #11308] tbench regression on each kernel release from	2.6.22
 -&gt; 2.6.28
References: <1ScKicKnTUE.A.VxH.DIHIJB@chimera> <NjF0-fuClJC.A.73B.cLHIJB@chimera> <20081117090648.GG28786@elte.hu> <Pine.LNX.4.64.0811191341570.23502@quilx.com> <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu>
In-Reply-To: <20081121083044.GL16242@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 21 Nov 2008 09:51:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar a écrit :
> * Christoph Lameter <cl@linux-foundation.org> wrote:
> 
>> hmmm... Well we are almost there.
>>
>> 2.6.22:
>>
>> Throughput 2526.15 MB/sec 8 procs
>>
>> 2.6.28-rc5:
>>
>> Throughput 2486.2 MB/sec 8 procs
>>
>> 8p Dell 1950 and the number of processors specified on the tbench 
>> command line.
> 
> And with net-next we might even be able to get past that magic limit? 
> net-next is linus-latest plus the latest and greatest networking bits:
> 
>  $ cat .git/config
> 
>  [remote "net-next"]
> 	url = git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next-2.6.git
> 	fetch = +refs/heads/*:refs/remotes/net-next/*
> 
> ... so might be worth a test. Just to satisfy our curiosity and to 
> possibly close the entry :-)
> 

Well, bits in net-next are new stuff for 2.6.29, not really regression fixes,
but yes, they should give nice tbench speedups.


Now, I wish sockets and pipes not going through dcache, not tbench affair
of course but real workloads...

running 8 processes on a 8 way machine doing a 

for (;;)
	close(socket(AF_INET, SOCK_STREAM, 0));

is slow as hell, we hit so many contended cache lines ...

ticket spin locks are slower in this case (dcache_lock for example
is taken twice when we allocate a socket(), once in d_alloc(), another one
in d_instantiate())


