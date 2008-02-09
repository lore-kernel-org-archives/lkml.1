Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYBILrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYBILrp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754087AbYBILri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:47:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50910 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025AbYBILrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:47:37 -0500
Date: Sat, 9 Feb 2008 12:47:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: davej@codemonkey.org.uk, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Use global TLB flushes in MTRR code
Message-ID: <20080209114725.GB5273@elte.hu>
References: <20080207190241.GA9449@basil.nowhere.org> <20080207191337.GA13111@elte.hu> <20080207200308.GA26555@one.firstfloor.org> <20080207203705.GA19083@elte.hu> <20080208114419.GB4745@one.firstfloor.org> <20080209094037.GA23418@elte.hu> <20080209114826.GA21172@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080209114826.GA21172@one.firstfloor.org>
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

> > > It changes behaviour in some minor ways but I don't think it makes 
> > > any difference. PGE only influences TLB flushes (according to its 
> > > specification) and all the TLB flushes still run with PGE 
> > > disabled.
> > 
> > now that i pointed out the difference, your position changed to 
> > "changes behavior in minor ways" ;-)
> 
> The instruction stream changes (more cr* accesses), but the actual 
> flushes do not. [...]

You are still dead wrong. You refuse to realize the _obvious_ and 
_fundamental_ thing that the PGE bit does: it enables global TLBs while 
we change MTRRs!

That would be a completely new and totally untested modus operandi for a 
large array of x86 CPUs. You should read the Intel manual about the 
recommended way to change MTRRs (Vol. 3A 10-41) - it describes disabling 
the PGE during MTRR changes if it's enabled. The primary purpose of that 
is of course to flush the TLB entries - but still it's documented that 
way and the current code does it that way. It would be rather stupid for 
us to do otherwise: we simply cannot guarantee that x86 CPUs that 
implement MTRRs and PGE have no undocumented or _unknown_ erratas in 
this area. It _might_ be fine, while what you say is that it _is_ fine - 
which we simply cannot know. (And yes, there are documented CPU erratas 
related to global TLBs and MTRR's, so this area is far from being an 
unwritten page.)

So i refuse to apply such a pointless and risky "cleanup" patch from you 
to arch/x86 [which increases code size as well], _especially_ given how 
many times i've explained this very issue to you already and especially 
because you continue to mislead about the true effects of the patch.

	Ingo
