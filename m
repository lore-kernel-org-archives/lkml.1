Return-Path: <linux-kernel-owner+w=401wt.eu-S1760070AbXFDSGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760070AbXFDSGa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 14:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758138AbXFDSGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 14:06:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42689 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757893AbXFDSGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 14:06:20 -0400
Date: Mon, 4 Jun 2007 10:51:58 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Drepper <drepper@gmail.com>,
       Maximilian Engelhardt <maxi@daemonizer.de>,
       Michael Buesch <mb@bu3sch.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: iperf: performance regression (was b44 driver problem?)
Message-ID: <20070604105158.31ede1f5@freepuppy>
In-Reply-To: <1180978368.4404.29.camel@chaos>
References: <20070525172431.60affaca@freepuppy>
	<200705281944.05030.maxi@daemonizer.de>
	<1180380230.3657.3.camel@chaos>
	<200706031826.06891.maxi@daemonizer.de>
	<1180939188.4404.5.camel@chaos>
	<20070604090918.42386fbb@freepuppy>
	<1180974958.4404.24.camel@chaos>
	<20070604095924.651d91c8@freepuppy>
	<1180978368.4404.29.camel@chaos>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jun 2007 19:32:48 +0200
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 2007-06-04 at 09:59 -0700, Stephen Hemminger wrote:
> > > > gettimeofday({1180973726, 982754}, NULL) = 0
> > > > recv(4, "\0\0\0\0\0\0\0\1\0\0\23\211\0\0\0\0\0\0\0\0\377\377\364"..., 8192, 0) = 8192
> > > > gettimeofday({1180973726, 983790}, NULL) = 0
> > > 
> > > Well, gettimeofday() is not affected by the highres code, but
> > > 
> > > > nanosleep({0, 0}, NULL) = 0
> > > > nanosleep({0, 0}, NULL) = 0
> > > 
> > > is. The nanosleep call with a relative timeout of 0 returns immediately
> > > with highres enabled, while it sleeps at least until the next tick
> > > arrives when highres is off. Are there more of those stupid sleeps in
> > > the code ?
> > 
> > GLIBC pthread_mutex does it, YES it is a problem!
> > Looks like the old behavior is required for ABI compatibility.
> >
> > iperf server has several threads. One thread is using pthread_mutex_lock
> > to wait for the other thread.  It looks like pthread_mutex_lock is using
> > nanosleep as yield().
> 
> I doubt that. This is in the iperf code itself.
> 
> void thread_rest ( void ) {
> #if defined( HAVE_THREAD )
> #if defined( HAVE_POSIX_THREAD )
>     // TODO add checks for sched_yield or pthread_yield and call that
>     // if available
>     usleep( 0 );
> 
> ----------^^^^
> 
> It results in a nanosleep({0,0}, NULL)
> 
> 	tglx
> 

Yes, the following patch makes iperf work better than ever.
But are other broken applications going to have same problem.
Sounds like the old "who runs first" fork() problems.

--- iperf-2.0.2/compat/Thread.c.orig	2005-05-03 08:15:51.000000000 -0700
+++ iperf-2.0.2/compat/Thread.c	2007-06-04 10:54:21.000000000 -0700
@@ -405,9 +405,13 @@
 void thread_rest ( void ) {
 #if defined( HAVE_THREAD )
 #if defined( HAVE_POSIX_THREAD )
-    // TODO add checks for sched_yield or pthread_yield and call that
-    // if available
+
+#if defined( _POSIX_PRIORITY_SCHEDULING )
+    sched_yield();
+#else
     usleep( 0 );
+#endif
+
 #else // Win32
     SwitchToThread( );
 #endif




-- 
Stephen Hemminger <shemminger@linux-foundation.org>
