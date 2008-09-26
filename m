Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYIZHCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYIZHCl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 03:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYIZHCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 03:02:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43746 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751535AbYIZHCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 03:02:32 -0400
Date: Fri, 26 Sep 2008 09:02:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Michael Davidson <md@google.com>
Cc: linux-kernel@vger.kernel.org, mbligh@google.com, tglx@linutronix.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: TSC resync
Message-ID: <20080926070217.GA26081@elte.hu>
References: <20080925220212.45B0029683@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080925220212.45B0029683@localhost>
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


* Michael Davidson <md@google.com> wrote:

> This patch is a slightly cleaned up version of one which has been in 
> use at for some time now at Google.
> 
> It uses an HPET based time source to resynchronize the TSC on systems 
> where it would otherwise be unsynchronized - eg early AMD Opteron 
> based systems where the TSC rate drifts when going in and out of the 
> C1E halt state.
> 
> While the approach is quite crude it has been effective for systems 
> where user space code relies on the TSC advancing at a constant rate 
> and being reasonably well synchronized between CPUs. The skew between 
> TSC's on different processors as seen from user space is typically 
> less than +/- 1000 clock cycles which has proved to be sufficient for 
> the applications that we care about.

hm, this patch syncs the TSCs every 20 seconds. That is enough to sync 
up AMD CPUs where the TSC slows down _slightly_ (at 10 ppm per second or 
so) when it's in HLT.

How does it behave in face of 'TSC stops' systems - systems with C2/C3 
sleeps? Basically all modern CPUs that save power are affected by that: 
the TSC get brutally cut when idle - almost all modern power saving 
laptop, desktop and server CPUs.

Also, what does it do in face of cpufreq-affected TSCs? That too is a 
large category of systems. (but most currently shipping CPUs fortunately 
have a cpufreq-invariant TSC already.)

> I don't expect this patch to be of much general interest, but if you 
> happen to be unlucky enough to have a system where the TSC is not 
> synchronized across CPUs and user space code which relies on the 
> assumption that it is, then this patch may be useful.
> 
> Signed-off-by: Michael Davidson <md@google.com>

This actually looks pretty interesting IMO, and the code looks simple, 
clean and straightforward enough - but it might not be enough to be a 
generic solution.

	Ingo
