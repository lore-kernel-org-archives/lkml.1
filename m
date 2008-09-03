Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbYICGCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbYICGCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbYICGCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:02:45 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:40324 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752595AbYICGCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:02:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=MI1tJL6WTDEU7+ypTVJaKntY2dqkCePsJIn6LWF6m1G8QkkVgw9/Nukwc5QOC/PFuTKuB1DWGKeJkHL0HiDt9v8W9LwrLGEjvkMhQNEjOMUVo0KtgXNSBzE8u2+S/7JdafWHLf36XBtU6CQGwIdJu5YHsVVvwH/2QpcWjTsi7/I=  ;
X-YMail-OSG: 0VibLloVM1m0Sl54etdL44vAztGkFDaimufCDDRMYThUkxNvx2..3kmchYUSiVasC9.ApJKGSdNJTdGUcOMzQZaH00Lg.HJgqTj9swcmZzMwNJua1KwxbzP9vMfhAJMikNc-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [2/2] Don't complain about disabled irqs when the system has paniced
Date: Wed, 3 Sep 2008 16:02:37 +1000
User-Agent: KMail/1.9.5
Cc: Peter Zijlstra <peterz@infradead.org>, torvalds@osdl.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20080902349.573187695@firstfloor.org> <1220366717.8609.65.camel@twins> <20080902150031.GN18288@one.firstfloor.org>
In-Reply-To: <20080902150031.GN18288@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809031602.37658.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 01:00, Andi Kleen wrote:
> On Tue, Sep 02, 2008 at 04:45:17PM +0200, Peter Zijlstra wrote:

> > The deadlock scenario is long the lines of two such smp_call_function*()
> > both under irq disabled calling each other with CSD_FLAG_WAIT set.
> > Neither remote cpu will handle the IPI due to irqs being disabled, so
> > we'll wait at-infinitum for completion.
>
> First smp_send_stop does not wait (or at least not pass the
> wait flag, it will still wait for the first ack like everyone else)

It won't wait, but it may have to wait for an ack as you say (but now
this is a very rare case when kmalloc fails rather than always having
to wait for so long).

So yes, it does wait in some cases. If interrupts are disabled then it
will stop processing IPIs which are sent to it from another CPU, which
might be also calling smp_send_stop and which itself is not processing
IPIs from the CPU. This is the deadlock.

We could serialise smp_send_stop (using a simple xchg, in case we panic
in lockdep), and then it is possible to get away without deadlocking.


> I don't claim to understand the new kernel/smp.c code (it seems to me quite
> overdesigned and complicated and I admit I got lost in it somewhere),
> but I think your scenario would rely on a global lock and presumably there
> is none in the new code?

Overdesigned? Well the old code was horribly slow and synchronized, and
made it useless for doing anything except things like smp_send_stop so
I would say it was under designed ;)


> > > Besides do you prefer to not allow panic from interrupts/machine
> > > checks etc. anymore?
> >
> > However did I imply that, I just said your fix looked iffy.
>
> Well it would be the only alternative. Or have a timeout (I had
> such a hack a long time ago) but that has also other issues.
>
> In fact for smp_send_stop() it would be far better to just use an NMI,
> but we unfortunately have a few BIOS that do not support NMI properly.
>
> I think for 2.6.27 at least this is the best fix. At least keeping
> panic that broken is no option I would say.

It is reasonable I think, but I don't like testing symbolic constants
with inequalities like in your patch 2/2. Can you just make it
system_state != SYSTEM_PANIC ?

Also... is it really a regression? The old code definitely had deadlock
warnings too, but maybe they were made more complete in the new code?

Thanks,
Nick
