Return-Path: <linux-kernel-owner+w=401wt.eu-S1763149AbYBLPaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763149AbYBLPaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 10:30:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762721AbYBLP3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 10:29:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52928 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762691AbYBLP3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 10:29:35 -0500
Date: Tue, 12 Feb 2008 16:28:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
Message-ID: <20080212152846.GC3078@elte.hu>
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <20080212135027.GA1343@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212135027.GA1343@one.firstfloor.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > do spinning for now: we dont _ever_ want to break a correctly 
> > working system with kgdb.
> 
> Stopping all CPUs for indefinite time very much seems like "breaking a 
> correctly working system" to me. [...]

well, this is a small detail, but still you are wrong, and on a 
correctly working system this will not occur. (if yes, tell me how)

KGDB does a very straightforward "all CPUs enter controlled state" 
transition when the session begins, and at the end an "all CPUs 
continue" transition.

I'm not sure what you mean exactly under "stopping all CPUs for 
indefinite amount of time" (your statement is sufficiently vague to be 
hard to counter via specifics) - that does not happen, unless the system 
is so buggy that a CPU is not able to process an NMI anymore [which is 
rather rare] - in that case the whole system is likely locked up anyway. 
In that case the simplest and safest behavior is what kgdb-light does 
currently: it will only proceed if all CPUs have responded. Note that 
you are wrong to suggest that "KGDB locks up", the system _has already 
locked up_.

yes, we could "time out" and force a KGDB session even if some CPUs do 
not respond. But it's obviously not a completely safe system state, 
because other CPUs might be changing things under the feet of the 
debugger. So the safest first-level approach is to not enter the 
debugger in this case.

	Ingo
