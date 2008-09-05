Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbYIELnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbYIELnA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 07:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbYIELmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 07:42:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39431 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681AbYIELmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 07:42:51 -0400
Date: Fri, 5 Sep 2008 13:42:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: pageexec@freemail.hu, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] Add basic sanity checks to the syscall execution patch
Message-ID: <20080905114233.GA27878@elte.hu>
References: <20080903195122.73905236@infradead.org> <48C0FF43.30940.2C3EFC0@pageexec.freemail.hu> <1220609647.4879.169.camel@pasglop> <48C10EC5.24400.3008276@pageexec.freemail.hu> <1220612231.4879.175.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220612231.4879.175.camel@pasglop>
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


* Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> 
> > and that'd be because at the same time they patch the syscall table (remember,
> > they already have to go to length to get around the read-only pages), they
> > can't also patch this 'protection'? sounds really plausible, right :).
> > 
> > [fixed hpa's address, .org bounces.]
> 
> Sure, they can :-)
> 
> It's just an idea I had on irc but I tend to agree that it wouldn't 
> have much effect in practice... regarding security, it will break some 
> existing rootkits ... until updated ones show up.

at which point we are left with a change that has no relevance to 
updated rootkits (they circumvent it just fine), while the kernel 
syscall entry path is left with 2 cycles (or more) overhead, forever.

Not a good deal.

We introduced the read-only syscall table because it has debugging and 
robustness advantages, with near zero cost. This change is not zero cost 
- it's ~1% of our null syscall latency. (which is ~100 nsecs, the cost 
of this check is ~1 nsec)

The other, more fundamental problem that nobody has mentioned so far is 
that the check returns -ENOSYS and thus makes rootkit attacks _more 
robust_ and hence more likely!

The far better solution would be to insert uncertainty into the picture: 
some sort of low-frequency watchdog [runs once a second or so] that 
tries to hide itself from the general kernel scope as much as possible, 
perhaps as ELF-PIC code at some randomized location, triggered by some 
frequently used and opaque kernel facility that an attacker can not 
afford to block or fully filter, and which would just check integrity 
periodically and with little cost.

When it finds a problem it immediately triggers a hard to block/filter 
vector of alert (which can be a silent alarm over the network or to the 
screen as well).

that method does not prevent rootkits in general (nothing can), but sure 
makes their life more risky in practice - and a guaranteed livelihood 
and risk reduction is what typical criminals are interested in 
primarily, not whether they can break into a particular house.

If we implement it then it should not be present in distro .config's, 
etc. - it should be as invisible as possible - perhaps only be part of 
the kernel image .init.data section in some unremarkably generic manner. 

[ It would be nice to have a 'randomize instruction scheduling' option 
  for gcc, to make automated attacks that recognize specific instruction 
  patterns less reliable. ]

A good benchmark for such a silent alarm facility would be whether an 
experienced kernel developer could reliably tell it via a kgdb session 
and full access to memory and system symbols that such a silent alarm is 
running on a box. If he cannot do it reliably then there's probably no 
good way for an attacker either.

And of course all the other layers of security play a bigger role: an 
attacker should not get to (native) kernel level access to begin with.

	Ingo
