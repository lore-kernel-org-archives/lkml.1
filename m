Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYGIEuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYGIEuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 00:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754578AbYGIEuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 00:50:14 -0400
Received: from ozlabs.org ([203.10.76.45]:47346 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754520AbYGIEuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 00:50:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH 2/3] stop_machine: simplify
Date: Wed, 9 Jul 2008 12:11:38 +1000
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Jason Baron <jbaron@redhat.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
References: <200807081750.55536.rusty@rustcorp.com.au> <200807081756.47140.rusty@rustcorp.com.au> <20080708142703.GB8278@Krystal>
In-Reply-To: <20080708142703.GB8278@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807091211.39457.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2008 00:27:03 Mathieu Desnoyers wrote:
> Hi Rusty,
>
> * Rusty Russell (rusty@rustcorp.com.au) wrote:
> > stop_machine creates a kthread which creates kernel threads.  We can
> > create those threads directly and simplify things a little.  Some care
> > must be taken with CPU hotunplug, which has special needs, but that code
> > seems more robust than it was in the past.
> >
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> > ---
> >  include/linux/stop_machine.h |   12 -
> >  kernel/cpu.c                 |   13 -
> >  kernel/stop_machine.c        |  299
> > ++++++++++++++++++------------------------- 3 files changed, 135
> > insertions(+), 189 deletions(-)
> >
> > diff --git a/include/linux/stop_machine.h b/include/linux/stop_machine.h
> > --- a/include/linux/stop_machine.h
> > +++ b/include/linux/stop_machine.h
> > @@ -17,13 +17,12 @@
> >   * @data: the data ptr for the @fn()
> >   * @cpu: if @cpu == n, run @fn() on cpu n
> >   *       if @cpu == NR_CPUS, run @fn() on any cpu
> > - *       if @cpu == ALL_CPUS, run @fn() first on the calling cpu, and
> > then - *       concurrently on all the other cpus
> > + *       if @cpu == ALL_CPUS, run @fn() on every online CPU.
> >   *
>
> I agree with this change if it makes things simpler. However, callers
> must be aware of this important change :
>
> "run @fn() first on the calling cpu, and then concurrently on all the
> other cpus" becomes "run @fn() on every online CPU".

OK.  Since that was never in mainline, I think you're the only one who needs 
to be aware of the semantic change?

The new symmetric implementation breaks it; hope that isn't a showstopper for 
you?

> There were assumptions done in @fn() where a simple non atomic increment
> was used on a static variable to detect that it was the first thread to
> execute. It will have to be changed into an atomic inc/dec and test.
> Given that the other threads have tasks to perform _after_ the first
> thread has executed, they will have to busy-wait (spin) there waiting
> for the first thread to finish its execution.

I assume you can't do that step then call stop_machine.

Thanks,
Rusty.
