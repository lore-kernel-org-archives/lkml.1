Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbXHTPqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbXHTPqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 11:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759370AbXHTPq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:46:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38353 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759142AbXHTPq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:46:28 -0400
Date: Mon, 20 Aug 2007 17:45:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Jan Glauber <jang@linux.vnet.ibm.com>, heiko.carstens@de.ibm.com,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [accounting regression since rc1]  scheduler updates
Message-ID: <20070820154529.GA300@elte.hu>
References: <20070812163225.GA11996@elte.hu> <200708141037.48001.borntraeger@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708141037.48001.borntraeger@de.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.5000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> 1. Jan could finish his sched_clock implementation for s390 and we 
> would get close to the precise numbers. This would also let CFS make 
> better decisions. [...]

i think this is the best option and it should give us the same /proc 
accuracy on s390 as before, plus improved scheduler precision. (and 
improved tracing accuracy, etc. etc.) Note that for architectures that 
already have sched_clock() at least as precise as the stime/utime stats 
there's no problem - and that seems to include all architectures except 
s390.

could you send that precise sched_clock() patch? It should be an order 
of magnitude simpler than the high-precision stime/utime tracking you 
already do, and it's needed for quality scheduling anyway.

> [...] Downside: its not as precise as before as we do some math on the 
> numbers and it will burn cycles to compute numbers we already have 
> (utime=sum*utime/stime).

i can see no real downside to it: if all of stime, utime and 
sum_exec_clock are precise, then the numbers we present via /proc are 
precise too:

   sum_exec * utime / stime;

there should be no loss of precision on s390 because the 
multiplication/division rounding is not accumulating - we keep the 
precise sum_exec, utime and stime values untouched.

on x86 we dont really want to slow down every irq and syscall event with 
precise stime/utime stats for 'top' to display. On s390 the 
multiplication and division is indeed superfluous but it keeps the code 
generic for arches where utime/stime is less precise and irq-sampled - 
while the sum is always precise. It also animates architectures that 
have an imprecise sched_clock() implementation to improve its accuracy. 
Accessing the /proc files alone is many orders of magnitude more 
expensive than this simple multiplication and division.

	Ingo

