Return-Path: <linux-kernel-owner+w=401wt.eu-S934227AbYBURZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934227AbYBURZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 12:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbYBURYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 12:24:55 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:38349 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938AbYBURYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 12:24:53 -0500
Subject: Re: [PATCH [RT] 08/14] add a loop counter based timeout mechanism
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Andi Kleen <ak@suse.de>
Cc: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, rostedt@goodmis.org,
       linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org,
       bill.huey@gmail.com, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, gregkh@suse.de, sdietrich@novell.com,
       mkohari@novell.com
In-Reply-To: <200802211741.10299.ak@suse.de>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221152707.4804.59177.stgit@novell1.haskins.net>
	 <200802211741.10299.ak@suse.de>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Thu, 21 Feb 2008 10:04:04 -0700
Message-Id: <1203613444.4232.27.camel@hermosa.morrealenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-21 at 17:41 +0100, Andi Kleen wrote:
> > +config RTLOCK_DELAY
> > +	int "Default delay (in loops) for adaptive rtlocks"
> > +	range 0 1000000000
> > +	depends on ADAPTIVE_RTLOCK
> 
> I must say I'm not a big fan of putting such subtle configurable numbers
> into Kconfig. Compilation is usually the wrong place to configure
> such a thing. Just having it as a sysctl only should be good enough.
> 
> > +	default "10000"
> 
> Perhaps you can expand how you came up with that default number? 
> It looks suspiciously round and worse the actual spin time depends a lot on the 
> CPU frequency (so e.g. a 3Ghz CPU will likely behave quite 
> differently from a 2Ghz CPU) Did you experiment with other spin times? 
> Should it be scaled with number of CPUs? And at what point is real
> time behaviour visibly impacted? 
> 

We did play with a number of different values at first, however this
needs more inspection.   With the loads we have played with, this
parameter is not that sensitive.

At first we only had the adaptive wait added to the rt spin lock code,
and the values chosen did not seem to have much of an impact until we
dropped below 1000.  Higher values had little impact.  Adding the
adaptive code to rt mutexes seems to make this (and the similar mutex
parameter) more sensitive, however this is likely due to the particular
benchmarks we were using.

Note that the adaptive wait loop breaks on every owner change, so the
actual time spent spinning on a CPU (in that loop) is, in general,
limited to the time the lock is held.  (Note the other cases in that
adaptive wait loop as well) 

It seems to be that the higher values help in the cases where the lock
is stolen from the pending owner, in which case the pending owner can
and will iterate and again start spinning. 

We are certainly hoping that the community will test and also provide
feedback. 

 
> Most likely it would be better to switch to something that is more
> absolute time, like checking RDTSC every few iteration similar to what
> udelay does. That would be at least constant time.
> 
> -Andi

We (at least I  :-) did try that, to the detriment of throughput.   It
is seemingly overkill to more precisely account for the "max" time spent
spinning.  

At one point, I did have a patch that specified the sysctl as
"nanoseconds" and converted that to a approximate loop count (via the
math in udelay()).  The idea was that nanoseconds are more human
friendly, as well as hardware independent, however on further review,
the idea was dropped.


Best,
-PWM


