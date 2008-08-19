Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbYHSNBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbYHSNBG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbYHSNAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:00:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55375 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753441AbYHSNAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:00:53 -0400
Date: Tue, 19 Aug 2008 14:59:54 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080819125954.GA20210@elte.hu>
References: <20080819103301.787700742@chello.nl> <20080819103844.459178947@chello.nl> <20080819110557.GA18608@elte.hu> <200808192117.52070.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808192117.52070.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> [...] Let's retain our API specifications and backwards compatibilty 
> by default. [...]

I agree with you that the 1 second default was a bit too tight - and we 
should definitely change that (and it's changed already).

So changing the "allow RT tasks up to 10 seconds uninterrupted CPU 
monopolization" is OK to me - it still keeps runaway CPU loops (which 
are in the vast majority) debuggable, while allowing common-sense RT 
task usage.

But changing that back to the other extreme: "allow lockups by default" 
is unreasonable IMO - especially in the face of rtlimit that allows 
unprivileged tasks to gain RT privileges.

As an experiment try running a 100% CPU using SCHED_FIFO:99 RT task. It 
does not result in a usable Linux system - it interacts with too many 
normal system activities. It is a very, very special mode of operation 
and anyone using Linux in such a way has to take precautions and has to 
tune things specially anyway. (has to turn off the softlockup watchdog, 
has to make sure IO requests do not time out artificially, etc.) You 
wont even get normal keyboard or console behavior in most cases.

Furthermore, if by "API specifications" you mean POSIX - to get a 
conformant POSIX run one has to change a lot of things on a typical 
Linux system anyway. APIs and utilities have to be crippled to be "POSIX 
compliant".

In other words: we use common sense when thinking about specifications. 
The kernel's defaults are about being reasonable by default.

I have no _strong_ feelings about it, but i dont see the practical value 
in going beyond 10 seconds - as it turns a rather useful robustness 
feature off by default (and keeps it untested, etc.).

	Ingo
