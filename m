Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbYG2JsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbYG2JsV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYG2JsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:48:12 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:27922 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752426AbYG2JsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:48:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=5SaNG7D3hEABDrSCcw181tKAseEbBb0bF4C1t/Wzrwu6pVeobPsoBeHDLuPI1FpTyEOTDLt2jAifcfPC3SZ0dOOd6TSO4LE0zd0JtT+bOT18tsacTACrvzB8KAOeUnrapoc7XdJrlzpWCgzPkzGF3PhUnElHBethDA9r575C1e4=  ;
X-YMail-OSG: HSx.rQEVM1llf5Q1Defi9lce.cgijVC3Reqg6vkTTy_RtVIwd7SQ4FNx5GTZ_1HvZ4hXcvS1xSC1BqKTmnIh9tKh1S3PdL8YUlQDvfkUIEbnrxilcD9f4fRovFd9Hr4vr9Y-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: x86: Is there still value in having a special tlb flush IPI vector?
Date: Tue, 29 Jul 2008 19:47:56 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
References: <488E534F.2030204@goop.org> <200807291430.08220.nickpiggin@yahoo.com.au> <488EB68A.2080301@goop.org>
In-Reply-To: <488EB68A.2080301@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807291947.56515.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 29 July 2008 16:19, Jeremy Fitzhardinge wrote:
> Nick Piggin wrote:
> > It definitely is not a clear win. They do not have the same
> > characteristics. So numbers will be needed.
> 
> > smp_call_function is now properly scalable in smp_call_function_single
> > form. The more general case of multiple targets is not so easy and it
> > still takes a global lock and touches global cachelines.
> >
> > I don't think it is a good use of time, honestly. Do you have a good
> > reason?
>
> Code cleanup, unification.  It took about 20 minutes to do.  It probably

OK, so nothing terribly important.


> won't take too much longer to unify kernel/tlb.c.  It seems that if
> there's any performance loss in making the transition, then we can make
> it up again by tuning smp_call_function_mask, benefiting all users.

No I don't think that is the right way to go for such an important
functionality. There are no ifs, smp_call_function does touch global
cachelines and locks.

smp_call_function is barely used, as should be very obvious because it
was allowed to languish with such horrible performance for so long. So
there aren't too many users.

But if you get smp_call_function_mask performance at the same time,
then there is less to argue about I guess (although it will always
be necessarily more complex than plain tlb flushing).


> But, truth be told, the real reason is that I think there may be some
> correctness issue around smp_call_function* - I've seen occasional
> inexplicable crashes, all within generic_smp_call_function() - and I
> just can't exercise that code enough to get a solid reproducing case.
> But if it gets used for tlb flushes, then any bug is going to become
> pretty obvious.  Regardless of whether these patches get accepted, I can
> use it as a test vehicle.

That's fair enough. Better still might be a test harness specifically
to exercise it.


> > No. The rewrite makes it now very good at synchronously sending a
> > function to a single other CPU.
> >
> > Sending asynchronously requires a slab allocation and then a remote slab
> > free (which is nasty for slab) at the other end, and bouncing of locks
> > and cachelines. No way you want to do that in the reschedule IPI.
> >
> > Not to mention the minor problem that it still deadlocks when called with
> > interrupts disabled ;)
>
> In the async case?  Or because it can become spontaneously sync if
> there's an allocation failure?

In both sync and async case, yes.
