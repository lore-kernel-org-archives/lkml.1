Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbYCXRfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbYCXRfc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 13:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYCXRfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 13:35:23 -0400
Received: from smtp-out.google.com ([216.239.45.13]:31166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753220AbYCXRfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 13:35:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:subject:from:to:cc:in-reply-to:references:
	content-type:organization:date:message-id:mime-version:x-mailer:content-transfer-encoding;
	b=LeqxxLFCyiLlmH4CLGfXZLNxkIgryGbaLnoFfBRUmlhq1/UFChl1Uem19Ri1pX7fM
	LxZhGSL6f3MBiXP1wWs0g==
Subject: Re: posix-cpu-timers revamp
From: Frank Mayhar <fmayhar@google.com>
To: Roland McGrath <roland@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080322215829.D69D026F9A7@magilla.localdomain>
References: <bug-9906-10286@http.bugzilla.kernel.org/>
	 <20080206165045.89b809cc.akpm@linux-foundation.org>
	 <1202345893.8525.33.camel@peace.smo.corp.google.com>
	 <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
	 <20080207162203.3e3cf5ab@Varda>
	 <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071054160.29320@mini.warudkars.net>
	 <20080207165455.04ec490b@Varda>
	 <alpine.LRH.1.00.0802071100230.29369@mini.warudkars.net>
	 <alpine.LRH.1.00.0802071153130.15220@mini.warudkars.net>
	 <1204314904.4850.23.camel@peace.smo.corp.google.com>
	 <20080304070016.903E127010A@magilla.localdomain>
	 <1204660376.9768.1.camel@bobble.smo.corp.google.com>
	 <20080305040826.D0E6127010A@magilla.localdomain>
	 <1204830243.20004.31.camel@bobble.smo.corp.google.com>
	 <20080311075020.A93DB26F991@magilla.localdomain>
	 <1205269507.23124.57.camel@bobble.smo.corp.google.com>
	 <20080311213507.5BCDF26F991@magilla.localdomain>
	 <1205455050.19551.16.camel@bobble.smo.corp.google.com>
	 <20080321071846.1B22B26F9A7@magilla.localdomain>
	 <1206122240.14638.31.camel@bobble.smo.corp.google.com>
	 <20080322215829.D69D026F9A7@magilla.localdomain>
Content-Type: text/plain
Organization: Google, Inc.
Date: Mon, 24 Mar 2008 10:34:39 -0700
Message-Id: <1206380079.21896.20.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-22 at 14:58 -0700, Roland McGrath wrote:
> > I would really like to just ignore the 2-cpu scenario and just have two
> > versions, the UP version and the n-way SMP version.  It would make life,
> > and maintenance, simpler.
> Like I've said, it's only something to investigate for best performance.
> If the conditional code is encapsulated well, it will be simple to add
> another variant later and experiment with it.

Well, if it's acceptable, for a first cut (and the patch I'll submit),
I'll handle the UP and SMP cases, encapsulating them in sched.h in such
a way as to make it invisible (as much as is possible) to the rest of
the code.

> There are several important scenarios you did not test.
> Analysis of combinations of all these variables is needed.
> 1. Tests with a few threads, like as many threads as CPUs or only 2x as many.

I've actually done this, although I didn't find the numbers particularly
interesting.  I'll do it again and keep the numbers, though.

> 2. Tests with a process CPU timer set for a long expiration time.
>    i.e. a timer set, but that never goes off in your entire run.
>    (This is what a non-infinity RLIMIT_CPU limit does.)
>    With the old code, a long enough timer and a small enough number
>    of threads will never trigger a "rebalance".

I'll do this at some point.

> > I guess I could be wrong about this, but it appears to be what the code
> > is doing.  If my analysis is correct, I really don't need a new field,
> > since the old fields work just fine.
> 
> The analysis above is correct but your conclusion here is wrong.
> The current value of an itimer is a user feature, not just a piece
> of internal bookkeeping.

After looking at the code again, I now understand what you're talking
about.  You overloaded it_*_expires to support both the POSIX interval
timers and RLIMIT_CPU.  So the way I have things, setting one can stomp
the other.

> Your code causes any timer_settime or timer_delete call on a process
> CPU timer or any setrlimit call on RLIMIT_CPU to suddenly change the
> itimer setting just as if the user had made some setitimer call that
> was never made or intended.  That's wrong.

Right, because the original effect was to only set the it_*_expires on
each individual task struct, leaving the one in the signal struct alone.

Might it be cleaner to handle the RLIMIT_CPU stuff separately, rather
than rolling it into the itimer handling?
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

