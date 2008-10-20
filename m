Return-Path: <linux-kernel-owner+w=401wt.eu-S1755058AbYJTXIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058AbYJTXIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYJTXIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:08:13 -0400
Received: from mail.lang.hm ([64.81.33.126]:54700 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331AbYJTXIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:08:12 -0400
Date: Mon, 20 Oct 2008 16:08:39 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Arnaldo Carvalho de Melo <acme@redhat.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: sched_yield() options
In-Reply-To: <20081020225318.GA10352@ghostprotocols.net>
Message-ID: <alpine.DEB.1.10.0810201603510.21749@asgard.lang.hm>
References: <alpine.DEB.1.10.0810201531010.21749@asgard.lang.hm> <20081020225318.GA10352@ghostprotocols.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Oct 2008, Arnaldo Carvalho de Melo wrote:

> Em Mon, Oct 20, 2008 at 03:34:07PM -0700, david@lang.hm escreveu:
>> I've seen a lot of discussion about how sched_yield is abused by
>> applications. I'm working with a developer on one application that looks
>> like it's falling into this same trap (mutexes between threads and using
>> sched_yield (or more precisely pthread_yield()) to let other threads get
>> the lock)
>>
>> however I've been having a hard time tracking down the appropriate
>> discussions to forward on to the developer (both for why what he's doing
>> is bad, and for what he should be doing instead)
>>
>> could someone point out appropriate mailing list threads, or other
>> documentation for this?
>
> http://kerneltrap.org/Linux/Using_sched_yield_Improperly

that helps, but the case that seems closest to what I'm looking at is

> > > One example I know of is a defragmenter for a multi-threaded memory 
> > > allocator, and it has to lock whole pools. When it releases these 
> > > locks, it calls yield before re-acquiring them to go back to work. 
> > > The idea is to "go to the back of the line" if any threads are 
> > > blocking on those mutexes.

> > at a quick glance this seems broken too - but if you show the specific 
> > code i might be able to point out the breakage in detail. (One 
> > underlying problem here appears to be fairness: a quick unlock/lock 
> > sequence may starve out other threads. yield wont solve that 
> > fundamental problem either, and it will introduce random latencies 
> > into apps using this memory allocator.)

> You are assuming that random latencies are necessarily bad. Random 
> latencies may be significantly better than predictable high latency.

in the case I'm looking at there are two (or more) threads running with 
one message queue in the center.

'input threads' are grabbing the lock to add messages to the queue

'output threads' are grabbing the lock to remove messages from the queue

the programmer is doing a pthread_yield() after each message is processed 
in an attempt to help fairness (he initially added it in when he started 
seeing starvation on single-core systems)

what should he be doing instead?

the link above talks about other cases more, but really doesn't say what 
the right thing to do is for this case.

David Lang
