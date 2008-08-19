Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbYHSJ50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbYHSJ50 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752708AbYHSJ5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:57:17 -0400
Received: from smtp108.mail.mud.yahoo.com ([209.191.85.218]:41276 "HELO
	smtp108.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752233AbYHSJ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:57:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=y7aGHks3MMjSXkGf5K1+g2kbGOst/c8rYWnRL4dy9lWDJG/YREABsxQjaT/Nxhs9qf9P1oOCDA4FjBYd6Ft5W+1CYaecRPHabXQhHcE5pNNb5jWlylS46jVBATsrtff7vHDHJSlb3ySV9RAxtbZqZaL1x4Y7l27/V+WNXSRXiDs=  ;
X-YMail-OSG: XcYfBCwVM1kY8AaY7dG6f__oaCu2iZmcDSLtnW_Uoesm2JtXuYs5YMkFDrbXKz22D.6k1BDNXAKmARC9KOqaDamIdtVaUBsSGNOuoVw.XXUFBA_naKYoJYa6mUMV_7Qf8.7xKGWF03ZjLM_vl.B0Yfnd
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 9] x86/smp function calls: convert x86 tlb flushes to use function calls [POST 2]
Date: Tue, 19 Aug 2008 19:56:59 +1000
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
       x86@kernel.org, Andi Kleen <andi@firstfloor.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <patchbomb.1219083817@localhost> <48AA5C19.3010204@goop.org> <20080819093130.GF28713@elte.hu>
In-Reply-To: <20080819093130.GF28713@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808191956.59898.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 August 2008 19:31, Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > Ingo Molnar wrote:
> > > nice stuff!
> > >
> > > I suspect the extra cost might be worth it for two reasons: 1) we could
> > > optimize the cross-call implementation further
> >
> > Unfortunately, I think the kmalloc fix for the RCU issue is going to
> > hurt quite a lot.
>
> yeah :-(
>
> Nick, is there any way to get rid of that kmalloc() in the async
> function call case? The whole premise of the smp_function_call() rewrite
> was that it's faster - and now it's measurably slower.

Not quite. smp_call_function_single is much faster, it is now scalable,
and it is queueing (and only needs a single IPI to submit multiple requests
if the target isn't keeping up). The rewrite is meant primarily to speed up
call single (for really interesting things like block request completion
migration). Before that, it was totally useless for anything remotely
performance critical.

A secondary goal was to make smp_call_function_mask at least somewhat
scalable. smp_call_function_mask used to have to execute the entire
call and wait-for-ack-from-all under a global lock (shared by 
call_function_single, mind you). Can't get a whole lot more serialised
than that. I wanted to improve this to improve vmalloc flushing
scalability. There wasn't much other performance critical stuff that
used it.

For that guy -- as I said, we could possibly look at retuning to a non
queueing implementation to avoid the kmalloc... but I'm not so hopeful
that it would bring TLB flushing to parity. And scalability would
probably suffer somewhat.


> At least we could/should perhaps standardize/generalize all the
> 'specific' IPI handlers into the smp_function_call() framework: if
> function address equals to a pre-cooked IPI entry point we could call
> that function without a kmalloc. As these are all hardwired,
> __builtin_is_constant_p() could come to the help as well. Hm?

No, it's not just the function call but also payload, list entry for
queue, scoreboard of CPUs have processed it, a lock, etc etc etc.

smp_call_function is *always* going to be heavier than a hard wired
special case, no matter how it is implemented. For such low level
performance critical functionality, I miss the days when people were
rabid about saving every cycle rather than every line of code ;)

I'm especially sore about mmap because I have a customer with a
database that uses a lot of mmap/munmap and those calls have slowed
down something like 50%(!!) from 2.6.early to 2.6.late.

Put another way: if TLB flushing were currently using
smp_call_function, I would be very happy to submit a patch to have
it use a hardwired call scheme even if it only gained 1% improvement
(in a realistic case).

Just let me reiterate that I would love anybody to make
smp_call_function go faster, or unify special case TLB flushing *if
it no longer makes sense to have*.
