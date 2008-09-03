Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbYICKR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbYICKR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752091AbYICKRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:17:51 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:25280 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752076AbYICKRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:17:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=RQfCNfjr7IydOJ8uLxZyCiBfgolhn28YBsvGEjM8KHENZlBSQuPk+UTchZjGFo7wnNZmwvq58s3C60HXksjVIBEjUpddqfPBY+1EGOBLgSA5NtM1BQ738hW1VoWpChC0V3d3OHdSg0Lq8fxA6vAZr4ztVQhzhrKVA9WfKFEO4aM=  ;
X-YMail-OSG: 9s222PkVM1mZxJzJ6L7F9GLz.00Um4hfQbMI.KAfl.ugkVrT6g_jiHIt7DNhtex.NzdqeZVE7Mqs6DMvbqDq4d2iButiiBP05APHpS3bYJHyRkJGICpPS6GkmrK9xe3MBuk-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the system has paniced
Date: Wed, 3 Sep 2008 20:17:42 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20080902349.573187695@firstfloor.org> <200809031937.46328.nickpiggin@yahoo.com.au> <20080903094815.GQ18288@one.firstfloor.org>
In-Reply-To: <20080903094815.GQ18288@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809032017.42237.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 19:48, Andi Kleen wrote:
> > Hmm... that does pull in significantly more code yes...
> >
> > It should be fixed. I guess a quickfix is to add a new call in
> > kernel/smp.c for use by panic code.
>
> Or just a new vector.  I'll take a look later.

That would work.


> > > an IPI?
> >
> > Oh. I thought the actual function call structure itself should be the
> > nice cleanup part that everyone would like...
>
> I fail to see how much more complex code is a cleanup to be honest.

I was referring to the call structure. You complained about 4 levels of
functions, but that's just to allow most of the code to be moved into
architecture independent kernel which is a cleanup I think.

The rest of the changes obviously are more complex and are not cleanups.


> > > And are there really benchmarks that show the
> > > queueing does actually improve something significantly?
> >
> > For the call_function_mask case, I did see a benefit of queueing when
> > testing vmap scalability on a bigish system, yes. I had since done
>
> Does that improve anything real-world?

Yes. XFS directory workloads when it's using name block size > PAGE_SIZE.


> > For call_function_single, queueing could really help with high interrupt
> > loads like the block completion migration that Jens has been looking at.
>
> But does it or not?

Well yes. It was basically impossible to implement without this IIRC,
due to performance problems. And that code itself also showed some
improvements in cases. I think it may need more tuning and testing.


> > In that case, queueing will act like interrupt mitigation when the target
> > CPU becomes saturated so it will help keep performance from degrading,
> > and it also allows multiple source CPUs to target a single destination
> > without losing too much scalability.
> >
> > Also there was some straight-line benefit of queueing due to the source
> > CPU not having to wait for an ack from the destination before continuing.
> > Basically that would previously put a hard upper limit of remote function
> > call to the interrupt latency.
> >
> > Benchmarks for "real" things unfortunately not easy to come by yet,
> > simply because it was so crap before that it was unusable for anything
> > remotely performance oriented. After the rewrite, I hope to see some
>
> At least the "industry standard benchmark" Intel spends a lot of time
> one used IPIs and iirc didn't run into too big issues. It was far
> less a problem than the endless sl[au]b regressions at least.

IPIs for smp_call_function? Generated at any significant rate? I guarantee
not, otherwise there would have been problems :)


> > It was certianly tried. It's not a simple problem to do this with any
> > reasonable scalability, however.
>
> Well just not having a big lock is a big step forward. But that
> doesn't need that much code, it's ~10-20 lines of new code
> as you can see in the scalable tlb flush.

As I said, if you don't queue, you put a pretty hard, pretty low upper
limit on the rate at which you can queue calls on the target, and that
limit slows down as your system gets larger which is pretty nasty.


> The queueing seems to add all the complexity and so far I haven't
> seen much evidence that the queueing actually helps enough
> to pay for its costs in complexity and maintenance overhead
> (and bugginess as the panic case and the earlier crash issue shows)

If Jens is ever running benchmarks on the request migration completion
patches (I think it still uses call_function_single), then maybe he could
disable queueing and report what happens.


> > > > It is reasonable I think, but I don't like testing symbolic constants
> > > > with inequalities like in your patch 2/2. Can you just make it
> > > > system_state != SYSTEM_PANIC ?
> > >
> > > Well I like it.
> >
> > How is it better than system_state != SYSTEM_PANIC? It breaks if
> > SYSTEM_PANIC gets something in front of it, and even when it is
>
> No it will not break in that case.

It breaks because it stops warning for the states above panic,
doesn't it?


> > correct it makes you double check the definition of SYSTEM_PANIC
> > to see what it does (is there any state above SYSTEM_PANIC?)
>
> The system states are already ordered and it would make
> a lot of sense to keep it that way.

OK, out of curiosity, please tell me what is the downside of != ?


> Anyways the code will go anyways I guess because we have
> established that it's not enough to fix panic.

Sure. 
