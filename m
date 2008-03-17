Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbYCQMxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbYCQMxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753441AbYCQMxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:53:41 -0400
Received: from n2.bullet.mail.ac4.yahoo.com ([76.13.13.30]:24985 "HELO
	n2.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752854AbYCQMxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:53:40 -0400
X-Yahoo-Newman-Id: 248936.21957.bm@omp402.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=Ic+lxCjjm7ISiwZRaTpRXVpje3IQP4ot9wB/8e129YNZRZDptCR2TBkZJNSnDm5aac4YSijVK2kBSKKZGbLrRivgQrld5UBh5zVH2AZ2aZk1JDDIhmqoB/127ViqDFy3MVku0uG7cwFItZuCevUZUvoozsTNB2HMFaYlmwPZvmI=  ;
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dmitry Antipov <dmantipov@yandex.ru>
Subject: Re: Are Linux pipes slower than the FreeBSD ones ?
Date: Mon, 17 Mar 2008 23:53:23 +1100
User-Agent: KMail/1.9.5
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
References: <1389671204703217@webmail34.yandex.ru> <200803060120.38032.nickpiggin@yahoo.com.au> <47CFDF55.6030103@yandex.ru>
In-Reply-To: <47CFDF55.6030103@yandex.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803172353.23965.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 23:11, Dmitry Antipov wrote:
> Nick Piggin wrote:
> > One thing to try is pinning both processes on the same CPU. This
> > may be what the FreeBSD scheduler is preferring to do, and it ends
> > up being really a tradeoff that helps some workloads and hurts
> > others. With a very unscientific test with an old kernel, the
> > pipe.c test gets anywhere from about 1.5 to 3 times faster when
> > running it as taskset 1 ./pipe
>
> Sounds interesting. What kernel version did you tried? Can you
> send your .config to me?
>
> I've tried this trick on 2.6.25-rc4, and got ~20% more throughput for
> large (> 8K) buffers at the cost of going ~30% down for the small ones.

Seems some people are still concerned about this benchmark. OK I
tried with Linux 2.6.25-rc6 (just because it's what I've got on
this system). Versus FreeBSD 7.0.

Unfortunately, I don't think FreeBSD supports binding a process to a
CPU, and on either system when the scheduler is allowed to choose
what happens, results are more variable than you would like.

That being said, I found that Linux often outscored FreeBSD in all 3
tests of pipe_v3. FreeBSD does appear like it can get a slightly higher
throughput at 64K in test #1, so maybe it's data copy routines are
slightly better. OTOH, I found Linux is better at 64K in test #2. For
the low sizes, I found Linux was usually faster than FreeBSD in tests
1 and 2, and around the same on test 3.

The other thing is that this test is pretty well a random context
switch benchmark that really depends on slight variations in how the
scheduler scheduler runs things. If you happen to be able to keep the
pipe from filling or emptying completely, you can run both processes
at the same time on different CPUs. If you run both processes on the
same CPU, then you want to avoid preempting the producer until it
fills the pipe, then you want to avoid preempting the consumer until
it empties the pipe in order to minimise context switches.

For example, if I call a nice(20) in the start of the reader processes
in tests #1 and #2, I get around a 5x speedup in Linux when running
reader and writer on the same CPU.

I won't bother posting actual numbers... if anybody is interested I
can mail raw results offline.

But again, it isn't such a great test because a higher number doesn't
really mean you'll do better with any real program, and optimising for
a higher number here could actually harm real programs.

pipe test v3 also is doing funny things with "simulating" real
accesses. It should generally write into the buffer before
write(2)ing it, and read from the buffer after read(2)ing it. Instead
it writes to the buffer after write(2) and after read(2). Also, it
should probably touch a significant number of the pages and
cachelines transferred in each case, rather than the 1/2 stores it
does right now. There are a lot of ways you can copy data around, so
even if you defeat page flipping (for small transfers), then you
still don't know if one method of copying data around is better than
another.

Basically I will just reiterate what I said before that it is really
difficult to draw any conclusions from a test like this, and from the
numbers I see, you certainly can't say FreeBSD is faster than Linux.

If you want to run this kind of microbenchmark, something like lmbench
at least has been around for a long time and been reviewed (whether or
not it is any more meaningful, I don't know). Or do you have a real
workload that this pipe test simulates?

Thanks,
Nick

