Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbXFDRdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbXFDRdI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:33:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbXFDRcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:32:54 -0400
Received: from www.osadl.org ([213.239.205.134]:51954 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750793AbXFDRcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:32:52 -0400
Subject: Re: iperf: performance regression (was b44 driver problem?)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Ulrich Drepper <drepper@gmail.com>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Michael Buesch <mb@bu3sch.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070604095924.651d91c8@freepuppy>
References: <20070525172431.60affaca@freepuppy>
	 <200705281944.05030.maxi@daemonizer.de> <1180380230.3657.3.camel@chaos>
	 <200706031826.06891.maxi@daemonizer.de> <1180939188.4404.5.camel@chaos>
	 <20070604090918.42386fbb@freepuppy> <1180974958.4404.24.camel@chaos>
	 <20070604095924.651d91c8@freepuppy>
Content-Type: text/plain
Date: Mon, 04 Jun 2007 19:32:48 +0200
Message-Id: <1180978368.4404.29.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 09:59 -0700, Stephen Hemminger wrote:
> > > gettimeofday({1180973726, 982754}, NULL) = 0
> > > recv(4, "\0\0\0\0\0\0\0\1\0\0\23\211\0\0\0\0\0\0\0\0\377\377\364"..., 8192, 0) = 8192
> > > gettimeofday({1180973726, 983790}, NULL) = 0
> > 
> > Well, gettimeofday() is not affected by the highres code, but
> > 
> > > nanosleep({0, 0}, NULL) = 0
> > > nanosleep({0, 0}, NULL) = 0
> > 
> > is. The nanosleep call with a relative timeout of 0 returns immediately
> > with highres enabled, while it sleeps at least until the next tick
> > arrives when highres is off. Are there more of those stupid sleeps in
> > the code ?
> 
> GLIBC pthread_mutex does it, YES it is a problem!
> Looks like the old behavior is required for ABI compatibility.
>
> iperf server has several threads. One thread is using pthread_mutex_lock
> to wait for the other thread.  It looks like pthread_mutex_lock is using
> nanosleep as yield().

I doubt that. This is in the iperf code itself.

void thread_rest ( void ) {
#if defined( HAVE_THREAD )
#if defined( HAVE_POSIX_THREAD )
    // TODO add checks for sched_yield or pthread_yield and call that
    // if available
    usleep( 0 );

----------^^^^

It results in a nanosleep({0,0}, NULL)

	tglx


